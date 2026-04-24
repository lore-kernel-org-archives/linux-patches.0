Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331713D47B0;
	Fri, 24 Apr 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037945; cv=none; b=X5Djt+fEVV7HR1/lI10ZFKlEW6u+p2LHHZnvWxynSj0kb2NZHxRrdwNThhhcTKcQlyxOimR+ageH5q7DsAHhT68YTmi6mBkMY98FuNrU92Sy21yQ4yg1RAN6BjsdscCPHxuZq3OBCgOzshARLtQmhxP066LQN5rcmlBQAD2N7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037945; c=relaxed/simple;
	bh=7bV7oExWtZalEKrFDlVHsqtTMOTMu03CRgsmygFrNAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2ry4hXc5N9NlgTwYMvh8eAMWZWdItGbdIFCZco2ZYNUQacmx3GLg8HxQbC63EP01iCGgJyiDs4Q8HsWYELh/PaHuj/Kf68W8OrnQ5bqlJp1hO9eQeJbdgQ606mPSNPTh6YDfmOph2uUKr5wzn4Xpbru2SHbzLwk33rlGnIH20s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=serdd83I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="serdd83I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A16C19425;
	Fri, 24 Apr 2026 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037944;
	bh=7bV7oExWtZalEKrFDlVHsqtTMOTMu03CRgsmygFrNAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=serdd83IG6Qo1M7LmTlV6cA209aKJsgNHE4TlBDjLv/xbYIZJOGz9PllLj4r1havc
	 94Z0fk6Q0fxGMshQxOUp4/QOxObtRpBQpllaX0MZ3U/qNULf+nNudtrfysoeF7TlsD
	 Ds60q/L8RXzVqg/q9h+hMYR7d1iisdMf2aXlesWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/166] net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers
Date: Fri, 24 Apr 2026 15:30:45 +0200
Message-ID: <20260424132600.336933910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

commit 2dddb34dd0d07b01fa770eca89480a4da4f13153 upstream.

The PPE enforces output frame size limits via per-tag-layer VLAN_MTU
registers that the driver never initializes. The hardware defaults do
not account for PPPoE overhead, causing the PPE to punt encapsulated
frames back to the CPU instead of forwarding them.

Initialize the registers at PPE start and on MTU changes using the
maximum GMAC MTU. This is a conservative approximation -- the actual
per-PPE requirement depends on egress path, but using the global
maximum ensures the limits are never too small.

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/ec995ab8ce8be423267a1cc093147a74d2eb9d82.1775789829.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 22 ++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 30 +++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  1 +
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e2d3bda1dc923..74cb96dbff9ee 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3368,11 +3368,22 @@ static int mtk_device_event(struct notifier_block *n, unsigned long event, void
 	return NOTIFY_DONE;
 }
 
+static int mtk_max_gmac_mtu(struct mtk_eth *eth)
+{
+	int i, max_mtu = ETH_DATA_LEN;
+
+	for (i = 0; i < ARRAY_SIZE(eth->netdev); i++)
+		if (eth->netdev[i] && eth->netdev[i]->mtu > max_mtu)
+			max_mtu = eth->netdev[i]->mtu;
+
+	return max_mtu;
+}
+
 static int mtk_open(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
-	int i, err;
+	int i, err, mtu;
 
 	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
 	if (err) {
@@ -3400,6 +3411,10 @@ static int mtk_open(struct net_device *dev)
 						  : MTK_GDMA_TO_PDMA;
 		mtk_gdm_config(eth, gdm_config);
 
+		mtu = mtk_max_gmac_mtu(eth);
+		for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+			mtk_ppe_update_mtu(eth->ppe[i], mtu);
+
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
@@ -4088,6 +4103,7 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	int length = new_mtu + MTK_RX_ETH_HLEN;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	int max_mtu, i;
 
 	if (rcu_access_pointer(eth->prog) &&
 	    length > MTK_PP_MAX_BUF_SIZE) {
@@ -4098,6 +4114,10 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	mtk_set_mcr_max_rx(mac, length);
 	dev->mtu = new_mtu;
 
+	max_mtu = mtk_max_gmac_mtu(eth);
+	for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+		mtk_ppe_update_mtu(eth->ppe[i], max_mtu);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 6e222a000bf7e..1e033d63b4510 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -971,6 +971,36 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
 	}
 }
 
+void mtk_ppe_update_mtu(struct mtk_ppe *ppe, int mtu)
+{
+	int base;
+	u32 val;
+
+	if (!ppe)
+		return;
+
+	/* The PPE checks output frame size against per-tag-layer MTU limits,
+	 * treating PPPoE and DSA tags just like 802.1Q VLAN tags. The Linux
+	 * device MTU already accounts for PPPoE (PPPOE_SES_HLEN) and DSA tag
+	 * overhead, but 802.1Q VLAN tags are handled transparently without
+	 * being reflected by the lower device MTU being increased by 4.
+	 * Use the maximum MTU across all GMAC interfaces so that PPE output
+	 * frame limits are sufficiently high regardless of which port a flow
+	 * egresses through.
+	 */
+	base = ETH_HLEN + mtu;
+
+	val = FIELD_PREP(MTK_PPE_VLAN_MTU0_NONE, base) |
+	      FIELD_PREP(MTK_PPE_VLAN_MTU0_1TAG, base + VLAN_HLEN);
+	ppe_w32(ppe, MTK_PPE_VLAN_MTU0, val);
+
+	val = FIELD_PREP(MTK_PPE_VLAN_MTU1_2TAG,
+			 base + 2 * VLAN_HLEN) |
+	      FIELD_PREP(MTK_PPE_VLAN_MTU1_3TAG,
+			 base + 3 * VLAN_HLEN);
+	ppe_w32(ppe, MTK_PPE_VLAN_MTU1, val);
+}
+
 void mtk_ppe_start(struct mtk_ppe *ppe)
 {
 	u32 val;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index e3d0ec72bc699..11c76fb8289ac 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -346,6 +346,7 @@ struct mtk_ppe {
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index);
 
 void mtk_ppe_deinit(struct mtk_eth *eth);
+void mtk_ppe_update_mtu(struct mtk_ppe *ppe, int mtu);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 int mtk_ppe_prepare_reset(struct mtk_ppe *ppe);
-- 
2.53.0



