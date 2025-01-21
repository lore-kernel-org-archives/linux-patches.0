Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C7D1F427B;
	Tue, 21 Jan 2025 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482458; cv=none; b=qFkZr4TnnBGqxUFc80TAveZmWo0Zu4+uivMTFZlcH05ybPGmXyXP4H/DMPFMyRcdlcQk/7+h5ZZfyxsHIUNH6SQb+aCYXiDZByEjOn68DD5H8DVcxctTwWdInbqYaK7vZrJYUyfaughai/52G473+8hEGtDshXMPh11VgnDcuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482458; c=relaxed/simple;
	bh=Cww9yStY+A3Ez+vTlkRr/Lhxdwf1M0K7gUEEoXiv1JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaWdtCLmr9fgJDwEqZbs7RFzRi4PyaCl5CHpsIqbARKcwLjQjg+5mYl3hz0FIt9EVwACEftiZQvDivI5ZBw+82Stn6CbuWLuhv7I8klIKPQujCmTBN+INSV/sEXvJHsyVhH28JaURO2aqGhPmxNCaRrs1ZFlRgUIRDreZbe83C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEq6oSpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEq6oSpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF09C4CEDF;
	Tue, 21 Jan 2025 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482457;
	bh=Cww9yStY+A3Ez+vTlkRr/Lhxdwf1M0K7gUEEoXiv1JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEq6oSpy+T1BD6n9I7ZfIoIB65Dwfjy5R5pfHa2nsfs5ftq8sFfgcOWbunYyU01+V
	 qudzpAHufl2WhAHZDuM/1i++PeMdZa9EDZ8nQnaBJjsXnllIYGJxoYYIkxztmI+7GM
	 QDS16i2vx2ZEAW+tRlGmDQ6P84iRB3BejApmeYiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 083/122] net: ethernet: xgbe: re-add aneg to supported features in PHY quirks
Date: Tue, 21 Jan 2025 18:52:11 +0100
Message-ID: <20250121174536.210678964@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 6be7aca91009865d8c2b73589270224a6b6e67ab upstream.

In 4.19, before the switch to linkmode bitmaps, PHY_GBIT_FEATURES
included feature bits for aneg and TP/MII ports.

				 SUPPORTED_TP | \
				 SUPPORTED_MII)

				 SUPPORTED_10baseT_Full)

				 SUPPORTED_100baseT_Full)

				 SUPPORTED_1000baseT_Full)

				 PHY_100BT_FEATURES | \
				 PHY_DEFAULT_FEATURES)

				 PHY_1000BT_FEATURES)

Referenced commit expanded PHY_GBIT_FEATURES, silently removing
PHY_DEFAULT_FEATURES. The removed part can be re-added by using
the new PHY_GBIT_FEATURES definition.
Not clear to me is why nobody seems to have noticed this issue.

I stumbled across this when checking what it takes to make
phy_10_100_features_array et al private to phylib.

Fixes: d0939c26c53a ("net: ethernet: xgbe: expand PHY_GBIT_FEAUTRES")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/46521973-7738-4157-9f5e-0bb6f694acba@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -923,7 +923,6 @@ static void xgbe_phy_free_phy_device(str
 
 static bool xgbe_phy_finisar_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	unsigned int phy_id = phy_data->phydev->phy_id;
 
@@ -945,14 +944,7 @@ static bool xgbe_phy_finisar_phy_quirks(
 	phy_write(phy_data->phydev, 0x04, 0x0d01);
 	phy_write(phy_data->phydev, 0x00, 0x9140);
 
-	linkmode_set_bit_array(phy_10_100_features_array,
-			       ARRAY_SIZE(phy_10_100_features_array),
-			       supported);
-	linkmode_set_bit_array(phy_gbit_features_array,
-			       ARRAY_SIZE(phy_gbit_features_array),
-			       supported);
-
-	linkmode_copy(phy_data->phydev->supported, supported);
+	linkmode_copy(phy_data->phydev->supported, PHY_GBIT_FEATURES);
 
 	phy_support_asym_pause(phy_data->phydev);
 
@@ -964,7 +956,6 @@ static bool xgbe_phy_finisar_phy_quirks(
 
 static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	struct xgbe_sfp_eeprom *sfp_eeprom = &phy_data->sfp_eeprom;
 	unsigned int phy_id = phy_data->phydev->phy_id;
@@ -1028,13 +1019,7 @@ static bool xgbe_phy_belfuse_phy_quirks(
 	reg = phy_read(phy_data->phydev, 0x00);
 	phy_write(phy_data->phydev, 0x00, reg & ~0x00800);
 
-	linkmode_set_bit_array(phy_10_100_features_array,
-			       ARRAY_SIZE(phy_10_100_features_array),
-			       supported);
-	linkmode_set_bit_array(phy_gbit_features_array,
-			       ARRAY_SIZE(phy_gbit_features_array),
-			       supported);
-	linkmode_copy(phy_data->phydev->supported, supported);
+	linkmode_copy(phy_data->phydev->supported, PHY_GBIT_FEATURES);
 	phy_support_asym_pause(phy_data->phydev);
 
 	netif_dbg(pdata, drv, pdata->netdev,


