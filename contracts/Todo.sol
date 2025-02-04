// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoApp {
    struct User {
        address walletAddress;
        bool isRegistered;
    }

    struct Todo {
        uint id;
        string content;
        bool completed;
    }

    mapping(address => User) private users;
    mapping(address => Todo[]) private userTodos;

    event UserRegistered(address indexed userAddress);
    event TodoCreated(address indexed userAddress, uint todoId);
    event TodoCompleted(address indexed userAddress, uint todoId);

    modifier onlyRegisteredUser() {
        require(users[msg.sender].isRegistered, "User not registered");
        _;
    }

    function registerUser() external {
        require(!users[msg.sender].isRegistered, "User already registered");
        
        users[msg.sender] = User({
            walletAddress: msg.sender,
            isRegistered: true
        });
        
        emit UserRegistered(msg.sender);
    }

    function createTodo(string memory _content) external onlyRegisteredUser {
        uint todoId = userTodos[msg.sender].length;
        userTodos[msg.sender].push(Todo({
            id: todoId,
            content: _content,
            completed: false
        }));
        
        emit TodoCreated(msg.sender, todoId);
    }

    function toggleTodoCompleted(uint _todoId) external onlyRegisteredUser {
        require(_todoId < userTodos[msg.sender].length, "Invalid todo ID");
        userTodos[msg.sender][_todoId].completed = !userTodos[msg.sender][_todoId].completed;
        
        emit TodoCompleted(msg.sender, _todoId);
    }

    function getUserTodos() external view onlyRegisteredUser returns (Todo[] memory) {
        return userTodos[msg.sender];
    }

    function isUserRegistered(address _user) external view returns (bool) {
        return users[_user].isRegistered;
    }
}