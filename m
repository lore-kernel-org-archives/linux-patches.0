Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519571A582
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAmhuIIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3207C43395;
	Mon,  9 Oct 2023 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857128;
	bh=txtR/kMmahZ5ivR8kayqVoj7DkKvJXa5W1JdIRo51Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAmhuIIpTIKQ9oUWvJfvib/oVnfL/7A4yFmeN6ewqVK3Qq/ickHSe/oatMk5K1qna
	 TvnzgzEN9I2QJawn5RL3nZi5s9dPiGhWeq0EKLQ4anZfoG1VIm6+rDJAAMhOm0/PFr
	 N5XX++tmlk6V4cWdJ4Zo1gAoeeMJzvPEOx1n/UNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Fabio Estevam <festevam@denx.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 106/163] net: dsa: mv88e6xxx: Avoid EEPROM timeout when EEPROM is absent
Date: Mon,  9 Oct 2023 15:01:10 +0200
Message-ID: <20231009130126.954431989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 6ccf50d4d4741e064ba35511a95402c63bbe21a8 ]

Since commit 23d775f12dcd ("net: dsa: mv88e6xxx: Wait for EEPROM done
before HW reset") the following error is seen on a imx8mn board with
a 88E6320 switch:

mv88e6085 30be0000.ethernet-1:00: Timeout waiting for EEPROM done

This board does not have an EEPROM attached to the switch though.

This problem is well explained by Andrew Lunn:

"If there is an EEPROM, and the EEPROM contains a lot of data, it could
be that when we perform a hardware reset towards the end of probe, it
interrupts an I2C bus transaction, leaving the I2C bus in a bad state,
and future reads of the EEPROM do not work.

The work around for this was to poll the EEInt status and wait for it
to go true before performing the hardware reset.

However, we have discovered that for some boards which do not have an
EEPROM, EEInt never indicates complete. As a result,
mv88e6xxx_g1_wait_eeprom_done() spins for a second and then prints a
warning.

We probably need a different solution than calling
mv88e6xxx_g1_wait_eeprom_done(). The datasheet for 6352 documents the
EEPROM Command register:

bit 15 is:

  EEPROM Unit Busy. This bit must be set to a one to start an EEPROM
  operation (see EEOp below). Only one EEPROM operation can be
  executing at one time so this bit must be zero before setting it to
  a one.  When the requested EEPROM operation completes this bit will
  automatically be cleared to a zero. The transition of this bit from
  a one to a zero can be used to generate an interrupt (the EEInt in
  Global 1, offset 0x00).

and more interesting is bit 11:

  Register Loader Running. This bit is set to one whenever the
  register loader is busy executing instructions contained in the
  EEPROM."

Change to using mv88e6xxx_g2_eeprom_wait() to fix the timeout error
when the EEPROM chip is not present.

Fixes: 23d775f12dcd ("net: dsa: mv88e6xxx: Wait for EEPROM done before HW reset")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  6 ++++--
 drivers/net/dsa/mv88e6xxx/global1.c | 31 -----------------------------
 drivers/net/dsa/mv88e6xxx/global1.h |  1 -
 drivers/net/dsa/mv88e6xxx/global2.c |  2 +-
 drivers/net/dsa/mv88e6xxx/global2.h |  1 +
 5 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7af2f08a62f14..0d4b236d1e344 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3040,14 +3040,16 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		 * from the wrong location resulting in the switch booting
 		 * to wrong mode and inoperable.
 		 */
-		mv88e6xxx_g1_wait_eeprom_done(chip);
+		if (chip->info->ops->get_eeprom)
+			mv88e6xxx_g2_eeprom_wait(chip);
 
 		gpiod_set_value_cansleep(gpiod, 1);
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
 
-		mv88e6xxx_g1_wait_eeprom_done(chip);
+		if (chip->info->ops->get_eeprom)
+			mv88e6xxx_g2_eeprom_wait(chip);
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 2fa55a6435910..174c773b38c2b 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -75,37 +75,6 @@ static int mv88e6xxx_g1_wait_init_ready(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
-void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip)
-{
-	const unsigned long timeout = jiffies + 1 * HZ;
-	u16 val;
-	int err;
-
-	/* Wait up to 1 second for the switch to finish reading the
-	 * EEPROM.
-	 */
-	while (time_before(jiffies, timeout)) {
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &val);
-		if (err) {
-			dev_err(chip->dev, "Error reading status");
-			return;
-		}
-
-		/* If the switch is still resetting, it may not
-		 * respond on the bus, and so MDIO read returns
-		 * 0xffff. Differentiate between that, and waiting for
-		 * the EEPROM to be done by bit 0 being set.
-		 */
-		if (val != 0xffff &&
-		    val & BIT(MV88E6XXX_G1_STS_IRQ_EEPROM_DONE))
-			return;
-
-		usleep_range(1000, 2000);
-	}
-
-	dev_err(chip->dev, "Timeout waiting for EEPROM done");
-}
-
 /* Offset 0x01: Switch MAC Address Register Bytes 0 & 1
  * Offset 0x02: Switch MAC Address Register Bytes 2 & 3
  * Offset 0x03: Switch MAC Address Register Bytes 4 & 5
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index c99ddd117fe6e..1095261f5b490 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -282,7 +282,6 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
-void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 937a01f2ba75e..b2b5f6ba438f4 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -340,7 +340,7 @@ int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip)
  * Offset 0x15: EEPROM Addr (for 8-bit data access)
  */
 
-static int mv88e6xxx_g2_eeprom_wait(struct mv88e6xxx_chip *chip)
+int mv88e6xxx_g2_eeprom_wait(struct mv88e6xxx_chip *chip)
 {
 	int bit = __bf_shf(MV88E6XXX_G2_EEPROM_CMD_BUSY);
 	int err;
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 7e091965582b7..d9434f7cae538 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -365,6 +365,7 @@ int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 				      int port);
+int mv88e6xxx_g2_eeprom_wait(struct mv88e6xxx_chip *chip);
 
 extern const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops;
-- 
2.40.1



