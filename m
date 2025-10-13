Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4863148B3;
	Mon, 13 Oct 2025 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370123; cv=none; b=TCZS75bDlQLpgXVbNj5xfleEIq93QBQYLJ2zGOPY5zpDZGboXrBxNAW2KrpSW4qu51BC6LTIC1pbRt26/P1+yk/FEcb4PfT1ZjX4G5lrsBdxNmPeTxpuODC9/Bpax5jVbTJCJJwHrw5VIxOJrfDwt7xERE+ZmaW+SRgjiXoIUFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370123; c=relaxed/simple;
	bh=PRbmbkwS8UdNjCjgb3UwKkSYEKW3Zyi5jR3lDVhpKxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5WbgwBfP30uHVY5lz1DcREfc/8DVt/fVN123J1qFhwqPJZpPWBaFZeaw6MjHlC0OCMaZFtyrTil6ayzqrQrlvNvo3/jAVwZa+NSKT5sIoZWYQvuiyy4q8YRWy2xnMmUdIAa/Kpyars/WEyuxWjS4KanRgZ8oJkI/ZwYjNIiqUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAj7bUY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAj7bUY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B9CC4CEE7;
	Mon, 13 Oct 2025 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370122;
	bh=PRbmbkwS8UdNjCjgb3UwKkSYEKW3Zyi5jR3lDVhpKxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAj7bUY41GuiY+g16fcnMsla5SCs3KnMUeuyZLEoLfm2r7+gF5do4lUSn/9svAU2m
	 OwKL1O1Oae1ZJRRVboc9BEBaSFtGLs6RFz130bsEAUJUB0BZDlXRvSv6y0F1igVaxr
	 IFzfCJRwJe8UymkvX3pb7czL4qPfibPXSWvMHw6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 453/563] net: macb: remove illusion about TBQPH/RBQPH being per-queue
Date: Mon, 13 Oct 2025 16:45:14 +0200
Message-ID: <20251013144427.691930431@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit fca3dc859b200ca4dcdd2124beaf3bb2ab80b0f7 ]

The MACB driver acts as if TBQPH/RBQPH are configurable on a per queue
basis; this is a lie. A single register configures the upper 32 bits of
each DMA descriptor buffers for all queues.

Concrete actions:

 - Drop GEM_TBQPH/GEM_RBQPH macros which have a queue index argument.
   Only use MACB_TBQPH/MACB_RBQPH constants.

 - Drop struct macb_queue->TBQPH/RBQPH fields.

 - In macb_init_buffers(): do a single write to TBQPH and RBQPH for all
   queues instead of a write per queue.

 - In macb_tx_error_task(): drop the write to TBQPH.

 - In macb_alloc_consistent(): if allocations give different upper
   32-bits, fail. Previously, it would have lead to silent memory
   corruption as queues would have used the upper 32 bits of the alloc
   from queue 0 and their own low 32 bits.

 - In macb_suspend(): if we use the tie off descriptor for suspend, do
   the write once for all queues instead of once per queue.

Fixes: fff8019a08b6 ("net: macb: Add 64 bit addressing support for GEM")
Fixes: ae1f2a56d273 ("net: macb: Added support for many RX queues")
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250923-macb-fixes-v6-2-772d655cdeb6@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  4 --
 drivers/net/ethernet/cadence/macb_main.c | 57 ++++++++++--------------
 2 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index c9a5c8beb2fa8..a7e845fee4b3a 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -213,10 +213,8 @@
 
 #define GEM_ISR(hw_q)		(0x0400 + ((hw_q) << 2))
 #define GEM_TBQP(hw_q)		(0x0440 + ((hw_q) << 2))
-#define GEM_TBQPH(hw_q)		(0x04C8)
 #define GEM_RBQP(hw_q)		(0x0480 + ((hw_q) << 2))
 #define GEM_RBQS(hw_q)		(0x04A0 + ((hw_q) << 2))
-#define GEM_RBQPH(hw_q)		(0x04D4)
 #define GEM_IER(hw_q)		(0x0600 + ((hw_q) << 2))
 #define GEM_IDR(hw_q)		(0x0620 + ((hw_q) << 2))
 #define GEM_IMR(hw_q)		(0x0640 + ((hw_q) << 2))
