Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD253FBB46;
	Thu, 16 Jul 2026 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209391; cv=none; b=XNrU9m7459ZqjhMFBm9fZ58JllowSat9D0nQdz2Kj4uOiIbowD9BXQ7D0swAERfQDC/iQ2F4estmMPg64gSVAuMrgP1ahxWegPlIvxQHel2JbDaUMNLx7mTOoNwlxT4Kh+UJGJ8ve4stTdhLtH92AkzQKWGfWlFLCSj7Npv8XYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209391; c=relaxed/simple;
	bh=ToyAdaRinRzEBvio24F8rpVXA/eaOSsKCRMgmMzm1mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEzek80b7V2BLaj0I9viHViJTGHoBw/7R1D5gOxyxF+fdxZYJMcuDfqNYfL03ZlgeNMQN/h0DvkqrUQKYl8TggyAM4gdhbwWnEkDJZSDsJt9Dn7wLDcVeAm1YEhJ77tqZUSB6fc+Fp+NdRDvB8UiNBmn9wOnTj6YFpPx0HIJiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jus+JUCt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jus+JUCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09C11F00A3A;
	Thu, 16 Jul 2026 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209387;
	bh=5LUCIypnRljXOyuI0ez18eo4FHBQOWx56Sc9pk21Ig4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jus+JUCtmsuagpnSbq6dzBQDaFqZjN/PLj3lQOGugzH7mIjANLujMwqnOMGdgd3W7
	 z6Sq+vVeA0Gn7RxITFF/VEyHzmxaj3q3qzs4vjtlWKy82Awne57oCOWTYvUq0w+KpA
	 5YjKst5SLk1OrYflohNo3wO7UloLlQNYuldrsv8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.1 123/518] rust_binder: clear freeze listener on node removal
Date: Thu, 16 Jul 2026 15:26:31 +0200
Message-ID: <20260716133050.548324453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit bc4a9828897871ff3e5a1f8a1d346decbf4ee95e upstream.

Generally userspace is supposed to explicitly clear freeze listeners
before they drop the refcount on the node ref to zero, but there's
nothing forcing that. Currently, in this scenario the freeze listener
remains in the freeze_listeners rbtree and in the remote node's freeze
listener list, even though the ref for which the listener is registered
is gone. This could potentially lead to a memory leak due to a refcount
cycle. Thus, remove the freeze listener in this scenario.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260703-remove-freeze-on-remove-node-v3-1-6e0c4547af46@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/freeze.rs  |   11 +++++++++--
 drivers/android/binder/node.rs    |   10 ++++++----
 drivers/android/binder/process.rs |   12 +++++++++++-
 3 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/android/binder/freeze.rs
+++ b/drivers/android/binder/freeze.rs
@@ -154,10 +154,17 @@ impl DeliverToRead for FreezeMessage {
 }
 
 impl FreezeListener {
-    pub(crate) fn on_process_exit(&self, proc: &Arc<Process>) {
+    /// Called when this freeze listener is cleared abnormally.
+    ///
+    /// This occurs either because the process exited or because the process dropped its last
+    /// refcount on the node ref without explicitly removing the freeze listener first.
+    ///
+    /// The returned `KVVec` is just a value that should be dropped outside of the lock.
+    pub(crate) fn on_process_cleanup(&self, proc: &Process) -> KVVec<Arc<Process>> {
         if !self.is_clearing {
-            self.node.remove_freeze_listener(proc);
+            return self.node.remove_freeze_listener(proc);
         }
+        KVVec::new()
     }
 }
 
--- a/drivers/android/binder/node.rs
+++ b/drivers/android/binder/node.rs
@@ -682,12 +682,13 @@ impl Node {
         }
     }
 
-    pub(crate) fn remove_freeze_listener(&self, p: &Arc<Process>) {
-        let _unused_capacity;
+    pub(crate) fn remove_freeze_listener(&self, p: &Process) -> KVVec<Arc<Process>> {
         let mut guard = self.owner.inner.lock();
         let inner = self.inner.access_mut(&mut guard);
         let len = inner.freeze_list.len();
-        inner.freeze_list.retain(|proc| !Arc::ptr_eq(proc, p));
+        inner
+            .freeze_list
+            .retain(|proc| !core::ptr::eq::<Process>(&**proc, p));
         if len == inner.freeze_list.len() {
             pr_warn!(
                 "Could not remove freeze listener for {}\n",
@@ -695,8 +696,9 @@ impl Node {
             );
         }
         if inner.freeze_list.is_empty() {
-            _unused_capacity = mem::take(&mut inner.freeze_list);
+            return mem::take(&mut inner.freeze_list);
         }
+        KVVec::new()
     }
 
     pub(crate) fn freeze_list<'a>(&'a self, guard: &'a ProcessInner) -> &'a [Arc<Process>] {
--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -946,6 +946,8 @@ impl Process {
 
         // To preserve original binder behaviour, we only fail requests where the manager tries to
         // increment references on itself.
+        let _to_free_freeze_listener;
+        let _to_free_freeze_listener_cleanup;
         let mut refs = self.node_refs.lock();
         if let Some(info) = refs.by_handle.get_mut(&handle) {
             if info.node_ref().update(inc, strong) {
@@ -961,6 +963,14 @@ impl Process {
                 unsafe { info.node_ref2().node.remove_node_info(info) };
 
                 let id = info.node_ref().node.global_id();
+
+                if let Some(freeze) = *info.freeze() {
+                    if let Some(fl) = refs.freeze_listeners.remove(&freeze) {
+                        _to_free_freeze_listener_cleanup = fl.on_process_cleanup(&self);
+                        _to_free_freeze_listener = fl;
+                    }
+                }
+
                 refs.by_handle.remove(&handle);
                 refs.by_node.remove(&id);
                 refs.handle_is_present.release_id(handle as usize);
@@ -1384,7 +1394,7 @@ impl Process {
         // Clean up freeze listeners.
         let freeze_listeners = take(&mut self.node_refs.lock().freeze_listeners);
         for listener in freeze_listeners.values() {
-            listener.on_process_exit(&self);
+            listener.on_process_cleanup(&self);
         }
         drop(freeze_listeners);
 


