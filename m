Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130C3F7A9F;
	Wed, 20 May 2026 18:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300223; cv=none; b=rn3N3m4lk1pD2Wo2ko/UJH6BFOEKf35iBZ3pKfsLnBdDJzo3dN2bFOvqGH+SfDvdHqZPzBT/iBi/6NTgqW/bb3TGLY507fTYpcabBblGIHw9HDnGQAG5v8GRwIGvK0SRlDYztCr0HAIW2HFRTkuusb6BFE92cNftb/EtVqn6gxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300223; c=relaxed/simple;
	bh=XEMTxWD8kcvYFc+ng8R6G4w+84i66iWDsx6hou/2g9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjP6m3OQvQNJJ8dQt7Dc4Jb1fZd7ONEvv83cXyoRqLBqPmjyiPD4Xb3jmsByGYtdWmES3ufoNkZUiyx5k+nDBEcAUcN2HIq8S5Rm704T316fLe3j8s+XzbioOtEj9lcYEdxrecDmVFw2Tj2qzJ9KoPfjOLVPemOJjjhrj0QsSSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5rtQWzg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5rtQWzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9E91F000E9;
	Wed, 20 May 2026 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300221;
	bh=y1Kk7/64aQY+DLJrZLF0O0ehTg77l9RXJEgCqjzZWEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5rtQWzgQrORzS4RLgTkAxwoEfVhtw9jKMqpom8xgBE7yBGQOkXae7b1hVS64Ijbm
	 mZwnlC5O5jU6YU30kf+asPqtwVVQPGxpHqOA5BOZ07VBPdrMZOyZXcLMMs5hh/yXEG
	 J0xvsKOXLRS8DrbeAZ1QRMB+lj/EiSaid1sY6de8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/666] net: bcmgenet: support reclaiming unsent Tx packets
Date: Wed, 20 May 2026 18:14:47 +0200
Message-ID: <20260520162112.879532375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b73f1ed97a4c..35b613930238c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1876,12 +1876,39 @@ static unsigned int __bcmgenet_tx_reclaim(struct net_device *dev,
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
@@ -1918,7 +1945,7 @@ static void bcmgenet_tx_reclaim_all(struct net_device *dev)
 	int i = 0;
 
 	do {
-		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++]);
+		bcmgenet_tx_reclaim(dev, &priv->tx_rings[i++], true);
 	} while (i <= priv->hw_params->tx_queues && netif_is_multiqueue(dev));
 }
 
@@ -2915,10 +2942,6 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
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



