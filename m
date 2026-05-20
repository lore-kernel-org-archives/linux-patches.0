Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982033F39C9;
	Wed, 20 May 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299709; cv=none; b=gdfxJ/uQHcq74zt1IYuZQlQ89UbypsgINUmHD0yITF4suZH/qHHF1GenGUriBcrKjQLDd72A++jewKwYrSnmbWTjFcERvtyM9GCnf/j5PDrTurVAkY9hTBj6Zr0kPimyMDpEnZ8YlYk6S4EvNhd669PlGNRA27J6R+AwM3McSFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299709; c=relaxed/simple;
	bh=MLOVqot1GJJf/qwtFolYPs9KYWjzwE4LZ2swWw5WkSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3oTt12044/6Ib/kj4zHYA0Cf1JRhp4E8wlzW1oeI47LEqafbPIaGlWBuLsSWCNtOmxiJUwAOP/FlHmQSpJpEsTi7BjYVyGl5MLmky5BDwfYoW0p0Izn/XzWwMzkFY+90I/HXXR/LGTkJJ3YcUedx6ga066CSazqzbyR1dR8Bok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFwbxFZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFwbxFZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096B91F000E9;
	Wed, 20 May 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299708;
	bh=EMvgdC7W/31ht/o0XFvnCF2OSnGxPGvV/9muVvlOrQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFwbxFZ5brcTmfbKfU2EkFw/2wzjiNDB/jC1IzUZKGXhGTlkDiHM+qs/pvkypXcTz
	 OgAB+JKUKATFCk0j7y1j79xo0StsHhex1LM24wEg8SdxnX+JTnsuZgrXh3wIj+r3k8
	 2btdL8dZCg81NYY82/7XQo7E7Onwd78eQT27eiv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 874/957] net: airoha: Fix VIP configuration for AN7583 SoC
Date: Wed, 20 May 2026 18:22:37 +0200
Message-ID: <20260520162153.520125955@linuxfoundation.org>
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

[ Upstream commit 1acdfbdb516b32165a8ecd1d5f8c68e4eac64637 ]

EN7581 and AN7583 SoCs have different VIP definitions. Introduce
get_vip_port callback in airoha_eth_soc_data struct in order to take
into account EN7581 and AN7583 VIP register layout and definition
differences.
Introduce nbq parameter in airoha_gdm_port struct. At the moment nbq
is set statically to value previously used in airhoha_set_gdm2_loopback
routine and it will be read from device tree in subsequent patches.

