Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3E3C1400;
	Tue, 21 Jul 2026 22:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673170; cv=none; b=TNifcNvEu3Mu0jaLvTj/4jmD05mkNEZBEAzlLSWcEEN/qYOebgBghwYE6lDQ3y4BtBDxsjvd8rzbG90xfLfy/8GF+vkAKlIcwzwi7TdD37HXQhNqIKu1g3qjx+NbOd5N7VzQ3AO7payJJhHeoZSYYfjYeRX5YXpX/dWSnesACIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673170; c=relaxed/simple;
	bh=4QBBLIoXpLq/uS9eTvhRdZOoQTePZKrpXXEQIuWHCAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9ykYOj4fDGV2Bnn7MWCSGkiQ3LRi4jPtrSm9RvH8iefCDFrUJeHTTLs9irtu3d9+FSvHpn3JRLzREktvps+cRDtvxG0ylmOfYc1ipBn4/NfeiLs4fzD+MYNLlavYWr1vmtsueZzPC1U5ldyyJgL9ixj6rO5PZpppZyCkSY5XGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbNEkrAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbNEkrAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5861F00A3D;
	Tue, 21 Jul 2026 22:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673169;
	bh=v3pgOAQxku7qLO4mGsXQxiISASf58yWHkmXcdn07Iug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbNEkrAxlmb5D8XZjatRJ3xTfrauhrh0fLQeuYusbnSDlGaCPgKJe4MZEN8sJQj4P
	 Fi5F8bq1GZH4I3Evm3ub/2Rww7QbLUCAyRqk7HUQpGZt+YWC/8yD0Kow2QjAcaNbs1
	 FP1OngBCwvvqJfyTS7C42OIg4u/zj/4yEcKxXUNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 061/699] binder: fix UAF in binder_thread_release()
Date: Tue, 21 Jul 2026 17:17:00 +0200
Message-ID: <20260721152357.080561558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 114a116aaa5f0295376cdf12da743c5bce3b20ce upstream.

When a thread exits, binder_thread_release() walks its transaction stack
to clear the t->from and t->to_proc that correspond with the exiting
thread. However, a process dying in parallel might attempt to kfree some
of these transactions. And if one of them has no associated t->to_proc,
the t->to_proc->inner_lock will not be acquired.

This means that transaction accesses in binder_thread_release() after
t->to_proc has been cleared might race with binder_free_transaction()
and cause a use-after-free error as reported by KASAN:

  ==================================================================
  BUG: KASAN: slab-use-after-free in binder_thread_release+0x5d0/0x798
  Write of size 8 at addr ffff000016627500 by task X/715

  CPU: 17 UID: 0 PID: 715 Comm: X Not tainted 7.1.0-rc5-00149-g8fde5d1d47f6 #30 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   binder_thread_release+0x5d0/0x798
   binder_ioctl+0x12c0/0x299c
   [...]

  Allocated by task 717 on cpu 18 at 67.267803s:
   __kasan_kmalloc+0xa0/0xbc
   __kmalloc_cache_noprof+0x174/0x444
   binder_transaction+0x554/0x8150
   binder_thread_write+0xa30/0x4354
   binder_ioctl+0x20f0/0x299c
   [...]

  Freed by task 202 on cpu 18 at 90.416221s:
   __kasan_slab_free+0x58/0x80
   kfree+0x1a0/0x4a4
   binder_free_transaction+0x150/0x294
   binder_send_failed_reply+0x398/0x6d8
   binder_release_work+0x3e4/0x4ec
   binder_deferred_func+0xbd8/0x104c
   [...]
  ==================================================================

In order to avoid this, make sure that binder_free_transaction() reads
the t->to_proc under the transaction lock. This will serialize the
transaction release with the accesses in binder_thread_release(). Plus,
it matches the documented locking rules for @to_proc.

Cc: stable <stable@kernel.org>
Fixes: 7a4408c6bd3e ("binder: make sure accesses to proc/thread are safe")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260619185233.2194678-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1909,7 +1909,11 @@ static void binder_free_txn_fixups(struc
 
 static void binder_free_transaction(struct binder_transaction *t)
 {
-	struct binder_proc *target_proc = t->to_proc;
+	struct binder_proc *target_proc;
+
+	spin_lock(&t->lock);
+	target_proc = t->to_proc;
+	spin_unlock(&t->lock);
 
 	if (target_proc) {
 		binder_inner_proc_lock(target_proc);


