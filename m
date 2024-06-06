Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B1199EB9;
	Thu,  6 Jun 2024 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683259; cv=none; b=h4M5rRFFoSnYqAmPj1MkP7fkv5tJI2Hjoyh/wTLpLnS0kopB1XWmDsdMYzY+SdJ5gtNYMw3Uh/gf4YpPwYEeUKUHMea/ARTjL+4boO/beAZig0DfnjMaTykdrO2b8o1s0y5hGHAuWDjuA/z2GKBhY3DVTMxrzrHXfpfXgMsBc3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683259; c=relaxed/simple;
	bh=f8UMic8xeSGLQY8acJ5SlRQ4IZgNSROrITKZlLPysiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfzQUugRwh0CS9B836Jy2H2ie5ClgNCWew5el4QfXtifgGEtuyy4Tp44CM2EIN8ccYPvUPcugPAxB7I17+SxlbS221fuOg8lTiiVdyC0twq5xRuDdEWnzH70R6y//0sbsQjJW8cGTbYjPR6DYpg/H4H42TdYEvCLUkE3g0PwGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIZXU0bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIZXU0bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327A5C32786;
	Thu,  6 Jun 2024 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683259;
	bh=f8UMic8xeSGLQY8acJ5SlRQ4IZgNSROrITKZlLPysiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIZXU0bm6i/S18UXZg2NAQ+zmVlxQ7i6j29gXaSGnr0RWRLDjCzsk0/+NFQhaP4BH
	 PbFmle7jVYbNvM/nMLPru2Y3+pq+gufAivulj4k7/5ab+co0EfJzScfielZnqbrLs+
	 BBHCgvXRVB0SEm+I+ms3Ak0/YyQaE0nBWD9xWYlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/473] net: dsa: mv88e6xxx: Add support for model-specific pre- and post-reset handlers
Date: Thu,  6 Jun 2024 16:01:04 +0200
Message-ID: <20240606131704.393434987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 517c50d11fbce..b59cdc850a07a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3003,6 +3003,7 @@ static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 {
 	struct gpio_desc *gpiod = chip->reset;
+	int err;
 
 	/* If there is a GPIO connected to the reset pin, toggle it */
 	if (gpiod) {
@@ -3011,17 +3012,26 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
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
 
@@ -4339,6 +4349,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4529,6 +4541,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4630,6 +4644,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4731,6 +4747,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4794,6 +4812,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4855,6 +4875,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4919,6 +4941,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -4977,6 +5001,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.watchdog_ops = &mv88e6250_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -5021,6 +5047,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -5085,6 +5113,8 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -5129,6 +5159,8 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
@@ -5177,6 +5209,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -5333,6 +5367,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -5400,6 +5436,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -5467,6 +5505,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
@@ -5537,6 +5577,8 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.watchdog_ops = &mv88e6393x_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 97a47d8743fd3..b34e96e689d5c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -458,6 +458,12 @@ struct mv88e6xxx_ops {
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



