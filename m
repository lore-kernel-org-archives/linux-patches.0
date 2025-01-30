Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F981E8824;
	Thu, 30 Jan 2025 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246791; cv=none; b=Notsb/VEREdNKTBbPCRuNNq6vlArZ7kVifsVXWVFFtouOoKt6cBguB/7Aaog+skO8XcZ/zSBYz/rmvTKqofQ/PUVm7/Yve/44hwsmlQcQmErsFoJ7ypWk5V76qlMl1rdoOg+CMS5dUODwWkw8UZ2E7W2QNIRgbXgXIAFCouVKww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246791; c=relaxed/simple;
	bh=ehL/gh5BQM4nJpGKG/A0iXq+TZr+Wm5Pu5bwPfqhZr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX//pRHspf+mAJG93+z+nlo2xhrla9ELlT7/VE0NLsTrIqZet+/eURrWNRipDYlA9LLNkm3T5E4iPwAMUkHuLC3B1z5mssQ4rOqv2sSWEqxydRQ09Nl+wHB4cbW8kPch3jQSzcri/oKVp7FodxAcZUF2rkZ3uQwb9B2UL1g3A3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjIq5eEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjIq5eEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D435DC4CEE2;
	Thu, 30 Jan 2025 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246791;
	bh=ehL/gh5BQM4nJpGKG/A0iXq+TZr+Wm5Pu5bwPfqhZr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjIq5eEWqFUmzLPamVetdCS5KcTXGrx1jTV5jo+3YiNxmz0+1bIXkSHjNIGLKFre+
	 lZehGmJB9oq7dwzJMW/j5uc65zQ3pqfAvE5vu+u3jRIT84SifjdQw6PSJZwKWt7Z2L
	 JIjUOq0u9/ROJGGpR5TG3wsiHIIgP9t20lfU7Zvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 68/91] net: ethernet: xgbe: re-add aneg to supported features in PHY quirks
Date: Thu, 30 Jan 2025 15:01:27 +0100
Message-ID: <20250130140136.408948376@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -855,7 +855,6 @@ static void xgbe_phy_free_phy_device(str
 
 static bool xgbe_phy_finisar_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	unsigned int phy_id = phy_data->phydev->phy_id;
 
@@ -877,14 +876,7 @@ static bool xgbe_phy_finisar_phy_quirks(
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
 
@@ -896,7 +888,6 @@ static bool xgbe_phy_finisar_phy_quirks(
 
 static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	struct xgbe_sfp_eeprom *sfp_eeprom = &phy_data->sfp_eeprom;
 	unsigned int phy_id = phy_data->phydev->phy_id;
@@ -960,13 +951,7 @@ static bool xgbe_phy_belfuse_phy_quirks(
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


