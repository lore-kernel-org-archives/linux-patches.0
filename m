Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095DB36C9D2;
	Wed, 20 May 2026 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294920; cv=none; b=Bd4vVfcZgR2MOL6xmArVT71dEjA+AH46RU401+LqeWxzTzv3hrlEWV9RSzeRkvm2zHwVzi0hA2XiL+Y+gPp/rYWEGg84kxm3RxXvkEw/N7iZceuxHK6vskTSu/m21DnaWlrcG+ttuOn/GZLWLEnjrKiHyaE1TW57+TDBs+njxoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294920; c=relaxed/simple;
	bh=jk+LPptQOaptZnqUQ8q8kazhOB+3GGcIk+v3CVWBZaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKVXXvarWHGDuoerioE0ppWUzKugjnVUU9zawBKJcH/3eO4yuyjEELNgilrj/ssaYfsGOWhPA02TK2w0a6jPZ57Ak9FymNotP8aM24w1EFgYHct45u7KQXerSqyh0vY42P88XAZNX2Y1mEEeYp1KNThLvX3VvPc+MC4t84RGDwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vw17yLy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vw17yLy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7FF1F000E9;
	Wed, 20 May 2026 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294918;
	bh=rlQGyZ70UWOroG81O2e86MzQFdTgRupLfP17tXVJsh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vw17yLy3/C12zCo6yDXJ/zVP8L9e//kKNiB5K3OYb5fZy46EOPB+25DOnSdw3bO0b
	 TYhcslx+sLI2J72adqPv8E6+2ITTv+g2ptSkqTDRy5Wfx2QzSLkRGPGqT+m1oip/xn
	 z1D7qnAQReIHzdmuGLmfwCTM+ibRjtEp8Lz3r6cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0223/1146] net: airoha: Fix VIP configuration for AN7583 SoC
Date: Wed, 20 May 2026 18:07:53 +0200
Message-ID: <20260520162153.302271306@linuxfoundation.org>
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
index 9e995094c32af..f484835af703c 100644
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
@@ -1710,7 +1698,7 @@ static int airoha_dev_set_macaddr(struct net_device *dev, void *p)
 static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 {
 	struct airoha_eth *eth = port->qdma->eth;
-	u32 val, pse_port, chan, nbq;
+	u32 val, pse_port, chan;
 	int src_port;
 
 	/* Forward the traffic to the proper GDM port */
@@ -1740,9 +1728,7 @@ static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(AIROHA_GDM2_IDX));
 	airoha_fe_clear(eth, REG_FE_IFC_PORT_EN, BIT(AIROHA_GDM2_IDX));
 
-	/* XXX: handle XSI_USB_PORT and XSI_PCE1_PORT */
-	nbq = port->id == AIROHA_GDM3_IDX && airoha_is_7581(eth) ? 4 : 0;
-	src_port = eth->soc->ops.get_src_port_id(port, nbq);
+	src_port = eth->soc->ops.get_src_port_id(port, port->nbq);
 	if (src_port < 0)
 		return src_port;
 
@@ -2951,6 +2937,8 @@ static int airoha_alloc_gdm_port(struct airoha_eth *eth,
 	port->qdma = qdma;
 	port->dev = dev;
 	port->id = id;
+	/* XXX: Read nbq from DTS */
+	port->nbq = id == AIROHA_GDM3_IDX && airoha_is_7581(eth) ? 4 : 0;
 	eth->ports[p] = port;
 
 	return airoha_metadata_dst_alloc(port);
@@ -3152,6 +3140,28 @@ static int airoha_en7581_get_src_port_id(struct airoha_gdm_port *port, int nbq)
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
@@ -3181,6 +3191,26 @@ static int airoha_an7583_get_src_port_id(struct airoha_gdm_port *port, int nbq)
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
@@ -3188,6 +3218,7 @@ static const struct airoha_eth_soc_data en7581_soc_data = {
 	.num_ppe = 2,
 	.ops = {
 		.get_src_port_id = airoha_en7581_get_src_port_id,
+		.get_vip_port = airoha_en7581_get_vip_port,
 	},
 };
 
@@ -3198,6 +3229,7 @@ static const struct airoha_eth_soc_data an7583_soc_data = {
 	.num_ppe = 1,
 	.ops = {
 		.get_src_port_id = airoha_an7583_get_src_port_id,
+		.get_vip_port = airoha_an7583_get_vip_port,
 	},
 };
 
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index a97903569335f..8bcd809e6f53e 100644
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