@@ -1214,10 +1212,8 @@ struct macb_queue {
 	unsigned int		IDR;
 	unsigned int		IMR;
 	unsigned int		TBQP;
-	unsigned int		TBQPH;
 	unsigned int		RBQS;
 	unsigned int		RBQP;
-	unsigned int		RBQPH;
 
 	/* Lock to protect tx_head and tx_tail */
 	spinlock_t		tx_ptr_lock;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c769b7dbd3baf..3e634049dadf1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -495,19 +495,19 @@ static void macb_init_buffers(struct macb *bp)
 	struct macb_queue *queue;
 	unsigned int q;
 
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-			queue_writel(queue, RBQPH,
-				     upper_32_bits(queue->rx_ring_dma));
+	/* Single register for all queues' high 32 bits. */
+	if (bp->hw_dma_cap & HW_DMA_CAP_64B) {
+		macb_writel(bp, RBQPH,
+			    upper_32_bits(bp->queues[0].rx_ring_dma));
+		macb_writel(bp, TBQPH,
+			    upper_32_bits(bp->queues[0].tx_ring_dma));
+	}
 #endif
+
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
 		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-			queue_writel(queue, TBQPH,
-				     upper_32_bits(queue->tx_ring_dma));
-#endif
 	}
 }
 
@@ -1166,10 +1166,6 @@ static void macb_tx_error_task(struct work_struct *work)
 
 	/* Reinitialize the TX desc queue */
 	queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-		queue_writel(queue, TBQPH, upper_32_bits(queue->tx_ring_dma));
-#endif
 	/* Make TX ring reflect state of hardware */
 	queue->tx_head = 0;
 	queue->tx_tail = 0;
@@ -2546,6 +2542,7 @@ static int macb_alloc_consistent(struct macb *bp)
 {
 	struct macb_queue *queue;
 	unsigned int q;
+	u32 upper;
 	int size;
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
@@ -2553,7 +2550,9 @@ static int macb_alloc_consistent(struct macb *bp)
 		queue->tx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
 						    &queue->tx_ring_dma,
 						    GFP_KERNEL);
-		if (!queue->tx_ring)
+		upper = upper_32_bits(queue->tx_ring_dma);
+		if (!queue->tx_ring ||
+		    upper != upper_32_bits(bp->queues[0].tx_ring_dma))
 			goto out_err;
 		netdev_dbg(bp->dev,
 			   "Allocated TX ring for queue %u of %d bytes at %08lx (mapped %p)\n",
@@ -2567,8 +2566,11 @@ static int macb_alloc_consistent(struct macb *bp)
 
 		size = RX_RING_BYTES(bp) + bp->rx_bd_rd_prefetch;
 		queue->rx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
-						 &queue->rx_ring_dma, GFP_KERNEL);
-		if (!queue->rx_ring)
+						    &queue->rx_ring_dma,
+						    GFP_KERNEL);
+		upper = upper_32_bits(queue->rx_ring_dma);
+		if (!queue->rx_ring ||
+		    upper != upper_32_bits(bp->queues[0].rx_ring_dma))
 			goto out_err;
 		netdev_dbg(bp->dev,
 			   "Allocated RX ring of %d bytes at %08lx (mapped %p)\n",
@@ -4309,12 +4311,6 @@ static int macb_init(struct platform_device *pdev)
 			queue->TBQP = GEM_TBQP(hw_q - 1);
 			queue->RBQP = GEM_RBQP(hw_q - 1);
 			queue->RBQS = GEM_RBQS(hw_q - 1);
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-			if (bp->hw_dma_cap & HW_DMA_CAP_64B) {
-				queue->TBQPH = GEM_TBQPH(hw_q - 1);
-				queue->RBQPH = GEM_RBQPH(hw_q - 1);
-			}
-#endif
 		} else {
 			/* queue0 uses legacy registers */
 			queue->ISR  = MACB_ISR;
@@ -4323,12 +4319,6 @@ static int macb_init(struct platform_device *pdev)
 			queue->IMR  = MACB_IMR;
 			queue->TBQP = MACB_TBQP;
 			queue->RBQP = MACB_RBQP;
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-			if (bp->hw_dma_cap & HW_DMA_CAP_64B) {
-				queue->TBQPH = MACB_TBQPH;
-				queue->RBQPH = MACB_RBQPH;
-			}
-#endif
 		}
 
 		/* get irq: here we use the linux queue index, not the hardware
@@ -5452,6 +5442,11 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		 */
 		tmp = macb_readl(bp, NCR);
 		macb_writel(bp, NCR, tmp & ~(MACB_BIT(TE) | MACB_BIT(RE)));
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+		if (!(bp->caps & MACB_CAPS_QUEUE_DISABLE))
+			macb_writel(bp, RBQPH,
+				    upper_32_bits(bp->rx_ring_tieoff_dma));
+#endif
 		for (q = 0, queue = bp->queues; q < bp->num_queues;
 		     ++q, ++queue) {
 			/* Disable RX queues */
@@ -5461,10 +5456,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
 				/* Tie off RX queues */
 				queue_writel(queue, RBQP,
 					     lower_32_bits(bp->rx_ring_tieoff_dma));
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-				queue_writel(queue, RBQPH,
-					     upper_32_bits(bp->rx_ring_tieoff_dma));
-#endif
 			}
 			/* Disable all interrupts */
 			queue_writel(queue, IDR, -1);
-- 
2.51.0



