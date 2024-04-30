Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DA412C46B;
	Tue, 30 Apr 2024 10:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474245; cv=none; b=uqA9fxctmjJr0YBRDSeNXNlKmu9dxzsoUcwdhWKuv6DUUo/pWfypdUJWO8oKAycfSQEDYbuPUHyqnvmtyb1tMvKY/kvjMONdsIfdoJhfCOoTttes2Usaxc+079fs/Cqmc/mPZIBvByuvXaQE5Ho8skv6B5G1lSiD3yYSHhPlmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474245; c=relaxed/simple;
	bh=d1NWWD1x150+6QwCLG176rMtWXCqVAOvwnLByxIy0Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg9NylakBNiHqiKab7KQrGdrpcmCcgR5FPbiIbCKM2BFbbVAVI+IUGLvRuV+aHVoRNtvfvOcGN1HoSf3HkdoIoSBewME4LpvF5nxxtc2HivtH7Rl0SBiTK4T8J0deEu3RPtjlKtV5rO9UJhhSXrQCu8xAs2iD7zlp4mqDd69HQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uqc2p/GG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uqc2p/GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95E5C4AF1A;
	Tue, 30 Apr 2024 10:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474245;
	bh=d1NWWD1x150+6QwCLG176rMtWXCqVAOvwnLByxIy0Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uqc2p/GGiqioXG/J4piaFc6K/qhhZ/GVAESsxqq48sc8KAaqFf1bzRuWs00eAnN5l
	 wnkqID2BdZ55jfCYv/5AEGegXo5HE/DQglew2rVdlO8oD5rAeB5qBXcnzSzYqjCrps
	 cHveDUYaufJikeo2DnoI4QFyTNDbx0qwLGajSWYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 061/228] net: dsa: mv88e6xx: fix supported_interfaces setup in mv88e6250_phylink_get_caps()
Date: Tue, 30 Apr 2024 12:37:19 +0200
Message-ID: <20240430103105.569767426@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit a4e3899065ffa87d49dc20e8c17501edbc189692 ]

With the recent PHYLINK changes requiring supported_interfaces to be set,
MV88E6250 family switches like the 88E6020 fail to probe - cmode is
never initialized on these devices, so mv88e6250_phylink_get_caps() does
not set any supported_interfaces flags.

Instead of a cmode, on 88E6250 we have a read-only port mode value that
encodes similar information. There is no reason to bother mapping port
mode to the cmodes of other switch models; instead we introduce a
mv88e6250_setup_supported_interfaces() that is called directly from
mv88e6250_phylink_get_caps().

Fixes: de5c9bf40c45 ("net: phylink: require supported_interfaces to be filled")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240417103737.166651-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 56 +++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/port.h | 23 ++++++++++---
 2 files changed, 71 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7de8a9c9e4576..32416d8802ca4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -566,13 +566,61 @@ static void mv88e6xxx_translate_cmode(u8 cmode, unsigned long *supported)
 		phy_interface_set_rgmii(supported);
 }
 
