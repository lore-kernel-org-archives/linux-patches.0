Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF86433BE;
	Tue, 14 May 2024 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682320; cv=none; b=IGycw+sS3vJ/G3qQU5yLWh2TOdZ1TnjjPebr6eNb7UuVYSzhyWphQHtGVnYNX0cWlyqn9XTF+xftwSBuap1IMgV8C7QGyp6lYlX6J0fsNKK847dvteF7fs3iJtYEw7QzBuWJC1rBdH58ZZJ+Mrg+sKE2SPHmlz0cCiObZd/NpwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682320; c=relaxed/simple;
	bh=tcYWDJ5Kf3/dgcl+AyIK4GE7R3eafKWuVuNd8dKzJLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWIDG4L1rxTmOZu9ItGR1tjrhnGQzBpJpjC36gaxn3SAgRiJ3Vy6e1q+gQFUNcQDYyMweubwtKPhMvrblGDjaGkhUF0w48D+mw94r20Vqg0AP6sTQZRX3PaeC1mqP+LI31iy3DvAD+EZTFOaR3koO6ySvL8ZJyQcktFcxxz2ZL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwWYSOWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwWYSOWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B28C2BD10;
	Tue, 14 May 2024 10:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682319;
	bh=tcYWDJ5Kf3/dgcl+AyIK4GE7R3eafKWuVuNd8dKzJLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwWYSOWkkU60Ih+sdg3+RRTcvYTYr7hBofT5vm7oe4RwX/zck4L9DG11aPJmyB1BM
	 dV7G8SNP8QfvCK9Iz8016kVTowFbqeZEwlhwLUn8FkSCNh3qKKSKhEWMZr1Mxkg1KZ
	 itC7sGwVqcTy5UxutKe4JO5zKAw+EyPNPTyIG168=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 013/336] pinctrl: baytrail: Fix selecting gpio pinctrl state
Date: Tue, 14 May 2024 12:13:37 +0200
Message-ID: <20240514101039.106688961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fed6d9a8e6a60ecf6506d0ea004040fbaa109927 ]

For all the "score" pin-groups all the intel_pingroup-s to select
the non GPIO function are re-used for byt_score_gpio_groups[].

But this is incorrect since a pin-group includes the mode setting,
which for the non GPIO functions generally is 1, where as to select
the GPIO function mode must be set to 0.

So the GPIO function needs separate intel_pingroup-s with their own mode
value of 0.

Add a new PIN_GROUP_GPIO macro which adds a foo_gpio entry to each
pin-group defined this way and update byt_score_gpio_groups[] to point
to the new foo_gpio entries.

The "sus" usb_oc_grp usb_ulpi_grp and pcu_spi_grp pin-groups are special
because these have a non 0 mode value to select the GPIO functions and
these already have matching foo_gpio pin-groups, leave these are unchanged.

