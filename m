Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E64418B0A;
	Wed, 25 Feb 2026 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983219; cv=none; b=bYAIGClZJZP/q9CsyEwXopeJ9bQCT3kK7UAtLN4Dq7b9KX+OC/Iaq/4IdGktV71n7IDfoVK1XcP8pOqC8BhJKSQ5NCizpCSKuRdYWyMqbo1er0MKRnzmyDEkHyWBIaJ5bfGmlmoJO+F3aJCxFSIpVX9dDOzR7sxImH+fGEoy2Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983219; c=relaxed/simple;
	bh=fpnZ0h9FJw9RmgIfYTN9l55vpX4/4ri/AwQeDw/I2W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKVc68p+aQXyTdXHDQFgYS9FsWCAL3S+iOaHruK80xrGm3OGMJhNeUqNeeCRvpDzRXg6CpM9ZMYTyvkyQXU0p1XG6dFKQdXnHJl63QSGTI808tDEO8e7dHGa7TnXLOMF7NJrKdQr9H3j2NmDrLfM4sFrSt2u/lFFU76Y0c8GiNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM3obhzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM3obhzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE1FC116D0;
	Wed, 25 Feb 2026 01:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983219;
	bh=fpnZ0h9FJw9RmgIfYTN9l55vpX4/4ri/AwQeDw/I2W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM3obhzoSodECIy7LidelSmkzp+nrbOpewcG8RJcOUtbF6Pm+p1G1nmxGFdx9Gh4k
	 GmDMrgO0znLrRgI1A5fNYHLimmUhBav/xb7VgFbxPjpK/5dIkH4JSnfe1nfbbb8O2j
	 GyrzCw7A1U9ElZpNK+UpFvJFhJ3O0NX0OdGJWSzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Panagiotis Foliadis <pfoliadis@posteo.net>,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 366/781] rust: task: restrict Task::group_leader() to current
Date: Tue, 24 Feb 2026 17:17:55 -0800
Message-ID: <20260225012408.657578041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 105ddfb2d2b3acec7a7d9695463df48733d91e6c ]

The Task::group_leader() method currently allows you to access the
group_leader() of any task, for example one you hold a refcount to.  But
this is not safe in general since the group leader could change when a
task exits.  See for example commit a15f37a40145c ("kernel/sys.c: fix the
racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths").

All existing users of Task::group_leader() call this method on current,
which is guaranteed running, so there's not an actual issue in Rust code
today.  But to prevent code in the future from making this mistake,
restrict Task::group_leader() so that it can only be called on current.

There are some other cases where accessing task->group_leader is okay.
For example it can be safe if you hold tasklist_lock or rcu_read_lock().
However, only supporting current->group_leader is sufficient for all
in-tree Rust users of group_leader right now.  Safe Rust functionality for
accessing it under rcu or while holding tasklist_lock may be added in the
future if required by any future Rust module.

This patch is a bugfix in that it prevents users of this API from writing
incorrect code.  It doesn't change behavior of correct code.

Link: https://lkml.kernel.org/r/20260107-task-group-leader-v2-1-8fbf816f2a2f@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 313c4281bc9d ("rust: add basic `Task`")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Closes: https://lore.kernel.org/all/aTLnV-5jlgfk1aRK@redhat.com/
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Benno Lossin <lossin@kernel.org>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Panagiotis Foliadis <pfoliadis@posteo.net>
Cc: Shankari Anand <shankari.ak0208@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/task.rs | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 49fad6de06740..cc907fb531bce 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -204,18 +204,6 @@ pub fn as_ptr(&self) -> *mut bindings::task_struct {
         self.0.get()
     }
 
-    /// Returns the group leader of the given task.
-    pub fn group_leader(&self) -> &Task {
-        // SAFETY: The group leader of a task never changes after initialization, so reading this
-        // field is not a data race.
-        let ptr = unsafe { *ptr::addr_of!((*self.as_ptr()).group_leader) };
-
-        // SAFETY: The lifetime of the returned task reference is tied to the lifetime of `self`,
-        // and given that a task has a reference to its group leader, we know it must be valid for
-        // the lifetime of the returned task reference.
-        unsafe { &*ptr.cast() }
-    }
-
     /// Returns the PID of the given task.
     pub fn pid(&self) -> Pid {
         // SAFETY: The pid of a task never changes after initialization, so reading this field is
@@ -345,6 +333,18 @@ pub fn active_pid_ns(&self) -> Option<&PidNamespace> {
         // `release_task()` call.
         Some(unsafe { PidNamespace::from_ptr(active_ns) })
     }
+
+    /// Returns the group leader of the current task.
+    pub fn group_leader(&self) -> &Task {
+        // SAFETY: The group leader of a task never changes while the task is running, and `self`
+        // is the current task, which is guaranteed running.
+        let ptr = unsafe { (*self.as_ptr()).group_leader };
+
+        // SAFETY: `current->group_leader` stays valid for at least the duration in which `current`
+        // is running, and the signature of this function ensures that the returned `&Task` can
+        // only be used while `current` is still valid, thus still running.
+        unsafe { &*ptr.cast() }
+    }
 }
 
 // SAFETY: The type invariants guarantee that `Task` is always refcounted.
-- 
2.51.0



