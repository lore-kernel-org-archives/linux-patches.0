Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A58481DD;
	Sat, 30 May 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161017; cv=none; b=DNx64cl3+AIemud2hyIk++BBMidbMjoZ0SqIq4NIKwNRGIpFtMIr7Fqco5fICs7+wQI5ZE9oVAWZEASMrdXsFyoEJ7MRwNnKefJXMy65EF/OR7yCvdfb/iNOx3ZHMHtkpNijRVr95NEXxqe3ojkJZNaxu+R4WWD+EzVmuBf2p9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161017; c=relaxed/simple;
	bh=GUYTpXfXXn4hhrm8+yHL5rBbSfXVoxlZiqlRywD1An0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQ11zIDQndfjQa5gLlWROR8hflwwuJR9Z6167Z/dGcwr7fXrBghj3FYyEoyz4rSzbLbfGZ0S/52s1d0Ey7lBegpMyPRXyI/OzOT/LUpunHunaqg3ZVd3tFYkK3NM/BHjPbHbQnCqinjZ3KB7aOy10qQ93BfPCYMyoCCH37SGtf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUGiRmr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUGiRmr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3E71F00893;
	Sat, 30 May 2026 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161016;
	bh=Nuuii3o4KI9G/gype/gAcudzhO8FLrUuLkHOpL2vCRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUGiRmr/tbydejtFiT1Xtai2PQpmyBrD7QTR7zMi6vM2SRKBUGQ5CS4LIFTsar3D6
	 +dfo7Rmeex9rXJb+Lkc4F9w79DB+wCag6t6uFIBoYDp4QZ3HxuyqmgH5R6LFjyMcGR
	 Qf7gKZNGlmrwCjIJ8ohKgyJF0/+Gx0KcSUIJzZqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/969] net: bcmgenet: add bcmgenet_has_* helpers
Date: Sat, 30 May 2026 17:59:55 +0200
Message-ID: <20260530160313.298983383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 07c1a756a50b1180a085ab61819a388bbb906a95 ]

