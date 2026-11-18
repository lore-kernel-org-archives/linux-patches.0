Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042616;
	b=m/gOs+Z6A8p+8SmwgbpC2aiWqobPw0Fxsu5OPCq+fM2TaoS0udK7RdOsVC6fLk1kBS4R
	 Z4TucpLYcsGdijScgc0KiFAXBPGQvOZQkaR2uai1p/dgwyGhR6uLAmfYudrank8kklQpq
	 Wx2hrCCYOz5xgwvcanHdu/ncNg+LUWKGaQIM/hbhOquNQ5LDyr9XQPFKD8TLTp6BnTheC
	 qGNmK9x7RmAac6N7B9s0ddbpPfa3xs+QoU1EWDI8sqI6zFQWQfp5SY+ltuugg/N/gVgWo
	 ToWEcVla1vwc68aq2+Lu5F5p9Pr7dWfdAkD1O1Ev/Y54GQsHkhy+y8zfudkZte/BglQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rXhc9zcp6bOqiCmndJjxY0ZQc7f/glC/Pp/5savDJw=;
	b=YyqVuXNHX7wvLuB8Y5sPOGFKIsFbBTNxLWsA6VSVnFpXhbZPTTHAJTcE8zB1vRE8yYmv
	 RtoBaE9s0oHhFvAM6GrN4oiv41ZrWy5O38RZlz6Af1vLCVB3V4VPoih1DY3aR0S87z/Ll
	 SE+JhMOgTbf1hsTZCRl/O9IqZTptYZMqIA0PqjGx+0Uic8HIiX4+zIghSqHmqZ0uCyXql
	 Z2NkWxhZIHQvE7z34DbHkbMOxdw8v8GxHDTKKit8LBiC4O30YJHJR5La6FZ8rV5LW1Nbu
	 bb65nquE4QHjISrWG7/7ygK3EZnOUBzprwyFa0zMznWyMD75DFbfBivWr84RcB817Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lB1FJ18u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC65606A325;
	Wed, 18 Nov 2026 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lB1FJ18u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A831F000C4;
	Wed, 18 Nov 2026 22:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042615;
	bh=6rXhc9zcp6bOqiCmndJjxY0ZQc7f/glC/Pp/5savDJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lB1FJ18uRSqLaf+AtfHByqeodRC4j6Nd2uh8H0qi/1hJkjhwKMh6PHbZ3xAtAZGYN
	 cLbJ9EVFLcDd4p4U3O1e9FQGHGlHn9pJdPFzEEdvryjksf+gvcQHMrFy9DRAHapEVk
	 65gl2WtXMvvW/BAZ2+Rvxtr6AH8PR3160N61OKJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3233/3318] net: bcmgenet: recover from a failed resume
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150456.691810414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45ce5eff13c15..42a6c45b94fee 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3000,7 +3000,9 @@ static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
 
 	bcmgenet_free_rx_buffers(priv);
 	kfree(priv->rx_cbs);
+	priv->rx_cbs = NULL;
 	kfree(priv->tx_cbs);
+	priv->tx_cbs = NULL;
 }
 
 /* init_edma: Initialize DMA control register */
@@ -3060,6 +3062,7 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 			       GFP_KERNEL);
 	if (!priv->tx_cbs) {
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		return -ENOMEM;
 	}
 
@@ -3078,7 +3081,9 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *priv, bool flush_rx)
 		netdev_err(priv->dev, "failed to initialize Rx queues\n");
 		bcmgenet_free_rx_buffers(priv);
 		kfree(priv->rx_cbs);
+		priv->rx_cbs = NULL;
 		kfree(priv->tx_cbs);
+		priv->tx_cbs = NULL;
 		return ret;
 	}
 
@@ -3386,7 +3391,9 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev, false);
+	/* A failed resume has torn the datapath down already */
+	if (priv->tx_cbs)
+		bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -3394,6 +3401,9 @@ static int bcmgenet_close(struct net_device *dev)
 	free_irq(priv->irq0, priv);
 	free_irq(priv->irq1, priv);
 
+	/* A failed resume left the device detached, __dev_open() refuses that */
+	netif_device_attach(dev);
+
 	if (priv->internal_phy)
 		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
 
@@ -4163,7 +4173,11 @@ static int bcmgenet_resume(struct device *d)
 
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
@@ -4193,6 +4207,9 @@ static int bcmgenet_resume(struct device *d)
 		bcmgenet_rdma_disable(priv);
 		bcmgenet_intr_disable(priv);
 		bcmgenet_fini_dma(priv);
+		if (phy_is_started(dev->phydev) ||
+		    dev->phydev->state == PHY_ERROR)
+			phy_stop(dev->phydev);
 		enable_irq(priv->irq1);
 	}
 
@@ -4218,8 +4235,9 @@ static int bcmgenet_resume(struct device *d)
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv, false);
 	if (ret) {
+		/* Leave the block clocked, close and suspend tear it down */
 		netdev_err(dev, "failed to initialize DMA\n");
-		goto out_clk_disable;
+		return ret;
 	}
 
 	if (!device_may_wakeup(d))
@@ -4230,50 +4248,64 @@ static int bcmgenet_resume(struct device *d)
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



