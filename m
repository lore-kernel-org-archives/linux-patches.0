Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CB8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5542C433C7;
	Sun, 16 Jul 2023 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538000;
	bh=FtQP2VqelRPeJhTDewTpjSIlnFRK5c65wxz/AzEAnXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3GCE+Lxymtz/3j0U5v30srBV09XpkkY1IIhgPuoDZp8QX3h7t9QcBX+QoWq2LBJ9
	 Nnhuo2wqegudF6LeEQUxzqOtZvo8/g+OvLiei+yhHP/BilxqCCUxU7exup2iNHpDVT
	 SiSBK6f1efs6mroUr77zkZoZnuHsTRgRl2isoTj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 296/800] ARM: omap2: Rewrite WLAN quirk to use GPIO descriptors
Date: Sun, 16 Jul 2023 21:42:29 +0200
Message-ID: <20230716194955.956898952@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 078dc5194c0ac1b8e2fc088be2168a1104e16f72 ]

The OMAP2 platform data quirk is using the global GPIO numberspace
to obtain two WLAN GPIOs to drive power and xcvr reset GPIO
lines during start-up.

Rewrite the quirk to use a GPIO descriptor table so we avoid using
global GPIO numbers.

This gets rid of the final dependency on the legacy <linux/gpio.h>
header from the OMAP2/3 platforms.

Fixes: 92bf78b33b0b ("gpio: omap: use dynamic allocation of base")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 41 ++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 3264c4e77a8aa..c1c0121f478d6 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -8,7 +8,6 @@
 #include <linux/davinci_emac.h>
 #include <linux/gpio/machine.h>
 #include <linux/gpio/consumer.h>
-#include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
@@ -178,25 +177,41 @@ static void __init am35xx_emac_reset(void)
 	omap_ctrl_readl(AM35XX_CONTROL_IP_SW_RESET); /* OCP barrier */
 }
 
-static struct gpio cm_t3517_wlan_gpios[] __initdata = {
-	{ 56,	GPIOF_OUT_INIT_HIGH,	"wlan pwr" },
-	{ 4,	GPIOF_OUT_INIT_HIGH,	"xcvr noe" },
+static struct gpiod_lookup_table cm_t3517_wlan_gpio_table = {
+	.dev_id = NULL,
+	.table = {
+		GPIO_LOOKUP("gpio-48-53", 8, "power",
+			    GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio-0-15", 4, "noe",
+			    GPIO_ACTIVE_HIGH),
+		{ }
+	},
 };
 
 static void __init omap3_sbc_t3517_wifi_init(void)
 {
-	int err = gpio_request_array(cm_t3517_wlan_gpios,
-				ARRAY_SIZE(cm_t3517_wlan_gpios));
-	if (err) {
-		pr_err("SBC-T3517: wl12xx gpios request failed: %d\n", err);
-		return;
-	}
+	struct gpio_desc *d;
 
-	gpiod_export(gpio_to_desc(cm_t3517_wlan_gpios[0].gpio), 0);
-	gpiod_export(gpio_to_desc(cm_t3517_wlan_gpios[1].gpio), 0);
+	gpiod_add_lookup_table(&cm_t3517_wlan_gpio_table);
 
+	/* This asserts the RESET line (reverse polarity) */
+	d = gpiod_get(NULL, "power", GPIOD_OUT_HIGH);
+	if (IS_ERR(d)) {
+		pr_err("Unable to get CM T3517 WLAN power GPIO descriptor\n");
+	} else {
+		gpiod_set_consumer_name(d, "wlan pwr");
+		gpiod_export(d, 0);
+	}
+
+	d = gpiod_get(NULL, "noe", GPIOD_OUT_HIGH);
+	if (IS_ERR(d)) {
+		pr_err("Unable to get CM T3517 WLAN XCVR NOE GPIO descriptor\n");
+	} else {
+		gpiod_set_consumer_name(d, "xcvr noe");
+		gpiod_export(d, 0);
+	}
 	msleep(100);
-	gpio_set_value(cm_t3517_wlan_gpios[1].gpio, 0);
+	gpiod_set_value(d, 0);
 }
 
 static struct gpiod_lookup_table omap3_sbc_t3517_usb_gpio_table = {
-- 
2.39.2



