Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B149C3148C2;
	Mon, 13 Oct 2025 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370128; cv=none; b=habk8mSnJq6sZzZdf8EBrK3nNYIGNlHq+OuC5Yvd35eoPTiJAS5mHz0NpukjhK4IAStF2++BeFrPiiYDuuhsiFGjzRZVf9R/y+XG3nZRQi126qt/zVeqIxjVvafpAp2I0fFpM+AiSjtxYK9MRcJRaP+nK1WwbN+By+r/dSW1w8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370128; c=relaxed/simple;
	bh=CnDYlck4EFepnhlHOkVPYnire/hTuHPmMj3bpCwEkuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEW48pAahroLVmp4L4FU9ewFLU6zKbpjjGgtWpfhrQmKu68R4GwZCZrl6EjyGFTJliZGo1NK9atNTBJSV2lsHssxSbi0TR9SixlguJ6FhpAYmQWlPnePnV6Tg6px/fNqqwdEGEvH28x2+adSGJ66Ry9RcjqLVhjvagMjLmIHbkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znZW07io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znZW07io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EADC4CEE7;
	Mon, 13 Oct 2025 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370128;
	bh=CnDYlck4EFepnhlHOkVPYnire/hTuHPmMj3bpCwEkuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znZW07ioVpHeONFWxnUWL41dfBduTVQztbexTfARarPEm2G4W5k5avLUr4SYcLyfR
	 wCBwh+UOLVILZqTAYusgqpEShKymsbGrRRAsdp5cwz6bXkOyaHyFa6CbbssWa8Br6M
	 IEV3SX4Cqs+G2pZJTSqe7wwSZhatrFheItFzem/s=
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
Subject: [PATCH 6.17 455/563] net: macb: single dma_alloc_coherent() for DMA descriptors
Date: Mon, 13 Oct 2025 16:45:16 +0200
Message-ID: <20251013144427.765163065@linuxfoundation.org>
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

[ Upstream commit 78d901897b3cae06b38f54e48a2378cf9da21175 ]

Move from 2*NUM_QUEUES dma_alloc_coherent() for DMA descriptor rings to
2 calls overall.

Issue is with how all queues share the same register for configuring the
upper 32-bits of Tx/Rx descriptor rings. Taking Tx, notice how TBQPH
does *not* depend on the queue index:

	#define GEM_TBQP(hw_q)		(0x0440 + ((hw_q) << 2))
	#define GEM_TBQPH(hw_q)		(0x04C8)

	queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
	#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
	if (bp->hw_dma_cap & HW_DMA_CAP_64B)
		queue_writel(queue, TBQPH, upper_32_bits(queue->tx_ring_dma));
	#endif

