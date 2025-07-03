Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9C82EE286;
	Thu,  3 Jul 2025 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555419; cv=none; b=pMWt4Ncz+fTLtqUetES5mHz4rG8p5QilNMhdCTnvX+XVsX5n2m1z4RdHdk3vp5zRA24c83DKuKtPNpNh6gYn5wfXzYNl9zSeQ3tA/9pt8+6ohKJE21A8mYNm72If87xwh3iaAWtK8MVWcjnCT5ummfkEwQVoVcoWMI6iiNWM0fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555419; c=relaxed/simple;
	bh=tmCZopcRxJnqw79Ey0tgO7XW7wObyljoXIHyzXZkg6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXo/cukvh3rtE/3IKyOH7SkLVFtTa1LuD0IYEfxBTItKUZufZxiGype+Kv3CU9rBZvCITfTbOhiRhKesaEfGNdpwcE3maolki5OIyK1l4z4I08KTLRJg78Mq77J1rN1/GcRgwCb1RG2eNNO5GkQ/ToaHl+IfXAjAaKhEJnRMj08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEIOG9Xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEIOG9Xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039C3C4CEE3;
	Thu,  3 Jul 2025 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555418;
	bh=tmCZopcRxJnqw79Ey0tgO7XW7wObyljoXIHyzXZkg6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEIOG9XpDUQnC+EO5GTnAzbpK+oBA7AfzCr0snMUjTXeDn3Xa6fo4S4d6REa9DBAe
	 OMIrYDt2GG4xBDITahDpw4EvZ9gPusnaV6QqE7HtFxw6159Om3U8vwcVu4eyLsO8m7
	 KVHs1QV30kNrkJABB6dMLaBGqQdRS1fvAgvoC6pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.15 254/263] rust: completion: implement initial abstraction
Date: Thu,  3 Jul 2025 16:42:54 +0200
Message-ID: <20250703144014.596129841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 1b56e765bf8990f1f60e124926c11fc4ac63d752 upstream.

Implement a minimal abstraction for the completion synchronization
primitive.

This initial abstraction only adds complete_all() and
wait_for_completion(), since that is what is required for the subsequent
Devres patch.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20250612121817.1621-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/bindings_helper.h |    1 
 rust/helpers/completion.c       |    8 ++
 rust/helpers/helpers.c          |    1 
 rust/kernel/sync.rs             |    2 
 rust/kernel/sync/completion.rs  |  112 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 124 insertions(+)
 create mode 100644 rust/helpers/completion.c
 create mode 100644 rust/kernel/sync/completion.rs

--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -10,6 +10,7 @@
 #include <linux/blk-mq.h>
 #include <linux/blk_types.h>
 #include <linux/blkdev.h>
+#include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/cred.h>
 #include <linux/device/faux.h>
--- /dev/null
+++ b/rust/helpers/completion.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/completion.h>
+
+void rust_helper_init_completion(struct completion *x)
+{
+	init_completion(x);
+}
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -11,6 +11,7 @@
 #include "bug.c"
 #include "build_assert.c"
 #include "build_bug.c"
+#include "completion.c"
 #include "cpumask.c"
 #include "cred.c"
 #include "device.c"
--- a/rust/kernel/sync.rs
+++ b/rust/kernel/sync.rs
@@ -10,6 +10,7 @@ use crate::types::Opaque;
 use pin_init;
 
 mod arc;
+pub mod completion;
 mod condvar;
 pub mod lock;
 mod locked_by;
@@ -17,6 +18,7 @@ pub mod poll;
 pub mod rcu;
 
 pub use arc::{Arc, ArcBorrow, UniqueArc};
+pub use completion::Completion;
 pub use condvar::{new_condvar, CondVar, CondVarTimeoutResult};
 pub use lock::global::{global_lock, GlobalGuard, GlobalLock, GlobalLockBackend, GlobalLockedBy};
 pub use lock::mutex::{new_mutex, Mutex, MutexGuard};
--- /dev/null
+++ b/rust/kernel/sync/completion.rs
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Completion support.
+//!
+//! Reference: <https://docs.kernel.org/scheduler/completion.html>
+//!
+//! C header: [`include/linux/completion.h`](srctree/include/linux/completion.h)
+
+use crate::{bindings, prelude::*, types::Opaque};
+
+/// Synchronization primitive to signal when a certain task has been completed.
+///
+/// The [`Completion`] synchronization primitive signals when a certain task has been completed by
+/// waking up other tasks that have been queued up to wait for the [`Completion`] to be completed.
+///
+/// # Examples
+///
+/// ```
+/// use kernel::sync::{Arc, Completion};
+/// use kernel::workqueue::{self, impl_has_work, new_work, Work, WorkItem};
+///
+/// #[pin_data]
+/// struct MyTask {
+///     #[pin]
+///     work: Work<MyTask>,
+///     #[pin]
+///     done: Completion,
+/// }
+///
+/// impl_has_work! {
+///     impl HasWork<Self> for MyTask { self.work }
+/// }
+///
+/// impl MyTask {
+///     fn new() -> Result<Arc<Self>> {
+///         let this = Arc::pin_init(pin_init!(MyTask {
+///             work <- new_work!("MyTask::work"),
+///             done <- Completion::new(),
+///         }), GFP_KERNEL)?;
+///
+///         let _ = workqueue::system().enqueue(this.clone());
+///
+///         Ok(this)
+///     }
+///
+///     fn wait_for_completion(&self) {
+///         self.done.wait_for_completion();
+///
+///         pr_info!("Completion: task complete\n");
+///     }
+/// }
+///
+/// impl WorkItem for MyTask {
+///     type Pointer = Arc<MyTask>;
+///
+///     fn run(this: Arc<MyTask>) {
+///         // process this task
+///         this.done.complete_all();
+///     }
+/// }
+///
+/// let task = MyTask::new()?;
+/// task.wait_for_completion();
+/// # Ok::<(), Error>(())
+/// ```
+#[pin_data]
+pub struct Completion {
+    #[pin]
+    inner: Opaque<bindings::completion>,
+}
+
+// SAFETY: `Completion` is safe to be send to any task.
+unsafe impl Send for Completion {}
+
+// SAFETY: `Completion` is safe to be accessed concurrently.
+unsafe impl Sync for Completion {}
+
+impl Completion {
+    /// Create an initializer for a new [`Completion`].
+    pub fn new() -> impl PinInit<Self> {
+        pin_init!(Self {
+            inner <- Opaque::ffi_init(|slot: *mut bindings::completion| {
+                // SAFETY: `slot` is a valid pointer to an uninitialized `struct completion`.
+                unsafe { bindings::init_completion(slot) };
+            }),
+        })
+    }
+
+    fn as_raw(&self) -> *mut bindings::completion {
+        self.inner.get()
+    }
+
+    /// Signal all tasks waiting on this completion.
+    ///
+    /// This method wakes up all tasks waiting on this completion; after this operation the
+    /// completion is permanently done, i.e. signals all current and future waiters.
+    pub fn complete_all(&self) {
+        // SAFETY: `self.as_raw()` is a pointer to a valid `struct completion`.
+        unsafe { bindings::complete_all(self.as_raw()) };
+    }
+
+    /// Wait for completion of a task.
+    ///
+    /// This method waits for the completion of a task; it is not interruptible and there is no
+    /// timeout.
+    ///
+    /// See also [`Completion::complete_all`].
+    pub fn wait_for_completion(&self) {
+        // SAFETY: `self.as_raw()` is a pointer to a valid `struct completion`.
+        unsafe { bindings::wait_for_completion(self.as_raw()) };
+    }
+}


