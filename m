Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CF13B7770;
	Mon, 23 Mar 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278250; cv=none; b=FNNWwCtNbBDZQNtC0J1EPJ2Ktrt68XawAocXMWS2EpvhAfIsPW5d5tKX34deq/KzzQF/B8dJtg7mCBSS4lJdBvlimtxldiaFhVdzDnfdad294bfkbmdiHNhYThFPLQJJBBJ8L89E/f5BZl0aWtkGjdXq9Hz/oJkGRJD01wYDzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278250; c=relaxed/simple;
	bh=VddGi0wFj9xsik+OGPFU2GEvazKe1PctWvPkUI2lGj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQqMzezeWnOrSn0M/QuPeyQuA6pUPz9kN/QleBTLcSEvLLlUlwrx66ui4jQLmWqvuLTbv8G6rrIDjvefXD+dtshsHuiFMccjEMLItre4EmAUre2uGCS6ADPYXD7hAE7NxNhBEJG5tZwGiABbxgQBHWhNSmNU7FrAXB0TyWmSKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVUjK8AC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVUjK8AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D773FC4CEF7;
	Mon, 23 Mar 2026 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278250;
	bh=VddGi0wFj9xsik+OGPFU2GEvazKe1PctWvPkUI2lGj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVUjK8ACBOx+oGEYM86KsaymYkZw3cTxWR7ehOWjpMOzbyGMwDWdJRG5q+blHEgsC
	 kJ9skwVVF8SOn/15wpACHtbKfaHYwmrI/rzfydhFmrGlk31mPNbfx8D3ss0KmNKhWk
	 tQQnwAkyUn9KtotaSiGlKmQxtEmjHOBl/MeKFpio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <cshi008@fiu.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Dave Tian <daveti@purdue.edu>,
	Christoph Hellwig <hch@lst.de>,
	Sungwoo Kim <iam@sung-woo.kim>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/567] nvme-pci: Fix race bug in nvme_poll_irqdisable()
Date: Mon, 23 Mar 2026 14:42:49 +0100
Message-ID: <20260323134539.999611652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit fc71f409b22ca831a9f87a2712eaa09ef2bb4a5e ]

In the following scenario, pdev can be disabled between (1) and (3) by
(2). This sets pdev->msix_enabled = 0. Then, pci_irq_vector() will
return MSI-X IRQ(>15) for (1) whereas return INTx IRQ(<=15) for (2).
This causes IRQ warning because it tries to enable INTx IRQ that has
never been disabled before.

To fix this, save IRQ number into a local variable and ensure
disable_irq() and enable_irq() operate on the same IRQ number.  Even if
pci_free_irq_vectors() frees the IRQ concurrently, disable_irq() and
enable_irq() on a stale IRQ number is still valid and safe, and the
depth accounting reamins balanced.

task 1:
nvme_poll_irqdisable()
  disable_irq(pci_irq_vector(pdev, nvmeq->cq_vector)) ...(1)
  enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector))  ...(3)

task 2:
nvme_reset_work()
  nvme_dev_disable()
    pdev->msix_enable = 0;  ...(2)

crash log:

