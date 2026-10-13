Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEB83EFFCC;
	Tue, 13 Oct 2026 12:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894283; cv=none; b=QzPtNo/gxwQJsXWSjTIZ1nqQGl/ihQzT/NMw3OUNi3dlWp1VlzfV5UTOxxiI9DMcYyIsjk1KQnYtBN1QxnhEQNfFiIa6KSOkZSsZ7hkra2UxthXQcBi1gvjE8V1WD/LKyPQ9DdYjQlsnKRpYDEpQXptuxQT3QlFL8nYldODsU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894283; c=relaxed/simple;
	bh=TWqxbStImzY038acwjFjnBFGC8S+jM5opp6aK86yXVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVdWKeBorVuLZNmHsJSpfNTFKH8FfEsZqTykbShs3c7Ny9KhNDAtTzXOY8xZuGezhM2LnhCE3gfxaEjQjS4VEIlUhcH9olOrBvtPP9TYvKLMgR8ONUf50VeYIISYbHp+gakkiO40pS3/CPc3/w/xE48VvWY1vaHxdMlfBf5GZ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvYcRWDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvYcRWDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D16E1F0089A;
	Tue, 13 Oct 2026 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894281;
	bh=QAHACHN4VWDcvSCttcXARMgIhcp1x2B+IxeA2QKv4wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvYcRWDcp6CEm9H8IGnZP5i1sYqnqOwjkGgT6+cxv3hN/O/7hMiykoTMcf09HY3g3
	 XJuVOuI7UzF5phpdiMsvIYwtmr/Ae5D+ZCBstPQMYSD3T2evFXd7Z7SWCXFV1IhcPh
	 46SRF7OL7zpdmzT8q/KlQnKgVlKwTXpfrOGQ5U04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/621] iommu/riscv: Serialize command queue publishing
Date: Tue, 13 Oct 2026 13:38:23 +0200
Message-ID: <20261013112932.881003059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit ca58afa40946acd252a50fa4d4a86f15847a3d7d ]

Serialize command queue publishing so software producer state advances only
after a command is written and the hardware tail is updated. Wait for
hardware consumption outside the queue lock when the command queue is full
so other CPUs are not blocked behind a long poll.

Fixes: 856c0cfe5c5f ("iommu/riscv: Command and fault queue support")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 100 +++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8f4f06348a7bc..890a31262b190 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -381,75 +381,91 @@ static int riscv_iommu_queue_wait(struct riscv_iommu_queue *queue,
 				 (int)(cons - index) > 0, 0, timeout_us);
 }
 
