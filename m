Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975DF27FD4A;
	Tue, 27 May 2025 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367002; cv=none; b=k7irMxi5Y/esQQ1kpYlaLdnEO381zJh90KdpDs9W0LVxM2jchKbTALI/P0LYe1I9YdLaonDhS4HWkvt66tKnwS4l7aua9OQKUQK1KqJybUEs0ZGYiJhGWO7KI8F4ZGB3Kz4n2ZSz5upR5gB6owVoBgraekS4lsOxUp48oNpGn5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367002; c=relaxed/simple;
	bh=6ndsnrp1Tfg30kJ0GkoJow2rEDTwJyAkVbs7gnUrCOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU91hNTwhWixemH8ChBQT5WzodgX8LLJXtcotDrhcKTHCb+EIkM8c3lBOT3IbNASUtYznHWi9vAhkiKSkkTUfS4uH9dhNXmTSIZHGGpGb0gzqQ5DJTVBnQW5aqip5bGADxKTWp3N0Hy7bpupN3SxqOht1L/pTYH9XZ7sJKy2yBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUi6cQ+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUi6cQ+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F43C4CEE9;
	Tue, 27 May 2025 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367002;
	bh=6ndsnrp1Tfg30kJ0GkoJow2rEDTwJyAkVbs7gnUrCOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUi6cQ+zKFG9Pw3nItbNfy2+hvVoCfAodlh3s5jOymF0J96q4Awwmoo6LUJCjkub3
	 CBxK68lZk18HNmBGxO9OAOkRUFtY9iPWxLAtTf4E2A+3GEQkofltgVmyTwR2eaaX1+
	 VC3z4y5YqSJGHdhi1RmxaDwTOaFamqAPa8wWy3Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 245/783] watchdog: aspeed: Update bootstatus handling
Date: Tue, 27 May 2025 18:20:42 +0200
Message-ID: <20250527162523.088868681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>

[ Upstream commit 5c03f9f4d36292150c14ebd90788c4d3273ed9dc ]

The boot status in the watchdog device struct is updated during
controller probe stage. Application layer can get the boot status
through the command, cat /sys/class/watchdog/watchdogX/bootstatus.
The bootstatus can be,
WDIOF_CARDRESET => System is reset due to WDT timeout occurs.
Others          => Other reset events, e.g., power on reset.

On ASPEED platforms, boot status is recorded in the SCU registers.
- AST2400: Only a bit is used to represent system reset triggered by
           any WDT controller.
- AST2500/AST2600: System reset triggered by different WDT controllers
                   can be distinguished by different SCU bits.

Besides, on AST2400 and AST2500, since alternating boot event is
also triggered by using WDT timeout mechanism, it is classified
as WDIOF_CARDRESET.

