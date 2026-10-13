Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEC4F4CF0;
	Tue, 13 Oct 2026 11:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892019; cv=none; b=QVJPg5mlYxWuawHCAysimJszzEbT7sSPC8EEE6EuRL1JXyi4jh6KxMs4nvEN5a568gChsig0RGVeTHhMkcVS35MK1PWH/JSCMApOUNby6tRYKfEwn5wJk82C1X6rmbzBB4pIQzUVrcXwO91GnH+e+Ki+R5btRAcoOHC9CX0IFwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892019; c=relaxed/simple;
	bh=CXR3zOlg9jrrP1s/tEkz/4pYilzcrL14kRGsFie4tDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky4zuezNTa1KrcnjJxZ8iV/a8AD90xOFtUK2UwkXR4uMAJ13Gh5mbI7CMeThKNYprSBmT6ZCqagtBKeLMeg9K/TyAALV/DrpezqAvAYYI/fD/UyiGX1cqH5vDBAv696CUBoBsx7e/xgVa0XGl3qriT/OqOAf/B1oC7I4IyJYIb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrkeSW3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrkeSW3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6C21F000FF;
	Tue, 13 Oct 2026 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892018;
	bh=DWwiyj51TwFHLuI1UHU+8joDKe9oQIk3nx68sO112+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrkeSW3sGBRGJ3DrXNktvYLWZp6bN4WJvPUpp11wzMshf1KWz99fXtoF0bUDgUh13
	 4ZwWABNZKj63IGRwYWVTfPUruSW7OBkJhB3C9+LxWCRP3DHoi71dW8IsCKfdp/B0vu
	 YD2gGQvwSZaOzvU6jIZJqR62TjeyL+Cd3KJUWqTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 009/281] rust_binder: reschedule node refcount update on thread exit
Date: Tue, 13 Oct 2026 13:35:25 +0200
Message-ID: <20261013112855.276875269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 2a74ccd1bcc170e66525f34e9de8652b57e2cf3d upstream.

When a thread exits via BINDER_THREAD_EXIT, its pending work items are
cancelled. If a thread exits while holding a pending node refcount
increment (e.g. pushed as deferred work to that thread), the refcount
increment was previously dropped because Node::cancel() and
NodeWrapper::cancel() were no-ops.

Dropping the refcount update leaves the node's delivery state and count
state desynchronized, and userspace will not receive the notification,
which can cause the node to never be freed from the process's nodes tree
when all external references are dropped.

Fix this by implementing DeliverToRead::cancel() for Node and NodeWrapper
to move the pending refcount update to the process's work queue on thread
exit so another thread can deliver it to userspace.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260903-binder-thread-exit-node-v1-1-be09ff14f6a4@google.com
[ Dropped first argument in calls to `push_work()` to adjust to the
  existing form without mainline commit dbb17c9ea756 ("rust_binder: move
  (e)poll wait queue to Process"). - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/node.rs         |   20 ++++++++++++++++---
 drivers/android/binder/node/wrapper.rs |   34 ++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 4 deletions(-)

--- a/drivers/android/binder/node.rs
+++ b/drivers/android/binder/node.rs
@@ -49,9 +49,9 @@ pub(crate) struct CouldNotDeliverCritica
 ///   about to drop the weak reference, then the strong increment could be processed after the
 ///   other thread has already exited, which would be too late.
 ///
-/// Note that trying to create a `ListArc` to the node can succeed even if `has_normal_push` is
+/// Note that trying to create a `ListArc` to the node can succeed even if `has_pushed_node` is
 /// set. This is because another thread might just have popped the node from a todo list, but not
-/// yet called `do_work`. However, if `has_normal_push` is false, then creating a `ListArc` should
+/// yet called `do_work`. However, if `has_pushed_node` is false, then creating a `ListArc` should
 /// always succeed.
 ///
 /// Like the other fields in `NodeInner`, the delivery state is protected by the process lock.
@@ -733,7 +733,21 @@ impl DeliverToRead for Node {
         self.do_work_locked(writer, owner_inner)
     }
 
-    fn cancel(self: DArc<Self>) {}
+    fn cancel(self: DArc<Self>) {
+        let _drop_outside_lock;
+        let mut owner_inner = self.owner.inner.lock();
+
+        // We only do something on BINDER_THREAD_EXIT, not process exit.
+        if owner_inner.is_dead {
+            return;
+        }
+
+        // If BINDER_THREAD_EXIT is invoked on a thread with a pending node refcount update, we
+        // should move ourselves to ensure the refcount update is still delivered.
+        if let Some(node) = ListArc::try_from_arc_borrow(self.as_arc_borrow()) {
+            _drop_outside_lock = owner_inner.push_work(node);
+        }
+    }
 
     fn should_sync_wakeup(&self) -> bool {
         false
--- a/drivers/android/binder/node/wrapper.rs
+++ b/drivers/android/binder/node/wrapper.rs
@@ -57,7 +57,39 @@ impl DeliverToRead for NodeWrapper {
         node.do_work_locked(writer, owner_inner)
     }
 
-    fn cancel(self: DArc<Self>) {}
+    fn cancel(self: DArc<Self>) {
+        let _drop_outside_lock;
+        let node = &self.node;
+        let mut owner_inner = node.owner.inner.lock();
+
+        // We only do something on BINDER_THREAD_EXIT, not process exit.
+        if owner_inner.is_dead {
+            return;
+        }
+
+        // We transfer the responsibility of the node refcount update to the scheduled Node because
+        // NodeWrapper has no way to re-create the ListArc.
+        let inner = node.inner.access_mut(&mut owner_inner);
+
+        let ds = &mut inner.delivery_state;
+        assert!(ds.has_pushed_wrapper);
+        assert!(ds.has_strong_zero2one);
+        ds.has_pushed_wrapper = false;
+
+        // We are changing the state to one where the Node is the strong zero2one update instead of
+        // the wrapper.
+        ds.has_weak_zero2one = false;
+
+        if !ds.has_pushed_node {
+            if let Some(node2) = ListArc::try_from_arc_borrow(node.as_arc_borrow()) {
+                ds.has_pushed_node = true;
+                _drop_outside_lock = owner_inner.push_work(node2);
+            } else {
+                // This can't actually happen.
+                ds.has_strong_zero2one = false;
+            }
+        }
+    }
 
     fn should_sync_wakeup(&self) -> bool {
         false


