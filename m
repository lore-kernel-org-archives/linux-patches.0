Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215709;
	b=d67ZpYiEcK84910ATESrG6HTFUISO2/aBCkXTh3qucmYJgMm4x4ze2WAoPEW5ZVJgBVx
	 qkDPyjxEmo1rfwpU96ik+zhrPuiJC6wmyiiGnwyH8iCgrmd2ihB4f7RjLXbZEDM2ebZ7d
	 1vkS5xzl4+wp6A14SSTc282HF3n+sEvBkBFoig49ECadaMPP9r9V/M2ViOAtsPUm6hjuJ
	 09vyp4dlJuwrLUORRaqv5z+2SQ5tlWudKxCtOM17m/BzZJePB+6YkSkbyQIp2GeVIVK8J
	 wGT0moaNnkkCR0UbH0ZBSA2CiTOx1LKKbH3COnuB57pO4U0XtNdOJIumBaETh3PQHkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yvmX99FSZYgt6IPwrKvU3oLLPME89hts3GrnF+xEatA=;
	b=P8o1aq6yvl978iquPYBSQj4BI94NhalhpRbHKW8ths8P5dsYIeZ9Q3NRRYid7Qgxc5Vf
	 //2tRvtHXvb4nz0hWGEtobeKN9vxtxXA0/YKoA2JY3fP9yhpDXEDgktvL/IPpkC9XDMWQ
	 bnmxblkKVAYog8tJgRDj9NCP8+cIeRPBCHWMY314MfBKITzDhhRF9pnRgVbiHR50IMndk
	 Gb6lMzKarqfZRoSXYXyjO/Gow/jYIyeTgkXQLIjAgXUOEN9BuVy46QeDDFWNXFhpteRjA
	 4YfAcmn8oiN/jXB1qH8Ct9PWKPm60LygCq+gBBO3XtOsH2dhCKNJARS0p0EOy4US3Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cME+qa3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C0606A31E;
	Wed, 28 Oct 2026 19:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cME+qa3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D9F1F01825;
	Wed, 28 Oct 2026 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215708;
	bh=yvmX99FSZYgt6IPwrKvU3oLLPME89hts3GrnF+xEatA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cME+qa3YiB4QgDCXGH/71MuWQPK6KEPbPdl/433WGUJwJ6ziWH7P3B+g+Qh0hxbym
	 fBA1UWAzrkYvgPJzd7bKOVyAOuStp0wYp0j1XtkghxQl98PpGqhwPxofOC0LPj6nK/
	 HNNrrwrszfW1snIiRbt3dznIDPUUXRHoSyjAQnYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1304/1887] gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock
Date: Wed, 28 Oct 2026 17:56:40 +0100
Message-ID: <20261028170529.102743868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b683553adf5e..2af6027a260f7 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -519,15 +519,23 @@ static int pca953x_read_regs(struct pca953x_chip *chip, int reg, unsigned long *
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
@@ -756,9 +764,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
 
-	if (chip->driver_data & PCA_PCAL) {
-		guard(mutex)(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
+	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
@@ -777,7 +785,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 
 	/* Look for any newly setup interrupt */
 	for_each_set_bit(level, irq_mask, gc->ngpio)
-		pca953x_gpio_direction_input(&chip->gpio_chip, level);
+		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
 	mutex_unlock(&chip->irq_lock);
 }
-- 
2.53.0



