Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303A260585;
	Thu, 27 Nov 2025 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255768; cv=none; b=KIok3t5oHkb83UBQPWmEoeCOI764s/4q9MNYKCi3GmYMR3OcyjAvJc0/MI4790V1jU3G58BTjeo5sNVzEw9Z+XuvfXXoX/L63q9vhKr2ql4EXXU74IQqt8hjk1GtkYiojAQa6C+rAshhmok2MCSWT0lR2lm1D384P+n2DZzq+CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255768; c=relaxed/simple;
	bh=OyG9mtwR96YM6dH54syyIqaTHrsxXuWdC4Q5mGm0FME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7LbWBM9X6ItTViORzAkRn+LdBOuACBIA1BKbV3HTcn9wCPbpf1t6qyLFG8CpZlvqHJ+d+KHnA+vGtKfzx+7dfu8zWpjF9SuoVwO7aiB0+yge9houcK6hUye/zDB/VVRstQ7koapzFWxEnrfqDbpES6hID3DeKASAvyhsoD0Ge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjSTq/z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjSTq/z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15F9C4CEF8;
	Thu, 27 Nov 2025 15:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255768;
	bh=OyG9mtwR96YM6dH54syyIqaTHrsxXuWdC4Q5mGm0FME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjSTq/z/Hq1yZaGnXjuLpn/63YlLU+aI8B2zEi1hb5D9Tc3BDZ+UoLb7wMzrEX4T3
	 Hm/taTRNjP5E5ourffy9QBm8Oy5CPBplV1HaMSLRCdO7O8JuptfM78ACS2cm5cAToW
	 wVvMINtJopVObJlW1QGF1uWzNbwRVc70TI0S6324=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 108/175] net: airoha: Add wlan flowtable TX offload
Date: Thu, 27 Nov 2025 15:46:01 +0100
Message-ID: <20251127144046.902257798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a8bdd935d1ddb7186358fb60ffe84253e85340c8 ]

Introduce support to offload the traffic received on the ethernet NIC
and forwarded to the wireless one using HW Packet Processor Engine (PPE)
capabilities.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250814-airoha-en7581-wlan-tx-offload-v1-1-72e0a312003e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 8e0a754b0836 ("net: airoha: Do not loopback traffic to GDM2 if it is available on the device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.h |  11 +++
 drivers/net/ethernet/airoha/airoha_ppe.c | 103 ++++++++++++++++-------
 2 files changed, 85 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index a970b789cf232..9f721e2b972f0 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -252,6 +252,10 @@ enum {
 #define AIROHA_FOE_MAC_SMAC_ID		GENMASK(20, 16)
 #define AIROHA_FOE_MAC_PPPOE_ID		GENMASK(15, 0)
 
+#define AIROHA_FOE_MAC_WDMA_QOS		GENMASK(15, 12)
+#define AIROHA_FOE_MAC_WDMA_BAND	BIT(11)
+#define AIROHA_FOE_MAC_WDMA_WCID	GENMASK(10, 0)
+
 struct airoha_foe_mac_info_common {
 	u16 vlan1;
 	u16 etype;
@@ -481,6 +485,13 @@ struct airoha_flow_table_entry {
 	unsigned long cookie;
 };
 
+struct airoha_wdma_info {
+	u8 idx;
+	u8 queue;
+	u16 wcid;
+	u8 bss;
+};
+
 /* RX queue to IRQ mapping: BIT(q) in IRQ(n) */
 #define RX_IRQ0_BANK_PIN_MASK			0x839f
 #define RX_IRQ1_BANK_PIN_MASK			0x7fe00000
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 88694b08afa1c..62e46a8d7e3c8 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -190,6 +190,31 @@ static int airoha_ppe_flow_mangle_ipv4(const struct flow_action_entry *act,
 	return 0;
 }
 
+static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
+				    struct airoha_wdma_info *info)
+{
+	struct net_device_path_stack stack;
+	struct net_device_path *path;
+	int err;
+
+	if (!dev)
+		return -ENODEV;
+
+	err = dev_fill_forward_path(dev, addr, &stack);
+	if (err)
+		return err;
+
+	path = &stack.path[stack.num_paths - 1];
+	if (path->type != DEV_PATH_MTK_WDMA)
+		return -1;
+
+	info->idx = path->mtk_wdma.wdma_idx;
+	info->bss = path->mtk_wdma.bss;
+	info->wcid = path->mtk_wdma.wcid;
+
+	return 0;
+}
+
 static int airoha_get_dsa_port(struct net_device **dev)
 {
 #if IS_ENABLED(CONFIG_NET_DSA)
@@ -220,9 +245,9 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 					struct airoha_flow_data *data,
 					int l4proto)
 {
-	int dsa_port = airoha_get_dsa_port(&dev);
+	u32 qdata = FIELD_PREP(AIROHA_FOE_SHAPER_ID, 0x7f), ports_pad, val;
+	int wlan_etype = -EINVAL, dsa_port = airoha_get_dsa_port(&dev);
 	struct airoha_foe_mac_info_common *l2;
-	u32 qdata, ports_pad, val;
 	u8 smac_id = 0xf;
 
 	memset(hwe, 0, sizeof(*hwe));
@@ -236,31 +261,47 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 	      AIROHA_FOE_IB1_BIND_TTL;
 	hwe->ib1 = val;
 
-	val = FIELD_PREP(AIROHA_FOE_IB2_PORT_AG, 0x1f) |
-	      AIROHA_FOE_IB2_PSE_QOS;
-	if (dsa_port >= 0)
-		val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ, dsa_port);
-
+	val = FIELD_PREP(AIROHA_FOE_IB2_PORT_AG, 0x1f);
 	if (dev) {
-		struct airoha_gdm_port *port = netdev_priv(dev);
-		u8 pse_port;
-
-		if (!airoha_is_valid_gdm_port(eth, port))
-			return -EINVAL;
-
-		if (dsa_port >= 0)
-			pse_port = port->id == 4 ? FE_PSE_PORT_GDM4 : port->id;
-		else
-			pse_port = 2; /* uplink relies on GDM2 loopback */
-		val |= FIELD_PREP(AIROHA_FOE_IB2_PSE_PORT, pse_port);
-
-		/* For downlink traffic consume SRAM memory for hw forwarding
-		 * descriptors queue.
-		 */
-		if (airhoa_is_lan_gdm_port(port))
-			val |= AIROHA_FOE_IB2_FAST_PATH;
-
-		smac_id = port->id;
+		struct airoha_wdma_info info = {};
+
+		if (!airoha_ppe_get_wdma_info(dev, data->eth.h_dest, &info)) {
+			val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ, info.idx) |
+			       FIELD_PREP(AIROHA_FOE_IB2_PSE_PORT,
+					  FE_PSE_PORT_CDM4);
+			qdata |= FIELD_PREP(AIROHA_FOE_ACTDP, info.bss);
+			wlan_etype = FIELD_PREP(AIROHA_FOE_MAC_WDMA_BAND,
+						info.idx) |
+				     FIELD_PREP(AIROHA_FOE_MAC_WDMA_WCID,
+						info.wcid);
+		} else {
+			struct airoha_gdm_port *port = netdev_priv(dev);
+			u8 pse_port;
+
+			if (!airoha_is_valid_gdm_port(eth, port))
+				return -EINVAL;
+
+			if (dsa_port >= 0)
+				pse_port = port->id == 4 ? FE_PSE_PORT_GDM4
+							 : port->id;
+			else
+				pse_port = 2; /* uplink relies on GDM2
+					       * loopback
+					       */
+
+			val |= FIELD_PREP(AIROHA_FOE_IB2_PSE_PORT, pse_port) |
+			       AIROHA_FOE_IB2_PSE_QOS;
+			/* For downlink traffic consume SRAM memory for hw
+			 * forwarding descriptors queue.
+			 */
+			if (airhoa_is_lan_gdm_port(port))
+				val |= AIROHA_FOE_IB2_FAST_PATH;
+			if (dsa_port >= 0)
+				val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ,
+						  dsa_port);
+
+			smac_id = port->id;
+		}
 	}
 
 	if (is_multicast_ether_addr(data->eth.h_dest))
