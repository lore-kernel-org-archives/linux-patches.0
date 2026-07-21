Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4725C43E4B9;
	Tue, 21 Jul 2026 21:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671045; cv=none; b=Htwc14qIIW3CKOdsNxcCK0bL0FSiEBbXWbqJpqFQKIN5saTrZoO+zASs/7vQUMY5Ma9vV/b33rAWTXCIwP3rYuQ6c7gLKrXQ2N20el/ztKPzDaLA1JYgl6CcEnFdVdZ1VeKLifxrHHAIufzhQ/Y60XVOVoyMLBSj48SRG3njwHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671045; c=relaxed/simple;
	bh=Ie9Ft4V2YFkZzX8tPdh0V1kFPDfblwPwarrl6+SgWiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKSybxqkSaFD7FhdRJeKpY5aYg9F4lc2R1OopdqgMvTWGqu8/sskszdGCXx2nQd21T7Ty4keRNgJplGIPa6bZp3NMs5I9jylsWW8B60bKvKcQnlQBHYJlDxUR56u9Ztal+9L4crdrYh5ZnyEl2G6MGmYW/IIJXUQSqN7cIJlnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcvGsA8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcvGsA8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E26B1F00A3E;
	Tue, 21 Jul 2026 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671042;
	bh=BeqwIt29hk/uMAVy19FUZ331g2jyHwUgdpXycLSsMMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcvGsA8z+tUuraCf7swLKJG05i1HNpohnTv/7j2tC6NuHpiStV6bvH3GiVSz4ifGK
	 NlY+i0gNTyX219C83Yq0RiXLPerAZ0L0aL3en6IPJswbb4X5npeJyG3nX8GboL9Qjo
	 49dmQxd6TuEHKNwfpLF/cQkDzeEBkGK+/cX71tYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 080/843] binder: fix UAF in binder_free_transaction()
Date: Tue, 21 Jul 2026 17:15:15 +0200
Message-ID: <20260721152407.798612210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit f223d27a546c1e1f48d38fd67760e78f068fe8c4 upstream.

In binder_free_transaction(), the t->to_proc is read under the t->lock.
However, once the t->lock is dropped, the to_proc can die in parallel.
This leads to a use-after-free error when we attempt to acquire its
inner lock right afterwards:

  ==================================================================
  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0xe4/0x1a0
  Write of size 4 at addr ffff00001125da70 by task B/672

  CPU: 20 UID: 0 PID: 672 Comm: B Not tainted 7.1.0-rc6-00284-g8e65320d91cd #4 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   _raw_spin_lock+0xe4/0x1a0
   binder_free_transaction+0x8c/0x320
   binder_send_failed_reply+0x21c/0x2f8
   binder_thread_release+0x488/0x7e0
   binder_ioctl+0x12c0/0x29a0
  [...]

  Allocated by task 675:
   __kmalloc_cache_noprof+0x174/0x444
   binder_open+0x118/0xb70
   do_dentry_open+0x374/0x1040
   vfs_open+0x58/0x3bc
  [...]

  Freed by task 212:
   __kasan_slab_free+0x58/0x80
   kfree+0x1a0/0x4a4
   binder_proc_dec_tmpref+0x32c/0x5e0
   binder_deferred_func+0xc48/0x104c
   process_one_work+0x53c/0xbc0
  [...]
  ==================================================================

To prevent this, pin the target thread (t->to_thread) to guarantee the
target process remains alive. Undelivered transactions without a target
thread are already safe, as the target process can only be the current
context in those paths.

Cc: stable <stable@kernel.org>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/all/aikJKVuny_eOivwN@google.com/
Fixes: a370003cc301 ("binder: fix possible UAF when freeing buffer")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260619185233.2194678-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1537,10 +1537,19 @@ static void binder_txn_latency_free(stru
 
 static void binder_free_transaction(struct binder_transaction *t)
 {
+	struct binder_thread *target_thread;
 	struct binder_proc *target_proc;
 
 	spin_lock(&t->lock);
 	target_proc = t->to_proc;
+	target_thread = t->to_thread;
+	/*
+	 * Pin target_thread to keep target_proc alive. Undelivered
+	 * transactions with !target_thread are safe, as target_proc
+	 * can only be the current context there.
+	 */
+	if (target_thread)
+		atomic_inc(&target_thread->tmp_ref);
 	spin_unlock(&t->lock);
 
 	if (target_proc) {
@@ -1555,6 +1564,10 @@ static void binder_free_transaction(stru
 			t->buffer->transaction = NULL;
 		binder_inner_proc_unlock(target_proc);
 	}
+
+	if (target_thread)
+		binder_thread_dec_tmpref(target_thread);
+
 	if (trace_binder_txn_latency_free_enabled())
 		binder_txn_latency_free(t);
 	/*


