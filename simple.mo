// importlar

import Map "mo:base/HashMap";
import Hash "mo:base/Hash"; // tur belirleme
import Nat "mo:base/Nat"; // integer belirleme unsigned butun integer sayiler
import Iter "mo:base/Iter";
import Text "mo:base/Text";

//smart contract => canister (icp)

actor Assistant { // akilli sozlesme başlar
  type ToDo ={
    description: Text;
    completed:Bool;
  };

  //fonksiyonlar func

  func natHash(n:Nat) : Hash.Hash
  {
    Text.hash(Nat.toText(n))
  };

  //değişkenler
  //let- immutable
  //var-mutable
  //const- global

  var todos = Map.HashMap<Nat, ToDo> (0,Nat.equal, natHash);
  var nextId: Nat=0;
  
  //func -> private
 //public query func-> sorgulama
 //public fun -> update (güncelleme)

 public query func getToDos () : async [ToDo]
 {
   Iter.toArray(todos.vals());
 };

 public func addToDo (description:Text) : async Nat {
   let id= nextId;
   todos.put(id, {description= description; completed= false});
   nextId +=1;
   id
 };


 public func completTodo (id:Nat):async ()
 {
     ignore do? {//(ne olurssa olsun işlemi yok say)
     let description =todos.get(id)!. description;
     todos.put(id,{description; completed= true});
     };
 };


public query func showTodos(): async Text{
  var output : Text = "\n_________________________TO-DOs__________________";
  for (todo: ToDo in todos.vals())
  { output#= "\n" # todo.description;
  if(todo.completed){
    output #= "!";
  };};
  output #"\n"
};


public func clearCompleted () :async ()
{
  todos:=Map.mapFilter <Nat , ToDo , ToDo> (todos,Nat.equal, natHash,
  func(_, todo){if (todo.completed)null else ? todo });
};








};