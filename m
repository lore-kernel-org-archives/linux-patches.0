Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F181E4A2;
	Thu, 13 Jun 2024 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281965; cv=none; b=G4BjpacIIxa5rA612Mc7gqfhXUus+AVnw9GgQW4X2VLVFS8gbPFVKS7yRiCZ3c2dGtC/E08OO4SDUS80eQHko2mNRwGlNHVgAiGD2i8V/RIhKKO2Kq/LnQPxswBvhwtC0JOKLm1XyvAcBnWISnxDsht4529O9dXHa24no2ITFL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281965; c=relaxed/simple;
	bh=Eo2UzfjCAtCpVR9df9EII4PNEKUr1rUB0rCzi8Hc9iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB7oRj/cfr0wXJksff6LH5YylQ5m9YY0yN5bG2Iflz0zgmGkl3m9bmNpZ3x3/LrBk3Ik2IZ0HUMel7aYqXpYt1+HtyX2XPbWkNioi8gvE7dRbzm07AU0AHevuDUQcvW1LGXRTnYeW9P1pebEIVO8uPUb73OLwvyDZ28N24MqRRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jW+kqvr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jW+kqvr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBA9C2BBFC;
	Thu, 13 Jun 2024 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281965;
	bh=Eo2UzfjCAtCpVR9df9EII4PNEKUr1rUB0rCzi8Hc9iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jW+kqvr2+UKgsu/2s17Or4otTBqADtC9YZcKpQsi0YHWhJVtCo+XWCw1oWgnfnIla
	 bn2yg0UrfnYrje4aI2QUzF7n2otaFmR5mtdB9YiJjaerXflFFjHUvUwMlJ2LebsM6l
	 582+0bppKnrkzIe3t8W1fcnrFbzU0Mg2zHpD6k2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/402] net: dsa: mv88e6xxx: Add support for model-specific pre- and post-reset handlers
Date: Thu, 13 Jun 2024 13:30:43 +0200
Message-ID: <20240613113305.492902587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 0fdd27b9d6d7c60bd319d3497ad797934bab13cb ]

Instead of calling mv88e6xxx_g2_eeprom_wait() directly from
mv88e6xxx_hardware_reset(), add configurable pre- and post-reset hard
reset handlers. Initially, the handlers are set to
mv88e6xxx_g2_eeprom_wait() for all families that have get/set_eeprom()
to match the existing behavior. No functional change intended (except
for additional error messages on failure).

Fixes: 6ccf50d4d474 ("net: dsa: mv88e6xxx: Avoid EEPROM timeout when EEPROM is absent")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 50 +++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3fc120802883a..7484ba387d771 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2585,6 +2585,7 @@ static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 {
 	struct gpio_desc *gpiod = chip->reset;
+	int err;
 
 	/* If there is a GPIO connected to the reset pin, toggle it */
 	if (gpiod) {
@@ -2593,17 +2594,26 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		 * mid-byte, causing the first EEPROM read after the reset
 		 * from the wrong location resulting in the switch booting
 		 * to wrong mode and inoperable.
+		 * For this reason, switch families with EEPROM support
+		 * generally wait for EEPROM loads to complete as their pre-
+		 * and post-reset handlers.
 		 */
-		if (chip->info->ops->get_eeprom)
-			mv88e6xxx_g2_eeprom_wait(chip);
+		if (chip->info->ops->hardware_reset_pre) {
+			err = chip->info->ops->hardware_reset_pre(chip);
+			if (err)
+				dev_err(chip->dev, "pre-reset error: %d\n", err);
+		}
 
 		gpiod_set_value_cansleep(gpiod, 1);
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
 
-		if (chip->info->ops->get_eeprom)
-			mv88e6xxx_g2_eeprom_wait(chip);
+		if (chip->info->ops->hardware_reset_post) {
+			err = chip->info->ops->hardware_reset_post(chip);
+			if (err)
+				dev_err(chip->dev, "post-reset error: %d\n", err);
+		}
 	}
 }
 
@@ -3824,6 +3834,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4006,6 +4018,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4103,6 +4117,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4201,6 +4217,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4262,6 +4280,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4321,6 +4341,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4383,6 +4405,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4438,6 +4462,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.watchdog_ops = &mv88e6250_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -4482,6 +4508,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4543,6 +4571,8 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -4586,6 +4616,8 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -4634,6 +4666,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4784,6 +4818,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4848,6 +4884,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4913,6 +4951,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4981,6 +5021,8 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.watchdog_ops = &mv88e6393x_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 6b7307edaf172..6b86e7645be60 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -434,6 +434,12 @@ struct mv88e6xxx_ops {
 	int (*ppu_enable)(struct mv88e6xxx_chip *chip);
 	int (*ppu_disable)(struct mv88e6xxx_chip *chip);
 
+	/* Additional handlers to run before and after hard reset, to make sure
+	 * that the switch and EEPROM are in a good state.
+	 */
+	int (*hardware_reset_pre)(struct mv88e6xxx_chip *chip);
+	int (*hardware_reset_post)(struct mv88e6xxx_chip *chip);
+
 	/* Switch Software Reset */
 	int (*reset)(struct mv88e6xxx_chip *chip);
 
-- 
2.43.0



