Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420BF3016E1;
	Sat, 30 May 2026 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161026; cv=none; b=bt2D0+4/9ymcQIinZezYc4MttdG4vDL7+0FdnG/6eR1ePOaADjxv7ozoqWoVh+HCwbtJ2hSxc5avdqu0ylVgIQV5pbReZhWy98P1t70Y7I5ustoGVBXUzyZBHhDgBEmAE9ZZdT8ak3qYTz8mlkWbau07UJp/WWfQ4djEN9Df1g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161026; c=relaxed/simple;
	bh=AFQpIzWtLnx38dXK+GO1gSmz28TjHtCv1vQdyvEr3S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHhKKr8E4Wtl7jC5z+APCHPTl/8n1EFbrRdw5jC9E+ne3VwTsVa2SIx/Yh5wnvo+kUa9sknLEho2wfoP6eaWh5vIgMG3YMf4atnYeNX8no/nwGLzKrdyEF7bZgZMMn0gcMIERcKmqD066D+2zCxE9exSU7YqvrWzTMp9APtEymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sier3Hpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sier3Hpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685D21F00893;
	Sat, 30 May 2026 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161025;
	bh=emIH8PwUxoVC6er0trpVvdFwxcawJGXZ3sThiZ1mLWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sier3HpgKUXWgLUv57YbSoRsrU3EKyoGpnzz3dhdMNQVfEB7hi4g7G0JCmJ9GRW/E
	 WrjKI6B9jb9jtc4sz3tqOoOFiz8xzjR8Zy16SuKelzkKZk7nrVkZaUG3z9y75z3jv5
	 8hsPlnwomHSe3MdKQIZQZPa5uIj6DM/dk63JzSuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 473/969] net: bcmgenet: support reclaiming unsent Tx packets
Date: Sat, 30 May 2026 17:59:57 +0200
Message-ID: <20260530160313.355450272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 9f670bbecc726..032ba3a157e4b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1880,12 +1880,39 @@ static unsigned int __bcmgenet_tx_reclaim(struct net_device *dev,
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
@@ -1922,7 +1949,7 @@ static void bcmgenet_tx_reclaim_all(struct net_device *dev)
 	int i = 0;
 
 	do {
-		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++]);
+		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++], true);
 	} while (i <= priv->hw_params->tx_queues && netif_is_multiqueue(dev));
 }
 
@@ -2919,10 +2946,6 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
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