Fixes: e4e5ce823bdd ("net: airoha: Add AN7583 SoC support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260412-airoha-7583-vip-fix-v1-1-c35e02b054bb@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 66 ++++++++++++++++++------
 drivers/net/ethernet/airoha/airoha_eth.h |  2 +
 2 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index c5f509cd52e63..27d62acfcc39c 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -107,19 +107,7 @@ static int airoha_set_vip_for_gdm_port(struct airoha_gdm_port *port,
 	struct airoha_eth *eth = port->qdma->eth;
 	u32 vip_port;
 
-	switch (port->id) {
-	case AIROHA_GDM3_IDX:
-		/* FIXME: handle XSI_PCIE1_PORT */
-		vip_port = XSI_PCIE0_VIP_PORT_MASK;
-		break;
-	case AIROHA_GDM4_IDX:
-		/* FIXME: handle XSI_USB_PORT */
-		vip_port = XSI_ETH_VIP_PORT_MASK;
-		break;
-	default:
-		return 0;
-	}
-
+	vip_port = eth->soc->ops.get_vip_port(port, port->nbq);
 	if (enable) {
 		airoha_fe_set(eth, REG_FE_VIP_PORT_EN, vip_port);
 		airoha_fe_set(eth, REG_FE_IFC_PORT_EN, vip_port);
@@ -1809,7 +1797,7 @@ static int airoha_dev_set_macaddr(struct net_device *dev, void *p)
 static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 {
 	struct airoha_eth *eth = port->qdma->eth;
-	u32 val, pse_port, chan, nbq;
+	u32 val, pse_port, chan;
 	int src_port;
 
 	/* Forward the traffic to the proper GDM port */
@@ -1839,9 +1827,7 @@ static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(AIROHA_GDM2_IDX));
 	airoha_fe_clear(eth, REG_FE_IFC_PORT_EN, BIT(AIROHA_GDM2_IDX));
 
-	/* XXX: handle XSI_USB_PORT and XSI_PCE1_PORT */
-	nbq = port->id == AIROHA_GDM3_IDX && airoha_is_7581(eth) ? 4 : 0;
-	src_port = eth->soc->ops.get_src_port_id(port, nbq);
+	src_port = eth->soc->ops.get_src_port_id(port, port->nbq);
 	if (src_port < 0)
 		return src_port;
 
@@ -3034,6 +3020,8 @@ static int airoha_alloc_gdm_port(struct airoha_eth *eth,
 	port->qdma = qdma;
 	port->dev = dev;
 	port->id = id;
+	/* XXX: Read nbq from DTS */
+	port->nbq = id == AIROHA_GDM3_IDX && airoha_is_7581(eth) ? 4 : 0;
 	eth->ports[p] = port;
 
 	return airoha_metadata_dst_alloc(port);
@@ -3229,6 +3217,28 @@ static int airoha_en7581_get_src_port_id(struct airoha_gdm_port *port, int nbq)
 	return -EINVAL;
 }
 
+static u32 airoha_en7581_get_vip_port(struct airoha_gdm_port *port, int nbq)
+{
+	switch (port->id) {
+	case AIROHA_GDM3_IDX:
+		if (nbq == 4)
+			return XSI_PCIE0_VIP_PORT_MASK;
+		if (nbq == 5)
+			return XSI_PCIE1_VIP_PORT_MASK;
+		break;
+	case AIROHA_GDM4_IDX:
+		if (!nbq)
+			return XSI_ETH_VIP_PORT_MASK;
+		if (nbq == 1)
+			return XSI_USB_VIP_PORT_MASK;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static const char * const an7583_xsi_rsts_names[] = {
 	"xsi-mac",
 	"hsi0-mac",
@@ -3258,6 +3268,26 @@ static int airoha_an7583_get_src_port_id(struct airoha_gdm_port *port, int nbq)
 	return -EINVAL;
 }
 
+static u32 airoha_an7583_get_vip_port(struct airoha_gdm_port *port, int nbq)
+{
+	switch (port->id) {
+	case AIROHA_GDM3_IDX:
+		if (!nbq)
+			return XSI_ETH_VIP_PORT_MASK;
+		break;
+	case AIROHA_GDM4_IDX:
+		if (!nbq)
+			return XSI_PCIE0_VIP_PORT_MASK;
+		if (nbq == 1)
+			return XSI_USB_VIP_PORT_MASK;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static const struct airoha_eth_soc_data en7581_soc_data = {
 	.version = 0x7581,
 	.xsi_rsts_names = en7581_xsi_rsts_names,
@@ -3265,6 +3295,7 @@ static const struct airoha_eth_soc_data en7581_soc_data = {
 	.num_ppe = 2,
 	.ops = {
 		.get_src_port_id = airoha_en7581_get_src_port_id,
+		.get_vip_port = airoha_en7581_get_vip_port,
 	},
 };
 
@@ -3275,6 +3306,7 @@ static const struct airoha_eth_soc_data an7583_soc_data = {
 	.num_ppe = 1,
 	.ops = {
 		.get_src_port_id = airoha_an7583_get_src_port_id,
+		.get_vip_port = airoha_an7583_get_vip_port,
 	},
 };
 
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 33277cc577990..57e8ddb30a9c5 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -536,6 +536,7 @@ struct airoha_gdm_port {
 	struct airoha_qdma *qdma;
 	struct net_device *dev;
 	int id;
+	int nbq;
 
 	struct airoha_hw_stats stats;
 
@@ -576,6 +577,7 @@ struct airoha_eth_soc_data {
 	int num_ppe;
 	struct {
 		int (*get_src_port_id)(struct airoha_gdm_port *port, int nbq);
+		u32 (*get_vip_port)(struct airoha_gdm_port *port, int nbq);
 	} ops;
 };
 
-- 
2.53.0



