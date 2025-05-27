Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1027FD49;
	Tue, 27 May 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365152; cv=none; b=UQjUTrAlS0Y5rOUQlTA1FoyBcTRebfn9gGq49Fw8GQCqI+a5QvNTOVpQy5ADxCTulI/TEkWsvnCS6R2BG2lHl/54eD2fSgOLkkKYwHilgB7wvtgyvThYjnmHcdU1HXlu/gm+oPEzrxIJg1AFlyIKgxyK/14b6zCRWi7xpTrEedY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365152; c=relaxed/simple;
	bh=MOJRz7Nd1MIZsv/x/0XyB9Jj9Q2jwlh7bPtwtpzyp+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxaeI8FZcg93BEj+f6eSxBt0UGS3waRarrK64/1Tsde8WfIRPPCi/mjtWX/pg5pwYqYeW5X3411IIHqEPjpDyMwfPb1kfH8KF8GHj/DD+RR9GjzliS7TuT1AvgF2uK0gEaDtXBiCCztnwg5loOFM3x+jDA94fjGxL5WiXy0R8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/5/ag3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/5/ag3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CCEC4CEE9;
	Tue, 27 May 2025 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365152;
	bh=MOJRz7Nd1MIZsv/x/0XyB9Jj9Q2jwlh7bPtwtpzyp+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/5/ag3GKquueV+vZ5PZKHX4v1yyEOtR0LTvRkbq8Yptps8MbRH6hlDUya8K9dzGL
	 aq9fEmQu3jncZqv5WPKP0P9wS5rWLoeD9OMZkjeG63L7nXvjD6LDApYk2ggVpd3v66
	 Vi+vQPGZG3ds/xOYutTzJLx6bpBMVhyK1JOJET9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Botila <andrei.botila@oss.nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/626] net: phy: nxp-c45-tja11xx: add match_phy_device to TJA1103/TJA1104
Date: Tue, 27 May 2025 18:22:16 +0200
Message-ID: <20250527162454.885786711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Andrei Botila <andrei.botila@oss.nxp.com>

[ Upstream commit a06a868a0cd96bc51401cdea897313a3f6ad01a0 ]

Add .match_phy_device for the existing TJAs to differentiate between
TJA1103 and TJA1104.
TJA1103 and TJA1104 share the same PHY_ID but TJA1104 has MACsec
capabilities while TJA1103 doesn't.

Signed-off-by: Andrei Botila <andrei.botila@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250228154320.2979000-2-andrei.botila@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 54 +++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 9788b820c6be7..99a5eee77bec1 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* NXP C45 PHY driver
- * Copyright 2021-2023 NXP
+ * Copyright 2021-2025 NXP
  * Author: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
  */
 
@@ -18,6 +18,8 @@
 
 #include "nxp-c45-tja11xx.h"
 
+#define PHY_ID_MASK			GENMASK(31, 4)
+/* Same id: TJA1103, TJA1104 */
 #define PHY_ID_TJA_1103			0x001BB010
 #define PHY_ID_TJA_1120			0x001BB031
 
@@ -1930,6 +1932,30 @@ static void tja1120_nmi_handler(struct phy_device *phydev,
 	}
 }
 
+static int nxp_c45_macsec_ability(struct phy_device *phydev)
+{
+	bool macsec_ability;
+	int phy_abilities;
+
+	phy_abilities = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				     VEND1_PORT_ABILITIES);
+	macsec_ability = !!(phy_abilities & MACSEC_ABILITY);
+
+	return macsec_ability;
+}
+
+static int tja1103_match_phy_device(struct phy_device *phydev)
+{
+	return phy_id_compare(phydev->phy_id, PHY_ID_TJA_1103, PHY_ID_MASK) &&
+	       !nxp_c45_macsec_ability(phydev);
+}
+
+static int tja1104_match_phy_device(struct phy_device *phydev)
+{
+	return phy_id_compare(phydev->phy_id, PHY_ID_TJA_1103, PHY_ID_MASK) &&
+	       nxp_c45_macsec_ability(phydev);
+}
+
 static const struct nxp_c45_regmap tja1120_regmap = {
 	.vend1_ptp_clk_period	= 0x1020,
 	.vend1_event_msg_filt	= 0x9010,
@@ -2000,7 +2026,6 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 
 static struct phy_driver nxp_c45_driver[] = {
 	{
-		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
 		.name			= "NXP C45 TJA1103",
 		.get_features		= nxp_c45_get_features,
 		.driver_data		= &tja1103_phy_data,
@@ -2022,6 +2047,31 @@ static struct phy_driver nxp_c45_driver[] = {
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
 		.remove			= nxp_c45_remove,
+		.match_phy_device	= tja1103_match_phy_device,
+	},
+	{
+		.name			= "NXP C45 TJA1104",
+		.get_features		= nxp_c45_get_features,
+		.driver_data		= &tja1103_phy_data,
+		.probe			= nxp_c45_probe,
+		.soft_reset		= nxp_c45_soft_reset,
+		.config_aneg		= genphy_c45_config_aneg,
+		.config_init		= nxp_c45_config_init,
+		.config_intr		= tja1103_config_intr,
+		.handle_interrupt	= nxp_c45_handle_interrupt,
+		.read_status		= genphy_c45_read_status,
+		.suspend		= genphy_c45_pma_suspend,
+		.resume			= genphy_c45_pma_resume,
+		.get_sset_count		= nxp_c45_get_sset_count,
+		.get_strings		= nxp_c45_get_strings,
+		.get_stats		= nxp_c45_get_stats,
+		.cable_test_start	= nxp_c45_cable_test_start,
+		.cable_test_get_status	= nxp_c45_cable_test_get_status,
+		.set_loopback		= genphy_c45_loopback,
+		.get_sqi		= nxp_c45_get_sqi,
+		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
+		.match_phy_device	= tja1104_match_phy_device,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1120),
-- 
2.39.5



