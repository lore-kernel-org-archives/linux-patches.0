Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC573B0AD6;
	Wed, 20 May 2026 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299184; cv=none; b=d3mBKCDoEbH3QhwD0Ly1wI8NQWEbbO3VZ0EeRsZYRsk6qGGnIm2MxXMqzeKvvwnRNH12BfbT10crCa+ZeqpF3fEotS1i8CNuQSpTtGDG4CPZraR6X+9gLkRUh+qUzd8vJqPCTO9OS8Oia649GpvTG2tVg1qcP6MtGxqCTB6QuUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299184; c=relaxed/simple;
	bh=fIe5icaW4wZazARoa9BQwfRBMugR3UTnkXh0dRbQXDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irzSINFDvzMCODzzViQmmvTjDGm0j5ZuLDMF5+6GrYjkt/dIp8nLcp8aAJ6hYJrUzcAO5ZtP12PlIrDIgUeyByNOzbyPlyel89yjyKBhecRFCMc/zBl+14fjGjGnYXT5p1ck1+xDfcsfjlkf4l0ZwYCZet1KUl+QYftKpQjxw+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZQ0MX0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZQ0MX0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEA61F000E9;
	Wed, 20 May 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299182;
	bh=o5BhEAJLt4uQeFxdKAGT8C/TFQ+aS4O85FrgR/OBJb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZQ0MX0N0sjsMG5GwzmLW+lN3RoRO9DuY274RiD2bbmiWVRdmMHB2dF4TTgR811Xy
	 gI+/h8G7ZgqzCMTAswUFx7NLF7XPnQnVjaTpAJ4s//Z4GZyJdxlEAfFINBgPB1RTMa
	 7YnjWcRlfVBrx81dwSlxSAAFap5369xwe4BHKW44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 693/957] net: airoha: Refactor src port configuration in airhoha_set_gdm2_loopback
Date: Wed, 20 May 2026 18:19:36 +0200
Message-ID: <20260520162149.569805151@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9d5b5219f672c80bed4d4e15f0068e648cdca43b ]

AN7583 chipset relies on different definitions for source-port
identifier used for hw offloading. In order to support hw offloading
in AN7583 controller, refactor src port configuration in
airhoha_set_gdm2_loopback routine and introduce get_src_port_id
callback.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-11-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3309965fe44c ("net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c  | 82 ++++++++++++++++-------
 drivers/net/ethernet/airoha/airoha_eth.h  | 18 +++--
 drivers/net/ethernet/airoha/airoha_regs.h |  6 +-
 3 files changed, 73 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index f8db324b141fe..6e7f816cd7edb 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1751,13 +1751,17 @@ static int airoha_dev_set_macaddr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
+static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 {
-	u32 pse_port = port->id == 3 ? FE_PSE_PORT_GDM3 : FE_PSE_PORT_GDM4;
+	u32 val, pse_port, chan = port->id == AIROHA_GDM3_IDX ? 4 : 0;
 	struct airoha_eth *eth = port->qdma->eth;
-	u32 chan = port->id == 3 ? 4 : 0;
+	/* XXX: handle XSI_USB_PORT and XSI_PCE1_PORT */
+	u32 nbq = port->id == AIROHA_GDM3_IDX ? 4 : 0;
+	int src_port;
 
 	/* Forward the traffic to the proper GDM port */
+	pse_port = port->id == AIROHA_GDM3_IDX ? FE_PSE_PORT_GDM3
+					       : FE_PSE_PORT_GDM4;
 	airoha_set_gdm_port_fwd_cfg(eth, REG_GDM_FWD_CFG(2), pse_port);
 	airoha_fe_clear(eth, REG_GDM_FWD_CFG(2), GDM_STRIP_CRC);
 
@@ -1778,29 +1782,25 @@ static void airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(2));
 	airoha_fe_clear(eth, REG_FE_IFC_PORT_EN, BIT(2));
 
-	if (port->id == 3) {
-		/* FIXME: handle XSI_PCE1_PORT */
-		airoha_fe_rmw(eth, REG_FE_WAN_PORT,
-			      WAN1_EN_MASK | WAN1_MASK | WAN0_MASK,
-			      FIELD_PREP(WAN0_MASK, HSGMII_LAN_PCIE0_SRCPORT));
-		airoha_fe_rmw(eth,
-			      REG_SP_DFT_CPORT(HSGMII_LAN_PCIE0_SRCPORT >> 3),
-			      SP_CPORT_PCIE0_MASK,
-			      FIELD_PREP(SP_CPORT_PCIE0_MASK,
-					 FE_PSE_PORT_CDM2));
-	} else {
-		/* FIXME: handle XSI_USB_PORT */
+	src_port = eth->soc->ops.get_src_port_id(port, nbq);
+	if (src_port < 0)
+		return src_port;
+
+	airoha_fe_rmw(eth, REG_FE_WAN_PORT,
+		      WAN1_EN_MASK | WAN1_MASK | WAN0_MASK,
+		      FIELD_PREP(WAN0_MASK, src_port));
+	val = src_port & SP_CPORT_DFT_MASK;
+	airoha_fe_rmw(eth,
+		      REG_SP_DFT_CPORT(src_port >> fls(SP_CPORT_DFT_MASK)),
+		      SP_CPORT_MASK(val),
+		      FE_PSE_PORT_CDM2 << __ffs(SP_CPORT_MASK(val)));
+
+	if (port->id != AIROHA_GDM3_IDX)
 		airoha_fe_rmw(eth, REG_SRC_PORT_FC_MAP6,
 			      FC_ID_OF_SRC_PORT24_MASK,
 			      FIELD_PREP(FC_ID_OF_SRC_PORT24_MASK, 2));
-		airoha_fe_rmw(eth, REG_FE_WAN_PORT,
-			      WAN1_EN_MASK | WAN1_MASK | WAN0_MASK,
-			      FIELD_PREP(WAN0_MASK, HSGMII_LAN_ETH_SRCPORT));
-		airoha_fe_rmw(eth,
-			      REG_SP_DFT_CPORT(HSGMII_LAN_ETH_SRCPORT >> 3),
-			      SP_CPORT_ETH_MASK,
-			      FIELD_PREP(SP_CPORT_ETH_MASK, FE_PSE_PORT_CDM2));
-	}
+
+	return 0;
 }
 
 static int airoha_dev_init(struct net_device *dev)
