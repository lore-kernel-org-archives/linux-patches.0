Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3454304BA9;
	Tue,  2 Sep 2025 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819851; cv=none; b=CnPPL8y5U1wO92FCWMkamCqvWKpXDuwV/5883w4XP1DR7LaqaX3eGKeSQUE3Twts6eUqaQulSnzPs4OXkpsRybamD8ELWOKRbeS53WP/ODgKDrMPVqAaFlBq3nE43afwPiLns4YzCBVVV/6Rv7a7ITqR+14hibwkShBeR6lUorQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819851; c=relaxed/simple;
	bh=Ae9lnsEhrQ1MG4Ug5XB0R/WkiL2oUWi9kEIPkLjH0To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpjosEtzkAWZiDMrb5E5NR8oqNetla6U39Bl4m5e6gvE0Gtch8NBIaC/OXljn5CyU3HW5JUagHHhCr9FdbW1CMxP6QaLqNP8H4ot2QZxEr2YJyK3soIDYUY+9gR5uY+4h6ls8j/t5VhfZGZOOFYma0JbdPM8t7n1Y8c8cuPHnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnaZjc9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnaZjc9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D390CC4CEED;
	Tue,  2 Sep 2025 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819851;
	bh=Ae9lnsEhrQ1MG4Ug5XB0R/WkiL2oUWi9kEIPkLjH0To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnaZjc9yNTBaT7Smb3a1t/MPxrmQTEHFxymGgf7mJ4UliM7x62HmeqfIjQoNQNXXo
	 QcTuSHQUBIwHEJaPW8kHuomcqHcc2xQwS4HUG5arc1R5tLb3qDcKgXP7ysdeeUNH/r
	 wMTi+OrDnaWqEY88/+ENoU7D/fJ/5l3x4VdhwyaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junli Liu <liujunli@lixiang.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/95] erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC
Date: Tue,  2 Sep 2025 15:19:52 +0200
Message-ID: <20250902131940.237855978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f35d2eb0ed11c..63acd91d15aad 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1410,6 +1410,16 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
 }
 #endif
 
+/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
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
@@ -1424,8 +1434,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	/* Use (kthread_)work and sync decompression for atomic contexts only */
-	if (!in_task() || irqs_disabled() || rcu_read_lock_any_held()) {
+	if (z_erofs_in_atomic()) {
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
-- 
2.50.1



