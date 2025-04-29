Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E86229B05;
	Tue, 29 Apr 2025 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945963; cv=none; b=jlRa+4jzDJ2JTS1jh6NUx/5sa+3s8kVRv5KhmoyOso9g0rsXBEDh8ARuViTar8oZNsQNoVQ/jMJDxsU/JXrEeT1sXjEZYGR34VeEmG9GFoMk+o2zatDgzdxiy0DEayDc6j8kJrFfkQ92/hAYwxSM9ktMTf/7YfFZGI1xLsK2x1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945963; c=relaxed/simple;
	bh=qGgH82uzwFYFtHzFycyuQknGoWtMXagd1ZQqfTGl8/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+c8VoYIx4UF1E5EQXfDADLKZxHtDQeBjdOhZBQQSU6TkIoC7wOVxfrMZOPhMKR+lRzD4Pi/0Sras+92tS71QbOeOLaScFWOJJ/3fGidIZYJ8whK0YzOxNg6Eize7jkE8XF1FPfO1PfLnFPWpE6Wc8RkHp7iLE8Xd7Q9SgvXF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b+ZDxNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b+ZDxNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875B6C4CEE3;
	Tue, 29 Apr 2025 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945963;
	bh=qGgH82uzwFYFtHzFycyuQknGoWtMXagd1ZQqfTGl8/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0b+ZDxNMqz1KqS3FRZzuQB09ahvZFy5/ZwxfFwINCcvvGkUsPiJou8nWM1Mwyr59m
	 ZgDn7R2deFFZsxT9kc6JQ2FQF+LzXKJg8OX/gG2syQSw1+61lKQbRkv/T5InpnRAlE
	 8CD4VWdSUlyrO4fj0osolixefTAXGpTZ9xcI2BXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 108/311] net: stmmac: block PHY RXC clock-stop
Date: Tue, 29 Apr 2025 18:39:05 +0200
Message-ID: <20250429161125.460539537@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit dd557266cf5fb01a8cd85482dd258c1e172301d1 upstream.

The DesignWare core requires the receive clock to be running during
certain operations. Ensure that we block PHY RXC clock-stop during
these operations.

This is a best-efforts change - not everywhere can be covered by this
because of net's core locking, which means we can't access the MDIO
bus to configure the PHY to disable RXC clock-stop in certain areas.
These are marked with FIXME comments.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1tvO6p-008Vjz-Qy@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3448,9 +3448,18 @@ static int stmmac_hw_setup(struct net_de
 	if (priv->hw->phylink_pcs)
 		phylink_pcs_pre_init(priv->phylink, priv->hw->phylink_pcs);
 
+	/* Note that clk_rx_i must be running for reset to complete. This
+	 * clock may also be required when setting the MAC address.
+	 *
+	 * Block the receive clock stop for LPI mode at the PHY in case
+	 * the link is established with EEE mode active.
+	 */
+	phylink_rx_clk_stop_block(priv->phylink);
+
 	/* DMA initialization and SW reset */
 	ret = stmmac_init_dma_engine(priv);
 	if (ret < 0) {
+		phylink_rx_clk_stop_unblock(priv->phylink);
 		netdev_err(priv->dev, "%s: DMA engine initialization failed\n",
 			   __func__);
 		return ret;
@@ -3458,6 +3467,7 @@ static int stmmac_hw_setup(struct net_de
 
 	/* Copy the MAC addr into the HW  */
 	stmmac_set_umac_addr(priv, priv->hw, dev->dev_addr, 0);
+	phylink_rx_clk_stop_unblock(priv->phylink);
 
 	/* PS and related bits will be programmed according to the speed */
 	if (priv->hw->pcs) {
@@ -3568,7 +3578,9 @@ static int stmmac_hw_setup(struct net_de
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
+	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_hw_vlan_mode(priv, priv->hw);
+	phylink_rx_clk_stop_unblock(priv->phylink);
 
 	return 0;
 }
@@ -5853,6 +5865,9 @@ static void stmmac_tx_timeout(struct net
  *  whenever multicast addresses must be enabled/disabled.
  *  Return value:
  *  void.
+ *
+ *  FIXME: This may need RXC to be running, but it may be called with BH
+ *  disabled, which means we can't call phylink_rx_clk_stop*().
  */
 static void stmmac_set_rx_mode(struct net_device *dev)
 {
@@ -5985,7 +6000,9 @@ static int stmmac_set_features(struct ne
 	else
 		priv->hw->hw_vlan_en = false;
 
+	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_hw_vlan_mode(priv, priv->hw);
+	phylink_rx_clk_stop_unblock(priv->phylink);
 
 	return 0;
 }
@@ -6269,7 +6286,9 @@ static int stmmac_set_mac_address(struct
 	if (ret)
 		goto set_mac_error;
 
+	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_umac_addr(priv, priv->hw, ndev->dev_addr, 0);
+	phylink_rx_clk_stop_unblock(priv->phylink);
 
 set_mac_error:
 	pm_runtime_put(priv->device);
@@ -6625,6 +6644,9 @@ static int stmmac_vlan_update(struct stm
 	return stmmac_update_vlan_hash(priv, priv->hw, hash, pmatch, is_double);
 }
 
+/* FIXME: This may need RXC to be running, but it may be called with BH
+ * disabled, which means we can't call phylink_rx_clk_stop*().
+ */
 static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -6656,6 +6678,9 @@ err_pm_put:
 	return ret;
 }
 
+/* FIXME: This may need RXC to be running, but it may be called with BH
+ * disabled, which means we can't call phylink_rx_clk_stop*().
+ */
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -7922,9 +7947,11 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_hw_setup(ndev, false);
 	stmmac_init_coalesce(priv);
+	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_rx_mode(ndev);
 
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
+	phylink_rx_clk_stop_unblock(priv->phylink);
 
 	stmmac_enable_all_queues(priv);
 	stmmac_enable_all_dma_irq(priv);


