Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022135;
	b=ucCmb9mZ7u3ozsQuoWbfjM11xU4HxPMNAy5CjnAgTvlFF7hz4QH0C3VVlGzVeX3bBGrN
	 WDrnz/3DvujBOwGYJ+Vq1uDO7I8MyvtUu4GBZpvqqxHoZ1xv86GtrVae3BfiA2SpN7N0K
	 /HdIBobfwJm/ZSic3s3dl4NxCGhFeupyf3P/bDOaGssphF6N14O+Q63sB/f2q7Rpv6kwN
	 wr8iCnX+2Vuv288pT7u7FRXNERwh1sDiwEghkmPGiE5zfIDAuy4ChnDIqthFsrcLvPac/
	 VSauTSfkE9x14U1ts8HMV4l2dJvIOlxGfhFEhTVfAXowC1p2PWDfhTo2eM4Iw/sPJhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WbCZBGs4yf7AbzfVA9SR6eure4EXFkgtDMcBTMPsMOs=;
	b=pGaAdhm3VAlVFTrPJ0tfdEaMeaSb9jrDsNXkBxHzZPZjeoR/6wvN49joI/891IfwnWjE
	 ZhE1WsMicz4QM2O12wUKGblq7ZwBN9x6CVaPeWUGBB8fsSmnSppUrCx5OupD5guIhip8A
	 hmZcYPRrrVHOavtyiT+CA2Dd7IQjTWvuxl7xvV7wF6jQSc1wixCyDRUJPhy9SclQ2yY+F
	 XC8ykz2XYHLNtesy0zQVdTypnMED3fhiE6trUXuDv3l/3dnr+Dn814IrJMDrAUyxYkkiT
	 yuTvDEZqGsWK7JhbSuV7Iie5H4DhDFShr0QAgqpigYujPd5xWn7ZS0/NKLZgESYrnpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBjuzfBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F5F606A31C;
	Wed, 18 Nov 2026 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBjuzfBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE3C1F000C4;
	Wed, 18 Nov 2026 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022134;
	bh=WbCZBGs4yf7AbzfVA9SR6eure4EXFkgtDMcBTMPsMOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vBjuzfBiUUOOHyH0C3ZWLdFA57rgQ+CdXnN0U4n2BokV01+qCxImadorH1LeCSUC3
	 pu7SOvejOwXlagZi4kHjkTPx73OUWnCfSDGZzl9iZC38WCpo3mAhIIjbj5jcLs9Vy3
	 9wjJe0Zmbvb3vFme6LAMssYbMTDsBzJJNX5i0axQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2554/2651] net: bcmgenet: recover from a failed resume
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150416.432475291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 1c1f51c3ee9ccf86462e36548291ed44fecd5355 ]

A resume that fails in bcmgenet_init_dma() returns with the interface
still IFF_UP and the datapath gone. The next ifdown runs the teardown
a second time and napi_disable() waits for a NAPI_STATE_SCHED bit that
nothing will clear:

  task:ip  state:D
    usleep_range_state+0xec/0x158
    napi_disable_locked+0x254/0x318
    napi_disable+0x3c/0x68
    bcmgenet_netif_stop+0x1c8/0x318
    bcmgenet_close+0x24/0xd0
    __dev_close_many+0x18c/0x310

RTNL is held across the wait, so everything else blocks behind it.

The same resume gates the clock and detaches the device. Close releases
the clock a second time and ifup fails with -ENODEV. The hardware filters
stay armed, so the next WoL suspend wakes on any frame. That suspend sets
CMD_RX_EN for magic packet detection, so the WoL resume reuses rings that
are gone.

A failed resume should leave a state the ordinary paths can handle. Clear
rx_cbs and tx_cbs as they are freed so they answer whether a datapath
exists, and leave the clock alone so close and suspend release it once.
The WoL resume rebuilds instead, so stop the PHY first, phy_start() only
takes PHY_READY or PHY_HALTED.

Flagged in a sashiko review and reproduced on a CM4 by forcing the resume
allocation to fail.

Fixes: b6e978e50444 ("net: bcmgenet: add suspend/resume callbacks")
Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")	# for the WoL parts
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261022-nb-genet-fini-dma-net-v3-1-6e9fc89c0156@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 92 +++++++++++++------
 1 file changed, 62 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index f4cfbff49a1b8..e7dec73d5b1c0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3117,7 +3117,9 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 	bcmgenet_free_rx_buffers(priv);
 	bcmgenet_destroy_rx_page_pools(priv);
 	kfree(priv->rx_cbs);
+	priv->rx_cbs = NULL;
 	kfree(priv->tx_cbs);
+	priv->tx_cbs = NULL;
 }
 
 /* init_edma: Initialize DMA control register */
@@ -3175,6 +3177,7 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 	priv->tx_cbs = kzalloc_objs(struct enet_cb, priv->num_tx_bds);
 	if (!priv->tx_cbs) {
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		return -ENOMEM;
 	}
 
@@ -3194,7 +3197,9 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 		bcmgenet_free_rx_buffers(priv);
 		bcmgenet_destroy_rx_page_pools(priv);
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		kfree(priv->tx_cbs);
+		priv->tx_cbs = NULL;
 		return ret;
 	}
 
@@ -3503,7 +3508,9 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev, false);
+	/* A failed resume has torn the datapath down already */
+	if (priv->tx_cbs)
+		bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -3511,6 +3518,9 @@ static int bcmgenet_close(struct net_device *dev)
 	free_irq(priv->irq0, priv);
 	free_irq(priv->irq1, priv);
 
+	/* A failed resume left the device detached, __dev_open() refuses that */
+	netif_device_attach(dev);
+
 	if (priv->internal_phy)
 		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
 
