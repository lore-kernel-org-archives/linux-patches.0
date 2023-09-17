Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764D16FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB01FC433C8;
	Sun, 17 Sep 2023 19:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980454;
	bh=RK3svflyBmA/9zB0vY4vKbnv5kDtMXstzSPiVa37lAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AFUmWEyfPRAig1fO6lMvV4TGPv1TSl3dTJrhw7GToXcUzqeh6k4uq0XUqQ/K3eZw
	 QF4WVPsJn++SKEGTDUKcwHD1adYnn1aXwcXopFswSlR1mJfivktpxEJh6ECQMTheFD
	 pk01F6CZvGbg1dYATD1sPk0F82JyQRc9IEmuTvag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 166/285] net: phy: Provide Module 4 KSZ9477 errata (DS80000754C)
Date: Sun, 17 Sep 2023 21:12:46 +0200
Message-ID: <20230917191057.399793099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 08c6d8bae48c2c28f7017d7b61b5d5a1518ceb39 ]

The KSZ9477 errata points out (in 'Module 4') the link up/down problems
when EEE (Energy Efficient Ethernet) is enabled in the device to which
the KSZ9477 tries to auto negotiate.

The suggested workaround is to clear advertisement of EEE for PHYs in
this chip driver.

To avoid regressions with other switch ICs the new MICREL_NO_EEE flag
has been introduced.

Moreover, the in-register disablement of MMD_DEVICE_ID_EEE_ADV.MMD_EEE_ADV
MMD register is removed, as this code is both; now executed too late
(after previous rework of the PHY and DSA for KSZ switches) and not
required as setting all members of eee_broken_modes bit field prevents
the KSZ9477 from advertising EEE.

Fixes: 69d3b36ca045 ("net: dsa: microchip: enable EEE support") # for KSZ9477
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # Confirmed disabled EEE with oscilloscope.
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20230905093315.784052-1-lukma@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 16 +++++++++++++++-
 drivers/net/phy/micrel.c               |  9 ++++++---
 include/linux/micrel_phy.h             |  1 +
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6c0623f88654e..d9d843efd111f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2337,13 +2337,27 @@ static u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
-	if (dev->chip_id == KSZ8830_CHIP_ID) {
+	switch (dev->chip_id) {
+	case KSZ8830_CHIP_ID:
 		/* Silicon Errata Sheet (DS80000830A):
 		 * Port 1 does not work with LinkMD Cable-Testing.
 		 * Port 1 does not respond to received PAUSE control frames.
 		 */
 		if (!port)
 			return MICREL_KSZ8_P1_ERRATA;
+		break;
+	case KSZ9477_CHIP_ID:
+		/* KSZ9477 Errata DS80000754C
+		 *
+		 * Module 4: Energy Efficient Ethernet (EEE) feature select must
+		 * be manually disabled
+		 *   The EEE feature is enabled by default, but it is not fully
+		 *   operational. It must be manually disabled through register
+		 *   controls. If not disabled, the PHY ports can auto-negotiate
+		 *   to enable EEE, and this feature can cause link drops when
+		 *   linked to another device supporting EEE.
+		 */
+		return MICREL_NO_EEE;
 	}
 
 	return 0;
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index b6d7981b2d1ee..927d3d54658ef 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1800,9 +1800,6 @@ static const struct ksz9477_errata_write ksz9477_errata_writes[] = {
 	/* Transmit waveform amplitude can be improved (1000BASE-T, 100BASE-TX, 10BASE-Te) */
 	{0x1c, 0x04, 0x00d0},
 
-	/* Energy Efficient Ethernet (EEE) feature select must be manually disabled */
-	{0x07, 0x3c, 0x0000},
-
 	/* Register settings are required to meet data sheet supply current specifications */
 	{0x1c, 0x13, 0x6eff},
 	{0x1c, 0x14, 0xe6ff},
@@ -1847,6 +1844,12 @@ static int ksz9477_config_init(struct phy_device *phydev)
 			return err;
 	}
 
+	/* According to KSZ9477 Errata DS80000754C (Module 4) all EEE modes
+	 * in this switch shall be regarded as broken.
+	 */
+	if (phydev->dev_flags & MICREL_NO_EEE)
+		phydev->eee_broken_modes = -1;
+
 	err = genphy_restart_aneg(phydev);
 	if (err)
 		return err;
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 322d872559847..4e27ca7c49def 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -44,6 +44,7 @@
 #define MICREL_PHY_50MHZ_CLK	BIT(0)
 #define MICREL_PHY_FXEN		BIT(1)
 #define MICREL_KSZ8_P1_ERRATA	BIT(2)
+#define MICREL_NO_EEE		BIT(3)
 
 #define MICREL_KSZ9021_EXTREG_CTRL	0xB
 #define MICREL_KSZ9021_EXTREG_DATA_WRITE	0xC
-- 
2.40.1



