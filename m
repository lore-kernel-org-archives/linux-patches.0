Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC133FE34;
	Tue, 11 Nov 2025 01:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823449; cv=none; b=AgxMjTbioeRuK5g1VDegk1FmLrCqBmo13jDekJxGKul+sIgss2wHmteOFv/Qg+XxR9msE/43j732FQEenNc24CBm0xF1ic5mRbNo3mGqAGtZos8xBK6OWxuz5NF4/qGUlT8miytv/ozJ7JXwxg9hZIofatEP+0OirJ0ItZ7nTBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823449; c=relaxed/simple;
	bh=vA4G/PjU7LfNw9tE1t3nNAXYlgeStv2N4ITikmnEX9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWaT42tRBNHRzYtz9iOX/KcO2pe4mpiGRBlbb7TOIcua2OaRKKww2sXmLdq4V2TX3hIrEAe9gXRprv1aI40hNk0vg4M9F43mn3EY893e7wjqUhMVUxdehPOhTxjCVXUUO6hTyD52qNxK6j4ex8KbY7LmdxYntkP/u2Dbk4X7Iik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kT7gT3sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kT7gT3sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480C8C16AAE;
	Tue, 11 Nov 2025 01:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823449;
	bh=vA4G/PjU7LfNw9tE1t3nNAXYlgeStv2N4ITikmnEX9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kT7gT3sGAfJa3dP2pB5p0cFyrH3mjNFGAtxCWWB1UiU2fkJHz/YOwOIaFPNphyUwj
	 TIWR75pbnuEYiumyyzdeIwJkDZ6hOYzLsy4+DyMSrreNi72OpPSzQp+qLQ5V6XKB0p
	 ZwXo9qR5QfVqpLTm2BzHcZKEun5cZWadHHe/jIuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 302/849] net: phy: mscc: report and configure in-band auto-negotiation for SGMII/QSGMII
Date: Tue, 11 Nov 2025 09:37:52 +0900
Message-ID: <20251111004543.710167069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit df979273bd716a93ca9ffa8f84aeb205c9bf2ab6 ]

The following Vitesse/Microsemi/Microchip PHYs, among those supported by
this driver, have the host interface configurable as SGMII or QSGMII:
- VSC8504
- VSC8514
- VSC8552
- VSC8562
- VSC8572
- VSC8574
- VSC8575
- VSC8582
- VSC8584

All these PHYs are documented to have bit 7 of "MAC SerDes PCS Control"
as "MAC SerDes ANEG enable".

Out of these, I could test the VSC8514 quad PHY in QSGMII. This works
both with the in-band autoneg on and off, on the NXP LS1028A-RDB and
T1040-RDB boards.

Notably, the bit is sticky (survives soft resets), so giving Linux the
tools to read and modify this settings makes it robust to changes made
to it by previous boot layers (U-Boot).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250813074454.63224-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |  3 +++
 drivers/net/phy/mscc/mscc_main.c | 40 ++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 2bfe314ef881c..2d8eca54c40a2 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -196,6 +196,9 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
+
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 24c75903f5354..ef0ef1570d392 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2202,6 +2202,28 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static unsigned int vsc85xx_inband_caps(struct phy_device *phydev,
+					phy_interface_t interface)
+{
+	if (interface != PHY_INTERFACE_MODE_SGMII &&
+	    interface != PHY_INTERFACE_MODE_QSGMII)
+		return 0;
+
+	return LINK_INBAND_DISABLE | LINK_INBAND_ENABLE;
+}
+
+static int vsc85xx_config_inband(struct phy_device *phydev, unsigned int modes)
+{
+	u16 reg_val = 0;
+
+	if (modes == LINK_INBAND_ENABLE)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2414,6 +2436,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8514,
@@ -2437,6 +2461,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
@@ -2557,6 +2583,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC856X,
@@ -2579,6 +2607,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8572,
@@ -2605,6 +2635,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8574,
@@ -2631,6 +2663,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8575,
@@ -2655,6 +2689,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8582,
@@ -2679,6 +2715,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8584,
@@ -2704,6 +2742,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
 	.link_change_notify = &vsc85xx_link_change_notify,
+	.inband_caps    = vsc85xx_inband_caps,
+	.config_inband  = vsc85xx_config_inband,
 }
 
 };
-- 
2.51.0



