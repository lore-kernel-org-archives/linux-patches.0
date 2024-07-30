Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273681D3624;
	Tue, 30 Jul 2024 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355258; cv=none; b=pGF6DeiPv4bskW428ulM0CAn4jNYk/ad2JIZrDBk6xTL/8LkqNZCgz3niDM2lVcPb19y2KyueW2qY1eZ+w3SSdwnlTdiUNVv0a1Ux/vscvRE3O/X1/x1ajGs7qZXdbLIkQitGBHGgjnSPwisf/PglMnSSG+DVzGlU/5EFts8NBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355258; c=relaxed/simple;
	bh=y1M6lyF0Ih7dKUKHgLhEl1eFczDPKdA0CDsWDr1cKCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHpEGF9hWLF7dgK0fOHjWYeVE5Bri/jlVGaMfsRzJ1aMpLMzbJKjYOBKfQYdFgfXXVd29ZUKZLu6zOJDbGRB/c/MDtswLgU6VL4WGjlXP5C7klzeGVzEt1jhRrL1T5dMDlCcmE3np3s3mAOPiQilv8OQkiYElkZAzP/kao3dDeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkrMR6wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkrMR6wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D68C4AF0A;
	Tue, 30 Jul 2024 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355258;
	bh=y1M6lyF0Ih7dKUKHgLhEl1eFczDPKdA0CDsWDr1cKCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkrMR6wWSHOpAGVusXTKcImzyskIN8uFuV1jmSsD8tPGABjIsr2WKyaN31iLF3iWu
	 k5NyUrlQ7A3NAoiL9J7r6NzYSWI8DQ5mv8Sz2eyoFWZ8aQrHX3yKKkj/O/H0exwq+5
	 Moi+uGuUyUOsWKdHvC5HlR/JtrrFfoJrrD2vgb2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/440] ARM: spitz: fix GPIO assignment for backlight
Date: Tue, 30 Jul 2024 17:45:10 +0200
Message-ID: <20240730151618.768701576@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 937f56bbaf6c6..effd28294da07 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -512,10 +512,8 @@ static struct ads7846_platform_data spitz_ads7846_info = {
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
@@ -523,10 +521,8 @@ static struct gpiod_lookup_table spitz_lcdcon_gpio_table = {
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
@@ -953,12 +949,9 @@ static inline void spitz_i2c_init(void) {}
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
@@ -966,12 +959,9 @@ static struct gpiod_lookup_table spitz_audio_gpio_table = {
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



