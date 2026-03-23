Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B403AEF5C;
	Mon, 23 Mar 2026 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282994; cv=none; b=sSZGDT68QwaPlGXqy2oQuERSinCSRV9O2WgvKsQcOsHn3oL1TQ/8pBUFchcTh/HQw4xphPJBKILq6LOnYTO5mlKrvURNgXLvtSP+0I2YPLnay37qO8lbSPOMxlxWqf0AU1WUAtIUFg9aWWYckxrvOVE7vTMNqucD1y8urG0ZheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282994; c=relaxed/simple;
	bh=XvJ94rgwDsAcimeQ/LZp4dB8ovQe4VCJCsYma8FZUbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/uh2iYxJ+BjWi8kU94QbLb6BuHEJuxWSzXCFpE21C7yQ6GmZth3/exItyvq7Ubtjtcii3maeekUDXjjbKevxEskY9keRfxeplL+OwKNqZg9MZ1jWFxbuT/4E5rrh3lC2bgXd/wU2gAR7iCKKGElooQgfXF2dx/huRdGLdokkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/3lELOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/3lELOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7567DC4CEF7;
	Mon, 23 Mar 2026 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282993;
	bh=XvJ94rgwDsAcimeQ/LZp4dB8ovQe4VCJCsYma8FZUbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/3lELOyCzblcGGosWJ/JOFkyc5/+iWTCfNDqNL4ixwsfrDKaV4cmG3ntFGXVC334
	 pV6fTmTsO768y52ppkzfLSEoFRPfuEuniY5msmFP4eyKQXhf8nPzpBqswQVXG/7h2T
	 GxjO1rc0vn/q0dcEeXJdKrGIKdOYn4obTM5fyNkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harini.katakam@amd.com>,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/481] net: macb: queue tie-off or disable during WOL suspend
Date: Mon, 23 Mar 2026 14:45:43 +0100
Message-ID: <20260323134533.905419184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Vineeth Karumanchi <vineeth.karumanchi@amd.com>

[ Upstream commit 759cc793ebfc2d1a02f357ae97e5dcdcd63f758f ]

When GEM is used as a wake device, it is not mandatory for the RX DMA
to be active. The RX engine in IP only needs to receive and identify
a wake packet through an interrupt. The wake packet is of no further
significance; hence, it is not required to be copied into memory.
By disabling RX DMA during suspend, we can avoid unnecessary DMA
processing of any incoming traffic.

During suspend, perform either of the below operations:

- tie-off/dummy descriptor: Disable unused queues by connecting
  them to a looped descriptor chain without free slots.

- queue disable: The newer IP version allows disabling individual queues.

Co-developed-by: Harini Katakam <harini.katakam@amd.com>
Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Signed-off-by: Vineeth Karumanchi <vineeth.karumanchi@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Tested-by: Claudiu Beznea <claudiu.beznea@tuxon.dev> # on SAMA7G5
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 718d0766ce4c ("net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb.h      |    7 +++
 drivers/net/ethernet/cadence/macb_main.c |   60 +++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -636,6 +636,10 @@
 #define GEM_T2OFST_OFFSET			0 /* offset value */
 #define GEM_T2OFST_SIZE				7
 
+/* Bitfields in queue pointer registers */
+#define MACB_QUEUE_DISABLE_OFFSET		0 /* disable queue */
+#define MACB_QUEUE_DISABLE_SIZE			1
+
 /* Offset for screener type 2 compare values (T2CMPOFST).
  * Note the offset is applied after the specified point,
  * e.g. GEM_T2COMPOFST_ETYPE denotes the EtherType field, so an offset
@@ -722,6 +726,7 @@
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
 #define MACB_CAPS_MIIONRGMII			0x00000200
 #define MACB_CAPS_NEED_TSUCLK			0x00000400
+#define MACB_CAPS_QUEUE_DISABLE			0x00000800
 #define MACB_CAPS_PCS				0x01000000
 #define MACB_CAPS_HIGH_SPEED			0x02000000
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
@@ -1254,6 +1259,8 @@ struct macb {
 	u32	(*macb_reg_readl)(struct macb *bp, int offset);
 	void	(*macb_reg_writel)(struct macb *bp, int offset, u32 value);
 
+	struct macb_dma_desc	*rx_ring_tieoff;
+	dma_addr_t		rx_ring_tieoff_dma;
 	size_t			rx_buffer_size;
 
 	unsigned int		rx_ring_size;
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2511,6 +2511,12 @@ static void macb_free_consistent(struct
 	unsigned int q;
 	int size;
 
+	if (bp->rx_ring_tieoff) {
+		dma_free_coherent(&bp->pdev->dev, macb_dma_desc_get_size(bp),
+				  bp->rx_ring_tieoff, bp->rx_ring_tieoff_dma);
+		bp->rx_ring_tieoff = NULL;
+	}
+
 	bp->macbgem_ops.mog_free_rx_buffers(bp);
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
@@ -2602,6 +2608,16 @@ static int macb_alloc_consistent(struct
 	if (bp->macbgem_ops.mog_alloc_rx_buffers(bp))
 		goto out_err;
 
+	/* Required for tie off descriptor for PM cases */
+	if (!(bp->caps & MACB_CAPS_QUEUE_DISABLE)) {
+		bp->rx_ring_tieoff = dma_alloc_coherent(&bp->pdev->dev,
+							macb_dma_desc_get_size(bp),
+							&bp->rx_ring_tieoff_dma,
+							GFP_KERNEL);
+		if (!bp->rx_ring_tieoff)
+			goto out_err;
+	}
+
 	return 0;
 
 out_err:
@@ -2609,6 +2625,19 @@ out_err:
 	return -ENOMEM;
 }
 
