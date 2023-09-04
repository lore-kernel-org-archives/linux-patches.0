Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46734C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C253CC433C7;
	Mon,  4 Sep 2023 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852561;
	bh=J/LzT0AylPcE2vdiiG+qjnZr4wYzssk+DE4QvZrkHMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCuwqOilhoJgad8tKNE26a16rSDLBHgJSjMohs9vFvbE3ed2Yl2+5a60dsoi4XGtx
	 xgmYJE/q82ccJC52Uap4YWb9UClrzfUpegt8CDfGal+W9VOm/Scm7zLLE+Gl2TvnHM
	 beKxaLkshwGtUyq4x5ezd3ot79yRsaos923UUmRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.15 04/28] ARM: pxa: remove use of symbol_get()
Date: Mon,  4 Sep 2023 19:30:35 +0100
Message-ID: <20230904182945.393334969@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
References: <20230904182945.178705038@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 0faa29c4207e6e29cfc81b427df60e326c37083a upstream.

The spitz board file uses the obscure symbol_get() function
to optionally call a function from sharpsl_pm.c if that is
built. However, the two files are always built together
these days, and have been for a long time, so this can
be changed to a normal function call.

Link: https://lore.kernel.org/lkml/20230731162639.GA9441@lst.de/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-pxa/sharpsl_pm.c |    2 --
 arch/arm/mach-pxa/spitz.c      |   14 +-------------
 2 files changed, 1 insertion(+), 15 deletions(-)

--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -220,8 +220,6 @@ void sharpsl_battery_kick(void)
 {
 	schedule_delayed_work(&sharpsl_bat, msecs_to_jiffies(125));
 }
-EXPORT_SYMBOL(sharpsl_battery_kick);
-
 
 static void sharpsl_battery_thread(struct work_struct *private_)
 {
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>	/* symbol_get ; symbol_put */
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/gpio_keys.h>
@@ -514,17 +513,6 @@ static struct pxa2xx_spi_chip spitz_ads7
 	.gpio_cs		= SPITZ_GPIO_ADS7846_CS,
 };
 
-static void spitz_bl_kick_battery(void)
-{
-	void (*kick_batt)(void);
-
-	kick_batt = symbol_get(sharpsl_battery_kick);
-	if (kick_batt) {
-		kick_batt();
-		symbol_put(sharpsl_battery_kick);
-	}
-}
-
 static struct gpiod_lookup_table spitz_lcdcon_gpio_table = {
 	.dev_id = "spi2.1",
 	.table = {
@@ -552,7 +540,7 @@ static struct corgi_lcd_platform_data sp
 	.max_intensity		= 0x2f,
 	.default_intensity	= 0x1f,
 	.limit_mask		= 0x0b,
-	.kick_battery		= spitz_bl_kick_battery,
+	.kick_battery		= sharpsl_battery_kick,
 };
 
 static struct pxa2xx_spi_chip spitz_lcdcon_chip = {


