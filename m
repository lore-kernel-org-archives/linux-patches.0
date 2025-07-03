Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1125E6F53E;
	Thu,  3 Jul 2025 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554822; cv=none; b=Ke+37CWbCmLlXm02DQ5nkKGErWhVz2toDazeAkljHwdc+cbIWCVv0ol5Au0niSyn0n6wXR2ixWe44R524gYecQw/wPOh1nJXSIpavQGSaPYS7cCVW7K0swXQBY7WNAr1dVKoe/pytGLuWOcNMD6IL1HamY13LDaX3oZdNwpF3g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554822; c=relaxed/simple;
	bh=Yvu3X0LTjQPFYzbmXmDOCVfFNmK9HD2Mk3bqYLGLwX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUC13wW2V8JFTsT0wM/c4tXIYdFc01e0CLTfWhG/et1g21BFB8prme1sUqfzM7oxn0rOX0gso69zmqF0hLpcZkGcbS/x8+YHYtGqNy/anMUWPjxJLBmLhkXnzOcZeG8RtbLn7SkDaY/KQuoGsB+ShBzH0OPolftfJoFB3Dw8jno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx/yGChm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx/yGChm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4CC4CEE3;
	Thu,  3 Jul 2025 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554821;
	bh=Yvu3X0LTjQPFYzbmXmDOCVfFNmK9HD2Mk3bqYLGLwX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx/yGChmqZiKsygLW7ksYCFr0EO+yzJlrFGpZQ4k79QxybOo/hKlmCpL5r48qS9fS
	 LdSvTwoD3vdd1hDK8HTCFZMWN3Zlq2C5QkVJ7dakzz0JXx3Oo2kBYsU5619Dg5uIjA
	 0UXVx5dzivpDXxwcuqhcpzAt55rruV91yz43dp3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 088/263] ASoC: codec: wcd9335: Convert to GPIO descriptors
Date: Thu,  3 Jul 2025 16:40:08 +0200
Message-ID: <20250703144007.831669798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit d5099bc1b56417733f4cccf10c61ee74dadd5562 ]

of_gpio.h is deprecated, update the driver to use GPIO descriptors.
- Use dev_gpiod_get to get GPIO descriptor.
- Use gpiod_set_value to configure output value.

With legacy of_gpio API, the driver set gpio value 0 to assert reset,
and 1 to deassert reset. And the reset-gpios use GPIO_ACTIVE_LOW flag in
DTS, so set GPIOD_OUT_LOW when get GPIO descriptors, and set value 1 means
output low, set value 0 means output high with gpiod API.

The in-tree DTS files have the right polarity set up already so we can
expect this to "just work"

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20250324-wcd-gpiod-v2-3-773f67ce3b56@nxp.com
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9079db287fc3 ("ASoC: codecs: wcd9335: Fix missing free of regulator supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 7cef43bb2a880..8ee4360aff929 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -17,7 +17,7 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 #include <sound/soc-dapm.h>
-#include <linux/of_gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <sound/tlv.h>
@@ -331,7 +331,7 @@ struct wcd9335_codec {
 	int comp_enabled[COMPANDER_MAX];
 
 	int intr1;
-	int reset_gpio;
+	struct gpio_desc *reset_gpio;
 	struct regulator_bulk_data supplies[WCD9335_MAX_SUPPLY];
 
 	unsigned int rx_port_value[WCD9335_RX_MAX];
@@ -4975,12 +4975,11 @@ static const struct regmap_irq_chip wcd9335_regmap_irq1_chip = {
 static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
 {
 	struct device *dev = wcd->dev;
-	struct device_node *np = dev->of_node;
 	int ret;
 
-	wcd->reset_gpio = of_get_named_gpio(np,	"reset-gpios", 0);
-	if (wcd->reset_gpio < 0)
-		return dev_err_probe(dev, wcd->reset_gpio, "Reset GPIO missing from DT\n");
+	wcd->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(wcd->reset_gpio))
+		return dev_err_probe(dev, PTR_ERR(wcd->reset_gpio), "Reset GPIO missing from DT\n");
 
 	wcd->mclk = devm_clk_get(dev, "mclk");
 	if (IS_ERR(wcd->mclk))
@@ -5023,9 +5022,9 @@ static int wcd9335_power_on_reset(struct wcd9335_codec *wcd)
 	 */
 	usleep_range(600, 650);
 
-	gpio_direction_output(wcd->reset_gpio, 0);
+	gpiod_set_value(wcd->reset_gpio, 1);
 	msleep(20);
-	gpio_set_value(wcd->reset_gpio, 1);
+	gpiod_set_value(wcd->reset_gpio, 0);
 	msleep(20);
 
 	return 0;
-- 
2.39.5