------------[ cut here ]------------
Unbalanced enable for IRQ 10
WARNING: kernel/irq/manage.c:753 at __enable_irq+0x102/0x190 kernel/irq/manage.c:753, CPU#1: kworker/1:0H/26
Modules linked in:
CPU: 1 UID: 0 PID: 26 Comm: kworker/1:0H Not tainted 6.19.0-dirty #9 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
Workqueue: kblockd blk_mq_timeout_work
RIP: 0010:__enable_irq+0x107/0x190 kernel/irq/manage.c:753
Code: ff df 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 79 48 8d 3d 2e 7a 3f 05 41 8b 74 24 2c <67> 48 0f b9 3a e8 ef b9 21 00 5b 41 5c 5d e9 46 54 66 03 e8 e1 b9
RSP: 0018:ffffc900001bf550 EFLAGS: 00010046
RAX: 0000000000000007 RBX: 0000000000000000 RCX: ffffffffb20c0e90
RDX: 0000000000000000 RSI: 000000000000000a RDI: ffffffffb74b88f0
RBP: ffffc900001bf560 R08: ffff88800197cf00 R09: 0000000000000001
R10: 0000000000000003 R11: 0000000000000003 R12: ffff8880012a6000
R13: 1ffff92000037eae R14: 000000000000000a R15: 0000000000000293
FS:  0000000000000000(0000) GS:ffff8880b49f7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555da4a25fa8 CR3: 00000000208e8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 enable_irq+0x121/0x1e0 kernel/irq/manage.c:797
 nvme_poll_irqdisable+0x162/0x1c0 drivers/nvme/host/pci.c:1494
 nvme_timeout+0x965/0x14b0 drivers/nvme/host/pci.c:1744
 blk_mq_rq_timed_out block/blk-mq.c:1653 [inline]
 blk_mq_handle_expired+0x227/0x2d0 block/blk-mq.c:1721
 bt_iter+0x2fc/0x3a0 block/blk-mq-tag.c:292
 __sbitmap_for_each_set include/linux/sbitmap.h:269 [inline]
 sbitmap_for_each_set include/linux/sbitmap.h:290 [inline]
 bt_for_each block/blk-mq-tag.c:324 [inline]
 blk_mq_queue_tag_busy_iter+0x969/0x1e80 block/blk-mq-tag.c:536
 blk_mq_timeout_work+0x627/0x870 block/blk-mq.c:1763
 process_one_work+0x956/0x1aa0 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x65c/0xe60 kernel/workqueue.c:3421
 kthread+0x41a/0x930 kernel/kthread.c:463
 ret_from_fork+0x6f8/0x8c0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
irq event stamp: 74478
hardirqs last  enabled at (74477): [<ffffffffb5720a9c>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (74477): [<ffffffffb5720a9c>] _raw_spin_unlock_irq+0x2c/0x60 kernel/locking/spinlock.c:202
hardirqs last disabled at (74478): [<ffffffffb57207b5>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (74478): [<ffffffffb57207b5>] _raw_spin_lock_irqsave+0x85/0xa0 kernel/locking/spinlock.c:162
softirqs last  enabled at (74304): [<ffffffffb1e9466c>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last  enabled at (74304): [<ffffffffb1e9466c>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last  enabled at (74304): [<ffffffffb1e9466c>] __irq_exit_rcu+0xdc/0x120 kernel/softirq.c:723
softirqs last disabled at (74287): [<ffffffffb1e9466c>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last disabled at (74287): [<ffffffffb1e9466c>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last disabled at (74287): [<ffffffffb1e9466c>] __irq_exit_rcu+0xdc/0x120 kernel/softirq.c:723
---[ end trace 0000000000000000 ]---

Fixes: fa059b856a59 (nvme-pci: Simplify nvme_poll_irqdisable)
Acked-by: Chao Shi <cshi008@fiu.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Acked-by: Dave Tian <daveti@purdue.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8dd1e71ee215e..03a2ca3edb9c3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1103,14 +1103,16 @@ static irqreturn_t nvme_irq_check(int irq, void *data)
 static void nvme_poll_irqdisable(struct nvme_queue *nvmeq)
 {
 	struct pci_dev *pdev = to_pci_dev(nvmeq->dev->dev);
+	int irq;
 
 	WARN_ON_ONCE(test_bit(NVMEQ_POLLED, &nvmeq->flags));
 
-	disable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+	irq = pci_irq_vector(pdev, nvmeq->cq_vector);
+	disable_irq(irq);
 	spin_lock(&nvmeq->cq_poll_lock);
 	nvme_poll_cq(nvmeq, NULL);
 	spin_unlock(&nvmeq->cq_poll_lock);
-	enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+	enable_irq(irq);
 }
 
 static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
-- 
2.51.0