-static void mv88e6250_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
-				       struct phylink_config *config)
+static void
+mv88e6250_setup_supported_interfaces(struct mv88e6xxx_chip *chip, int port,
+				     struct phylink_config *config)
 {
 	unsigned long *supported = config->supported_interfaces;
+	int err;
+	u16 reg;
 
-	/* Translate the default cmode */
-	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
+	if (err) {
+		dev_err(chip->dev, "p%d: failed to read port status\n", port);
+		return;
+	}
+
+	switch (reg & MV88E6250_PORT_STS_PORTMODE_MASK) {
+	case MV88E6250_PORT_STS_PORTMODE_MII_10_HALF_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_100_HALF_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_10_FULL_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_100_FULL_PHY:
+		__set_bit(PHY_INTERFACE_MODE_REVMII, supported);
+		break;
+
+	case MV88E6250_PORT_STS_PORTMODE_MII_HALF:
+	case MV88E6250_PORT_STS_PORTMODE_MII_FULL:
+		__set_bit(PHY_INTERFACE_MODE_MII, supported);
+		break;
+
+	case MV88E6250_PORT_STS_PORTMODE_MII_DUAL_100_RMII_FULL_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_200_RMII_FULL_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_HALF_PHY:
+	case MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_FULL_PHY:
+		__set_bit(PHY_INTERFACE_MODE_REVRMII, supported);
+		break;
+
+	case MV88E6250_PORT_STS_PORTMODE_MII_DUAL_100_RMII_FULL:
+	case MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_FULL:
+		__set_bit(PHY_INTERFACE_MODE_RMII, supported);
+		break;
+
+	case MV88E6250_PORT_STS_PORTMODE_MII_100_RGMII:
+		__set_bit(PHY_INTERFACE_MODE_RGMII, supported);
+		break;
+
+	default:
+		dev_err(chip->dev,
+			"p%d: invalid port mode in status register: %04x\n",
+			port, reg);
+	}
+}
+
+static void mv88e6250_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	if (!mv88e6xxx_phy_is_internal(chip, port))
+		mv88e6250_setup_supported_interfaces(chip, port, config);
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 86deeb347cbc1..ddadeb9bfdaee 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -25,10 +25,25 @@
 #define MV88E6250_PORT_STS_PORTMODE_PHY_100_HALF	0x0900
 #define MV88E6250_PORT_STS_PORTMODE_PHY_10_FULL		0x0a00
 #define MV88E6250_PORT_STS_PORTMODE_PHY_100_FULL	0x0b00
-#define MV88E6250_PORT_STS_PORTMODE_MII_10_HALF		0x0c00
-#define MV88E6250_PORT_STS_PORTMODE_MII_100_HALF	0x0d00
-#define MV88E6250_PORT_STS_PORTMODE_MII_10_FULL		0x0e00
-#define MV88E6250_PORT_STS_PORTMODE_MII_100_FULL	0x0f00
+/* - Modes with PHY suffix use output instead of input clock
+ * - Modes without RMII or RGMII use MII
+ * - Modes without speed do not have a fixed speed specified in the manual
+ *   ("DC to x MHz" - variable clock support?)
+ */
+#define MV88E6250_PORT_STS_PORTMODE_MII_DISABLED		0x0000
+#define MV88E6250_PORT_STS_PORTMODE_MII_100_RGMII		0x0100
+#define MV88E6250_PORT_STS_PORTMODE_MII_DUAL_100_RMII_FULL_PHY	0x0200
+#define MV88E6250_PORT_STS_PORTMODE_MII_200_RMII_FULL_PHY	0x0400
+#define MV88E6250_PORT_STS_PORTMODE_MII_DUAL_100_RMII_FULL	0x0600
+#define MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_FULL	0x0700
+#define MV88E6250_PORT_STS_PORTMODE_MII_HALF			0x0800
+#define MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_HALF_PHY	0x0900
+#define MV88E6250_PORT_STS_PORTMODE_MII_FULL			0x0a00
+#define MV88E6250_PORT_STS_PORTMODE_MII_10_100_RMII_FULL_PHY	0x0b00
+#define MV88E6250_PORT_STS_PORTMODE_MII_10_HALF_PHY		0x0c00
+#define MV88E6250_PORT_STS_PORTMODE_MII_100_HALF_PHY		0x0d00
+#define MV88E6250_PORT_STS_PORTMODE_MII_10_FULL_PHY		0x0e00
+#define MV88E6250_PORT_STS_PORTMODE_MII_100_FULL_PHY		0x0f00
 #define MV88E6XXX_PORT_STS_LINK			0x0800
 #define MV88E6XXX_PORT_STS_DUPLEX		0x0400
 #define MV88E6XXX_PORT_STS_SPEED_MASK		0x0300
-- 
2.43.0



