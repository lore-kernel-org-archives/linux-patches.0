Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F39B7261B;
	Tue, 15 Jul 2025 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585402; cv=none; b=syh5JM7DTlSxL8xzzLl44vKnUBHxuL3HgaOKQPudnQMn4q5T0f/20AJtmhb+X6So6Q8JhOLr/e6ho4vIDkCyFY9HoFZEfuFO8KZTZScJVEvYtu+UgiHzNGvLYU0ugxlESVQrH3WkGTREabDiNp3FXllkGM0ys19xLAFjqByEBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585402; c=relaxed/simple;
	bh=uQfM1ySX9IE1NhZHoqa5WI8SGoCT/AgiwHqq6bNbeak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4UucRFds36h4E6/h0qJRKmupBUbq6mziAYkRLb3A8VXKMkbQOjDk33S8rDLnFqEQMRvfY16SEwtvnxDhpTF3ggsJGAzlrnrw3L20bbXyb//UrlH1Ix7pdZYdidxBhmV/GBJAiXQpxFP7EXstIHt+WuTFZAoIQDvucxrVwRj9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAvS17En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAvS17En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DA1C4CEE3;
	Tue, 15 Jul 2025 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585401;
	bh=uQfM1ySX9IE1NhZHoqa5WI8SGoCT/AgiwHqq6bNbeak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAvS17EnxwdxROTDCUvf1mqUXaqAup99hGT+fNIYWCi6KvZYUQwUpdluGsB/kF5HH
	 NA5lYzm8OWo8qrdEEGvOki2uosRHMB9Cy65g1ou3OExP6BUST74ws5b03PPSZGErZW
	 o4VQoA+a+rbledJrisCzisWzrE4MNZO3Y1P779vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Luo Jie <quic_luoj@quicinc.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/163] net: phy: qcom: move the WoL function to shared library
Date: Tue, 15 Jul 2025 15:11:35 +0200
Message-ID: <20250715130809.847419261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 105602581a033..ac909ad8a87b4 100644
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