-/* Enqueue an entry and wait to be processed if timeout_us > 0
- *
- * Error handling for IOMMU hardware not responding in reasonable time
- * will be added as separate patch series along with other RAS features.
- * For now, only report hardware failure and continue.
- */
+static int riscv_iommu_queue_wait_for_space(struct riscv_iommu_queue *queue,
+						   unsigned int last)
+{
+	unsigned int head;
+	unsigned int tail;
+	unsigned int hw_head;
+	unsigned long flags;
+	int ret;
+
+	ret = riscv_iommu_readl_timeout(queue->iommu, Q_HEAD(queue), hw_head,
+					      !(hw_head & ~queue->mask) && hw_head != last,
+					      0, RISCV_IOMMU_QUEUE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	raw_spin_lock_irqsave(&queue->lock, flags);
+	head = atomic_read(&queue->head);
+	tail = atomic_read(&queue->tail);
+	if ((tail - head) >= queue->mask) {
+		last = Q_ITEM(queue, head);
+		/*
+		 * Re-read hw_head under the lock so that it is consistent with
+		 * the freshly computed 'last'.  Using the pre-lock snapshot
+		 * could produce a stale value that wraps around relative to the
+		 * new 'last', advancing the shadow head past entries that have
+		 * not yet been consumed by the hardware.
+		 */
+		hw_head = riscv_iommu_readl(queue->iommu, Q_HEAD(queue));
+		if (!(hw_head & ~queue->mask) && hw_head != last)
+			atomic_add((hw_head - last) & queue->mask, &queue->head);
+	}
+	raw_spin_unlock_irqrestore(&queue->lock, flags);
+
+	return 0;
+}
+
+/* Enqueue an entry and publish it to the hardware queue. */
 static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
 					   void *entry, size_t entry_size)
 {
 	unsigned int prod;
 	unsigned int head;
-	unsigned int tail;
 	unsigned long flags;
+	int ret;
 
-	/* Do not preempt submission flow. */
-	local_irq_save(flags);
+	/* 1. Wait for space availability and reserve the next slot. */
+	for (;;) {
+		raw_spin_lock_irqsave(&queue->lock, flags);
 
-	/* 1. Allocate some space in the queue */
-	prod = atomic_inc_return(&queue->prod) - 1;
-	head = atomic_read(&queue->head);
+		prod = atomic_read(&queue->tail);
+		head = atomic_read(&queue->head);
 
-	/* 2. Wait for space availability. */
-	if ((prod - head) > queue->mask) {
-		if (readx_poll_timeout(atomic_read, &queue->head,
-				       head, (prod - head) < queue->mask,
-				       0, RISCV_IOMMU_QUEUE_TIMEOUT))
-			goto err_busy;
-	} else if ((prod - head) == queue->mask) {
-		const unsigned int last = Q_ITEM(queue, head);
+		if ((prod - head) < queue->mask)
+			break;
+
+		head = Q_ITEM(queue, head);
+		raw_spin_unlock_irqrestore(&queue->lock, flags);
 
-		if (riscv_iommu_readl_timeout(queue->iommu, Q_HEAD(queue), head,
-					      !(head & ~queue->mask) && head != last,
-					      0, RISCV_IOMMU_QUEUE_TIMEOUT))
+		ret = riscv_iommu_queue_wait_for_space(queue, head);
+		if (ret)
 			goto err_busy;
-		atomic_add((head - last) & queue->mask, &queue->head);
 	}
 
-	/* 3. Store entry in the ring buffer */
+	/* 2. Store entry in the ring buffer. */
 	memcpy(queue->base + Q_ITEM(queue, prod) * entry_size, entry, entry_size);
 
-	/* 4. Wait for all previous entries to be ready */
-	if (readx_poll_timeout(atomic_read, &queue->tail, tail, prod == tail,
-			       0, RISCV_IOMMU_QUEUE_TIMEOUT))
-		goto err_busy;
-
-	/*
-	 * 5. Make sure the ring buffer update (whether in normal or I/O memory) is
-	 *    completed and visible before signaling the tail doorbell to fetch
-	 *    the next command. 'fence ow, ow'
-	 */
+	/* 3. Make sure the entry is visible before updating the queue tail. */
 	dma_wmb();
 	riscv_iommu_writel(queue->iommu, Q_TAIL(queue), Q_ITEM(queue, prod + 1));
 
 	/*
-	 * 6. Make sure the doorbell write to the device has finished before updating
-	 *    the shadow tail index in normal memory. 'fence o, w'
+	 * 4. Make sure the doorbell write to the device has finished before
+	 *    updating the shadow tail index in normal memory. 'fence o, w'
 	 */
 	mmiowb();
-	atomic_inc(&queue->tail);
+	atomic_set(&queue->tail, prod + 1);
+	atomic_set(&queue->prod, prod + 1);
 
-	/* 7. Complete submission and restore local interrupts */
-	local_irq_restore(flags);
+	raw_spin_unlock_irqrestore(&queue->lock, flags);
 
 	return prod;
 
 err_busy:
-	local_irq_restore(flags);
+	/* Report the failure and continue; full RAS recovery is not implemented. */
 	dev_err_once(queue->iommu->dev, "Hardware error: command enqueue failed\n");
-
 	return prod;
 }
 
-- 
2.53.0



