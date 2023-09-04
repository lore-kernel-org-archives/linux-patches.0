Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD5C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8D2C433C7;
	Mon,  4 Sep 2023 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852525;
	bh=n6GZekqj4TjGY7gkBV6eFTVsdDBjwdfO3+ONmxwN0nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0txHPgnjokDxDynB5LHyRPuTfgevTvc9NnU8VwuImL2SonuMRX/TEDU3YdpPr1Bpn
	 fczXnKX1NB5XIxi63XlnP5VxDr7JrprNXXrfY2BajozaT/ay5nVSN79rNf/rvlWzBA
	 htNrezrncZoAbV/nN40kHPjFktqP7YaRGa6T2Kks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 06/31] ARM: pxa: remove use of symbol_get()
Date: Mon,  4 Sep 2023 19:30:14 +0100
Message-ID: <20230904182947.300211380@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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
@@ -510,17 +509,6 @@ static struct ads7846_platform_data spit
 	.wait_for_sync		= spitz_ads7846_wait_for_hsync,
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
@@ -548,7 +536,7 @@ static struct corgi_lcd_platform_data sp
 	.max_intensity		= 0x2f,
 	.default_intensity	= 0x1f,
 	.limit_mask		= 0x0b,
-	.kick_battery		= spitz_bl_kick_battery,
+	.kick_battery		= sharpsl_battery_kick,
 };
 
 static struct spi_board_info spitz_spi_devices[] = {


