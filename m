Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35563A5426;
	Wed, 20 May 2026 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301889; cv=none; b=tconnVvl7DD6t20HXfMHouR0YFNLfncujy41o/tahtkprBwUoAlw+nlY5vnPUexDeXB6lqaXmamgBUBkuzGz2xdGlVtQyQ1QyGuDjPQSJRkoFn7WPU1heGWSZAe/am5v2uB1Z/54EnQVlrvmxGzpY2JBPVZB4vUJ8FiwhS5HEAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301889; c=relaxed/simple;
	bh=OefnmZsoSGtJH5jq104lqg4+4Z7x/c5su6Y66f7asPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXe0RtQATaCsgQbCBL11XGg8PmMKUKoHx+B/3WVa3Y0yBQSAlVlDgeMHK4TOYAkUnwbai07io/NQxBDRd9nIsZfxHUo8XucAC2GIQjQAqONMYNJtJPZCU0eo69uoOFbMTTVdzssXCDebbm5eQ03m47sypKrmEiaKcjSJSLGEcp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3LMx+cG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3LMx+cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444EB1F00893;
	Wed, 20 May 2026 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301887;
	bh=L4iv5ZV3GPhG2SeLvSI/W2mpS6yJ4u0hiC9j7MOR/eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3LMx+cGFeV9J25gFproeSRVj14plkiLxHE/s4ihhzohs0onjuWMw/xHl1qQK5aIy
	 ZT0v+pm8jG8lzHDdzzFGsKK1hfI4vnYmLVhXFq/NGxwDisU7J8yWAGyxBkkp4iJMyd
	 Xf5OpTSybv1N7yAqfUYU4wpZNOGEXYcs36PhUF5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/508] net: bcmgenet: support reclaiming unsent Tx packets
Date: Wed, 20 May 2026 18:18:01 +0200
Message-ID: <20260520162059.858141678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit f1bacae8b655163dcbc3c54b9e714ef1a8986d7b ]

When disabling the transmitter any outstanding packets can now
be reclaimed by bcmgenet_tx_reclaim_all() rather than by the
bcmgenet_fini_dma() function.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-12-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5393b2b5bee2 ("net: bcmgenet: fix racing timeout handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 37 +++++++++++++++----
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ed66ae393100e..de15243c52a62 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1885,12 +1885,39 @@ static unsigned int __bcmgenet_tx_reclaim(struct net_device *dev,
 }
 
 static unsigned int bcmgenet_tx_reclaim(struct net_device *dev,
-				struct bcmgenet_tx_ring *ring)
+				struct bcmgenet_tx_ring *ring,
+				bool all)
 {
-	unsigned int released;
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device *kdev = &priv->pdev->dev;
+	unsigned int released, drop, wr_ptr;
+	struct enet_cb *cb_ptr;
+	struct sk_buff *skb;
 
 	spin_lock_bh(&ring->lock);
 	released = __bcmgenet_tx_reclaim(dev, ring);
+	if (all) {
+		skb = NULL;
+		drop = (ring->prod_index - ring->c_index) & DMA_C_INDEX_MASK;
+		released += drop;
+		ring->prod_index = ring->c_index & DMA_C_INDEX_MASK;
+		while (drop--) {
+			cb_ptr = bcmgenet_put_txcb(priv, ring);
+			skb = cb_ptr->skb;
+			bcmgenet_free_tx_cb(kdev, cb_ptr);
+			if (skb && cb_ptr == GENET_CB(skb)->first_cb) {
+				dev_consume_skb_any(skb);
+				skb = NULL;
+			}
+		}
+		if (skb)
+			dev_consume_skb_any(skb);
+		bcmgenet_tdma_ring_writel(priv, ring->index,
+					  ring->prod_index, TDMA_PROD_INDEX);
+		wr_ptr = ring->write_ptr * WORDS_PER_BD(priv);
+		bcmgenet_tdma_ring_writel(priv, ring->index, wr_ptr,
+					  TDMA_WRITE_PTR);
+	}
 	spin_unlock_bh(&ring->lock);
 
 	return released;
@@ -1927,7 +1954,7 @@ static void bcmgenet_tx_reclaim_all(struct net_device *dev)
 	int i = 0;
 
 	do {
-		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++]);
+		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++], true);
 	} while (i <= priv->hw_params->tx_queues && netif_is_multiqueue(dev));
 }
 
@@ -2924,10 +2951,6 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 	bcmgenet_fini_rx_napi(priv);
 	bcmgenet_fini_tx_napi(priv);
 
-	for (i = 0; i < priv->num_tx_bds; i++)
-		dev_kfree_skb(bcmgenet_free_tx_cb(&priv->pdev->dev,
-						  priv->tx_cbs + i));
-
 	for (i = 0; i <= priv->hw_params->tx_queues; i++) {
 		txq = netdev_get_tx_queue(priv->dev, i);
 		netdev_tx_reset_queue(txq);
-- 
2.53.0



