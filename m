Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A131CFEA9;
	Tue, 15 Oct 2024 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993115; cv=none; b=TQ7eWLUseg9g3Qk4lR8T0agqQjqWykYKQ9WBsKvC2PIevK7aNTPz6fjONPAFOMDNBUqVzCrJ3sY5glP/wv1wZelSyagfILR1PkBAF4qRU3Yp+5iyc4zJpbuu5yaqEEo35Hnj6tHWX0tr5xNdAuZH1IAXEuvbq38pOVF1E5jr7ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993115; c=relaxed/simple;
	bh=5Pf6ghFiWPX+lI6SHIDjM/ysuNxkVhxSbZofbZl7R6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma88iF1QMFxxbZW1jOe2pQmFs542CgPIm7Fnu5Wke0cYBUthwVLq/ZDHAEmfDPispvq+acQuq43//kCWaByUXgdEvjNRA0mIAQdkzRBD/sSvPHbMj4eZ4C0ariTn5jsh46oVXfcM2WMvnnCt4+np9qEASD84RlY0DBfUvWA+Q44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fX+OZlaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fX+OZlaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12232C4CEC6;
	Tue, 15 Oct 2024 11:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993115;
	bh=5Pf6ghFiWPX+lI6SHIDjM/ysuNxkVhxSbZofbZl7R6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fX+OZlazTsvklrB3Pfei37+yuHfuvgRlrhHKRMY8gvkTSRHpKLvNgthUo2kxFned+
	 Jlvu2BEO6NrXgrQT6D6Jj3bhJGFDxOLBuFSf65Dlqe7h6w/SN9q3ajQuQtUYXHPD7c
	 7LNIWmhsRrXB5jycrSBzES3Ti5FkbTAfwL2fzdss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/691] net: axienet: implement NAPI and GRO receive
Date: Tue, 15 Oct 2024 13:23:52 +0200
Message-ID: <20241015112451.619542459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit cc37610caaf8d13a6ecb8afd1fe2ebc2424ff622 ]

