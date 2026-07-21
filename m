Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4304A43933F;
	Tue, 21 Jul 2026 21:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668220; cv=none; b=PRRzIg19QQrKb2jirAECWTjAUSlW59PESOUwSBWZGH2Oc9XTFxRUxRcBvrHTjBn//Eg9y1SmRmX9u1nPomJkiQtGFwKCX8hCsJ/vabmXou5RH4LoFDpu2e5/ixN+nqs7GBKxMr2wNouH4TFicaq8XWo6QzFGru2o0xQWYQn4kvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668220; c=relaxed/simple;
	bh=RJpH2OCH+Bj+xtZqCM0zVpbsctNpj2VltqOg+BpiFYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSw0UiQhISgC89RSJMAXjb7maBJTbdm3tVMlFQMdhYOU6uB4Ginedo6MzbGXvn3LEtYZYsku7Te1s05PE2X+yh+XJ+sA79HGmFF4TBMUrKk/MdUon3GRAcApISTA4/F8xE5rzT9JWWDiKbJfzJkiVHc0vUQktcGzgvdjA3eAnoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSRa9CTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSRa9CTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83481F00A3A;
	Tue, 21 Jul 2026 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668219;
	bh=Y2wwqGBEdLNn1rFmSgwT+XlF5xTfH4NmEmZmM0bXbuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSRa9CTzSNYTBxJIzAgW9LsdiHsxG/G+Vda+Gdf0L7j1eMCuDdDiSd5/Crp4gi7Cc
	 fwaqSymdEfVvXRl3/5tCTi7e0gL967kbzichi4PSaktFVLi06vw4fq80UzeYdRj/mo
	 qM34sMP1xYxpYhZxXL4BmvQJ/UcK21ON7HNKQZMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.1 0091/1067] binder: fix UAF in binder_free_transaction()
Date: Tue, 21 Jul 2026 17:11:32 +0200
Message-ID: <20260721152426.618341173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1566,10 +1566,19 @@ static void binder_txn_latency_free(stru
 
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
@@ -1584,6 +1593,10 @@ static void binder_free_transaction(stru
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


