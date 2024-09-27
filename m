Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244E817B515;
	Fri, 27 Sep 2024 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440045; cv=none; b=p3PBN2HZqSoR9WONcG0XMTSNoOE5GaN01D9zmrnPPfpPJhyL/jTYCma1kr6Awzf3AOxYcMhMhzhOwurf9rKkknX0t2Ze4ytoClLK/BnDHrdyjLv80ONFCfNPwnwbz/3vpEiwQmG/CKAebohBOOm8BysPB0c424XWTJtQKc+/huw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440045; c=relaxed/simple;
	bh=UuQaAJTCvhMUYEJA4g88rzv1sqdX8Y360uwtC1lK/u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQW5uTYGGbNrSPe7EAtCqibTnmCzdcSzG5sDprLGIDhEbkvFSHsBVZ+Pu9EvXigS0FaizW/Qthkm6GOqafRwnGXtRaXhQCiEX6y3ua0u24w1c2Z6/+V/FNOI2duOz/jUXwvI9xp/921XDiglCPyZQjlEFyZzbjqb/dK1/QWCeLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwPs9SKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwPs9SKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A641AC4CEC4;
	Fri, 27 Sep 2024 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440045;
	bh=UuQaAJTCvhMUYEJA4g88rzv1sqdX8Y360uwtC1lK/u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwPs9SKkMba74Fz7ydA/owkEpTSCXZKVW6KTESEn809FufnzZkJZPOLbGVEJ0xTjx
	 Gxk1d60VgN2l0KYz1Tum11735M28oIR0/QcuGcNbuwDvGhHABlAR+AlHX894p++FIz
	 YLxmM61g2VqgbIfBUQv7PPEiNmogizYtANFyUf1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 13/58] net: ftgmac100: Ensure tx descriptor updates are visible
Date: Fri, 27 Sep 2024 14:23:15 +0200
Message-ID: <20240927121719.337113027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Chou <jacky_chou@aspeedtech.com>

[ Upstream commit 4186c8d9e6af57bab0687b299df10ebd47534a0a ]

The driver must ensure TX descriptor updates are visible
before updating TX pointer and TX clear pointer.

This resolves TX hangs observed on AST2600 when running
iperf3.

Signed-off-by: Jacky Chou <jacky_chou@aspeedtech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 26 ++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index fddfd1dd50709..4c546c3aef0fe 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -572,7 +572,7 @@ static bool ftgmac100_rx_packet(struct ftgmac100 *priv, int *processed)
 	(*processed)++;
 	return true;
 
- drop:
+drop:
 	/* Clean rxdes0 (which resets own bit) */
 	rxdes->rxdes0 = cpu_to_le32(status & priv->rxdes0_edorr_mask);
 	priv->rx_pointer = ftgmac100_next_rx_pointer(priv, pointer);
@@ -656,6 +656,11 @@ static bool ftgmac100_tx_complete_packet(struct ftgmac100 *priv)
 	ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
 	txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
 
+	/* Ensure the descriptor config is visible before setting the tx
+	 * pointer.
+	 */
+	smp_wmb();
+
 	priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv, pointer);
 
 	return true;
@@ -809,6 +814,11 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	dma_wmb();
 	first->txdes0 = cpu_to_le32(f_ctl_stat);
 
+	/* Ensure the descriptor config is visible before setting the tx
+	 * pointer.
+	 */
+	smp_wmb();
+
 	/* Update next TX pointer */
 	priv->tx_pointer = pointer;
 
@@ -829,7 +839,7 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_OK;
 
- dma_err:
+dma_err:
 	if (net_ratelimit())
 		netdev_err(netdev, "map tx fragment failed\n");
 
@@ -851,7 +861,7 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	 * last fragment, so we know ftgmac100_free_tx_packet()
 	 * hasn't freed the skb yet.
 	 */
- drop:
+drop:
 	/* Drop the packet */
 	dev_kfree_skb_any(skb);
 	netdev->stats.tx_dropped++;
@@ -1344,7 +1354,7 @@ static void ftgmac100_reset(struct ftgmac100 *priv)
 	ftgmac100_init_all(priv, true);
 
 	netdev_dbg(netdev, "Reset done !\n");
- bail:
+bail:
 	if (priv->mii_bus)
 		mutex_unlock(&priv->mii_bus->mdio_lock);
 	if (netdev->phydev)
@@ -1543,15 +1553,15 @@ static int ftgmac100_open(struct net_device *netdev)
 
 	return 0;
 
- err_ncsi:
+err_ncsi:
 	napi_disable(&priv->napi);
 	netif_stop_queue(netdev);
- err_alloc:
+err_alloc:
 	ftgmac100_free_buffers(priv);
 	free_irq(netdev->irq, netdev);
- err_irq:
+err_irq:
 	netif_napi_del(&priv->napi);
- err_hw:
+err_hw:
 	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
 	ftgmac100_free_rings(priv);
 	return err;
-- 
2.43.0



