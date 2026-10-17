Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14161E555;
	Sat, 17 Oct 2026 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259412; cv=none; b=TTDEAijHFwzD8mDY+0uwiQggGc0o6WiHeLeEGUvJs1GK4vK0Yk0sUZZoVozY8IRl4ISLYaNf4L8W7w/j5ingPQ0hBbaqD6FJVo9rpSMjUNRWSfnFUU+a+sm2DzXENvqR8JyuVtirshjB3lTnEIP2NMsVnAc8S5PHGLxowUwqzQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259412; c=relaxed/simple;
	bh=1nixtrIv8kG77mLUgg5Ff7JflYSXGLVqvwrdKJJbY4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk5YHId4wRoYHkrjjJ/H+1jhmq0SFe84I7mkeHO9EZUuPJrI6CIIapXQUt5dYrs8Fel7M9usBQ2yk8hEbRyXubahVKygQj+agqUFIefXXFkjF/qx1TUhgYuTDz8WAOwD4f7s9f6Ql8YoJrPPmch1WEFdVSiUkayKXNq4dTEqIQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZtGV3M5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZtGV3M5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699B51F000C4;
	Sat, 17 Oct 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259411;
	bh=nYKpsw6yJ1VCKtp9Iy+zpDPoRqkyDzKZETstVhTXDKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZtGV3M58VOnUIDfYL+MOczjS1blf7AH38CgnhYdzicfd9KrN6yUa33T751rIVSNM
	 tclb+AmAR874/8pSkIHNluYNIOZDOba+Pu02Mm97yZjgCsVsn+3PEDCxm8qr5UvkGh
	 tlyKSogJw1dvPKQhU896L/mc3w+8RX7o4zU+VDGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1206/1674] gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock
Date: Sat, 17 Oct 2026 17:57:58 +0200
Message-ID: <20261017160502.096380798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd07cb24f2333..f2a3961664cd5 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -517,15 +517,23 @@ static int pca953x_read_regs(struct pca953x_chip *chip, int reg, unsigned long *
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
@@ -753,9 +761,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
 
-	if (chip->driver_data & PCA_PCAL) {
-		guard(mutex)(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
@@ -776,7 +784,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 
 	/* Look for any newly setup interrupt */
 	for_each_set_bit(level, irq_mask, gc->ngpio)
-		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
 	mutex_unlock(&chip->irq_lock);
 }
-- 
2.53.0



