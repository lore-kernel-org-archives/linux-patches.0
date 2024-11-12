Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FAD214411;
	Tue, 12 Nov 2024 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408236; cv=none; b=thNE5JCVW8qX3i6xsC+V2KRdzuRu9vQWS/s82eQeeulnjCmhEIsICE7TxEPTEoFrBJ4hn2az8fmys43MJjmm6fufB8unMaJBuO/IOPh4jq4trM+uyYFubbSMgfhge9hK+7ID5/xGRmtZgq/OIcHw5er6TxTqOCK1YdrXvjzq5NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408236; c=relaxed/simple;
	bh=xO2t/t7KjCGrzYEVT+xonTvIDolT4YIV3uwWdzUFsd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7cn8K3A9iPPmsmdSuOZa1vpQ6GRCVq1/jb6ftrL0NNWmdZ++8oMAfwQ7KEi3/CYLqask20zCBCAzmYpl0H9So8CfCdarkYaomun1EreTmLWdXHEVwZ5uCVj+XQtKIQp9zanZ7lmoyFkfGcGxUEQ6NGfbsY5mbphgm4bLT0njOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFCLMk66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFCLMk66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0817C4CECD;
	Tue, 12 Nov 2024 10:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408236;
	bh=xO2t/t7KjCGrzYEVT+xonTvIDolT4YIV3uwWdzUFsd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFCLMk66dgqDpWe6AenbqSgBQgdQyN2FxelZbqcbUTA8xcAKMkB0gS4m5je044Mh4
	 II2CZxVsVRc4NlyaOGraS6ZB3ilRePUvwolS8tnYiVw5GFRfNPmHwFA5nyIgLnu3aX
	 BnmcODBSf8paTxCBsWYp13x9CmdMcDX896ibg2sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wu <david.wu@rock-chips.com>,
	Johan Jonker <jbx6244@gmail.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 059/184] net: arc: fix the device for dma_map_single/dma_unmap_single
Date: Tue, 12 Nov 2024 11:20:17 +0100
Message-ID: <20241112101903.127900189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 71803c1dfa29e0d13b99e48fda11107cc8caebc7 ]

The ndev->dev and pdev->dev aren't the same device, use ndev->dev.parent
which has dma_mask, ndev->dev.parent is just pdev->dev.
Or it would cause the following issue:

