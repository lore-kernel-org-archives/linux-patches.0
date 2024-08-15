Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2919DF60;
	Thu, 15 Aug 2024 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729253; cv=none; b=kxyWMZQeJoJVAKFyRTWAXafkUh9d7FpyHVeat5164TDAqO6aJWbaPf2NyNz3PTGG6U6RRNrM+IcjyiCKn3RpX1Q7OE4UEPL/hL08U20MNvQmOSiCfycOswBtpBb47DKP4MOrnysVsXe6/Mf5vx1VUHSQ5xIa/ZZY3E3iaGAaiwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729253; c=relaxed/simple;
	bh=B0BpGjEYE5mm6/SdEP5BdC7HGS1pK69r5uSsP90a1lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u62YblA0wAwpwmF043gT7HDqPk/RhTkTOmEVF16QuPXPTz48dMD65lFeWh0v8QwGLbXpBdULX3HxtwxQUkexPz4x3hcUn0iG83Ar/vUMUXC0prx373MGracIVtnUPK6DbEsTXCa5aRZffq56jfU/tvqb2eL44d6KYu26+8lAcSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpcvmDDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpcvmDDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FF8C32786;
	Thu, 15 Aug 2024 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729253;
	bh=B0BpGjEYE5mm6/SdEP5BdC7HGS1pK69r5uSsP90a1lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpcvmDDAIJxEqVWF0md1F5tCvzteFDvDhJ3wdBFBtFr19bCxKDOGKNqxrPB9GAyM8
	 Uc8bIGcsbnO3wrMcVjhhB9pR7nJ0Q6/+ZmjiQUZlhINvUp3cPhH9Z/bzsaiK2qWXom
	 eJrzcHKawfZ0fkIUtj5Gi2uc0jo7LibwTzAEUWS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/484] ARM: spitz: fix GPIO assignment for backlight
Date: Thu, 15 Aug 2024 15:18:18 +0200
Message-ID: <20240815131942.828593803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 78ab3d352f2982bf3f7e506bfbaba7afee1ed8a9 ]

GPIOs controlling backlight on Spitz and Akita are coming from GPIO
expanders, not the pxa27xx-gpio block, correct it.

Additionally GPIO lookup tables operate with pin numbers rather than
legacy GPIO numbers, fix that as well. Use raw numbers instead of legacy
GPIO names to avoid confusion.

Fixes: ee0c8e494cc3 ("backlight: corgi: Convert to use GPIO descriptors")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20240628180852.1738922-2-dmitry.torokhov@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-pxa/spitz.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 8f880dbc05fdb..9bdc20706d187 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -516,10 +516,8 @@ static struct pxa2xx_spi_chip spitz_ads7846_chip = {
 static struct gpiod_lookup_table spitz_lcdcon_gpio_table = {
 	.dev_id = "spi2.1",
 	.table = {
-		GPIO_LOOKUP("gpio-pxa", SPITZ_GPIO_BACKLIGHT_CONT,
-			    "BL_CONT", GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP("gpio-pxa", SPITZ_GPIO_BACKLIGHT_ON,
-			    "BL_ON", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.1", 6, "BL_CONT", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("sharp-scoop.1", 7, "BL_ON", GPIO_ACTIVE_HIGH),
 		{ },
 	},
 };
@@ -527,10 +525,8 @@ static struct gpiod_lookup_table spitz_lcdcon_gpio_table = {
 static struct gpiod_lookup_table akita_lcdcon_gpio_table = {
 	.dev_id = "spi2.1",
 	.table = {
-		GPIO_LOOKUP("gpio-pxa", AKITA_GPIO_BACKLIGHT_CONT,
-			    "BL_CONT", GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP("gpio-pxa", AKITA_GPIO_BACKLIGHT_ON,
-			    "BL_ON", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("i2c-max7310", 3, "BL_ON", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("i2c-max7310", 4, "BL_CONT", GPIO_ACTIVE_LOW),
 		{ },
 	},
 };
@@ -957,12 +953,9 @@ static inline void spitz_i2c_init(void) {}
 static struct gpiod_lookup_table spitz_audio_gpio_table = {
 	.dev_id = "spitz-audio",
 	.table = {
-		GPIO_LOOKUP("sharp-scoop.0", SPITZ_GPIO_MUTE_L - SPITZ_SCP_GPIO_BASE,
-			    "mute-l", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("sharp-scoop.0", SPITZ_GPIO_MUTE_R - SPITZ_SCP_GPIO_BASE,
-			    "mute-r", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("sharp-scoop.1", SPITZ_GPIO_MIC_BIAS - SPITZ_SCP2_GPIO_BASE,
-			    "mic", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.0", 3, "mute-l", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.0", 4, "mute-r", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.1", 8, "mic", GPIO_ACTIVE_HIGH),
 		{ },
 	},
 };
@@ -970,12 +963,9 @@ static struct gpiod_lookup_table spitz_audio_gpio_table = {
 static struct gpiod_lookup_table akita_audio_gpio_table = {
 	.dev_id = "spitz-audio",
 	.table = {
-		GPIO_LOOKUP("sharp-scoop.0", SPITZ_GPIO_MUTE_L - SPITZ_SCP_GPIO_BASE,
-			    "mute-l", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("sharp-scoop.0", SPITZ_GPIO_MUTE_R - SPITZ_SCP_GPIO_BASE,
-			    "mute-r", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("i2c-max7310", AKITA_GPIO_MIC_BIAS - AKITA_IOEXP_GPIO_BASE,
-			    "mic", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.0", 3, "mute-l", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sharp-scoop.0", 4, "mute-r", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("i2c-max7310", 2, "mic", GPIO_ACTIVE_HIGH),
 		{ },
 	},
 };
-- 
2.43.0



