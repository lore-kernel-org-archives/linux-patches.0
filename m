Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174853FBB45;
	Wed, 20 May 2026 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300310; cv=none; b=AuGm7V6GegrG7IyH1hs7Vqp+mHXScLLtxkuOvaFiqbEp2njvMuL2FP0nzP0oUdzTUF+xy3watEjyf81znd9BNVP5Ae9JuFDl3jH2qKlxaDBCH4khDzB/d8vZcPHSxxjHLumGoyBCo07u+YC+Vzr5lOYfG20R7Oa3J+qdizbk+tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300310; c=relaxed/simple;
	bh=kwpoyEP0iY8GrX1F6BH2OD301a7ikChkhvNzjudSfnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG51sAGfzuRWBxEYshmXmYD1L5lFbdsG/tztc6SLchsXH8musoJEQ+mqRE68gLc+6HoZPk1gplo/fHQet//qXLz/UjHQzb9/p+7Knx5w4qJsX5Y33fm1fI0Zu0chGX6GVg9ypeetPiGjf8sG+03AWv/PyR4ObKCILI5D3UzY2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNtsKN5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNtsKN5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BEA1F000E9;
	Wed, 20 May 2026 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300309;
	bh=ckJmo+Yoe1kQtVEQ6n4Ku89C6eRw6eDMXcXFKnsEDZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNtsKN5nutDulGP2v7jj92JoZuDT6RA+060Gkn8Id0hWLgI4Kv/Gt9gTJACAqsniH
	 1JJFTU1ZhCPuXnSQ7ttXy1vaqFzcXKI3kEgmINjHo6vrnnKt/LRcTQCxwFui/iPSkW
	 JGnonztghD+Xdob6nhHV2i7CkqnT7aYtPqjaElGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/666] net: bcmgenet: add bcmgenet_has_* helpers
Date: Wed, 20 May 2026 18:14:45 +0200
Message-ID: <20260520162112.834132111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ac9bd34f3b3ce..1767d96dd6546 100644
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
@@ -1644,9 +1644,9 @@ static int bcmgenet_power_down(struct bcmgenet_priv *priv,
 
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
@@ -1674,7 +1674,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 {
 	u32 reg;
 
-	if (!(priv->hw_params->flags & GENET_HAS_EXT))
+	if (!bcmgenet_has_ext(priv))
 		return;
 
 	reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
@@ -1683,7 +1683,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 	case GENET_POWER_PASSIVE:
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
 			 EXT_ENERGY_DET_MASK);
-		if (GENET_IS_V5(priv) && !priv->ephy_16nm) {
+		if (GENET_IS_V5(priv) && !bcmgenet_has_ephy_16nm(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
 				 EXT_PWR_DOWN_PHY_SD |
@@ -2516,7 +2516,7 @@ static void bcmgenet_link_intr_enable(struct bcmgenet_priv *priv)
 	} else if (priv->ext_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
 	} else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
-		if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
+		if (bcmgenet_has_moca_link_det(priv))
 			int0_enable |= UMAC_IRQ_LINK_EVENT;
 	}
 	bcmgenet_intrl2_0_writel(priv, int0_enable, INTRL2_CPU_MASK_CLEAR);
@@ -2581,7 +2581,7 @@ static void init_umac(struct bcmgenet_priv *priv)
 	}
 
 	/* Enable MDIO interrupts on GENET v3+ */
-	if (priv->hw_params->flags & GENET_HAS_MDIO_INTR)
+	if (bcmgenet_has_mdio_intr(priv))
 		int0_enable |= (UMAC_IRQ_MDIO_DONE | UMAC_IRQ_MDIO_ERROR);
 
 	bcmgenet_intrl2_0_writel(priv, int0_enable, INTRL2_CPU_MASK_CLEAR);
@@ -3221,7 +3221,7 @@ static irqreturn_t bcmgenet_isr0(int irq, void *dev_id)
 		}
 	}
 
-	if ((priv->hw_params->flags & GENET_HAS_MDIO_INTR) &&
+	if (bcmgenet_has_mdio_intr(priv) &&
 		status & (UMAC_IRQ_MDIO_DONE | UMAC_IRQ_MDIO_ERROR)) {
 		wake_up(&priv->wq);
 	}
@@ -3891,7 +3891,7 @@ static void bcmgenet_set_hw_params(struct bcmgenet_priv *priv)
 	}
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	if (!(params->flags & GENET_HAS_40BITS))
+	if (!bcmgenet_has_40bits(priv))
 		pr_warn("GENET does not support 40-bits PA\n");
 #endif
 
@@ -4070,7 +4070,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	bcmgenet_set_hw_params(priv);
 
 	err = -EIO;
-	if (priv->hw_params->flags & GENET_HAS_40BITS)
+	if (bcmgenet_has_40bits(priv))
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
 	if (err)
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index c0005a0fff567..ed7402fb7fdaa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2014-2024 Broadcom
+ * Copyright (c) 2014-2025 Broadcom
  */
 
 #ifndef __BCMGENET_H__
@@ -648,6 +648,31 @@ struct bcmgenet_priv {
 	struct bcmgenet_mib_counters mib;
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
index 9beb65e6d0a96..eeb2aa75efdae 100644
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
@@ -151,7 +151,7 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 	u32 reg = 0;
 
 	/* EXT_GPHY_CTRL is only valid for GENETv4 and onward */
-	if (GENET_IS_V4(priv) || priv->ephy_16nm) {
+	if (GENET_IS_V4(priv) || bcmgenet_has_ephy_16nm(priv)) {
 		reg = bcmgenet_ext_readl(priv, EXT_GPHY_CTRL);
 		if (enable) {
 			reg &= ~EXT_CK25_DIS;
@@ -181,7 +181,7 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
+	if (bcmgenet_has_moca_link_det(priv))
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
 }
-- 
2.53.0



