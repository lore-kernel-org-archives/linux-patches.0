Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A3C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006D1C433C7;
	Mon,  4 Sep 2023 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852312;
	bh=e6vZ6/mEByZSU33rZTP6bDKiS8aBcNuNdRd0iHP1uiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zO5ctkW80ahPvN2BJ1JZ2E0Xb8NlbiVoFtsqrVj7drEBaACYVZ9g2FkOiXcdSAR5u
	 wLJ7SWVHMY47Py5Jl7j0qNh/Wy2alJIFRNaOAbiQR71TJtZFpS97NdOaj1ct38A9sp
	 3MEuVVd7kXKIQv1HAuEnzkIAIkvtfZfSn88vxRBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.5 07/34] ARM: pxa: remove use of symbol_get()
Date: Mon,  4 Sep 2023 19:29:54 +0100
Message-ID: <20230904182948.937882589@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,8 +216,6 @@ void sharpsl_battery_kick(void)
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
@@ -518,17 +517,6 @@ static struct gpiod_lookup_table spitz_a
 	},
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
@@ -556,7 +544,7 @@ static struct corgi_lcd_platform_data sp
 	.max_intensity		= 0x2f,
 	.default_intensity	= 0x1f,
 	.limit_mask		= 0x0b,
-	.kick_battery		= spitz_bl_kick_battery,
+	.kick_battery		= sharpsl_battery_kick,
 };
 
 static struct spi_board_info spitz_spi_devices[] = {


