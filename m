Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2232399CE9;
	Fri,  9 Oct 2026 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556004; cv=none; b=pu45wzUcso/+UhnqzyTe5wVo9BGa93h7HBiMK/1KyrkvlOsjYe6+Fpuj9OA4fpd9bpiO9vbY70t3b1Hm3h2H4ABnkTw2GQjYYoyyh440+OdUoX9KhyL/kYLZHaiKx8j+u2FcLHdzl7NcsS+tFY/k5ble8+ukQy9CGoVyGJhCO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556004; c=relaxed/simple;
	bh=2oIfyHOOLErC9iOMPh7wLAvvpSxdsNVfn1yyClRfSEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X60ADRjO16B3kuKPFiqdH+1sen06febVyM0egCWa3X1JY3snEO7cyPdBr4AZCrKfiXvt4yEVsjbcdw0MFBo11pyMJ5QY7XpT4sa+suOubXmOJWQpJG8yf98+vPMT6BQOvDixcyUrMSIKgJx3Qd8I1KrIelfF+kbNX98XvasUXS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTFP1yDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTFP1yDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED091F000FF;
	Fri,  9 Oct 2026 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556002;
	bh=FyYK8yz4fE3OGbAM+K5aN0RKfx2zlkxhoG5/YLzz2ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTFP1yDmmPQVhyFkuZ1aQoyr1gRyyuFUrsZRuyaVuVpamTuUl+0pWzvtCaLM00xEe
	 8NDAqrXTgIwthMhxVE4eGvXWCFCqexx3cKDUJx2BFXhuWN/jMT5QuRfHGjzQtqt9J5
	 MRMRSXx3uxEoofM8HwT/dEoJIcRHkKSyOXm8CkAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 158/403] rust_binder: reschedule node refcount update on thread exit
Date: Fri,  9 Oct 2026 16:08:39 +0200
Message-ID: <20261009140955.775132646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -725,7 +725,21 @@ impl DeliverToRead for Node {
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
+            _drop_outside_lock = owner_inner.push_work(&self.owner, node);
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
+                _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
+            } else {
+                // This can't actually happen.
+                ds.has_strong_zero2one = false;
+            }
+        }
+    }
 
     fn should_sync_wakeup(&self) -> bool {
         false


