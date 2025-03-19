Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09831C4A24;
	Wed, 19 Mar 2025 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394969; cv=none; b=L9QgOAxb63GFtB+tpHxXFGxYpcKuaJrAzesGJDMZzXNv9rNqzkjT9dE1P8p+sJtmpmk03lw2AZuyFxrr5axSHLrGpYPtFFY5Hb1twrQt+mxwxllX23SbSei5eblkepXG+HZRvTa3CBs2lf9/SNY+ZGYtIl9lKUwUMsEWyzHJGhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394969; c=relaxed/simple;
	bh=Z8qXk3FDcUMq72bUmMyVsP8LifMfQc7B6iCuUramaYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJV1Ug/LaiJPZJO+Q9Dd6J2cPNrxNeBco/hRLpZgtzhw/uMhh9pR1BURfiMFC66XIDKdttbu4t1qX6+SCzFmgoxR0aLs3eY5yeDTCimr2XPsOmFzJoUyQDK46B/x+QeA69S22h6ryVvo5cpF0bKoMrO2i/TVTDX7aQpI11mPNZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPLHiu8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPLHiu8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5773C4CEE4;
	Wed, 19 Mar 2025 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394969;
	bh=Z8qXk3FDcUMq72bUmMyVsP8LifMfQc7B6iCuUramaYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPLHiu8hfUY/ejT1js6v8akyB/X31vrZ2nljol2Ja1HvaFzHQuS+kq5PAtkFggkFo
	 WCKf3YGdQHAhed4g/kyvB6bXn8sXW0ut44hvAkOHyWOLVgf18cfMsMOSYnsIdGgiNC
	 S/GUa5yTrgg4a6zwtiu/rRS5sCnWv2T7wKZMRHpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Botila <andrei.botila@oss.nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 204/241] net: phy: nxp-c45-tja11xx: add TJA112XB SGMII PCS restart errata
Date: Wed, 19 Mar 2025 07:31:14 -0700
Message-ID: <20250319143032.776492507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Botila <andrei.botila@oss.nxp.com>

commit 48939523843e4813e78920f54937944a8787134b upstream.

TJA1120B/TJA1121B can achieve a stable operation of SGMII after
a startup event by putting the SGMII PCS into power down mode and
restart afterwards.

It is necessary to put the SGMII PCS into power down mode and back up.

Cc: stable@vger.kernel.org
Fixes: f1fe5dff2b8a ("net: phy: nxp-c45-tja11xx: add TJA1120 support")
Signed-off-by: Andrei Botila <andrei.botila@oss.nxp.com>
Link: https://patch.msgid.link/20250304160619.181046-3-andrei.botila@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -114,6 +114,9 @@
 #define MII_BASIC_CONFIG_RMII		0x5
 #define MII_BASIC_CONFIG_MII		0x4
 
+#define VEND1_SGMII_BASIC_CONTROL	0xB000
+#define SGMII_LPM			BIT(11)
+
 #define VEND1_SYMBOL_ERROR_CNT_XTD	0x8351
 #define EXTENDED_CNT_EN			BIT(15)
 #define VEND1_MONITOR_STATUS		0xAC80
@@ -1598,11 +1601,11 @@ static int nxp_c45_set_phy_mode(struct p
 	return 0;
 }
 
-/* Errata: ES_TJA1120 and ES_TJA1121 Rev. 1.0 — 28 November 2024 Section 3.1 */
+/* Errata: ES_TJA1120 and ES_TJA1121 Rev. 1.0 — 28 November 2024 Section 3.1 & 3.2 */
 static void nxp_c45_tja1120_errata(struct phy_device *phydev)
 {
+	bool macsec_ability, sgmii_ability;
 	int silicon_version, sample_type;
-	bool macsec_ability;
 	int phy_abilities;
 	int ret = 0;
 
@@ -1619,6 +1622,7 @@ static void nxp_c45_tja1120_errata(struc
 	phy_abilities = phy_read_mmd(phydev, MDIO_MMD_VEND1,
 				     VEND1_PORT_ABILITIES);
 	macsec_ability = !!(phy_abilities & MACSEC_ABILITY);
+	sgmii_ability = !!(phy_abilities & SGMII_ABILITY);
 	if ((!macsec_ability && silicon_version == 2) ||
 	    (macsec_ability && silicon_version == 1)) {
 		/* TJA1120/TJA1121 PHY configuration errata workaround.
@@ -1639,6 +1643,18 @@ static void nxp_c45_tja1120_errata(struc
 
 		phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 0x0);
 		phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 0x0);
+
+		if (sgmii_ability) {
+			/* TJA1120B/TJA1121B SGMII PCS restart errata workaround.
+			 * Put SGMII PCS into power down mode and back up.
+			 */
+			phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+					 VEND1_SGMII_BASIC_CONTROL,
+					 SGMII_LPM);
+			phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					   VEND1_SGMII_BASIC_CONTROL,
+					   SGMII_LPM);
+		}
 	}
 }
 


