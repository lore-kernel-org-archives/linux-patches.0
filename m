Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA94722333B;
	Thu,  3 Jul 2025 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556018; cv=none; b=UdOOvBFZbvz2lcRVltjPt9UkT+1jMwC0WfJxE0vbm43ngz5eagsHLkOYn3AafErwBRjQJdFXASYHT0si1q9UA4nSbnEYduTAZy40Vko3ung3L6I+veV2aHi+AgWpTI84n8+v1rkNrIenkJNrTOb1WswouQkZE7JiZxLUIA0M2EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556018; c=relaxed/simple;
	bh=/U5mfXU/qIaQGQbX4PUCRS9QKq5kqIfT7m9Lkvw1tFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgoiE6SHlr3kC7YXP6JJgqBP0sjITLOWUghtJqrwjpwgIg8mPOioKCn+Os+oF4a11U1ofBvR93848SSnydBRQAPkqYN9U/BGhXkLj3M8foiO3Gmq1jyOMD3fkA4DuKScsZfFjTtVjiOXYcNuoQSinyHqy1SnzAH8+8UOU5QkgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6fJbJHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6fJbJHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44C5C4CEE3;
	Thu,  3 Jul 2025 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556016;
	bh=/U5mfXU/qIaQGQbX4PUCRS9QKq5kqIfT7m9Lkvw1tFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6fJbJHHsN2SqbY5XEF27XkP+Uk7X2iBzKs84L/9gYhJITY4aG1LklEIHdCuLGZQY
	 6UGuFFNg501iKvF2W3QtVN4cNZNGiQ5dpsL8R6NMftZoGN9D2laYaGC3eWaNi1FKh8
	 US6A9io1uBl/7dQkLcSNg5JecPC3L3UfubBj5PhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/132] ASoC: codec: wcd9335: Convert to GPIO descriptors
Date: Thu,  3 Jul 2025 16:42:17 +0200
Message-ID: <20250703143941.309931402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 23f3c0253d9eb..7817dff99b6c6 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -16,7 +16,7 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 #include <sound/soc-dapm.h>
-#include <linux/of_gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <sound/tlv.h>
@@ -329,7 +329,7 @@ struct wcd9335_codec {
 	int comp_enabled[COMPANDER_MAX];
 
 	int intr1;
-	int reset_gpio;
+	struct gpio_desc *reset_gpio;
 	struct regulator_bulk_data supplies[WCD9335_MAX_SUPPLY];
 
 	unsigned int rx_port_value[WCD9335_RX_MAX];
@@ -5032,12 +5032,11 @@ static const struct regmap_irq_chip wcd9335_regmap_irq1_chip = {
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
@@ -5080,9 +5079,9 @@ static int wcd9335_power_on_reset(struct wcd9335_codec *wcd)
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