The pmu_clk "sus" groups added in commit 2f46d7f7e959 ("pinctrl: baytrail:
Add pinconf group + function for the pmu_clk") do need to use the new
PIN_GROUP_GPIO macro.

Fixes: 2f46d7f7e959 ("pinctrl: baytrail: Add pinconf group + function for the pmu_clk")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 74 ++++++++++++------------
 drivers/pinctrl/intel/pinctrl-intel.h    |  4 ++
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index ac97724c59bae..1edb6041fb424 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -278,33 +278,33 @@ static const unsigned int byt_score_plt_clk5_pins[] = { 101 };
 static const unsigned int byt_score_smbus_pins[] = { 51, 52, 53 };
 
 static const struct intel_pingroup byt_score_groups[] = {
-	PIN_GROUP("uart1_grp", byt_score_uart1_pins, 1),
-	PIN_GROUP("uart2_grp", byt_score_uart2_pins, 1),
-	PIN_GROUP("pwm0_grp", byt_score_pwm0_pins, 1),
-	PIN_GROUP("pwm1_grp", byt_score_pwm1_pins, 1),
-	PIN_GROUP("ssp2_grp", byt_score_ssp2_pins, 1),
-	PIN_GROUP("sio_spi_grp", byt_score_sio_spi_pins, 1),
-	PIN_GROUP("i2c5_grp", byt_score_i2c5_pins, 1),
-	PIN_GROUP("i2c6_grp", byt_score_i2c6_pins, 1),
-	PIN_GROUP("i2c4_grp", byt_score_i2c4_pins, 1),
-	PIN_GROUP("i2c3_grp", byt_score_i2c3_pins, 1),
-	PIN_GROUP("i2c2_grp", byt_score_i2c2_pins, 1),
-	PIN_GROUP("i2c1_grp", byt_score_i2c1_pins, 1),
-	PIN_GROUP("i2c0_grp", byt_score_i2c0_pins, 1),
-	PIN_GROUP("ssp0_grp", byt_score_ssp0_pins, 1),
-	PIN_GROUP("ssp1_grp", byt_score_ssp1_pins, 1),
-	PIN_GROUP("sdcard_grp", byt_score_sdcard_pins, byt_score_sdcard_mux_values),
-	PIN_GROUP("sdio_grp", byt_score_sdio_pins, 1),
-	PIN_GROUP("emmc_grp", byt_score_emmc_pins, 1),
-	PIN_GROUP("lpc_grp", byt_score_ilb_lpc_pins, 1),
-	PIN_GROUP("sata_grp", byt_score_sata_pins, 1),
-	PIN_GROUP("plt_clk0_grp", byt_score_plt_clk0_pins, 1),
-	PIN_GROUP("plt_clk1_grp", byt_score_plt_clk1_pins, 1),
-	PIN_GROUP("plt_clk2_grp", byt_score_plt_clk2_pins, 1),
-	PIN_GROUP("plt_clk3_grp", byt_score_plt_clk3_pins, 1),
-	PIN_GROUP("plt_clk4_grp", byt_score_plt_clk4_pins, 1),
-	PIN_GROUP("plt_clk5_grp", byt_score_plt_clk5_pins, 1),
-	PIN_GROUP("smbus_grp", byt_score_smbus_pins, 1),
+	PIN_GROUP_GPIO("uart1_grp", byt_score_uart1_pins, 1),
+	PIN_GROUP_GPIO("uart2_grp", byt_score_uart2_pins, 1),
+	PIN_GROUP_GPIO("pwm0_grp", byt_score_pwm0_pins, 1),
+	PIN_GROUP_GPIO("pwm1_grp", byt_score_pwm1_pins, 1),
+	PIN_GROUP_GPIO("ssp2_grp", byt_score_ssp2_pins, 1),
+	PIN_GROUP_GPIO("sio_spi_grp", byt_score_sio_spi_pins, 1),
+	PIN_GROUP_GPIO("i2c5_grp", byt_score_i2c5_pins, 1),
+	PIN_GROUP_GPIO("i2c6_grp", byt_score_i2c6_pins, 1),
+	PIN_GROUP_GPIO("i2c4_grp", byt_score_i2c4_pins, 1),
+	PIN_GROUP_GPIO("i2c3_grp", byt_score_i2c3_pins, 1),
+	PIN_GROUP_GPIO("i2c2_grp", byt_score_i2c2_pins, 1),
+	PIN_GROUP_GPIO("i2c1_grp", byt_score_i2c1_pins, 1),
+	PIN_GROUP_GPIO("i2c0_grp", byt_score_i2c0_pins, 1),
+	PIN_GROUP_GPIO("ssp0_grp", byt_score_ssp0_pins, 1),
+	PIN_GROUP_GPIO("ssp1_grp", byt_score_ssp1_pins, 1),
+	PIN_GROUP_GPIO("sdcard_grp", byt_score_sdcard_pins, byt_score_sdcard_mux_values),
+	PIN_GROUP_GPIO("sdio_grp", byt_score_sdio_pins, 1),
+	PIN_GROUP_GPIO("emmc_grp", byt_score_emmc_pins, 1),
+	PIN_GROUP_GPIO("lpc_grp", byt_score_ilb_lpc_pins, 1),
+	PIN_GROUP_GPIO("sata_grp", byt_score_sata_pins, 1),
+	PIN_GROUP_GPIO("plt_clk0_grp", byt_score_plt_clk0_pins, 1),
+	PIN_GROUP_GPIO("plt_clk1_grp", byt_score_plt_clk1_pins, 1),
+	PIN_GROUP_GPIO("plt_clk2_grp", byt_score_plt_clk2_pins, 1),
+	PIN_GROUP_GPIO("plt_clk3_grp", byt_score_plt_clk3_pins, 1),
+	PIN_GROUP_GPIO("plt_clk4_grp", byt_score_plt_clk4_pins, 1),
+	PIN_GROUP_GPIO("plt_clk5_grp", byt_score_plt_clk5_pins, 1),
+	PIN_GROUP_GPIO("smbus_grp", byt_score_smbus_pins, 1),
 };
 
 static const char * const byt_score_uart_groups[] = {
@@ -332,12 +332,14 @@ static const char * const byt_score_plt_clk_groups[] = {
 };
 static const char * const byt_score_smbus_groups[] = { "smbus_grp" };
 static const char * const byt_score_gpio_groups[] = {
-	"uart1_grp", "uart2_grp", "pwm0_grp", "pwm1_grp", "ssp0_grp",
-	"ssp1_grp", "ssp2_grp", "sio_spi_grp", "i2c0_grp", "i2c1_grp",
-	"i2c2_grp", "i2c3_grp", "i2c4_grp", "i2c5_grp", "i2c6_grp",
-	"sdcard_grp", "sdio_grp", "emmc_grp", "lpc_grp", "sata_grp",
-	"plt_clk0_grp", "plt_clk1_grp", "plt_clk2_grp", "plt_clk3_grp",
-	"plt_clk4_grp", "plt_clk5_grp", "smbus_grp",
+	"uart1_grp_gpio", "uart2_grp_gpio", "pwm0_grp_gpio",
+	"pwm1_grp_gpio", "ssp0_grp_gpio", "ssp1_grp_gpio", "ssp2_grp_gpio",
+	"sio_spi_grp_gpio", "i2c0_grp_gpio", "i2c1_grp_gpio", "i2c2_grp_gpio",
+	"i2c3_grp_gpio", "i2c4_grp_gpio", "i2c5_grp_gpio", "i2c6_grp_gpio",
+	"sdcard_grp_gpio", "sdio_grp_gpio", "emmc_grp_gpio", "lpc_grp_gpio",
+	"sata_grp_gpio", "plt_clk0_grp_gpio", "plt_clk1_grp_gpio",
+	"plt_clk2_grp_gpio", "plt_clk3_grp_gpio", "plt_clk4_grp_gpio",
+	"plt_clk5_grp_gpio", "smbus_grp_gpio",
 };
 
 static const struct intel_function byt_score_functions[] = {
@@ -456,8 +458,8 @@ static const struct intel_pingroup byt_sus_groups[] = {
 	PIN_GROUP("usb_oc_grp_gpio", byt_sus_usb_over_current_pins, byt_sus_usb_over_current_gpio_mode_values),
 	PIN_GROUP("usb_ulpi_grp_gpio", byt_sus_usb_ulpi_pins, byt_sus_usb_ulpi_gpio_mode_values),
 	PIN_GROUP("pcu_spi_grp_gpio", byt_sus_pcu_spi_pins, byt_sus_pcu_spi_gpio_mode_values),
-	PIN_GROUP("pmu_clk1_grp", byt_sus_pmu_clk1_pins, 1),
-	PIN_GROUP("pmu_clk2_grp", byt_sus_pmu_clk2_pins, 1),
+	PIN_GROUP_GPIO("pmu_clk1_grp", byt_sus_pmu_clk1_pins, 1),
+	PIN_GROUP_GPIO("pmu_clk2_grp", byt_sus_pmu_clk2_pins, 1),
 };
 
 static const char * const byt_sus_usb_groups[] = {
@@ -469,7 +471,7 @@ static const char * const byt_sus_pmu_clk_groups[] = {
 };
 static const char * const byt_sus_gpio_groups[] = {
 	"usb_oc_grp_gpio", "usb_ulpi_grp_gpio", "pcu_spi_grp_gpio",
-	"pmu_clk1_grp", "pmu_clk2_grp",
+	"pmu_clk1_grp_gpio", "pmu_clk2_grp_gpio",
 };
 
 static const struct intel_function byt_sus_functions[] = {
diff --git a/drivers/pinctrl/intel/pinctrl-intel.h b/drivers/pinctrl/intel/pinctrl-intel.h
index fde65e18cd145..6981e2fab93f3 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.h
+++ b/drivers/pinctrl/intel/pinctrl-intel.h
@@ -179,6 +179,10 @@ struct intel_community {
 		.modes = __builtin_choose_expr(__builtin_constant_p((m)), NULL, (m)),	\
 	}
 
+#define PIN_GROUP_GPIO(n, p, m)						\
+	 PIN_GROUP(n, p, m),						\
+	 PIN_GROUP(n "_gpio", p, 0)
+
 #define FUNCTION(n, g)							\
 	{								\
 		.func = PINCTRL_PINFUNCTION((n), (g), ARRAY_SIZE(g)),	\
-- 
2.43.0



