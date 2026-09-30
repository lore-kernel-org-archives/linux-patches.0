Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8D503BF3;
	Wed, 30 Sep 2026 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786247; cv=none; b=hikxV2Jsap4bLmVM583FxnKInghj1v6sgciD+gebYTGFT4ZZbhuSBksJSSyfxt+P/4xr8MFMt+NBNxZ8iS/StxH8nGGauULmy9eEPoFpdDC0wAygxfSj9QX1QH4BlO3dEqrpIksZfXybycmytuN3pm2hB6xJxjUo7E1jdAAiboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786247; c=relaxed/simple;
	bh=mXiEZeJ1gQOfk5Kbr6/KOKImCRXFKi443fMFrNGu8r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX3AnUcCErTKue4sBuVW6y4d00Lls5VMwrz88tlzq+4zjoYHJrBNR0crHvMMCDYBDHxji+pXq46EhTh4dbr9K5xTrx/qMKXbQCY8IyTWmMo3yg/yXoohunDRMCUwAmAF+HlmKI10arYVubuR00eH8Ln9ADMWpO0o5R3TBtDBKLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bfAT+C3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bfAT+C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6FE1F000FF;
	Wed, 30 Sep 2026 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786245;
	bh=rNcS5ttsV30m811YFecLQBYsIIWi/TxkzpWkaHAmPyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bfAT+C3+DXMy48obU3JyFFpaxubCbE5R+9ic59bA1+nh41Fj/2cWAY2b0CU2u23f
	 woWCDQJ8XAkPQGHxJlw5gr+VaxRiIVgCHHf6RCgMO16t/k9P7RcLRgdyl7ewHe9uBo
	 9ej7wHi3iHXtokSj+3CWtEVgTZSdsY/fDbOWkFHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junli Liu <liujunli@lixiang.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 795/982] erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC
Date: Wed, 30 Sep 2026 17:25:31 +0200
Message-ID: <20260930152433.831711935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Junli Liu <liujunli@lixiang.com>

[ Upstream commit c99fab6e80b76422741d34aafc2f930a482afbdd ]

Since EROFS handles decompression in non-atomic contexts due to
uncontrollable decompression latencies and vmap() usage, it tries
to detect atomic contexts and only kicks off a kworker on demand
in order to reduce unnecessary scheduling overhead.

However, the current approach is insufficient and can lead to
sleeping function calls in invalid contexts, causing kernel
warnings and potential system instability. See the stacktrace [1]
and previous discussion [2].

The current implementation only checks rcu_read_lock_any_held(),
which behaves inconsistently across different kernel configurations:

- When CONFIG_DEBUG_LOCK_ALLOC is enabled: correctly detects
  RCU critical sections by checking rcu_lock_map
- When CONFIG_DEBUG_LOCK_ALLOC is disabled: compiles to
  "!preemptible()", which only checks preempt_count and misses
  RCU critical sections

This patch introduces z_erofs_in_atomic() to provide comprehensive
atomic context detection:

1. Check RCU preemption depth when CONFIG_PREEMPTION is enabled,
   as RCU critical sections may not affect preempt_count but still
   require atomic handling

2. Always use async processing when CONFIG_PREEMPT_COUNT is disabled,
   as preemption state cannot be reliably determined

3. Fall back to standard preemptible() check for remaining cases

The function replaces the previous complex condition check and ensures
that z_erofs always uses (kthread_)work in atomic contexts to minimize
scheduling overhead and prevent sleeping in invalid contexts.

[1] Problem stacktrace
[ 61.266692] BUG: sleeping function called from invalid context at kernel/locking/rtmutex_api.c:510
[ 61.266702] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 107, name: irq/54-ufshcd
[ 61.266704] preempt_count: 0, expected: 0
[ 61.266705] RCU nest depth: 2, expected: 0
[ 61.266710] CPU: 0 UID: 0 PID: 107 Comm: irq/54-ufshcd Tainted: G W O 6.12.17 #1
[ 61.266714] Tainted: [W]=WARN, [O]=OOT_MODULE
[ 61.266715] Hardware name: schumacher (DT)
[ 61.266717] Call trace:
[ 61.266718] dump_backtrace+0x9c/0x100
[ 61.266727] show_stack+0x20/0x38
[ 61.266728] dump_stack_lvl+0x78/0x90
[ 61.266734] dump_stack+0x18/0x28
[ 61.266736] __might_resched+0x11c/0x180
[ 61.266743] __might_sleep+0x64/0xc8
[ 61.266745] mutex_lock+0x2c/0xc0
[ 61.266748] z_erofs_decompress_queue+0xe8/0x978
[ 61.266753] z_erofs_decompress_kickoff+0xa8/0x190
[ 61.266756] z_erofs_endio+0x168/0x288
[ 61.266758] bio_endio+0x160/0x218
[ 61.266762] blk_update_request+0x244/0x458
[ 61.266766] scsi_end_request+0x38/0x278
[ 61.266770] scsi_io_completion+0x4c/0x600
[ 61.266772] scsi_finish_command+0xc8/0xe8
[ 61.266775] scsi_complete+0x88/0x148
[ 61.266777] blk_mq_complete_request+0x3c/0x58
[ 61.266780] scsi_done_internal+0xcc/0x158
[ 61.266782] scsi_done+0x1c/0x30
[ 61.266783] ufshcd_compl_one_cqe+0x12c/0x438
[ 61.266786] __ufshcd_transfer_req_compl+0x2c/0x78
[ 61.266788] ufshcd_poll+0xf4/0x210
[ 61.266789] ufshcd_transfer_req_compl+0x50/0x88
[ 61.266791] ufshcd_intr+0x21c/0x7c8
[ 61.266792] irq_forced_thread_fn+0x44/0xd8
[ 61.266796] irq_thread+0x1a4/0x358
[ 61.266799] kthread+0x12c/0x138
[ 61.266802] ret_from_fork+0x10/0x20

[2] https://lore.kernel.org/r/58b661d0-0ebb-4b45-a10d-c5927fb791cd@paulmck-laptop

Signed-off-by: Junli Liu <liujunli@lixiang.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250805011957.911186-1-liujunli@lixiang.com
[ Gao Xiang: Use the original trace in v1. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 49b7c77488415..27cfc9aa30722 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1255,6 +1255,16 @@ static void z_erofs_decompressqueue_work(struct work_struct *work)
 	kvfree(bgq);
 }
 
+/* Use workqueue and sync decompression for atomic contexts only */
+static inline bool z_erofs_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       int bios)
 {
@@ -1270,8 +1280,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	/* Use workqueue and sync decompression for atomic contexts only */
-	if (!in_task() || irqs_disabled() || rcu_read_lock_any_held()) {
+	if (z_erofs_in_atomic()) {
 		queue_work(z_erofs_workqueue, &io->u.work);
 		/* enable sync decompression for readahead */
 		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-- 
2.53.0



