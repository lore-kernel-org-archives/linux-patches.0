Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34BB21CA00;
	Wed, 19 Mar 2025 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395131; cv=none; b=Nuay8fycIDPnqsijtDnWAm2gtuU45z+WQBqaxP6IQ85EuituAopT3tYVl9UXMFyeQXAMlQjHibEFhGTqglfFPOZ8iouRnu8JiNhbP9+kpBHGsKBVTG5QG7R0k/HsTujnkMsYQNNs6fdQc+La3gDNkBFitwGvajmmpdjgxKtM2S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395131; c=relaxed/simple;
	bh=hNabgOodPPX9DRXA3OiKRQ+tE4I67lnV6sHY9bqPZxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+ffcD8S5pXyexrU+pgYoyirDKJtynOzjFN2+Kza5JFC6MQ/V059jWfCptsgFmIQ3+3Wa+mpyTEj6ZNIYlan7+qz2oHDwSqucmAeJQuU8if/m1AqyuSVwbLBK/clWoz7CTjxTFb0kAtIH9SjK/B6ionfzVNSD0N9IJ4ymgorb2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1meX/Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1meX/Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B91CC4CEE8;
	Wed, 19 Mar 2025 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395131;
	bh=hNabgOodPPX9DRXA3OiKRQ+tE4I67lnV6sHY9bqPZxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1meX/UvSRE+m4B3AtlEcIttdmvK6LSVyVUOqpDPTE0ip4V9NlWM24L/X2uKnumnl
	 l+SKv1TxRJb4YLEiw1XJLE6joumCzZuiZmx3tpRe70P4PZ9EEKQm44mKxbqcP40c6k
	 X2/j6SmkAQPt+TV+UjORqMA2SUW6MzMY3ckp1hX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Botila <andrei.botila@oss.nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 196/231] net: phy: nxp-c45-tja11xx: add TJA112XB SGMII PCS restart errata
Date: Wed, 19 Mar 2025 07:31:29 -0700
Message-ID: <20250319143031.682981603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -113,6 +113,9 @@
 #define MII_BASIC_CONFIG_RMII		0x5
 #define MII_BASIC_CONFIG_MII		0x4
 
+#define VEND1_SGMII_BASIC_CONTROL	0xB000
+#define SGMII_LPM			BIT(11)
+
 #define VEND1_SYMBOL_ERROR_CNT_XTD	0x8351
 #define EXTENDED_CNT_EN			BIT(15)
 #define VEND1_MONITOR_STATUS		0xAC80
@@ -1588,11 +1591,11 @@ static int nxp_c45_set_phy_mode(struct p
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
 
@@ -1609,6 +1612,7 @@ static void nxp_c45_tja1120_errata(struc
 	phy_abilities = phy_read_mmd(phydev, MDIO_MMD_VEND1,
 				     VEND1_PORT_ABILITIES);
 	macsec_ability = !!(phy_abilities & MACSEC_ABILITY);
+	sgmii_ability = !!(phy_abilities & SGMII_ABILITY);
 	if ((!macsec_ability && silicon_version == 2) ||
 	    (macsec_ability && silicon_version == 1)) {
 		/* TJA1120/TJA1121 PHY configuration errata workaround.
@@ -1629,6 +1633,18 @@ static void nxp_c45_tja1120_errata(struc
 
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
 