[   39.933526] ------------[ cut here ]------------
[   39.938414] WARNING: CPU: 1 PID: 501 at kernel/dma/mapping.c:149 dma_map_page_attrs+0x90/0x1f8

Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Signed-off-by: David Wu <david.wu@rock-chips.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/arc/emac_main.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 31ee477dd131e..8283aeee35fb6 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -111,6 +111,7 @@ static void arc_emac_tx_clean(struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &ndev->stats;
+	struct device *dev = ndev->dev.parent;
 	unsigned int i;
 
 	for (i = 0; i < TX_BD_NUM; i++) {
@@ -140,7 +141,7 @@ static void arc_emac_tx_clean(struct net_device *ndev)
 			stats->tx_bytes += skb->len;
 		}
 
-		dma_unmap_single(&ndev->dev, dma_unmap_addr(tx_buff, addr),
+		dma_unmap_single(dev, dma_unmap_addr(tx_buff, addr),
 				 dma_unmap_len(tx_buff, len), DMA_TO_DEVICE);
 
 		/* return the sk_buff to system */
@@ -174,6 +175,7 @@ static void arc_emac_tx_clean(struct net_device *ndev)
 static int arc_emac_rx(struct net_device *ndev, int budget)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
+	struct device *dev = ndev->dev.parent;
 	unsigned int work_done;
 
 	for (work_done = 0; work_done < budget; work_done++) {
@@ -223,9 +225,9 @@ static int arc_emac_rx(struct net_device *ndev, int budget)
 			continue;
 		}
 
-		addr = dma_map_single(&ndev->dev, (void *)skb->data,
+		addr = dma_map_single(dev, (void *)skb->data,
 				      EMAC_BUFFER_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, addr)) {
+		if (dma_mapping_error(dev, addr)) {
 			if (net_ratelimit())
 				netdev_err(ndev, "cannot map dma buffer\n");
 			dev_kfree_skb(skb);
@@ -237,7 +239,7 @@ static int arc_emac_rx(struct net_device *ndev, int budget)
 		}
 
 		/* unmap previosly mapped skb */
-		dma_unmap_single(&ndev->dev, dma_unmap_addr(rx_buff, addr),
+		dma_unmap_single(dev, dma_unmap_addr(rx_buff, addr),
 				 dma_unmap_len(rx_buff, len), DMA_FROM_DEVICE);
 
 		pktlen = info & LEN_MASK;
@@ -423,6 +425,7 @@ static int arc_emac_open(struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 	struct phy_device *phy_dev = ndev->phydev;
+	struct device *dev = ndev->dev.parent;
 	int i;
 
 	phy_dev->autoneg = AUTONEG_ENABLE;
@@ -445,9 +448,9 @@ static int arc_emac_open(struct net_device *ndev)
 		if (unlikely(!rx_buff->skb))
 			return -ENOMEM;
 
-		addr = dma_map_single(&ndev->dev, (void *)rx_buff->skb->data,
+		addr = dma_map_single(dev, (void *)rx_buff->skb->data,
 				      EMAC_BUFFER_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, addr)) {
+		if (dma_mapping_error(dev, addr)) {
 			netdev_err(ndev, "cannot dma map\n");
 			dev_kfree_skb(rx_buff->skb);
 			return -ENOMEM;
@@ -548,6 +551,7 @@ static void arc_emac_set_rx_mode(struct net_device *ndev)
 static void arc_free_tx_queue(struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
+	struct device *dev = ndev->dev.parent;
 	unsigned int i;
 
 	for (i = 0; i < TX_BD_NUM; i++) {
@@ -555,7 +559,7 @@ static void arc_free_tx_queue(struct net_device *ndev)
 		struct buffer_state *tx_buff = &priv->tx_buff[i];
 
 		if (tx_buff->skb) {
-			dma_unmap_single(&ndev->dev,
+			dma_unmap_single(dev,
 					 dma_unmap_addr(tx_buff, addr),
 					 dma_unmap_len(tx_buff, len),
 					 DMA_TO_DEVICE);
@@ -579,6 +583,7 @@ static void arc_free_tx_queue(struct net_device *ndev)
 static void arc_free_rx_queue(struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
+	struct device *dev = ndev->dev.parent;
 	unsigned int i;
 
 	for (i = 0; i < RX_BD_NUM; i++) {
@@ -586,7 +591,7 @@ static void arc_free_rx_queue(struct net_device *ndev)
 		struct buffer_state *rx_buff = &priv->rx_buff[i];
 
 		if (rx_buff->skb) {
-			dma_unmap_single(&ndev->dev,
+			dma_unmap_single(dev,
 					 dma_unmap_addr(rx_buff, addr),
 					 dma_unmap_len(rx_buff, len),
 					 DMA_FROM_DEVICE);
@@ -679,6 +684,7 @@ static netdev_tx_t arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 	unsigned int len, *txbd_curr = &priv->txbd_curr;
 	struct net_device_stats *stats = &ndev->stats;
 	__le32 *info = &priv->txbd[*txbd_curr].info;
+	struct device *dev = ndev->dev.parent;
 	dma_addr_t addr;
 
 	if (skb_padto(skb, ETH_ZLEN))
@@ -692,10 +698,9 @@ static netdev_tx_t arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 
-	addr = dma_map_single(&ndev->dev, (void *)skb->data, len,
-			      DMA_TO_DEVICE);
+	addr = dma_map_single(dev, (void *)skb->data, len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&ndev->dev, addr))) {
+	if (unlikely(dma_mapping_error(dev, addr))) {
 		stats->tx_dropped++;
 		stats->tx_errors++;
 		dev_kfree_skb_any(skb);
-- 
2.43.0



