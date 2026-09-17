Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4223B5326B4;
	Thu, 17 Sep 2026 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666124; cv=none; b=YQGUlm4wo5pnGmPt7Rpj9GUqmHS5MM/33Mzq5AiEFGSGSfoUp28a9RO9SizAcr5xm7Qus8ciJmzg84KF2Ru6uoQC++74Ll7Mrdbz5hv70SBKPPLzIcJW6ix0sPodQ4siYVwHiSpv81WA+rhd3Nm0hsvXAPxHOEfnhOJjItKp2H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666124; c=relaxed/simple;
	bh=+9Lt8OLiG7olq4ctAJnt3lX4aGuG+mKNZgrAfEgmEH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODsbf6gKoNZeb+LSGiY7g3xPPwN108twsPKqKAUX0CaRLnBDAgLk0Hy1xj+uK+wAWSayh12N9HCxtZ2jGQ6qYtZVphBrnRgGDcDP897seQ7dPMdhB1q87UCKHs0g/3r3c0ws/kCJcXPiArHv2usEUbz9+gSsolCUjICA4fACrM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hppacPDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hppacPDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D121F000FF;
	Thu, 17 Sep 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666122;
	bh=+Pp31sfRpOg4Y3GSE+ywDHgjERKm5ZvXePCuZ7Ts/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hppacPDpqM+RWGpuO9RJFguiDnTaO8W1eVrF4tgqBiLvORApii7rD6nmt1GBhAJPi
	 7F76mJhwom7pusUXsWgr28wRGCXnqYtUHP4qtjKoutC/gwj5si1n2TzPnbBE/9yTVM
	 V7m4cCGmz+Qwle4BXMr6Hz9riVaQX4+Dp8oFoOt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joris Vaisvila <joey@tinyisr.com>,
	Daniel Golle <daniel@makrotpia.org>,
	Stefan Roese <stefan.roese@mailbox.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0931/1250] net: ethernet: mtk_eth_soc: avoid writing to ESW registers on MT7628
Date: Thu, 17 Sep 2026 16:12:06 +0100
Message-ID: <20260917151617.246862348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joris Vaisvila <joey@tinyisr.com>

[ Upstream commit 9a04d3b2f0708a9e5e1f731bafb69b040bb934a0 ]

The MT7628 has a fixed-link PHY and does not expose MAC control
registers. Writes to these registers only corrupt the ESW VLAN
configuration.

This patch explicitly registers no-op phylink_mac_ops for MT7628, as
after removing the invalid register accesses, the existing
phylink_mac_ops effectively become no-ops.

This code was introduced by commit 296c9120752b
("net: ethernet: mediatek: Add MT7628/88 SoC support")

Signed-off-by: Joris Vaisvila <joey@tinyisr.com>
Reviewed-by: Daniel Golle <daniel@makrotpia.org>
Reviewed-by: Stefan Roese <stefan.roese@mailbox.org>
Link: https://patch.msgid.link/20260226154547.68553-1-joey@tinyisr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d876c9cb2d16 ("net: ethernet: mtk_eth_soc: populate lpi_interfaces to fix EEE support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 34 ++++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 98cf11a706e14..19d971bf66f51 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -562,9 +562,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	int val, ge_mode, err = 0;
 	u32 i;
 
-	/* MT76x8 has no hardware settings between for the MAC */
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
-	    mac->interface != state->interface) {
+	if (mac->interface != state->interface) {
 		/* Setup soc pin functions */
 		switch (state->interface) {
 		case PHY_INTERFACE_MODE_TRGMII:
@@ -956,6 +954,30 @@ static const struct phylink_mac_ops mtk_phylink_ops = {
 	.mac_enable_tx_lpi = mtk_mac_enable_tx_lpi,
 };
 
+static void rt5350_mac_config(struct phylink_config *config, unsigned int mode,
+				const struct phylink_link_state *state)
+{
+}
+
+static void rt5350_mac_link_down(struct phylink_config *config, unsigned int mode,
+				phy_interface_t interface)
+{
+}
+
+static void rt5350_mac_link_up(struct phylink_config *config,
+			    struct phy_device *phy,
+			    unsigned int mode, phy_interface_t interface,
+			    int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+}
+
+/* MT76x8 (rt5350-eth) does not expose any MAC control registers */
+static const struct phylink_mac_ops rt5350_phylink_ops = {
+	.mac_config = rt5350_mac_config,
+	.mac_link_down = rt5350_mac_link_down,
+	.mac_link_up = rt5350_mac_link_up,
+};
+
 static void mtk_mdio_config(struct mtk_eth *eth)
 {
 	u32 val;
@@ -4798,6 +4820,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
+	const struct phylink_mac_ops *mac_ops = &mtk_phylink_ops;
 	const __be32 *_id = of_get_property(np, "reg", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
@@ -4932,9 +4955,12 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 			  mac->phylink_config.supported_interfaces);
 	}
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		mac_ops = &rt5350_phylink_ops;
+
 	phylink = phylink_create(&mac->phylink_config,
 				 of_fwnode_handle(mac->of_node),
-				 phy_mode, &mtk_phylink_ops);
+				 phy_mode, mac_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
 		goto free_netdev;
-- 
2.53.0



