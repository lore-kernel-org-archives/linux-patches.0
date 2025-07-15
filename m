Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100B62EA17D;
	Tue, 15 Jul 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586812; cv=none; b=tVpIIU5iV2GZOUSaVy3oyoo17qmeufPCSv4id0eRSRoxwfigS0bXgRa5C5LVY2H7qPoJmD5hsrmpicR2S2wfaWgp/9CY8LYf/HT1muhjmP8Dy1TcOgD0BeBtrA+blQsMfqRCxVcDJW3KyRHBYJgLQiMnDwEyxvAVw2fViWXYakw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586812; c=relaxed/simple;
	bh=OE4yhTJDPHMPVO0zHqgAzSCoebDT8gcPiyJdsM3fMxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5aOJc7zGDDz3/x2uKJQKJnBf2NQf6HCKCBq3wrMqFigkoCvx/1ElId4vDphpVgEk7wu7CpunyMGIlUqzG/K+oQtuy9FLsuzWrUtqiESZqVz4quhA8RvOOqyKTfBRo2pvYCF2HJxe2l/mLdbcRn+UFXg4pOZvWEi135AxXDMKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPb4ppGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPb4ppGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FBFC4CEF1;
	Tue, 15 Jul 2025 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586811;
	bh=OE4yhTJDPHMPVO0zHqgAzSCoebDT8gcPiyJdsM3fMxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPb4ppGafnfx5/TaSUtwCBfpkJ/J/6ASxPHM6pjEIS1G8778grq0j66gqGu0TZAu9
	 LXV7M0oZiLsSmP/TqNIHtCPN2imr92c2YpvQAHBsufxWV/4zdeWhbxhdQ2rzPBv36p
	 LDtRKbDlK/g7lnWlAUxsxk3qVJQTiua/bn3Xkl5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Luo Jie <quic_luoj@quicinc.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 026/192] net: phy: qcom: move the WoL function to shared library
Date: Tue, 15 Jul 2025 15:12:01 +0200
Message-ID: <20250715130815.914234904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Jie <quic_luoj@quicinc.com>

[ Upstream commit e31cf3cce2102af984656fed6e2254cbdd46da02 ]

Move the WoL (Wake-on-LAN) functionality to a shared library to enable
its reuse by the QCA808X PHY driver, incorporating support for WoL
functionality similar to the implementation in at8031_set_wol().

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
Link: https://patch.msgid.link/20250704-qcom_phy_wol_support-v1-1-053342b1538d@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4ab9ada765b7 ("net: phy: qcom: qca808x: Fix WoL issue by utilizing at8031_set_wol()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/at803x.c       | 27 ---------------------------
 drivers/net/phy/qcom/qcom-phy-lib.c | 25 +++++++++++++++++++++++++
 drivers/net/phy/qcom/qcom.h         |  5 +++++
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/net/phy/qcom/at803x.c b/drivers/net/phy/qcom/at803x.c
index 26350b962890b..8f26e395e39f9 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -26,9 +26,6 @@
 
 #define AT803X_LED_CONTROL			0x18
 
-#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
-#define AT803X_WOL_EN				BIT(5)
-
 #define AT803X_REG_CHIP_CONFIG			0x1f
 #define AT803X_BT_BX_REG_SEL			0x8000
 
@@ -866,30 +863,6 @@ static int at8031_config_init(struct phy_device *phydev)
 	return at803x_config_init(phydev);
 }
 
-static int at8031_set_wol(struct phy_device *phydev,
-			  struct ethtool_wolinfo *wol)
-{
-	int ret;
-
-	/* First setup MAC address and enable WOL interrupt */
-	ret = at803x_set_wol(phydev, wol);
-	if (ret)
-		return ret;
-
-	if (wol->wolopts & WAKE_MAGIC)
-		/* Enable WOL function for 1588 */
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
-				     AT803X_PHY_MMD3_WOL_CTRL,
-				     0, AT803X_WOL_EN);
-	else
-		/* Disable WoL function for 1588 */
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
-				     AT803X_PHY_MMD3_WOL_CTRL,
-				     AT803X_WOL_EN, 0);
-
-	return ret;
-}
-
 static int at8031_config_intr(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
diff --git a/drivers/net/phy/qcom/qcom-phy-lib.c b/drivers/net/phy/qcom/qcom-phy-lib.c
index d28815ef56bbf..af7d0d8e81be5 100644
--- a/drivers/net/phy/qcom/qcom-phy-lib.c
+++ b/drivers/net/phy/qcom/qcom-phy-lib.c
@@ -115,6 +115,31 @@ int at803x_set_wol(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(at803x_set_wol);
 
+int at8031_set_wol(struct phy_device *phydev,
+		   struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	/* First setup MAC address and enable WOL interrupt */
+	ret = at803x_set_wol(phydev, wol);
+	if (ret)
+		return ret;
+
+	if (wol->wolopts & WAKE_MAGIC)
+		/* Enable WOL function for 1588 */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+				     AT803X_PHY_MMD3_WOL_CTRL,
+				     0, AT803X_WOL_EN);
+	else
+		/* Disable WoL function for 1588 */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+				     AT803X_PHY_MMD3_WOL_CTRL,
+				     AT803X_WOL_EN, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(at8031_set_wol);
+
 void at803x_get_wol(struct phy_device *phydev,
 		    struct ethtool_wolinfo *wol)
 {
diff --git a/drivers/net/phy/qcom/qcom.h b/drivers/net/phy/qcom/qcom.h
index 4bb541728846d..7f7151c8bacaa 100644
--- a/drivers/net/phy/qcom/qcom.h
+++ b/drivers/net/phy/qcom/qcom.h
@@ -172,6 +172,9 @@
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
 #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
 
+#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
+#define AT803X_WOL_EN				BIT(5)
+
 #define AT803X_DEBUG_ADDR			0x1D
 #define AT803X_DEBUG_DATA			0x1E
 
@@ -215,6 +218,8 @@ int at803x_debug_reg_mask(struct phy_device *phydev, u16 reg,
 int at803x_debug_reg_write(struct phy_device *phydev, u16 reg, u16 data);
 int at803x_set_wol(struct phy_device *phydev,
 		   struct ethtool_wolinfo *wol);
+int at8031_set_wol(struct phy_device *phydev,
+		   struct ethtool_wolinfo *wol);
 void at803x_get_wol(struct phy_device *phydev,
 		    struct ethtool_wolinfo *wol);
 int at803x_ack_interrupt(struct phy_device *phydev);
-- 
2.39.5