@@ -4268,7 +4278,11 @@ static int bcmgenet_resume(struct device *d)
 
 	if (device_may_wakeup(d) && priv->wolopts) {
 		reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-		if (reg & CMD_RX_EN) {
+
+		/* The WoL power down sets CMD_RX_EN itself, so the bit
+		 * alone does not mean the rings survived
+		 */
+		if (priv->tx_cbs && (reg & CMD_RX_EN)) {
 			/* Successfully exited WoL, just resume data flows */
 			list_for_each_entry(rule, &priv->rxnfc_list, list)
 				if (rule->state == BCMGENET_RXNFC_STATE_ENABLED)
@@ -4298,6 +4312,9 @@ static int bcmgenet_resume(struct device *d)
 		bcmgenet_rdma_disable(priv);
 		bcmgenet_intr_disable(priv);
 		bcmgenet_fini_dma(priv);
+		if (phy_is_started(dev->phydev) ||
+		    dev->phydev->state == PHY_ERROR)
+			phy_stop(dev->phydev);
 		enable_irq(priv->irq1);
 	}
 
@@ -4320,8 +4337,9 @@ static int bcmgenet_resume(struct device *d)
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv, false);
 	if (ret) {
+		/* Leave the block clocked, close and suspend tear it down */
 		netdev_err(dev, "failed to initialize DMA\n");
-		goto out_clk_disable;
+		return ret;
 	}
 
 	if (!device_may_wakeup(d))
@@ -4332,24 +4350,57 @@ static int bcmgenet_resume(struct device *d)
 	netif_device_attach(dev);
 
 	return 0;
+}
 
-out_clk_disable:
-	if (priv->internal_phy)
-		bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
-	clk_disable_unprepare(priv->clk);
-	return ret;
+/* Arm the configured wake filters and drop the rest, then clear old
+ * matches so that only a new one wakes the system
+ */
+static void bcmgenet_wol_arm_filters(struct bcmgenet_priv *priv)
+{
+	struct bcmgenet_rxnfc_rule *rule;
+	u32 reg, hfb_enable = 0;
+
+	if (priv->wolopts & WAKE_FILTER)
+		list_for_each_entry(rule, &priv->rxnfc_list, list)
+			if (rule->fs.ring_cookie == RX_CLS_FLOW_WAKE &&
+			    rule->state == BCMGENET_RXNFC_STATE_ENABLED)
+				hfb_enable |= 1 << rule->fs.location;
+
+	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	if (GENET_IS_V1(priv) || GENET_IS_V2(priv)) {
+		reg &= ~RBUF_HFB_FILTER_EN_MASK;
+		reg |= hfb_enable << (RBUF_HFB_FILTER_EN_SHIFT + 1);
+	} else {
+		bcmgenet_hfb_reg_writel(priv, hfb_enable << 1,
+					HFB_FLT_ENABLE_V3PLUS + 4);
+	}
+	if (!hfb_enable)
+		reg &= ~RBUF_HFB_EN;
+	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+
+	bcmgenet_intrl2_0_writel(priv, 0xFFFFFFFF, INTRL2_CPU_MASK_SET);
+	bcmgenet_intrl2_0_writel(priv, 0xFFFFFFFF, INTRL2_CPU_CLEAR);
 }
 
 static int bcmgenet_suspend(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct bcmgenet_rxnfc_rule *rule;
-	u32 reg, hfb_enable = 0;
 
 	if (!netif_running(dev))
 		return 0;
 
+	/* A failed resume has torn the datapath down already. Resume still
+	 * enables irq1 on the WoL path, so it has to be disabled here.
+	 */
+	if (!priv->tx_cbs) {
+		if (device_may_wakeup(d) && priv->wolopts) {
+			bcmgenet_wol_arm_filters(priv);
+			disable_irq(priv->irq1);
+		}
+		return 0;
+	}
+
 	netif_device_detach(dev);
 
 	if (device_may_wakeup(d) && priv->wolopts) {
@@ -4358,26 +4409,7 @@ static int bcmgenet_suspend(struct device *d)
 		netif_tx_disable(dev);
 
 		/* Suspend non-wake Rx data flows */
-		if (priv->wolopts & WAKE_FILTER)
-			list_for_each_entry(rule, &priv->rxnfc_list, list)
-				if (rule->fs.ring_cookie == RX_CLS_FLOW_WAKE &&
-				    rule->state == BCMGENET_RXNFC_STATE_ENABLED)
-					hfb_enable |= 1 << rule->fs.location;
-		reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
-		if (GENET_IS_V1(priv) || GENET_IS_V2(priv)) {
-			reg &= ~RBUF_HFB_FILTER_EN_MASK;
-			reg |= hfb_enable << (RBUF_HFB_FILTER_EN_SHIFT + 1);
-		} else {
-			bcmgenet_hfb_reg_writel(priv, hfb_enable << 1,
-						HFB_FLT_ENABLE_V3PLUS + 4);
-		}
-		if (!hfb_enable)
-			reg &= ~RBUF_HFB_EN;
-		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
-
-		/* Clear any old filter matches so only new matches wake */
-		bcmgenet_intrl2_0_writel(priv, 0xFFFFFFFF, INTRL2_CPU_MASK_SET);
-		bcmgenet_intrl2_0_writel(priv, 0xFFFFFFFF, INTRL2_CPU_CLEAR);
+		bcmgenet_wol_arm_filters(priv);
 
 		if (-ETIMEDOUT == bcmgenet_tdma_disable(priv))
 			netdev_warn(priv->dev,
-- 
2.53.0



