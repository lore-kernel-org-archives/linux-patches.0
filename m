Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65021AB522;
	Thu,  6 Jun 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683257; cv=none; b=bywrJC2lZCh4+lE/iGESukXwGBjG9wJwxIEpHbqog7yLMawMj5bn/ecYItaoBQDiKX2zvM7OeDLznASQGYDhKYVtpMWlFkSVPkyOC5O1uWdR3zuAgy0j6uTXZuWSlIKyKB8/CeMZtP6oo7aBnLWnOBgzidkxerEWOsBhVwizpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683257; c=relaxed/simple;
	bh=C0arV5JFzFUhUqbip53m1R7lbuKMwgFDrWLLuxMZD9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx9BCyhPuG6DAhFirJrD3l3kEfLTpKBMPr2mRzVcMTd8976wy3dFVT+z8l+vxzSYGI5SYcJT7HX3eCda/10Zq6UQSW369jIvb5ng0FZLJhBrAEqZBrYXpuIabEy24uc2kg5LVNuJ1VdOCGziouEa9KGDINNLjiPhzdC/+6gKJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1lLesnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1lLesnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A468EC32781;
	Thu,  6 Jun 2024 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683257;
	bh=C0arV5JFzFUhUqbip53m1R7lbuKMwgFDrWLLuxMZD9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1lLesnnU5mPMm4NhzVUqyXxEqsbQKNnO42VRD5nq8ENkTFSo0gA1oO8aPVvjoly2
	 PlY+Lfn5aWO7E0AOyO5BYxBzzUht2h4Rkosz+JCbkkkh/g5yMUcdCV9Yiy3oa+w45v
	 SY1o1+1rcB7kBbu7mvZ/7qXBb294IueOC75VsRnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/744] net: dsa: mv88e6xxx: Avoid EEPROM timeout without EEPROM on 88E6250-family switches
Date: Thu,  6 Jun 2024 15:57:53 +0200
Message-ID: <20240606131738.865456892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit e44894e2aa4eb311ceda134de8b6f51ff979211b ]

88E6250-family switches have the quirk that the EEPROM Running flag can
get stuck at 1 when no EEPROM is connected, causing
mv88e6xxx_g2_eeprom_wait() to time out. We still want to wait for the
EEPROM however, to avoid interrupting a transfer and leaving the EEPROM
in an invalid state.

The condition to wait for recommended by the hardware spec is the EEInt
flag, however this flag is cleared on read, so before the hardware reset,
is may have been cleared already even though the EEPROM has been read
successfully.

For this reason, we revive the mv88e6xxx_g1_wait_eeprom_done() function
that was removed in commit 6ccf50d4d474
("net: dsa: mv88e6xxx: Avoid EEPROM timeout when EEPROM is absent") in a
slightly refactored form, and introduce a new
mv88e6xxx_g1_wait_eeprom_done_prereset() that additionally handles this
case by triggering another EEPROM reload that can be waited on.

On other switch models without this quirk, mv88e6xxx_g2_eeprom_wait() is
kept, as it avoids the additional reload.

Fixes: 6ccf50d4d474 ("net: dsa: mv88e6xxx: Avoid EEPROM timeout when EEPROM is absent")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  4 +-
 drivers/net/dsa/mv88e6xxx/global1.c | 89 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  2 +
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a2aec16abb8fc..9571e1b1e59ef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4900,8 +4900,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.watchdog_ops = &mv88e6250_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
-	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
-	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
+	.hardware_reset_pre = mv88e6250_g1_wait_eeprom_done_prereset,
+	.hardware_reset_post = mv88e6xxx_g1_wait_eeprom_done,
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 174c773b38c2b..7ef0f4426ad71 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -75,6 +75,95 @@ static int mv88e6xxx_g1_wait_init_ready(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
+static int mv88e6250_g1_eeprom_reload(struct mv88e6xxx_chip *chip)
+{
+	/* MV88E6185_G1_CTL1_RELOAD_EEPROM is also valid for 88E6250 */
+	int bit = __bf_shf(MV88E6185_G1_CTL1_RELOAD_EEPROM);
+	u16 val;
+	int err;
+
+	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
+	if (err)
+		return err;
+
+	val |= MV88E6185_G1_CTL1_RELOAD_EEPROM;
+
+	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_CTL1, val);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_CTL1, bit, 0);
+}
+
+/* Returns 0 when done, -EBUSY when waiting, other negative codes on error */
+static int mv88e6xxx_g1_is_eeprom_done(struct mv88e6xxx_chip *chip)
+{
+	u16 val;
+	int err;
+
+	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &val);
+	if (err < 0) {
+		dev_err(chip->dev, "Error reading status");
+		return err;
+	}
+
+	/* If the switch is still resetting, it may not
+	 * respond on the bus, and so MDIO read returns
+	 * 0xffff. Differentiate between that, and waiting for
+	 * the EEPROM to be done by bit 0 being set.
+	 */
+	if (val == 0xffff || !(val & BIT(MV88E6XXX_G1_STS_IRQ_EEPROM_DONE)))
+		return -EBUSY;
+
+	return 0;
+}
+
+/* As the EEInt (EEPROM done) flag clears on read if the status register, this
+ * function must be called directly after a hard reset or EEPROM ReLoad request,
+ * or the done condition may have been missed
+ */
+int mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip)
+{
+	const unsigned long timeout = jiffies + 1 * HZ;
+	int ret;
+
+	/* Wait up to 1 second for the switch to finish reading the
+	 * EEPROM.
+	 */
+	while (time_before(jiffies, timeout)) {
+		ret = mv88e6xxx_g1_is_eeprom_done(chip);
+		if (ret != -EBUSY)
+			return ret;
+	}
+
+	dev_err(chip->dev, "Timeout waiting for EEPROM done");
+	return -ETIMEDOUT;
+}
+
+int mv88e6250_g1_wait_eeprom_done_prereset(struct mv88e6xxx_chip *chip)
+{
+	int ret;
+
+	ret = mv88e6xxx_g1_is_eeprom_done(chip);
+	if (ret != -EBUSY)
+		return ret;
+
+	/* Pre-reset, we don't know the state of the switch - when
+	 * mv88e6xxx_g1_is_eeprom_done() returns -EBUSY, that may be because
+	 * the switch is actually busy reading the EEPROM, or because
+	 * MV88E6XXX_G1_STS_IRQ_EEPROM_DONE has been cleared by an unrelated
+	 * status register read already.
+	 *
+	 * To account for the latter case, trigger another EEPROM reload for
+	 * another chance at seeing the done flag.
+	 */
+	ret = mv88e6250_g1_eeprom_reload(chip);
+	if (ret)
+		return ret;
+
+	return mv88e6xxx_g1_wait_eeprom_done(chip);
+}
+
 /* Offset 0x01: Switch MAC Address Register Bytes 0 & 1
  * Offset 0x02: Switch MAC Address Register Bytes 2 & 3
  * Offset 0x03: Switch MAC Address Register Bytes 4 & 5
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 1095261f5b490..3dbb7a1b8fe11 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -282,6 +282,8 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
+int mv88e6250_g1_wait_eeprom_done_prereset(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
-- 
2.43.0



