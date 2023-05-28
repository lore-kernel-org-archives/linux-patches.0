Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C8611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC68C433D2;
	Sun, 28 May 2023 19:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302534;
	bh=UI9yPhKavncBXoLPIpOSLkQGcpHq5CK7RtFXPbu1h3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBsg1fW1TimBpgYTZDHmV+xKAsf6lH5EBlrvkKQpgMWUwTPJz8wuU0xTcuLtQDhvP
	 +Moq4biQ2d0u3qzK+lCUcpu3HSAT5wQ6ZoVDN2V+v7BKiZP4JymkMLUxk8fH/RhdIH
	 zC0pPBOyr9S1KI0+A9GiyEyR5l3KbrOPbHebEZVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Fabio Estevam <festevam@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 6.1 013/119] net: dsa: mv88e6xxx: Add RGMII delay to 88E6320
Date: Sun, 28 May 2023 20:10:13 +0100
Message-Id: <20230528190835.778869435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steffen Bätz <steffen@innosonix.de>

commit 91e87045a5ef6f7003e9a2cb7dfa435b9b002dbe upstream.

Currently, the .port_set_rgmii_delay hook is missing for the 88E6320
family, which causes failure to retrieve an IP address via DHCP.

Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
delay for ports 2, 5, and 6, which are the only ports that can be used
in RGMII mode.

Tested on a custom i.MX8MN board connected to an 88E6320 switch.

This change also applies safely to the 88E6321 variant.

The only difference between 88E6320 versus 88E6321 is the temperature
grade and pinout.

They share exactly the same MDIO register map for ports 2, 5, and 6,
which are the only ports that can be used in RGMII mode.

Signed-off-by: Steffen Bätz <steffen@innosonix.de>
[fabio: Improved commit log and extended it to mv88e6321_ops]
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221028163158.198108-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 drivers/net/dsa/mv88e6xxx/port.c |    9 +++++++++
 drivers/net/dsa/mv88e6xxx/port.h |    2 ++
 3 files changed, 13 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5044,6 +5044,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -5088,6 +5089,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -133,6 +133,15 @@ int mv88e6390_port_set_rgmii_delay(struc
 	return mv88e6xxx_port_set_rgmii_delay(chip, port, mode);
 }
 
+int mv88e6320_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
+				   phy_interface_t mode)
+{
+	if (port != 2 && port != 5 && port != 6)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_rgmii_delay(chip, port, mode);
+}
+
 int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link)
 {
 	u16 reg;
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -332,6 +332,8 @@ int mv88e6xxx_port_wait_bit(struct mv88e
 
 int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
 			     int pause);
+int mv88e6320_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
+				   phy_interface_t mode);
 int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 				   phy_interface_t mode);
 int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,


