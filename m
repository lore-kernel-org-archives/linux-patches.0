Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA7719B3FF;
	Tue, 15 Oct 2024 11:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993093; cv=none; b=tFhMw06gpE1u9r8Mabq3zHywwdFS/QhUhv3TywIVwnLN24zbShkkTF0n8/XzdOuf7AUFnNxCrdQNk8sloAFhS24jDSD7gIB+pP4wvDxrYqLBWZa/BSYxHs+IjrUySRcmxRW9vsSSttGXKKJLPw1Lez9aBgzKfq9FvL4XLgi/qDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993093; c=relaxed/simple;
	bh=BLrrBSyvNRHUmHMo5dlq511xLteEfpjNyXtiSxCKV78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmpewOj0KsQcaPGk6uyOAD/W4Gj7eAOaHEDLzlqZ3GSVnF0hMG3lus9RQNB9IQjwG3+GB0AMxTSRrAin3hhxQWKZmuv/r8N7w0+3hxDnHS7hRnRN8TujwoIxybRnDDBAH9Adxb4RqVC3hrw4P2sBmp61iVW8kdoHYYnXLw3mSMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG2hWTgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG2hWTgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F83C4CEC6;
	Tue, 15 Oct 2024 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993092;
	bh=BLrrBSyvNRHUmHMo5dlq511xLteEfpjNyXtiSxCKV78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG2hWTgwvmz3rHhHZMbFPx6pMm6T0/KxcGm/tpDE5Q7vRa0Ak6wCw9PM6nJYyIZLE
	 WxPwEJcSoc9XlcyHvWbHlDCh21huKARRVWOQRlrsf+4kQAwXx+ilEPTMNjsfhF4Mf6
	 2yZdvIhu9MNdewe6wFxRPRAEpQh5BIxUxw1Bbctw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/691] net: axienet: Clean up device used for DMA calls
Date: Tue, 15 Oct 2024 13:23:49 +0200
Message-ID: <20241015112451.497663138@linuxfoundation.org>
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

[ Upstream commit 17882fd4256721451457ee57532bbae0cd5cacfe ]

Instead of using lp->ndev.parent to find the correct device to use for
DMA API calls, just use the dev attribute in the device structure.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0ca350faa4848..50738ef43fb42 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -190,7 +190,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 			  lp->tx_bd_v,
 			  lp->tx_bd_p);
@@ -215,12 +215,12 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 */
 		if (lp->rx_bd_v[i].cntrl) {
 			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(ndev->dev.parent, phys,
+			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
 	}
 
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 			  lp->rx_bd_v,
 			  lp->rx_bd_p);
@@ -249,13 +249,13 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	lp->rx_bd_ci = 0;
 
 	/* Allocate the Tx and Rx buffer descriptors. */
-	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->tx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
 		return -ENOMEM;
 
-	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->rx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 					 &lp->rx_bd_p, GFP_KERNEL);
 	if (!lp->rx_bd_v)
@@ -285,9 +285,9 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		addr = dma_map_single(ndev->dev.parent, skb->data,
+		addr = dma_map_single(lp->dev, skb->data,
 				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, addr)) {
+		if (dma_mapping_error(lp->dev, addr)) {
 			netdev_err(ndev, "DMA mapping error\n");
 			goto out;
 		}
@@ -637,7 +637,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys,
+		dma_unmap_single(lp->dev, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				 DMA_TO_DEVICE);
 
@@ -775,9 +775,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	phys = dma_map_single(ndev->dev.parent, skb->data,
+	phys = dma_map_single(lp->dev, skb->data,
 			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+	if (unlikely(dma_mapping_error(lp->dev, phys))) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
@@ -791,11 +791,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(ndev->dev.parent,
+		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
 				      skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -873,7 +873,7 @@ static void axienet_recv(struct net_device *ndev)
 			length = cur_p->app4 & 0x0000FFFF;
 
 			phys = desc_get_phys_addr(lp, cur_p);
-			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+			dma_unmap_single(lp->dev, phys, lp->max_frm_size,
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
@@ -906,10 +906,10 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			break;
 
-		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+		phys = dma_map_single(lp->dev, new_skb->data,
 				      lp->max_frm_size,
 				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
@@ -1770,7 +1770,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 		if (cur_p->cntrl) {
 			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
 
-			dma_unmap_single(ndev->dev.parent, addr,
+			dma_unmap_single(lp->dev, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-- 
2.43.0