+static void macb_init_tieoff(struct macb *bp)
+{
+	struct macb_dma_desc *desc = bp->rx_ring_tieoff;
+
+	if (bp->caps & MACB_CAPS_QUEUE_DISABLE)
+		return;
+	/* Setup a wrapping descriptor with no free slots
+	 * (WRAP and USED) to tie off/disable unused RX queues.
+	 */
+	macb_set_addr(bp, desc, MACB_BIT(RX_WRAP) | MACB_BIT(RX_USED));
+	desc->ctrl = 0;
+}
+
 static void gem_init_rings(struct macb *bp)
 {
 	struct macb_queue *queue;
@@ -2632,6 +2661,7 @@ static void gem_init_rings(struct macb *
 		gem_rx_refill(queue);
 	}
 
+	macb_init_tieoff(bp);
 }
 
 static void macb_init_rings(struct macb *bp)
@@ -2649,6 +2679,8 @@ static void macb_init_rings(struct macb
 	bp->queues[0].tx_head = 0;
 	bp->queues[0].tx_tail = 0;
 	desc->ctrl |= MACB_BIT(TX_WRAP);
+
+	macb_init_tieoff(bp);
 }
 
 static void macb_reset_hw(struct macb *bp)
@@ -5188,6 +5220,7 @@ static int __maybe_unused macb_suspend(s
 	unsigned long flags;
 	unsigned int q;
 	int err;
+	u32 tmp;
 
 	if (!device_may_wakeup(&bp->dev->dev))
 		phy_exit(bp->sgmii_phy);
@@ -5197,17 +5230,38 @@ static int __maybe_unused macb_suspend(s
 
 	if (bp->wol & MACB_WOL_ENABLED) {
 		spin_lock_irqsave(&bp->lock, flags);
-		/* Flush all status bits */
-		macb_writel(bp, TSR, -1);
-		macb_writel(bp, RSR, -1);
+
+		/* Disable Tx and Rx engines before  disabling the queues,
+		 * this is mandatory as per the IP spec sheet
+		 */
+		tmp = macb_readl(bp, NCR);
+		macb_writel(bp, NCR, tmp & ~(MACB_BIT(TE) | MACB_BIT(RE)));
 		for (q = 0, queue = bp->queues; q < bp->num_queues;
 		     ++q, ++queue) {
+			/* Disable RX queues */
+			if (bp->caps & MACB_CAPS_QUEUE_DISABLE) {
+				queue_writel(queue, RBQP, MACB_BIT(QUEUE_DISABLE));
+			} else {
+				/* Tie off RX queues */
+				queue_writel(queue, RBQP,
+					     lower_32_bits(bp->rx_ring_tieoff_dma));
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+				queue_writel(queue, RBQPH,
+					     upper_32_bits(bp->rx_ring_tieoff_dma));
+#endif
+			}
 			/* Disable all interrupts */
 			queue_writel(queue, IDR, -1);
 			queue_readl(queue, ISR);
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, -1);
 		}
+		/* Enable Receive engine */
+		macb_writel(bp, NCR, tmp | MACB_BIT(RE));
+		/* Flush all status bits */
+		macb_writel(bp, TSR, -1);
+		macb_writel(bp, RSR, -1);
+
 		/* Change interrupt handler and
 		 * Enable WoL IRQ on queue 0
 		 */


