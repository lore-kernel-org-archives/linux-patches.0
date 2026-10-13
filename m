Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E83390CB7;
	Tue, 13 Oct 2026 12:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893876; cv=none; b=ok9x4VclSw12AYiHFtqyTq1vor9BG2yBZCUHMAb0055sgzj2/72HWn6oB73cRMLQyneYO/w82OjHmJFYW4I2Z/pkuVm2nxN+L0mvmXjdAz1nKt+Nyes/dVgHRqPQ8lDKPgbh+zzaghsge6O5z0G8FBnDHEAm4ujYeKlW1Vx5ji0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893876; c=relaxed/simple;
	bh=xWBCs3EKEu/sJoMLhEhuJc7KQdrofFc3GMA5wcet5xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+QJISLyErC2EjHdvfOpKQX6OTdu/RHvJX1vtiEa/NnNFYlOE4teBuYSeLLAnTpM5RA/4jazvYsMzN1pmNdsH3hofFg2ke+kAtxRHgLQTF8fXblztB+epT4aVcy5FRXnTd3619pmlUhefldUeG5+hmchohzZ74ddwJJ3Lkf1eHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmlinG+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmlinG+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298271F000FF;
	Tue, 13 Oct 2026 12:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893875;
	bh=65JBofYumWjsQqsh3kc8UtZjvdULhgp3A5xyWVoCd6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmlinG+jy1q2vZBYV9X9q9WU11SoQb5JYmMp6IilLEmK6j5QxHTGMthB65ekv4jld
	 nbYVGzaSTeUwI0n8oGsGPqQCwlor/KTg1ol8Cik8yWT7mR0dR9WRG6DPBGLq+M8KwL
	 tXQoEkj01Ku9VmDCKEIBMmOs0071Cmg9QwiJ+lFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 345/621] gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock
Date: Tue, 13 Oct 2026 13:35:40 +0200
Message-ID: <20261013112929.038270230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpio/gpio-pca953x.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index b18a2d0f6984e..4eeac12ad0ed3 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -605,20 +605,28 @@ static int pca953x_read_regs(struct pca953x_chip *chip, int reg, unsigned long *
 	return 0;
 }
 
-static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+static int pca953x_gpio_direction_input_unlocked(struct gpio_chip *gc,
+						 unsigned int off)
 {
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
 	u8 dirreg = chip->recalc_addr(chip, chip->regs->direction, off);
 	u8 bit = pca953x_get_bit_mask(chip, off);
 
-	guard(mutex)(&chip->i2c_lock);
-
 	if (PCA_CHIP_TYPE(chip->driver_data) == TCA6418_TYPE)
 		return regmap_update_bits(chip->regmap, dirreg, bit, 0);
 
 	return regmap_update_bits(chip->regmap, dirreg, bit, bit);
 }
 
+static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned int off)
+{
+	struct pca953x_chip *chip = gpiochip_get_data(gc);
+
+	guard(mutex)(&chip->i2c_lock);
+
+	return pca953x_gpio_direction_input_unlocked(gc, off);
+}
+
 static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		unsigned off, int val)
 {
@@ -856,9 +864,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
 
-	if (chip->driver_data & PCA_PCAL) {
-		guard(mutex)(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
@@ -879,7 +887,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 
 	/* Look for any newly setup interrupt */
 	for_each_set_bit(level, irq_mask, gc->ngpio)
-		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
 	mutex_unlock(&chip->irq_lock);
 }
-- 
2.53.0