@@ -272,7 +313,6 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 	if (type == PPE_PKT_TYPE_IPV6_ROUTE_3T)
 		hwe->ipv6.ports = ports_pad;
 
-	qdata = FIELD_PREP(AIROHA_FOE_SHAPER_ID, 0x7f);
 	if (type == PPE_PKT_TYPE_BRIDGE) {
 		airoha_ppe_foe_set_bridge_addrs(&hwe->bridge, &data->eth);
 		hwe->bridge.data = qdata;
@@ -313,7 +353,9 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 			l2->vlan2 = data->vlan.hdr[1].id;
 	}
 
-	if (dsa_port >= 0) {
+	if (wlan_etype >= 0) {
+		l2->etype = wlan_etype;
+	} else if (dsa_port >= 0) {
 		l2->etype = BIT(dsa_port);
 		l2->etype |= !data->vlan.num ? BIT(15) : 0;
 	} else if (data->pppoe.num) {
@@ -490,6 +532,10 @@ static void airoha_ppe_foe_flow_stats_update(struct airoha_ppe *ppe,
 		meter = &hwe->ipv4.l2.meter;
 	}
 
+	pse_port = FIELD_GET(AIROHA_FOE_IB2_PSE_PORT, *ib2);
+	if (pse_port == FE_PSE_PORT_CDM4)
+		return;
+
 	airoha_ppe_foe_flow_stat_entry_reset(ppe, npu, index);
 
 	val = FIELD_GET(AIROHA_FOE_CHANNEL | AIROHA_FOE_QID, *data);
@@ -500,7 +546,6 @@ static void airoha_ppe_foe_flow_stats_update(struct airoha_ppe *ppe,
 		      AIROHA_FOE_IB2_PSE_QOS | AIROHA_FOE_IB2_FAST_PATH);
 	*meter |= FIELD_PREP(AIROHA_FOE_TUNNEL_MTU, val);
 
-	pse_port = FIELD_GET(AIROHA_FOE_IB2_PSE_PORT, *ib2);
 	nbq = pse_port == 1 ? 6 : 5;
 	*ib2 &= ~(AIROHA_FOE_IB2_NBQ | AIROHA_FOE_IB2_PSE_PORT |
 		  AIROHA_FOE_IB2_PSE_QOS);
-- 
2.51.0



