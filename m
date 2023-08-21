Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4031171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D940C433C7;
	Mon, 21 Aug 2023 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648026;
	bh=89tRwFwqe1vrv9EvlsO+iWVdU3Z0YxokEYefZlKgx+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgV6hxWbGwb0WlQ7wb8qVyiE/BU2SKW2GXfi0WRCgUz5dxcT/TFsTPpSQHva0sywC
	 mZfrqstign4S8RsIT9bL2ikfYUJ56C5y97volcGG1wm5g8oLRaDwYctpVwt43j967T
	 n2ZguxHWfutbjdYieg9RJoCkO/+Eq5ka4FAQVuSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yang <leoyang.li@nxp.com>,
	Viorel Suman <viorel.suman@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 003/234] net: phy: at803x: fix the wol setting functions
Date: Mon, 21 Aug 2023 21:39:26 +0200
Message-ID: <20230821194128.902927109@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Yang <leoyang.li@nxp.com>

[ Upstream commit e58f30246c35c126c7571065b33bee4b3b1d2ef8 ]

In commit 7beecaf7d507 ("net: phy: at803x: improve the WOL feature"), it
seems not correct to use a wol_en bit in a 1588 Control Register which is
only available on AR8031/AR8033(share the same phy_id) to determine if WoL
is enabled.  Change it back to use AT803X_INTR_ENABLE_WOL for determining
the WoL status which is applicable on all chips supporting wol. Also update
the at803x_set_wol() function to only update the 1588 register on chips
having it.  After this change, disabling wol at probe from commit
d7cd5e06c9dd ("net: phy: at803x: disable WOL at probe") is no longer
needed.  Change it to just disable the WoL bit in 1588 register for
AR8031/AR8033 to be aligned with AT803X_INTR_ENABLE_WOL in probe.

Fixes: 7beecaf7d507 ("net: phy: at803x: improve the WOL feature")
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Reviewed-by: Viorel Suman <viorel.suman@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 45 ++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index b2e1c0655f628..8a77ec33b4172 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -459,21 +459,27 @@ static int at803x_set_wol(struct phy_device *phydev,
 			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
-		/* Enable WOL function */
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
-				0, AT803X_WOL_EN);
-		if (ret)
-			return ret;
+		/* Enable WOL function for 1588 */
+		if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+			ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+					     AT803X_PHY_MMD3_WOL_CTRL,
+					     0, AT803X_WOL_EN);
+			if (ret)
+				return ret;
+		}
 		/* Enable WOL interrupt */
 		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
 		if (ret)
 			return ret;
 	} else {
-		/* Disable WoL function */
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
-				AT803X_WOL_EN, 0);
-		if (ret)
-			return ret;
+		/* Disable WoL function for 1588 */
+		if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+			ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+					     AT803X_PHY_MMD3_WOL_CTRL,
+					     AT803X_WOL_EN, 0);
+			if (ret)
+				return ret;
+		}
 		/* Disable WOL interrupt */
 		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
 		if (ret)
@@ -508,11 +514,11 @@ static void at803x_get_wol(struct phy_device *phydev,
 	wol->supported = WAKE_MAGIC;
 	wol->wolopts = 0;
 
-	value = phy_read_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL);
+	value = phy_read(phydev, AT803X_INTR_ENABLE);
 	if (value < 0)
 		return;
 
-	if (value & AT803X_WOL_EN)
+	if (value & AT803X_INTR_ENABLE_WOL)
 		wol->wolopts |= WAKE_MAGIC;
 }
 
@@ -858,9 +864,6 @@ static int at803x_probe(struct phy_device *phydev)
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
 		int mode_cfg;
-		struct ethtool_wolinfo wol = {
-			.wolopts = 0,
-		};
 
 		if (ccr < 0)
 			return ccr;
@@ -877,12 +880,14 @@ static int at803x_probe(struct phy_device *phydev)
 			break;
 		}
 
-		/* Disable WOL by default */
-		ret = at803x_set_wol(phydev, &wol);
-		if (ret < 0) {
-			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
+		/* Disable WoL in 1588 register which is enabled
+		 * by default
+		 */
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS,
+				     AT803X_PHY_MMD3_WOL_CTRL,
+				     AT803X_WOL_EN, 0);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
-- 
2.40.1



