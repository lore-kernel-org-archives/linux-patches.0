Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4184299AB5;
	Tue,  2 Sep 2025 13:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820142; cv=none; b=d/bXuRh7Pr0pf5tu0iLz9q/gIFJuwd8w6Nhiuf7cjkNTAnHBfiTaXYVBZJgtavKmmbVE3P3HOJMlNFwlXzkGnWHqTC/gjXbh99Bl5rJ6XCUt7qVm0lKhuhP9UiPXFTxMEuZ1IXQwY2nUOq1qSitMxo1orXxy+e6G1IRRgrIUq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820142; c=relaxed/simple;
	bh=4F/QNCEI9oqUfe7I1L4mSSEHL6O5OSiFX86NsZFAVMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVp1bcyZ4CYDPe25Pczyt13zUh1UG05Xz4jQUf/DRoWCzj/Hqp1qeKsH1KS5qFuh5hvOwcJ9tadB/2dpqnulzXn0e1CED/yRbSPrPRl8cg4Ro1loEo8O4T6JdFrXP42ptaOuB0CdnAxDUfcDWxc9YG1NikyPaba34gwSSHSbCMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQcVjjMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQcVjjMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF44C4CEED;
	Tue,  2 Sep 2025 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820142;
	bh=4F/QNCEI9oqUfe7I1L4mSSEHL6O5OSiFX86NsZFAVMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQcVjjMbbYVRM+GwNqoPVgu/abbS46VPNY7KSpv95hvyugXP05Nv7J89vGeLQAex2
	 W5nQJub4IPkjgOEkC0YwugniQNKqNNB3pVP0+u48zceu1KLomFP6aRUV9QbnazImHP
	 BkTumM1ItxPuLV+bwUL+azZRh1nLXpa861H+crEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junli Liu <liujunli@lixiang.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/75] erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC
Date: Tue,  2 Sep 2025 15:20:24 +0200
Message-ID: <20250902131935.598674456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d852b43ac43e3..c1f802ecc47b2 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1401,6 +1401,16 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
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
@@ -1415,8 +1425,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	/* Use (kthread_)work and sync decompression for atomic contexts only */
-	if (!in_task() || irqs_disabled() || rcu_read_lock_any_held()) {
+	if (z_erofs_in_atomic()) {
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
-- 
2.50.1