Implement NAPI and GRO receive. In addition to better performance, this
also avoids handling RX packets in hard IRQ context, which reduces the
IRQ latency impact to other devices.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  6 ++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 81 ++++++++++++-------
 2 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index bdda836115095..e8a210201f744 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -386,6 +386,7 @@ struct axidma_bd {
  * @phy_node:	Pointer to device node structure
  * @phylink:	Pointer to phylink instance
  * @phylink_config: phylink configuration settings
+ * @napi:	NAPI control structure
  * @pcs_phy:	Reference to PCS/PMA PHY if used
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
  * @axi_clk:	AXI4-Lite bus clock
@@ -395,6 +396,7 @@ struct axidma_bd {
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
+ * @rx_dma_cr:  Nominal content of RX DMA control register
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -434,6 +436,8 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
+	struct napi_struct napi;
+
 	struct mdio_device *pcs_phy;
 
 	bool switch_x_sgmii;
@@ -448,6 +452,8 @@ struct axienet_local {
 	void __iomem *regs;
 	void __iomem *dma_regs;
 
+	u32 rx_dma_cr;
+
 	struct work_struct dma_err_task;
 
 	int tx_irq;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 7bb8d04c997e7..a33e860861d55 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -7,7 +7,7 @@
  * Copyright (c) 2008-2009 Secret Lab Technologies Ltd.
  * Copyright (c) 2010 - 2011 Michal Simek <monstr@monstr.eu>
  * Copyright (c) 2010 - 2011 PetaLogix
- * Copyright (c) 2019 SED Systems, a division of Calian Ltd.
+ * Copyright (c) 2019 - 2022 Calian Advanced Technologies
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  *
  * This is a driver for the Xilinx Axi Ethernet which is used in the Virtex6
@@ -232,18 +232,18 @@ static void axienet_dma_bd_release(struct net_device *ndev)
  */
 static void axienet_dma_start(struct axienet_local *lp)
 {
-	u32 rx_cr, tx_cr;
+	u32 tx_cr;
 
 	/* Start updating the Rx channel control register */
-	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
-		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	lp->rx_dma_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
+			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
 	/* Only set interrupt delay timer if not generating an interrupt on
 	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_rx > 1)
-		rx_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-			 XAXIDMA_IRQ_DELAY_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+		lp->rx_dma_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+				 XAXIDMA_IRQ_DELAY_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 
 	/* Start updating the Tx channel control register */
 	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
@@ -260,8 +260,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * halted state. This will make the Rx side ready for reception.
 	 */
 	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	rx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+	lp->rx_dma_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
 			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
@@ -876,28 +876,26 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 }
 
 /**
- * axienet_recv - Is called from Axi DMA Rx Isr to complete the received
- *		  BD processing.
- * @ndev:	Pointer to net_device structure.
+ * axienet_poll - Triggered by RX ISR to complete the received BD processing.
+ * @napi:	Pointer to NAPI structure.
+ * @budget:	Max number of packets to process.
  *
- * This function is invoked from the Axi DMA Rx isr to process the Rx BDs. It
- * does minimal processing and invokes "netif_rx" to complete further
- * processing.
+ * Return: Number of RX packets processed.
  */
-static void axienet_recv(struct net_device *ndev)
+static int axienet_poll(struct napi_struct *napi, int budget)
 {
 	u32 length;
 	u32 csumstatus;
 	u32 size = 0;
-	u32 packets = 0;
+	int packets = 0;
 	dma_addr_t tail_p = 0;
-	struct axienet_local *lp = netdev_priv(ndev);
-	struct sk_buff *skb, *new_skb;
 	struct axidma_bd *cur_p;
+	struct sk_buff *skb, *new_skb;
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
 
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
-	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
+	while (packets < budget && (cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		dma_addr_t phys;
 
 		/* Ensure we see complete descriptor update */
@@ -919,7 +917,7 @@ static void axienet_recv(struct net_device *ndev)
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
-			skb->protocol = eth_type_trans(skb, ndev);
+			skb->protocol = eth_type_trans(skb, lp->ndev);
 			/*skb_checksum_none_assert(skb);*/
 			skb->ip_summed = CHECKSUM_NONE;
 
@@ -938,13 +936,13 @@ static void axienet_recv(struct net_device *ndev)
 				skb->ip_summed = CHECKSUM_COMPLETE;
 			}
 
-			netif_rx(skb);
+			napi_gro_receive(napi, skb);
 
 			size += length;
 			packets++;
 		}
 
-		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
+		new_skb = netdev_alloc_skb_ip_align(lp->ndev, lp->max_frm_size);
 		if (!new_skb)
 			break;
 
@@ -953,7 +951,7 @@ static void axienet_recv(struct net_device *ndev)
 				      DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
-				netdev_err(ndev, "RX DMA mapping error\n");
+				netdev_err(lp->ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
 			break;
 		}
@@ -973,11 +971,20 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	ndev->stats.rx_packets += packets;
-	ndev->stats.rx_bytes += size;
+	lp->ndev->stats.rx_packets += packets;
+	lp->ndev->stats.rx_bytes += size;
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
+
+	if (packets < budget && napi_complete_done(napi, packets)) {
+		/* Re-enable RX completion interrupts. This should
+		 * cause an immediate interrupt if any RX packets are
+		 * already pending.
+		 */
+		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
+	}
+	return packets;
 }
 
 /**
@@ -1023,7 +1030,7 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  *
  * Return: IRQ_HANDLED if device generated a RX interrupt, IRQ_NONE otherwise.
  *
- * This is the Axi DMA Rx Isr. It invokes "axienet_recv" to complete the BD
+ * This is the Axi DMA Rx Isr. It invokes NAPI polling to complete the RX BD
  * processing.
  */
 static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
@@ -1046,7 +1053,15 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 			   (lp->rx_bd_v[lp->rx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
 	} else {
-		axienet_recv(lp->ndev);
+		/* Disable further RX completion interrupts and schedule
+		 * NAPI receive.
+		 */
+		u32 cr = lp->rx_dma_cr;
+
+		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
+		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+
+		napi_schedule(&lp->napi);
 	}
 
 	return IRQ_HANDLED;
@@ -1122,6 +1137,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
+	napi_enable(&lp->napi);
+
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
 			  ndev->name, ndev);
@@ -1147,6 +1164,7 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&lp->napi);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1170,6 +1188,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
+	napi_disable(&lp->napi);
+
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
@@ -1743,6 +1763,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
+	napi_disable(&lp->napi);
+
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
@@ -1807,6 +1829,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
+	napi_enable(&lp->napi);
 }
 
 /**
@@ -1855,6 +1878,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
 		/* For backward compatibility, if named AXI clock is not present,
-- 
2.43.0