To maximise our chances of getting valid DMA addresses, we do a single
dma_alloc_coherent() across queues. This improves the odds because
alloc_pages() guarantees natural alignment. Other codepaths (IOMMU or
dev/arch dma_map_ops) don't give high enough guarantees
(even page-aligned isn't enough).

Two consideration:

 - dma_alloc_coherent() gives us page alignment. Here we remove this
   constraint meaning each queue's ring won't be page-aligned anymore.

 - This can save some tiny amounts of memory. Fewer allocations means
   (1) less overhead (constant cost per alloc) and (2) less wasted bytes
   due to alignment constraints.

   Example for (2): 4 queues, default ring size (512), 64-bit DMA
   descriptors, 16K pages:
    - Before: 8 allocs of 8K, each rounded to 16K => 64K wasted.
    - After:  2 allocs of 32K => 0K wasted.

Fixes: 02c958dd3446 ("net/macb: add TX multiqueue support for gem")
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Nicolas Ferre <nicolas.ferre@microchip.com> # on sam9x75
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250923-macb-fixes-v6-4-772d655cdeb6@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 80 ++++++++++++------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 73840808ea801..fc082a7a5a313 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2478,32 +2478,30 @@ static unsigned int macb_rx_ring_size_per_queue(struct macb *bp)
 
 static void macb_free_consistent(struct macb *bp)
 {
+	struct device *dev = &bp->pdev->dev;
 	struct macb_queue *queue;
 	unsigned int q;
+	size_t size;
 
 	if (bp->rx_ring_tieoff) {
-		dma_free_coherent(&bp->pdev->dev, macb_dma_desc_get_size(bp),
+		dma_free_coherent(dev, macb_dma_desc_get_size(bp),
 				  bp->rx_ring_tieoff, bp->rx_ring_tieoff_dma);
 		bp->rx_ring_tieoff = NULL;
 	}
 
 	bp->macbgem_ops.mog_free_rx_buffers(bp);
 
+	size = bp->num_queues * macb_tx_ring_size_per_queue(bp);
+	dma_free_coherent(dev, size, bp->queues[0].tx_ring, bp->queues[0].tx_ring_dma);
+
+	size = bp->num_queues * macb_rx_ring_size_per_queue(bp);
+	dma_free_coherent(dev, size, bp->queues[0].rx_ring, bp->queues[0].rx_ring_dma);
+
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		kfree(queue->tx_skb);
 		queue->tx_skb = NULL;
-		if (queue->tx_ring) {
-			dma_free_coherent(&bp->pdev->dev,
-					  macb_tx_ring_size_per_queue(bp),
-					  queue->tx_ring, queue->tx_ring_dma);
-			queue->tx_ring = NULL;
-		}
-		if (queue->rx_ring) {
-			dma_free_coherent(&bp->pdev->dev,
-					  macb_rx_ring_size_per_queue(bp),
-					  queue->rx_ring, queue->rx_ring_dma);
-			queue->rx_ring = NULL;
-		}
+		queue->tx_ring = NULL;
+		queue->rx_ring = NULL;
 	}
 }
 
@@ -2545,41 +2543,45 @@ static int macb_alloc_rx_buffers(struct macb *bp)
 
 static int macb_alloc_consistent(struct macb *bp)
 {
+	struct device *dev = &bp->pdev->dev;
+	dma_addr_t tx_dma, rx_dma;
 	struct macb_queue *queue;
 	unsigned int q;
-	u32 upper;
-	int size;
+	void *tx, *rx;
+	size_t size;
+
+	/*
+	 * Upper 32-bits of Tx/Rx DMA descriptor for each queues much match!
+	 * We cannot enforce this guarantee, the best we can do is do a single
+	 * allocation and hope it will land into alloc_pages() that guarantees
+	 * natural alignment of physical addresses.
+	 */
+
+	size = bp->num_queues * macb_tx_ring_size_per_queue(bp);
+	tx = dma_alloc_coherent(dev, size, &tx_dma, GFP_KERNEL);
+	if (!tx || upper_32_bits(tx_dma) != upper_32_bits(tx_dma + size - 1))
+		goto out_err;
+	netdev_dbg(bp->dev, "Allocated %zu bytes for %u TX rings at %08lx (mapped %p)\n",
+		   size, bp->num_queues, (unsigned long)tx_dma, tx);
+
+	size = bp->num_queues * macb_rx_ring_size_per_queue(bp);
+	rx = dma_alloc_coherent(dev, size, &rx_dma, GFP_KERNEL);
+	if (!rx || upper_32_bits(rx_dma) != upper_32_bits(rx_dma + size - 1))
+		goto out_err;
+	netdev_dbg(bp->dev, "Allocated %zu bytes for %u RX rings at %08lx (mapped %p)\n",
+		   size, bp->num_queues, (unsigned long)rx_dma, rx);
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		size = macb_tx_ring_size_per_queue(bp);
-		queue->tx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
-						    &queue->tx_ring_dma,
-						    GFP_KERNEL);
-		upper = upper_32_bits(queue->tx_ring_dma);
-		if (!queue->tx_ring ||
-		    upper != upper_32_bits(bp->queues[0].tx_ring_dma))
-			goto out_err;
-		netdev_dbg(bp->dev,
-			   "Allocated TX ring for queue %u of %d bytes at %08lx (mapped %p)\n",
-			   q, size, (unsigned long)queue->tx_ring_dma,
-			   queue->tx_ring);
+		queue->tx_ring = tx + macb_tx_ring_size_per_queue(bp) * q;
+		queue->tx_ring_dma = tx_dma + macb_tx_ring_size_per_queue(bp) * q;
+
+		queue->rx_ring = rx + macb_rx_ring_size_per_queue(bp) * q;
+		queue->rx_ring_dma = rx_dma + macb_rx_ring_size_per_queue(bp) * q;
 
 		size = bp->tx_ring_size * sizeof(struct macb_tx_skb);
 		queue->tx_skb = kmalloc(size, GFP_KERNEL);
 		if (!queue->tx_skb)
 			goto out_err;
-
-		size = macb_rx_ring_size_per_queue(bp);
-		queue->rx_ring = dma_alloc_coherent(&bp->pdev->dev, size,
-						    &queue->rx_ring_dma,
-						    GFP_KERNEL);
-		upper = upper_32_bits(queue->rx_ring_dma);
-		if (!queue->rx_ring ||
-		    upper != upper_32_bits(bp->queues[0].rx_ring_dma))
-			goto out_err;
-		netdev_dbg(bp->dev,
-			   "Allocated RX ring of %d bytes at %08lx (mapped %p)\n",
-			   size, (unsigned long)queue->rx_ring_dma, queue->rx_ring);
 	}
 	if (bp->macbgem_ops.mog_alloc_rx_buffers(bp))
 		goto out_err;
-- 
2.51.0



