Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC711C4A24;
	Wed, 19 Mar 2025 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394969; cv=none; b=E0+9KGzdVBD+xHPUtp4T9WkJRlUrtLbrZnA6TPLBYm08q9I/QdqRLHqTdnWcJ1Tyb8YVtE3bwWZBwtQh69Z2e4ZMKT+9NGIAMkqcYvE/+vBeeJqkRjX0+2WZwS3OmZT+KOCw+sxEduh0j9B47lZYEPhr0ZMWvm4xkQwP78XcZF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394969; c=relaxed/simple;
	bh=grBY6yQjul12TJRiU98MBdGA8q1XaUH5JQt4t95PgjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpi3SPjzsigFd/XHRiAqci7pdDGM03A0iUQ6LJoyGyFJ71/g6Q6i6tUoOvzjmZcVP0Why2N4r4YW4GJ5P4uH2KW5BWvhXi2fHmQTq1+71VdNgaVMSAo0FkStVJggxqsDb7gr3WfzdtKF5bJauaoeh50mf/sy8A3TGGJfAU9851c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cwx5Qj2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cwx5Qj2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000C8C4CEE4;
	Wed, 19 Mar 2025 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394969;
	bh=grBY6yQjul12TJRiU98MBdGA8q1XaUH5JQt4t95PgjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwx5Qj2iu0AZi9gva+VGYpyyWiBK5cU+x5M5Qg7j5Z39TVKBFDm/QKqpVGDy2ntQb
	 NR9PCkdWoCidI6Fd497kidP3PdnRA0upiYSLcYi7HI8qWisGIkbAuK2SOW/fCXTlN9
	 N7HOE/4D7RfxjtCc/lS3L9mP9WTsGS4od4ZnTEt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Botila <andrei.botila@oss.nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 203/241] net: phy: nxp-c45-tja11xx: add TJA112X PHY configuration errata
Date: Wed, 19 Mar 2025 07:31:13 -0700
Message-ID: <20250319143032.750984673@linuxfoundation.org>
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

commit a07364b394697d2e0baffeb517f41385259aa484 upstream.

The most recent sillicon versions of TJA1120 and TJA1121 can achieve
full silicon performance by putting the PHY in managed mode.

It is necessary to apply these PHY writes before link gets established.
Application of this fix is required after restart of device and wakeup
from sleep.

Cc: stable@vger.kernel.org
Fixes: f1fe5dff2b8a ("net: phy: nxp-c45-tja11xx: add TJA1120 support")
Signed-off-by: Andrei Botila <andrei.botila@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250304160619.181046-2-andrei.botila@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |   52 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -22,6 +22,11 @@
 #define PHY_ID_TJA_1103			0x001BB010
 #define PHY_ID_TJA_1120			0x001BB031
 
+#define VEND1_DEVICE_ID3		0x0004
+#define TJA1120_DEV_ID3_SILICON_VERSION	GENMASK(15, 12)
+#define TJA1120_DEV_ID3_SAMPLE_TYPE	GENMASK(11, 8)
+#define DEVICE_ID3_SAMPLE_TYPE_R	0x9
+
 #define VEND1_DEVICE_CONTROL		0x0040
 #define DEVICE_CONTROL_RESET		BIT(15)
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
@@ -1593,6 +1598,50 @@ static int nxp_c45_set_phy_mode(struct p
 	return 0;
 }
 
+/* Errata: ES_TJA1120 and ES_TJA1121 Rev. 1.0 — 28 November 2024 Section 3.1 */
+static void nxp_c45_tja1120_errata(struct phy_device *phydev)
+{
+	int silicon_version, sample_type;
+	bool macsec_ability;
+	int phy_abilities;
+	int ret = 0;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_ID3);
+	if (ret < 0)
+		return;
+
+	sample_type = FIELD_GET(TJA1120_DEV_ID3_SAMPLE_TYPE, ret);
+	if (sample_type != DEVICE_ID3_SAMPLE_TYPE_R)
+		return;
+
+	silicon_version = FIELD_GET(TJA1120_DEV_ID3_SILICON_VERSION, ret);
+
+	phy_abilities = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				     VEND1_PORT_ABILITIES);
+	macsec_ability = !!(phy_abilities & MACSEC_ABILITY);
+	if ((!macsec_ability && silicon_version == 2) ||
+	    (macsec_ability && silicon_version == 1)) {
+		/* TJA1120/TJA1121 PHY configuration errata workaround.
+		 * Apply PHY writes sequence before link up.
+		 */
+		if (!macsec_ability) {
+			phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 0x4b95);
+			phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 0xf3cd);
+		} else {
+			phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 0x89c7);
+			phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 0x0893);
+		}
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x0476, 0x58a0);
+
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, 0x8921, 0xa3a);
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, 0x89F1, 0x16c1);
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 0x0);
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 0x0);
+	}
+}
+
 static int nxp_c45_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -1609,6 +1658,9 @@ static int nxp_c45_config_init(struct ph
 	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
 	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
 
+	if (phy_id_compare(phydev->phy_id, PHY_ID_TJA_1120, GENMASK(31, 4)))
+		nxp_c45_tja1120_errata(phydev);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 