Introduce helper functions to indicate whether the driver should
make use of a particular feature that it supports. These helpers
abstract the implementation of how the feature availability is
encoded.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-3-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5393b2b5bee2 ("net: bcmgenet: fix racing timeout handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 20 +++++++-------
 .../net/ethernet/broadcom/genet/bcmgenet.h    | 27 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  6 ++---
 3 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 4d76c9aebd439..88d2a8c3d3baf 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -104,7 +104,7 @@ static inline void dmadesc_set_addr(struct bcmgenet_priv *priv,
 	 * the platform is explicitly configured for 64-bits/LPAE.
 	 */
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	if (priv->hw_params->flags & GENET_HAS_40BITS)
+	if (bcmgenet_has_40bits(priv))
 		bcmgenet_writel(upper_32_bits(addr), d + DMA_DESC_ADDRESS_HI);
 #endif
 }
@@ -1648,9 +1648,9 @@ static int bcmgenet_power_down(struct bcmgenet_priv *priv,
 
 	case GENET_POWER_PASSIVE:
 		/* Power down LED */
-		if (priv->hw_params->flags & GENET_HAS_EXT) {
+		if (bcmgenet_has_ext(priv)) {
 			reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-			if (GENET_IS_V5(priv) && !priv->ephy_16nm)
+			if (GENET_IS_V5(priv) && !bcmgenet_has_ephy_16nm(priv))
 				reg |= EXT_PWR_DOWN_PHY_EN |
 				       EXT_PWR_DOWN_PHY_RD |
 				       EXT_PWR_DOWN_PHY_SD |
@@ -1678,7 +1678,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 {
 	u32 reg;
 
-	if (!(priv->hw_params->flags & GENET_HAS_EXT))
+	if (!bcmgenet_has_ext(priv))
 		return;
 
 	reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
@@ -1687,7 +1687,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 	case GENET_POWER_PASSIVE:
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
 			 EXT_ENERGY_DET_MASK);
-		if (GENET_IS_V5(priv) && !priv->ephy_16nm) {
+		if (GENET_IS_V5(priv) && !bcmgenet_has_ephy_16nm(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
 				 EXT_PWR_DOWN_PHY_SD |
@@ -2520,7 +2520,7 @@ static void bcmgenet_link_intr_enable(struct bcmgenet_priv *priv)
 	} else if (priv->ext_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
 	} else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
-		if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
+		if (bcmgenet_has_moca_link_det(priv))
 			int0_enable |= UMAC_IRQ_LINK_EVENT;
 	}
 	bcmgenet_intrl2_0_writel(priv, int0_enable, INTRL2_CPU_MASK_CLEAR);
@@ -2585,7 +2585,7 @@ static void init_umac(struct bcmgenet_priv *priv)
 	}
 
 	/* Enable MDIO interrupts on GENET v3+ */
-	if (priv->hw_params->flags & GENET_HAS_MDIO_INTR)
+	if (bcmgenet_has_mdio_intr(priv))
 		int0_enable |= (UMAC_IRQ_MDIO_DONE | UMAC_IRQ_MDIO_ERROR);
 
 	bcmgenet_intrl2_0_writel(priv, int0_enable, INTRL2_CPU_MASK_CLEAR);
@@ -3225,7 +3225,7 @@ static irqreturn_t bcmgenet_isr0(int irq, void *dev_id)
 		}
 	}
 
-	if ((priv->hw_params->flags & GENET_HAS_MDIO_INTR) &&
+	if (bcmgenet_has_mdio_intr(priv) &&
 		status & (UMAC_IRQ_MDIO_DONE | UMAC_IRQ_MDIO_ERROR)) {
 		wake_up(&priv->wq);
 	}
@@ -3895,7 +3895,7 @@ static void bcmgenet_set_hw_params(struct bcmgenet_priv *priv)
 	}
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	if (!(params->flags & GENET_HAS_40BITS))
+	if (!bcmgenet_has_40bits(priv))
 		pr_warn("GENET does not support 40-bits PA\n");
 #endif
 
@@ -4074,7 +4074,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	bcmgenet_set_hw_params(priv);
 
 	err = -EIO;
-	if (priv->hw_params->flags & GENET_HAS_40BITS)
+	if (bcmgenet_has_40bits(priv))
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
 	if (err)
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 28e2c94ef835c..ba83819210aa8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2014-2024 Broadcom
+ * Copyright (c) 2014-2025 Broadcom
  */
 
 #ifndef __BCMGENET_H__
@@ -650,6 +650,31 @@ struct bcmgenet_priv {
 	struct ethtool_eee eee;
 };
 
+static inline bool bcmgenet_has_40bits(struct bcmgenet_priv *priv)
+{
+	return !!(priv->hw_params->flags & GENET_HAS_40BITS);
+}
+
+static inline bool bcmgenet_has_ext(struct bcmgenet_priv *priv)
+{
+	return !!(priv->hw_params->flags & GENET_HAS_EXT);
+}
+
+static inline bool bcmgenet_has_mdio_intr(struct bcmgenet_priv *priv)
+{
+	return !!(priv->hw_params->flags & GENET_HAS_MDIO_INTR);
+}
+
+static inline bool bcmgenet_has_moca_link_det(struct bcmgenet_priv *priv)
+{
+	return !!(priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET);
+}
+
+static inline bool bcmgenet_has_ephy_16nm(struct bcmgenet_priv *priv)
+{
+	return priv->ephy_16nm;
+}
+
 #define GENET_IO_MACRO(name, offset)					\
 static inline u32 bcmgenet_##name##_readl(struct bcmgenet_priv *priv,	\
 					u32 off)			\
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index f21f2aaa6fd91..3836ea92527f3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET MDIO routines
  *
- * Copyright (c) 2014-2024 Broadcom
+ * Copyright (c) 2014-2025 Broadcom
  */
 
 #include <linux/acpi.h>
@@ -153,7 +153,7 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 	u32 reg = 0;
 
 	/* EXT_GPHY_CTRL is only valid for GENETv4 and onward */
-	if (GENET_IS_V4(priv) || priv->ephy_16nm) {
+	if (GENET_IS_V4(priv) || bcmgenet_has_ephy_16nm(priv)) {
 		reg = bcmgenet_ext_readl(priv, EXT_GPHY_CTRL);
 		if (enable) {
 			reg &= ~EXT_CK25_DIS;
@@ -183,7 +183,7 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
+	if (bcmgenet_has_moca_link_det(priv))
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
 }
-- 
2.53.0



