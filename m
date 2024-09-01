Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4BA2B9C7;
	Sun,  1 Sep 2024 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208847; cv=none; b=rcH5ExtmZVZRopXnE7yS334weBaGNruolwzXndgJr7nZnW8vixCOO+4v8zmTn7Bm9bnPZZE2G8tU9sSI0Zvfq+Gxr49OXD2Pc0gqLV3hdH9FHYU7PpsYZZ5faMIt4WeKf5LZIJl8aZCtmZSHHqBvIfkZvfYlkp2Q8Ueu22ukNyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208847; c=relaxed/simple;
	bh=GKQhq9U0gDE1SRUqXeJf/rJkFWke/hTd9eeu3vbmsSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abx/MKKwZAAUOQLIK4UjDrsWj/fTqwzkWvL2SJbmoLKsh7obXDNlfv0GEsvyaiPfaa3FOUU7fu7N2mI4IAuKyFI0f59lXl3obuK0MlXDURW1xhSEuvlvZTz7wo6NConUNqdDs38iXforka8A2s/VHrQvJfO7NanAnoWPbN6Zz1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7fyCORr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7fyCORr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA58C4CEC3;
	Sun,  1 Sep 2024 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208847;
	bh=GKQhq9U0gDE1SRUqXeJf/rJkFWke/hTd9eeu3vbmsSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7fyCORrwJ71Iyd+ccufWV5wb8WcYyG4Af6AuH0li0gVscHUhvkPHJkdgxCIckHnn
	 T7TmeK7BCs5X8EymsgzT0GFdJ/C3jQ9AMgxVkMGCBdlZ3zWkDMB2eXHqL88+L+4Loq
	 9hFxwN1uV2szf6JBmk1Or3vK9GcRpELxMefXFrcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/134] net: axienet: Upgrade descriptors to hold 64-bit addresses
Date: Sun,  1 Sep 2024 18:16:11 +0200
Message-ID: <20240901160811.056114381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 4e958f33ee8f404787711416fe0f78cce2b2f4e2 ]

Newer revisions of the AXI DMA IP (>= v7.1) support 64-bit addresses,
both for the descriptors itself, as well as for the buffers they are
pointing to.
This is realised by adding "MSB" words for the next and phys pointer
right behind the existing address word, now named "LSB". These MSB words
live in formerly reserved areas of the descriptor.

If the hardware supports it, write both words when setting an address.
The buffer address is handled by two wrapper functions, the two
occasions where we set the next pointers are open coded.

For now this is guarded by a flag which we don't set yet.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   9 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 113 ++++++++++++------
 2 files changed, 83 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index fb7450ca5c532..84c4c3655516a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -328,6 +328,7 @@
 #define XAE_FEATURE_PARTIAL_TX_CSUM	(1 << 1)
 #define XAE_FEATURE_FULL_RX_CSUM	(1 << 2)
 #define XAE_FEATURE_FULL_TX_CSUM	(1 << 3)
+#define XAE_FEATURE_DMA_64BIT		(1 << 4)
 
 #define XAE_NO_CSUM_OFFLOAD		0
 
@@ -340,9 +341,9 @@
 /**
  * struct axidma_bd - Axi Dma buffer descriptor layout
  * @next:         MM2S/S2MM Next Descriptor Pointer
- * @reserved1:    Reserved and not used
+ * @next_msb:     MM2S/S2MM Next Descriptor Pointer (high 32 bits)
  * @phys:         MM2S/S2MM Buffer Address
- * @reserved2:    Reserved and not used
+ * @phys_msb:     MM2S/S2MM Buffer Address (high 32 bits)
  * @reserved3:    Reserved and not used
  * @reserved4:    Reserved and not used
  * @cntrl:        MM2S/S2MM Control value
@@ -355,9 +356,9 @@
  */
 struct axidma_bd {
 	u32 next;	/* Physical address of next buffer descriptor */
-	u32 reserved1;
+	u32 next_msb;	/* high 32 bits for IP >= v7.1, reserved on older IP */
 	u32 phys;
-	u32 reserved2;
+	u32 phys_msb;	/* for IP >= v7.1, reserved for older IP */
 	u32 reserved3;
 	u32 reserved4;
 	u32 cntrl;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index bd03a6d66e122..5440f39c5760d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -154,6 +154,25 @@ static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 	axienet_dma_out32(lp, reg, lower_32_bits(addr));
 }
 
+static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
+			       struct axidma_bd *desc)
+{
+	desc->phys = lower_32_bits(addr);
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		desc->phys_msb = upper_32_bits(addr);
+}
+
+static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
+				     struct axidma_bd *desc)
+{
+	dma_addr_t ret = desc->phys;
+
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		ret |= ((dma_addr_t)desc->phys_msb << 16) << 16;
+
+	return ret;
+}
+
 /**
  * axienet_dma_bd_release - Release buffer descriptor rings
  * @ndev:	Pointer to the net_device structure
@@ -177,6 +196,8 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		return;
 
 	for (i = 0; i < lp->rx_bd_num; i++) {
+		dma_addr_t phys;
+
 		/* A NULL skb means this descriptor has not been initialised
 		 * at all.
 		 */
