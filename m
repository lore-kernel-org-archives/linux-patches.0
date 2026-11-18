Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033227;
	b=gp40LF5fkvSXzwh1SfS8FWiwbLsh/T68CqYDJkFhxHp73xxQmvBWVeJxH94BkPBch96g
	 fBacZVHF0Sp5AZBGmvDm17JgYyXWnR0ukCBxpD7tijYHpC0smV4YuIzyX0r1h91zlQlG5
	 Pbclr1Tm9SK92ZnLG0Zvb/44IDUJZNhUsYM8xDl34MzOBoHHLYTCRBfJKOuOwO1MLWLSH
	 g7+PVEudI5xfGKAVaAaC8KOaruuKvcDYCKjZ7ODWbh8ZLplOTE1FH2zZaZFSxHrWtcDWs
	 KhnJ1eT/4VLYCUMJ+Azs7b/lXuaIVt21JXK5N1xqAWTivUnv99cRc/zMcqaboPln1nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bug3YS2PnxCyEx3xTdqezLUXr2hLVUUd04cT0fgn11s=;
	b=QA5JorcCavNrF3CIFvLYUbe+N/i8DnBy23tolUTMKbwl7myTSj8MZRE6wHHdl8+cv8qi
	 MT+aKa+zSxXL2oicHgSJ+aoot9TBA2LNgNZfgdwfeHnsJJRwBX5wxSSoR46ODXlL73sPv
	 7p39IyILeaV7dTwIlvYP+XcE8OkOEA7kfjrvw0qwGr7m6XQAb93fywNd3QSuN9oi4Y8gd
	 HG5EccIZFbpuutZY+QDJgnHnAAlqYuxzb9QnilC/Ty4uyV2+B+kDzeEXxOAwdt/+d+dOr
	 sPFnNkF5caqucDmLUZg6Eny8159f5Ro/1pqvrcLAQFB/KcPENkj0xOWBUfF5BzcHtfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XR6hcls1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B5D606A330;
	Wed, 18 Nov 2026 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XR6hcls1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F891F000C4;
	Wed, 18 Nov 2026 20:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033227;
	bh=bug3YS2PnxCyEx3xTdqezLUXr2hLVUUd04cT0fgn11s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XR6hcls1ysvysKY2ZyYeu6nZEcnjpEc2+mxuj225Ua5W6gA9qj9GzvUQDByorv6UY
	 I5B8OVjMEubxW3k0pItVHRZR4wIDckoS1uRSTXn/jac54uKanrMcza+aLVrWuTcxJB
	 vLAqwbvSfYddMMD3SdI/kIeNHwltqdABv9b/aaPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1650/1756] net: bcmgenet: recover from a failed resume
Date: Wed, 18 Nov 2026 16:02:57 +0100
Message-ID: <20261118150115.427221037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9280f94641d74..608dd03c6fe69 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2991,7 +2991,9 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 
 	bcmgenet_free_rx_buffers(priv);
 	kfree(priv->rx_cbs);
+	priv->rx_cbs = NULL;
 	kfree(priv->tx_cbs);
+	priv->tx_cbs = NULL;
 }
 
 /* init_edma: Initialize DMA control register */
@@ -3051,6 +3053,7 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 			       GFP_KERNEL);
 	if (!priv->tx_cbs) {
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		return -ENOMEM;
 	}
 
@@ -3069,7 +3072,9 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 		netdev_err(priv->dev, "failed to initialize Rx queues\n");
 		bcmgenet_free_rx_buffers(priv);
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		kfree(priv->tx_cbs);
+		priv->tx_cbs = NULL;
 		return ret;
 	}
 
@@ -3377,7 +3382,9 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev, false);
+	/* A failed resume has torn the datapath down already */
+	if (priv->tx_cbs)
+		bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -3385,6 +3392,9 @@ static int bcmgenet_close(struct net_device *dev)
 	free_irq(priv->irq0, priv);
 	free_irq(priv->irq1, priv);
 
+	/* A failed resume left the device detached, __dev_open() refuses that */
+	netif_device_attach(dev);
+
 	if (priv->internal_phy)
 		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
 
@@ -4152,7 +4162,11 @@ static int bcmgenet_resume(struct device *d)
 
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
@@ -4182,6 +4196,9 @@ static int bcmgenet_resume(struct device *d)
 		bcmgenet_rdma_disable(priv);
 		bcmgenet_intr_disable(priv);
 		bcmgenet_fini_dma(priv);
+		if (phy_is_started(dev->phydev) ||
+		    dev->phydev->state == PHY_ERROR)
+			phy_stop(dev->phydev);
 		enable_irq(priv->irq1);
 	}
 
@@ -4207,8 +4224,9 @@ static int bcmgenet_resume(struct device *d)
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv, false);
 	if (ret) {
+		/* Leave the block clocked, close and suspend tear it down */
 		netdev_err(dev, "failed to initialize DMA\n");
-		goto out_clk_disable;
+		return ret;
 	}
 
 	if (!device_may_wakeup(d))
@@ -4219,50 +4237,64 @@ static int bcmgenet_resume(struct device *d)
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