Signed-off-by: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250113093737.845097-2-chin-ting_kuo@aspeedtech.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/aspeed_wdt.c | 81 ++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index b4773a6aaf8cc..369635b38ca0e 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -11,21 +11,30 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/watchdog.h>
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+struct aspeed_wdt_scu {
+	const char *compatible;
+	u32 reset_status_reg;
+	u32 wdt_reset_mask;
+	u32 wdt_reset_mask_shift;
+};
 
 struct aspeed_wdt_config {
 	u32 ext_pulse_width_mask;
 	u32 irq_shift;
 	u32 irq_mask;
+	struct aspeed_wdt_scu scu;
 };
 
 struct aspeed_wdt {
@@ -39,18 +48,36 @@ static const struct aspeed_wdt_config ast2400_config = {
 	.ext_pulse_width_mask = 0xff,
 	.irq_shift = 0,
 	.irq_mask = 0,
+	.scu = {
+		.compatible = "aspeed,ast2400-scu",
+		.reset_status_reg = 0x3c,
+		.wdt_reset_mask = 0x1,
+		.wdt_reset_mask_shift = 1,
+	},
 };
 
 static const struct aspeed_wdt_config ast2500_config = {
 	.ext_pulse_width_mask = 0xfffff,
 	.irq_shift = 12,
 	.irq_mask = GENMASK(31, 12),
+	.scu = {
+		.compatible = "aspeed,ast2500-scu",
+		.reset_status_reg = 0x3c,
+		.wdt_reset_mask = 0x1,
+		.wdt_reset_mask_shift = 2,
+	},
 };
 
 static const struct aspeed_wdt_config ast2600_config = {
 	.ext_pulse_width_mask = 0xfffff,
 	.irq_shift = 0,
 	.irq_mask = GENMASK(31, 10),
+	.scu = {
+		.compatible = "aspeed,ast2600-scu",
+		.reset_status_reg = 0x74,
+		.wdt_reset_mask = 0xf,
+		.wdt_reset_mask_shift = 16,
+	},
 };
 
 static const struct of_device_id aspeed_wdt_of_table[] = {
@@ -213,6 +240,56 @@ static int aspeed_wdt_restart(struct watchdog_device *wdd,
 	return 0;
 }
 
+static void aspeed_wdt_update_bootstatus(struct platform_device *pdev,
+					 struct aspeed_wdt *wdt)
+{
+	const struct resource *res;
+	struct aspeed_wdt_scu scu = wdt->cfg->scu;
+	struct regmap *scu_base;
+	u32 reset_mask_width;
+	u32 reset_mask_shift;
+	u32 idx = 0;
+	u32 status;
+	int ret;
+
+	if (!of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2400-wdt")) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		idx = ((intptr_t)wdt->base & 0x00000fff) / resource_size(res);
+	}
+
+	scu_base = syscon_regmap_lookup_by_compatible(scu.compatible);
+	if (IS_ERR(scu_base)) {
+		wdt->wdd.bootstatus = WDIOS_UNKNOWN;
+		return;
+	}
+
+	ret = regmap_read(scu_base, scu.reset_status_reg, &status);
+	if (ret) {
+		wdt->wdd.bootstatus = WDIOS_UNKNOWN;
+		return;
+	}
+
+	reset_mask_width = hweight32(scu.wdt_reset_mask);
+	reset_mask_shift = scu.wdt_reset_mask_shift +
+			   reset_mask_width * idx;
+
+	if (status & (scu.wdt_reset_mask << reset_mask_shift))
+		wdt->wdd.bootstatus = WDIOF_CARDRESET;
+
+	/* clear wdt reset event flag */
+	if (of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2400-wdt") ||
+	    of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2500-wdt")) {
+		ret = regmap_read(scu_base, scu.reset_status_reg, &status);
+		if (!ret) {
+			status &= ~(scu.wdt_reset_mask << reset_mask_shift);
+			regmap_write(scu_base, scu.reset_status_reg, status);
+		}
+	} else {
+		regmap_write(scu_base, scu.reset_status_reg,
+			     scu.wdt_reset_mask << reset_mask_shift);
+	}
+}
+
 /* access_cs0 shows if cs0 is accessible, hence the reverted bit */
 static ssize_t access_cs0_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -458,10 +535,10 @@ static int aspeed_wdt_probe(struct platform_device *pdev)
 		writel(duration - 1, wdt->base + WDT_RESET_WIDTH);
 	}
 
+	aspeed_wdt_update_bootstatus(pdev, wdt);
+
 	status = readl(wdt->base + WDT_TIMEOUT_STATUS);
 	if (status & WDT_TIMEOUT_STATUS_BOOT_SECONDARY) {
-		wdt->wdd.bootstatus = WDIOF_CARDRESET;
-
 		if (of_device_is_compatible(np, "aspeed,ast2400-wdt") ||
 		    of_device_is_compatible(np, "aspeed,ast2500-wdt"))
 			wdt->wdd.groups = bswitch_groups;
-- 
2.39.5



