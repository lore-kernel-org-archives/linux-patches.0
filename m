Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D72D3A69;
	Sun,  7 Jun 2026 10:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828293; cv=none; b=TiDd4m6Oeuh0+W64tekOX4P8BtFLhowoW+1DilvO5H9uiQ/2rfDE9KT4ovxA18turU3evisjnI1gLJPt4nnt/QRQXw0Gw12oJQkLODBjvM+84YFuiBESOsE9jgLt+XdqgqAtg6dYFuBfAN3+TOfEqnxehevc8byktxA9P2o2OYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828293; c=relaxed/simple;
	bh=0YzjiWMb17OX4LQqVcxtHaJXVptXXNEZT++3ttMNIcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEIJkha1qZ1uunjmFeK9Lx3/SMr1KY8/GZ7Hsj8Mpq0BPKoZ7/xQRzQ2ga/o46FqwfetANOyBDmapsWBbO5KXr153PiV3+5mzOblQW6i4WpAHBR2VBp8gJ7fbx53n8hgkRi+WfdOPBKlB9a9d9S0LQHth5hAPOZBf1GVXUpNQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksROiC++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksROiC++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D231F00893;
	Sun,  7 Jun 2026 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828292;
	bh=6ACifZl0FqDE2ch6pi4ScPTcDX3zd1JooDbb3WqFNMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksROiC++Nx1Y8rC8AC+ADFC1CZtUtlZObtvDU4940XFlKJbBC1JNDU0FQFvqZRjTG
	 knfy9K2f0ZZIrg0OgSVAR6hJOYppQOWe/x04Mf0tUTClW90RXe54l9FQtkRcnkaiAn
	 34Hvkv5ZcRgd5zwHkXjUirUgDROiGPX3GqSP5ckc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 7.0 157/332] rust_binder: avoid calling pending_oneway_finished() on TF_UPDATE_TXN
Date: Sun,  7 Jun 2026 11:58:46 +0200
Message-ID: <20260607095733.847852978@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 4c19719eb8b8df08c5bec7c499f73ddaea6f09fc upstream.

When an outdated transaction is removed from `oneway_todo` due to
`TF_UPDATE_TXN`, its `Allocation` is dropped. The current implementation
of `Allocation::drop` calls `pending_oneway_finished()`, assuming the
transaction was executed. This leads to premature execution of the next
queued one-way transaction.

Fix this by taking the `oneway_node` from the `Allocation` of the
outdated transaction before it is dropped. This prevents
`Allocation::drop` from signaling completion.

We do not call `take_oneway_node()` from `Transaction::cancel` because
it's actually correct to call `pending_oneway_finished()` on cancel if
the transaction did not come from `oneway_todo`. This ensures that if
`BINDER_THREAD_EXIT` is invoked and cancels a oneway transaction, then
the next transaction is taken from `oneway_todo`.

This bug does not lead to any issues in the kernel, but may lead to
Binder delivering transactions to userspace earlier than userspace
expected to receive them.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Assisted-by: Antigravity:gemini
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260414-tf-update-txn-fix-v1-1-d2b83303acc9@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/allocation.rs  |    8 ++++++++
 drivers/android/binder/transaction.rs |   11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/android/binder/allocation.rs
+++ b/drivers/android/binder/allocation.rs
@@ -160,6 +160,14 @@ impl Allocation {
         self.get_or_init_info().target_node = Some(target_node);
     }
 
+    pub(crate) fn take_oneway_node(&mut self) -> Option<DArc<Node>> {
+        if let Some(info) = self.allocation_info.as_mut() {
+            info.oneway_node.take()
+        } else {
+            None
+        }
+    }
+
     /// Reserve enough space to push at least `num_fds` fds.
     pub(crate) fn info_add_fd_reserve(&mut self, num_fds: usize) -> Result {
         self.get_or_init_info()
--- a/drivers/android/binder/transaction.rs
+++ b/drivers/android/binder/transaction.rs
@@ -250,7 +250,8 @@ impl Transaction {
     /// Not used for replies.
     pub(crate) fn submit(self: DLArc<Self>) -> BinderResult {
         // Defined before `process_inner` so that the destructor runs after releasing the lock.
-        let mut _t_outdated;
+        let _t_outdated;
+        let _oneway_node;
 
         let oneway = self.flags & TF_ONE_WAY != 0;
         let process = self.to.clone();
@@ -267,6 +268,14 @@ impl Transaction {
                         if let Some(t_outdated) =
                             target_node.take_outdated_transaction(&self, &mut process_inner)
                         {
+                            let mut alloc_guard = t_outdated.allocation.lock();
+                            if let Some(alloc) = (*alloc_guard).as_mut() {
+                                // Take the oneway node to prevent `Allocation::drop` from calling
+                                // `pending_oneway_finished()`, which would be incorrect as this
+                                // transaction is not being submitted.
+                                _oneway_node = alloc.take_oneway_node();
+                            }
+                            drop(alloc_guard);
                             // Save the transaction to be dropped after locks are released.
                             _t_outdated = t_outdated;
                         }


