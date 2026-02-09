Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750235CB6B;
	Mon,  9 Feb 2026 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647254; cv=none; b=bWxP0lxRw2Ow8FT1tJ+bCXqV3ZrGoDIgdT/aa63DTlcv1sZPxFQhtSCmti+30FrvBqyPf28vIerPkvPfrI9Q6tJzAqDDLz5K8q4qMjcUg9+wsxynhO9Wkjf4FDCgpbqsDv58f1nF/4DE20cc4EhpTaCH+GZRD7KpcbVpL/B2ndU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647254; c=relaxed/simple;
	bh=XtyplXi93z3QnshyFN9FGuyXPQEouWBP6oEtnlqQv5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyjhcHwIGNpfM9/q6OqKNF6xi/GdL7xalSoQUghw8B9W0pEwRGtbAC4q+GfDPV9RiewrGUowEX7DHzkL3c1eCtOtqJDdch7pS9/cydSkeSYbhquuluxdNKQiiKbYMwHQUsVauNdk8G10H/80VqopMhrNU5rdQ4CZHtSRkKPjl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni7oZiaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni7oZiaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4708AC116C6;
	Mon,  9 Feb 2026 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647254;
	bh=XtyplXi93z3QnshyFN9FGuyXPQEouWBP6oEtnlqQv5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ni7oZiaw8O1ZsUkHpAM/KHG2t3mzW8/x1RI1GUuCwV/Vci7n/u1cIlulqSxBrJKqR
	 IwC9fPo1HZjx5ntG+gs6kV52KABC9wn0I8G9Bm6dzD6HfYFy75hWkaXhxSEoUBskYq
	 qcIb8qPreOLzLcxSf4mbwOMAFvYKWiLTRj6vqip8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 044/175] binder: fix UAF in binder_netlink_report()
Date: Mon,  9 Feb 2026 15:21:57 +0100
Message-ID: <20260209142322.058670902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 5e8a3d01544282e50d887d76f30d1496a0a53562 upstream.

Oneway transactions sent to frozen targets via binder_proc_transaction()
return a BR_TRANSACTION_PENDING_FROZEN error but they are still treated
as successful since the target is expected to thaw at some point. It is
then not safe to access 't' after BR_TRANSACTION_PENDING_FROZEN errors
as the transaction could have been consumed by the now thawed target.

This is the case for binder_netlink_report() which derreferences 't'
after a pending frozen error, as pointed out by the following KASAN
report:

  ==================================================================
  BUG: KASAN: slab-use-after-free in binder_netlink_report.isra.0+0x694/0x6c8
  Read of size 8 at addr ffff00000f98ba38 by task binder-util/522

  CPU: 4 UID: 0 PID: 522 Comm: binder-util Not tainted 6.19.0-rc6-00015-gc03e9c42ae8f #1 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   binder_netlink_report.isra.0+0x694/0x6c8
   binder_transaction+0x66e4/0x79b8
   binder_thread_write+0xab4/0x4440
   binder_ioctl+0x1fd4/0x2940
   [...]

  Allocated by task 522:
   __kmalloc_cache_noprof+0x17c/0x50c
   binder_transaction+0x584/0x79b8
   binder_thread_write+0xab4/0x4440
   binder_ioctl+0x1fd4/0x2940
   [...]

  Freed by task 488:
   kfree+0x1d0/0x420
   binder_free_transaction+0x150/0x234
   binder_thread_read+0x2d08/0x3ce4
   binder_ioctl+0x488/0x2940
   [...]
  ==================================================================

Instead, make a transaction copy so the data can be safely accessed by
binder_netlink_report() after a pending frozen error. While here, add a
comment about not using t->buffer in binder_netlink_report().

Cc: stable@vger.kernel.org
Fixes: 63740349eba7 ("binder: introduce transaction reports via netlink")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260122180203.1502637-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2991,6 +2991,10 @@ static void binder_set_txn_from_error(st
  * @t:		the binder transaction that failed
  * @data_size:	the user provided data size for the transaction
  * @error:	enum binder_driver_return_protocol returned to sender
+ *
+ * Note that t->buffer is not safe to access here, as it may have been
+ * released (or not yet allocated). Callers should guarantee all the
+ * transaction items used here are safe to access.
  */
 static void binder_netlink_report(struct binder_proc *proc,
 				  struct binder_transaction *t,
@@ -3780,6 +3784,14 @@ static void binder_transaction(struct bi
 			goto err_dead_proc_or_thread;
 		}
 	} else {
+		/*
+		 * Make a transaction copy. It is not safe to access 't' after
+		 * binder_proc_transaction() reported a pending frozen. The
+		 * target could thaw and consume the transaction at any point.
+		 * Instead, use a safe 't_copy' for binder_netlink_report().
+		 */
+		struct binder_transaction t_copy = *t;
+
 		BUG_ON(target_node == NULL);
 		BUG_ON(t->buffer->async_transaction != 1);
 		return_error = binder_proc_transaction(t, target_proc, NULL);
@@ -3790,7 +3802,7 @@ static void binder_transaction(struct bi
 		 */
 		if (return_error == BR_TRANSACTION_PENDING_FROZEN) {
 			tcomplete->type = BINDER_WORK_TRANSACTION_PENDING;
-			binder_netlink_report(proc, t, tr->data_size,
+			binder_netlink_report(proc, &t_copy, tr->data_size,
 					      return_error);
 		}
 		binder_enqueue_thread_work(thread, tcomplete);


