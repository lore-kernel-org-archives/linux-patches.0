Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C86F37DEBE;
	Sat, 17 Oct 2026 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254780; cv=none; b=Fj9bAyfunKUx+ED0DO2SYzWA+gFyn5ebeR1xYdabQqrvF3+4h5NgNp97Zm3ONdB0fdAsokZz/jntOYxJifdd9YN/zqaoSnxjLRhJ496x1ZesMMaMGqRZ/W1Ln9k+jNkKmgd1Nwcm+xU/Anpres7uCpfcr2ZxBYxyBBQ8KEdYdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254780; c=relaxed/simple;
	bh=2fEMU31w5FAO4D60TciAVPhJXCMurEOORGvwkOaztnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPLhOkVpaOJFeQTGX8a7W/iSTQi+zHmX68qajtPf/8tgwhESHINxXReEWo+nNZ497cZ3x6n9U2jVUGgdbmJmexDUGww4MjHZHzeojNsJnFhl4KnNdW/gZGM9qc/WiRLkMqhOp6+73jMBD96Ys1+vsn7Yg0AxQKY/uiPBwMp+H7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iy4Jamoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iy4Jamoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF31F000C4;
	Sat, 17 Oct 2026 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254779;
	bh=uN7mBP1rvaIbkYzZlwEj3rDAMuNJ3AwxeGTLHkOpNUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iy4JamohVrDo5/S2qn6qEkwscHFRDFFCRSBeCPjHNDPkFcp0rJ26+NH7FDoHF9Io5
	 S/Y/VV1PSpEHEEyzBDt5iaJac6cWLdk4VSxODJSVHjgJikNK9epOAwxsnZD6+w2+ne
	 +MEKNur4SSNSBsJrP/TI22SG7gwMmBORb0vOejig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/869] gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock
Date: Sat, 17 Oct 2026 17:55:58 +0200
Message-ID: <20261017160050.356413021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 9dc325327babe7f159e84cbe9380a45342da0585 ]

Locking is disabled in the regmap config as this driver uses its own
lock. This means that all calls to regmap functions (read or write) must
hold the i2c_lock. The function pca953x_irq_bus_sync_unlock() did not do
this, and it was therefore possible that multiple threads could cause an
incorrect register to be read/written.

A previous patch partly fixed this, but only protected the write to the
interrupt mask register, and not the read from the direction register.

Fixes: bfc6444b57dc ("gpio: pca953x: fix pca953x_irq_bus_sync_unlock race")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://patch.msgid.link/20260709045116.2304246-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ad9280472bdd5..1c7ae71dfe555 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -525,15 +525,23 @@ static int pca953x_read_regs(struct pca953x_chip *chip, int reg, unsigned long *
 	return 0;
 }
 
-static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+static int pca953x_gpio_direction_input_unlocked(struct gpio_chip *gc,
+						 unsigned int off)
 {
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
 	u8 dirreg = chip->recalc_addr(chip, chip->regs->direction, off);
 	u8 bit = BIT(off % BANK_SZ);
 
+	return regmap_write_bits(chip->regmap, dirreg, bit, bit);
+}
+
+static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned int off)
+{
+	struct pca953x_chip *chip = gpiochip_get_data(gc);
+
 	guard(mutex)(&chip->i2c_lock);
 
-	return regmap_write_bits(chip->regmap, dirreg, bit, bit);
+	return pca953x_gpio_direction_input_unlocked(gc, off);
 }
 
 static int pca953x_gpio_direction_output(struct gpio_chip *gc,
@@ -759,9 +767,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
 
-	if (chip->driver_data & PCA_PCAL) {
-		guard(mutex)(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
@@ -782,7 +790,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 
 	/* Look for any newly setup interrupt */
 	for_each_set_bit(level, irq_mask, gc->ngpio)
-		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
 	mutex_unlock(&chip->irq_lock);
 }
-- 
2.53.0



