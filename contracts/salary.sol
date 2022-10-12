//SPDX-License-Identifier:MIT
 
 pragma solidity ^0.8.7;


 contract salary{


 //set admin using constructor
    address public admin;
    
        constructor (){
            admin= msg.sender;
}



     //initalising Salaries based on Postion 
     // Here 3 type of positin P1,P2
     uint  SalaryOfP1= 20000000000000000   ;//wei
     uint  SalaryOfP2=30000000000000000 ;//wei
     

     // initalising Employee Structure
     struct  Employe{
         string name;
         uint role;
         uint Id_No;
         address payable account_No;
         bool paid_status;
     }

    mapping (address=>Employe) public GetEmployeeDetails; // All the employee's 
    Employe [] public AllEmployes;

    
     modifier onlyAdmin{
         require(msg.sender==admin,"you don't have rights ");
         _;
     }
/// 0xb2309adF6FD227cd04fcAa5546E1375B2BC65Da0
  // //0x42B87638C82427D78dC8bF1e2C3653c8866C93f7 aacont 2  

//sudheer,1,03,0xb2309adF6FD227cd04fcAa5546E1375B2BC65Da0,false
//pavan,2,03,0x42B87638C82427D78dC8bF1e2C3653c8866C93f7,false
    //Employee registration funtion
     function Employe_Registration (string memory name,  uint role,uint _Id_No,address payable _account_No, bool _paidStatus) public   {
        require(GetEmployeeDetails[_account_No].account_No != _account_No,"user already register");
        Employe storage  employe = GetEmployeeDetails[_account_No];
        employe.name=name;
        employe.role=role;
        employe.Id_No=_Id_No;
        employe.account_No=_account_No;
        employe.paid_status=_paidStatus;

       

        AllEmployes.push(employe);
        
    }

    // //paying  salary function  to All employess
    function sendingSalariesToEmployee() public  payable  onlyAdmin {

      
        for(uint256 i= 0; i<AllEmployes.length; i++){
         if (!AllEmployes[i].paid_status)
         {

            if( AllEmployes[i].role == 1)
            {
                sendingSalaries(AllEmployes[i].account_No,SalaryOfP1);
                AllEmployes[i].paid_status=true;
                }
            else if (AllEmployes[i].role == 2 ){
                sendingSalaries(AllEmployes[i].account_No,SalaryOfP2);
                AllEmployes[i].paid_status=true;
             }
        }
        }
    }
    
    
    


    function sendingSalaries(address payable  _ToEmployeAddress ,uint _amount)  public onlyAdmin  payable   returns   (uint256){
        require(!GetEmployeeDetails[_ToEmployeAddress].paid_status,"Salary already is creited");

        bool sending = _ToEmployeAddress.send(_amount);
        require(sending,"Failed to send ETHER");
        // GetEmployeeDetails[_ToEmployeAddress].paid_status=true;

        uint256  balanne= address(this).balance;
        return balanne  ;


     }

    // check change paid status 

    function changePaidStatus() public  onlyAdmin{

        for(uint i=0; i<AllEmployes.length;i++){
            AllEmployes[i].paid_status=!AllEmployes[i].paid_status;
            
            GetEmployeeDetails[AllEmployes[i].account_No].paid_status=!GetEmployeeDetails[AllEmployes[i].account_No].paid_status;
        }
    }
    
// //  function using  checking account Status
  function CheckSalaryStatus (address _account_No)  public onlyAdmin view  returns (bool status){
      uint256 count=0;

       for (uint i=0;i<AllEmployes.length; i++ ){
         if(AllEmployes[i].account_No ==_account_No){
            return AllEmployes[i].paid_status;
         }
       count+=1;
    if(AllEmployes.length == count){
             revert("employee not found");
         }
  }
  }

// //function using change  employee postion
 function ChangePostion( address _account_No, uint256   ChangePosition) public onlyAdmin {
     uint256 count=0;

     // using maping
     GetEmployeeDetails[_account_No].role=ChangePosition;

       for (uint i=0;i<AllEmployes.length; i++ ){
         if(AllEmployes[i].account_No ==_account_No){
           AllEmployes[i].role=ChangePosition;
         }
       count+=1;
    if(AllEmployes.length == count){
             revert("employee not found");
         }
  }
    
}





//  // remove Employe 
 function RemoveEmployee ( address  _account_No) public onlyAdmin returns (bool status){
     uint256 count=0;
     Employe memory RemoveEmploye;
     GetEmployeeDetails[_account_No]=

     for (uint256 i=0;i<AllEmployes.length; i++ ){


         if(AllEmployes[i].account_No ==_account_No){
             AllEmployes[i]=RemoveEmploye;
             AllEmployes[i]=AllEmployes[AllEmployes.length-1];
             AllEmployes[AllEmployes.length-1]=RemoveEmploye;
             AllEmployes.pop();
         }
         count+=1;

         if(AllEmployes.length == count){
             revert("employee not found");
         }
        return true;
     }
 }

}




 