@@ -1815,8 +1815,13 @@ static int airoha_dev_init(struct net_device *dev)
 	case 3:
 	case 4:
 		/* If GDM2 is active we can't enable loopback */
-		if (!eth->ports[1])
-			airhoha_set_gdm2_loopback(port);
+		if (!eth->ports[1]) {
+			int err;
+
+			err = airhoha_set_gdm2_loopback(port);
+			if (err)
+				return err;
+		}
 		fallthrough;
 	case 2:
 		if (airoha_ppe_is_enabled(eth, 1)) {
@@ -3135,11 +3140,38 @@ static const char * const en7581_xsi_rsts_names[] = {
 	"xfp-mac",
 };
 
+static int airoha_en7581_get_src_port_id(struct airoha_gdm_port *port, int nbq)
+{
+	switch (port->id) {
+	case 3:
+		/* 7581 SoC supports PCIe serdes on GDM3 port */
+		if (nbq == 4)
+			return HSGMII_LAN_7581_PCIE0_SRCPORT;
+		if (nbq == 5)
+			return HSGMII_LAN_7581_PCIE1_SRCPORT;
+		break;
+	case 4:
+		/* 7581 SoC supports eth and usb serdes on GDM4 port */
+		if (!nbq)
+			return HSGMII_LAN_7581_ETH_SRCPORT;
+		if (nbq == 1)
+			return HSGMII_LAN_7581_USB_SRCPORT;
+		break;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static const struct airoha_eth_soc_data en7581_soc_data = {
 	.version = 0x7581,
 	.xsi_rsts_names = en7581_xsi_rsts_names,
 	.num_xsi_rsts = ARRAY_SIZE(en7581_xsi_rsts_names),
 	.num_ppe = 2,
+	.ops = {
+		.get_src_port_id = airoha_en7581_get_src_port_id,
+	},
 };
 
 static const struct of_device_id of_airoha_match[] = {
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 8d121d12dc120..8a2c68781e94b 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -67,10 +67,10 @@ enum {
 };
 
 enum {
-	HSGMII_LAN_PCIE0_SRCPORT = 0x16,
-	HSGMII_LAN_PCIE1_SRCPORT,
-	HSGMII_LAN_ETH_SRCPORT,
-	HSGMII_LAN_USB_SRCPORT,
+	HSGMII_LAN_7581_PCIE0_SRCPORT	= 0x16,
+	HSGMII_LAN_7581_PCIE1_SRCPORT,
+	HSGMII_LAN_7581_ETH_SRCPORT,
+	HSGMII_LAN_7581_USB_SRCPORT,
 };
 
 enum {
@@ -99,6 +99,13 @@ enum {
 	CRSN_25 = 0x19,
 };
 
+enum airoha_gdm_index {
+	AIROHA_GDM1_IDX = 1,
+	AIROHA_GDM2_IDX = 2,
+	AIROHA_GDM3_IDX = 3,
+	AIROHA_GDM4_IDX = 4,
+};
+
 enum {
 	FE_PSE_PORT_CDM1,
 	FE_PSE_PORT_GDM1,
@@ -556,6 +563,9 @@ struct airoha_eth_soc_data {
 	const char * const *xsi_rsts_names;
 	int num_xsi_rsts;
 	int num_ppe;
+	struct {
+		int (*get_src_port_id)(struct airoha_gdm_port *port, int nbq);
+	} ops;
 };
 
 struct airoha_eth {
diff --git a/drivers/net/ethernet/airoha/airoha_regs.h b/drivers/net/ethernet/airoha/airoha_regs.h
index 69c5a143db8c0..ebcce00d9bc6f 100644
--- a/drivers/net/ethernet/airoha/airoha_regs.h
+++ b/drivers/net/ethernet/airoha/airoha_regs.h
@@ -383,10 +383,8 @@
 #define REG_MC_VLAN_DATA		0x2108
 
 #define REG_SP_DFT_CPORT(_n)		(0x20e0 + ((_n) << 2))
-#define SP_CPORT_PCIE1_MASK		GENMASK(31, 28)
-#define SP_CPORT_PCIE0_MASK		GENMASK(27, 24)
-#define SP_CPORT_USB_MASK		GENMASK(7, 4)
-#define SP_CPORT_ETH_MASK		GENMASK(7, 4)
+#define SP_CPORT_DFT_MASK		GENMASK(2, 0)
+#define SP_CPORT_MASK(_n)		GENMASK(3 + ((_n) << 2), ((_n) << 2))
 
 #define REG_SRC_PORT_FC_MAP6		0x2298
 #define FC_ID_OF_SRC_PORT27_MASK	GENMASK(28, 24)
-- 
2.53.0



