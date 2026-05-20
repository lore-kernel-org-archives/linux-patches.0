Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00C236A01E;
	Wed, 20 May 2026 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294888; cv=none; b=gXfBxxMrVg2g5Df7XZ2DQMXQ1Z1L7JMLJYZllxtRcA+tcnJd1IWU8J5RvmrrKXIm3DUZbSV4ffndQ1O2v++AFiA8ZzV/INJZ5JJgryXZtlGOExVTZYcWQPHPIH876sZra8bD54yF3jo72KdW6b1pZbLhS2z9WbRFLKTmkfPfQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294888; c=relaxed/simple;
	bh=eIApBFQFu0y26Q4m/d9ArulHIaiA/r5z0D2hZDoHTEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzwZKbxgFV/z9lQrDzDrXDDA/gqaAOcdHe2Exic5sFJvc4VLF4on68U1kgS6eFzW28Awib4GtQZLtkShdHuUkSchY+WF73fIU7YMVEodKmslSU0BbhQkBxzZudlJOKanC+ZFmAgSq5+d4YnLBQ9kkc7R8nue7Ld+AK96FtEIYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eqhm6cW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eqhm6cW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A361F000E9;
	Wed, 20 May 2026 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294887;
	bh=89PFykt7KbcNKN4b1abxVnBFqI2QygY47NR3XsgF+CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eqhm6cW4jb2VZI1WyTvHrublHukeAUF7aN5kD2umEwPqE74yp2XEY+IZ02rcm/r/l
	 QupjSvMH1w7kCUZJEQY2Fjc7fHhQpUSl3Ivz7SYjDuSB/1vJccdyGkYCgCvSM8lNpN
	 nXm4UDSyRlk1znr83wcQLagWRdBan1AOpNTywPnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0208/1146] net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers
Date: Wed, 20 May 2026 18:07:38 +0200
Message-ID: <20260520162152.974284866@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 2dddb34dd0d07b01fa770eca89480a4da4f13153 ]

The PPE enforces output frame size limits via per-tag-layer VLAN_MTU
registers that the driver never initializes. The hardware defaults do
not account for PPPoE overhead, causing the PPE to punt encapsulated
frames back to the CPU instead of forwarding them.

Initialize the registers at PPE start and on MTU changes using the
maximum GMAC MTU. This is a conservative approximation -- the actual
per-PPE requirement depends on egress path, but using the global
maximum ensures the limits are never too small.

Fixes: ba37b7caf1ed2 ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
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
index ddc321a02fdae..796f79088f366 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3566,12 +3566,23 @@ static int mtk_device_event(struct notifier_block *n, unsigned long event, void
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
 	struct mtk_mac *target_mac;
-	int i, err, ppe_num;
+	int i, err, ppe_num, mtu;
 
 	ppe_num = eth->soc->ppe_num;
 
@@ -3618,6 +3629,10 @@ static int mtk_open(struct net_device *dev)
 			mtk_gdm_config(eth, target_mac->id, gdm_config);
 		}
 
+		mtu = mtk_max_gmac_mtu(eth);
+		for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+			mtk_ppe_update_mtu(eth->ppe[i], mtu);
+
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
@@ -4311,6 +4326,7 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	int length = new_mtu + MTK_RX_ETH_HLEN;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	int max_mtu, i;
 
 	if (rcu_access_pointer(eth->prog) &&
 	    length > MTK_PP_MAX_BUF_SIZE) {
@@ -4321,6 +4337,10 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	mtk_set_mcr_max_rx(mac, length);
 	WRITE_ONCE(dev->mtu, new_mtu);
 
+	max_mtu = mtk_max_gmac_mtu(eth);
+	for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+		mtk_ppe_update_mtu(eth->ppe[i], max_mtu);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 75f7728fc7962..18279e2a7022e 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -973,6 +973,36 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
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
index 223f709e2704f..ba85e39a155bf 100644
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



