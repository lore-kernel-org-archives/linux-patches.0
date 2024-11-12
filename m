Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3681B2141DC;
	Tue, 12 Nov 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407669; cv=none; b=NQXllhvNzdAY0k0GUo/JHzVVFaHtdl2UtZ91wPqFTN/32G2NSGpvwBvfDGMS9Uk74Al6MbtpCjBWLjL3zFUYUzbV8AiwYRo5h1Wo2XG8ii5dj6p7NNz4YE0Y4qUEWz09Y2+gRWkLMXC/6XO2bid27TWDuqzxK2trk60bv+XPNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407669; c=relaxed/simple;
	bh=0Cu4jFzva4XePwZ7Iz8BycpzfmhzqqRY66W5e8wsf2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA4FwscLjIjbbeZqDOgW4B7pgmeqv6sDzZp6AwDgd0bAGyVLW1C1/XZBU7VHoX2ur5a0quyD4OP458l3V75XwBv7fG/n2HoRMiG87IHnxaPBdE9hY7HT9RWjQUwjyAbbfxKjeb8n0DERmIC38L6RxDMkqpKb+1nUcCKBAgZRuH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZwA+loZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZwA+loZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7C5C4CECD;
	Tue, 12 Nov 2024 10:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407669;
	bh=0Cu4jFzva4XePwZ7Iz8BycpzfmhzqqRY66W5e8wsf2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZwA+loZqnmyS5RGQmERy4g12pKSOV0rwy6cn5MigPD8E51zxwYAVb6F6y4/3t1W7
	 68PGyEvWJmtm7IoJnrep2mE3CkUcvGK22INAVti0jupVYcqJPHbQjZjoAgb/2rsmBX
	 bdREgnKhPbBdmLuk5RlYsDNo3fLK4aroax5GC5QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wu <david.wu@rock-chips.com>,
	Johan Jonker <jbx6244@gmail.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/119] net: arc: fix the device for dma_map_single/dma_unmap_single
Date: Tue, 12 Nov 2024 11:20:54 +0100
Message-ID: <20241112101850.476952820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