@@ -189,9 +210,11 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 * descriptor size, after it had been successfully allocated.
 		 * So a non-zero value in there means we need to unmap it.
 		 */
-		if (lp->rx_bd_v[i].cntrl)
-			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+		if (lp->rx_bd_v[i].cntrl) {
+			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
+			dma_unmap_single(ndev->dev.parent, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
+		}
 	}
 
 	dma_free_coherent(ndev->dev.parent,
@@ -236,29 +259,36 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		goto out;
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
-		lp->tx_bd_v[i].next = lp->tx_bd_p +
-				      sizeof(*lp->tx_bd_v) *
-				      ((i + 1) % lp->tx_bd_num);
+		dma_addr_t addr = lp->tx_bd_p +
+				  sizeof(*lp->tx_bd_v) *
+				  ((i + 1) % lp->tx_bd_num);
+
+		lp->tx_bd_v[i].next = lower_32_bits(addr);
+		if (lp->features & XAE_FEATURE_DMA_64BIT)
+			lp->tx_bd_v[i].next_msb = upper_32_bits(addr);
 	}
 
 	for (i = 0; i < lp->rx_bd_num; i++) {
-		lp->rx_bd_v[i].next = lp->rx_bd_p +
-				      sizeof(*lp->rx_bd_v) *
-				      ((i + 1) % lp->rx_bd_num);
+		dma_addr_t addr;
+
+		addr = lp->rx_bd_p + sizeof(*lp->rx_bd_v) *
+			((i + 1) % lp->rx_bd_num);
+		lp->rx_bd_v[i].next = lower_32_bits(addr);
+		if (lp->features & XAE_FEATURE_DMA_64BIT)
+			lp->rx_bd_v[i].next_msb = upper_32_bits(addr);
 
 		skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
 		if (!skb)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
-						     skb->data,
-						     lp->max_frm_size,
-						     DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
+		addr = dma_map_single(ndev->dev.parent, skb->data,
+				      lp->max_frm_size, DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, addr)) {
 			netdev_err(ndev, "DMA mapping error\n");
 			goto out;
 		}
+		desc_set_phys_addr(lp, addr, &lp->rx_bd_v[i]);
 
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
@@ -575,6 +605,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 	struct axidma_bd *cur_p;
 	int max_bds = nr_bds;
 	unsigned int status;
+	dma_addr_t phys;
 	int i;
 
 	if (max_bds == -1)
@@ -590,9 +621,10 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
-		dma_unmap_single(ndev->dev.parent, cur_p->phys,
-				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
-				DMA_TO_DEVICE);
+		phys = desc_get_phys_addr(lp, cur_p);
+		dma_unmap_single(ndev->dev.parent, phys,
+				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
+				 DMA_TO_DEVICE);
 
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
@@ -688,7 +720,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 csum_start_off;
 	u32 csum_index_off;
 	skb_frag_t *frag;
-	dma_addr_t tail_p;
+	dma_addr_t tail_p, phys;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
 	u32 orig_tail_ptr = lp->tx_bd_tail;
@@ -727,14 +759,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
-				     skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+	phys = dma_map_single(ndev->dev.parent, skb->data,
+			      skb_headlen(skb), DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
 	}
+	desc_set_phys_addr(lp, phys, cur_p);
 	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
@@ -742,11 +775,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		cur_p->phys = dma_map_single(ndev->dev.parent,
-					     skb_frag_address(frag),
-					     skb_frag_size(frag),
-					     DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+		phys = dma_map_single(ndev->dev.parent,
+				      skb_frag_address(frag),
+				      skb_frag_size(frag),
+				      DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -756,6 +789,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 			return NETDEV_TX_OK;
 		}
+		desc_set_phys_addr(lp, phys, cur_p);
 		cur_p->cntrl = skb_frag_size(frag);
 	}
 
@@ -794,10 +828,12 @@ static void axienet_recv(struct net_device *ndev)
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
+		dma_addr_t phys;
+
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
-		dma_unmap_single(ndev->dev.parent, cur_p->phys,
-				 lp->max_frm_size,
+		phys = desc_get_phys_addr(lp, cur_p);
+		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);
 
 		skb = cur_p->skb;
@@ -833,15 +869,16 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			return;
 
-		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
-					     lp->max_frm_size,
-					     DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+				      lp->max_frm_size,
+				      DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
 			return;
 		}
+		desc_set_phys_addr(lp, phys, cur_p);
 
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
@@ -886,7 +923,8 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
+		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
+			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
 			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
 
 		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
@@ -935,7 +973,8 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
+		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
+			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
 			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
 
 		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
@@ -1628,14 +1667,18 @@ static void axienet_dma_err_handler(struct work_struct *work)
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->cntrl)
-			dma_unmap_single(ndev->dev.parent, cur_p->phys,
+		if (cur_p->cntrl) {
+			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
+
+			dma_unmap_single(ndev->dev.parent, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
+		}
 		if (cur_p->skb)
 			dev_kfree_skb_irq(cur_p->skb);
 		cur_p->phys = 0;
+		cur_p->phys_msb = 0;
 		cur_p->cntrl = 0;
 		cur_p->status = 0;
 		cur_p->app0 = 0;
-- 
2.43.0



