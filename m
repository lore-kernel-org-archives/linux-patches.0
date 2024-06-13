Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C736399;
	Thu, 13 Jun 2024 12:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282313; cv=none; b=oP/6QX71jkOJZbqL0iMD9mHtM84lQHF1mQvIG7B/5e/RldnhDmzIbliK9sMeKem4GVpyoSh8S3tSiTc1WO9lDMZ+3nNnZv7LOOZgEdHsG0M4/De1CZZNrYOSnthHNglSHE6oP8tb+5fC4SvXjMXpecP1fLEfKRJb8Lp+h9tT+UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282313; c=relaxed/simple;
	bh=Z+UkoeqddfnP7q6Wtf+ft1FjPO4nK+6NLSJuN2TaF+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ3DNrkQc6B0SPAdrX5aE7IweP+5RiWoda4rPUodq/deOkwEdZN7BSQZdCbVgFpAB4HKL2V3SHS3EG0BXRfSeSvvAWFVzXOew7mzX40MTQJbs/MgUJ4/32GMILkUmVpxpOpz8yD/TZvwYEVXebFZAlAJ4q5mFu7jv1McYuPf1d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbjzl1Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbjzl1Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77D3C2BBFC;
	Thu, 13 Jun 2024 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282313;
	bh=Z+UkoeqddfnP7q6Wtf+ft1FjPO4nK+6NLSJuN2TaF+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbjzl1PnkdmToPO1JSjLxxBP/moSp6o7lzmlErrCwPMN66lln4VyyGvf62gpEYOtK
	 YWD36i0/FhniWASZNXPFlU9b/BzDrs5lBK1zP/8ekf3+9+nwWxaJIm4s6XYeCnquN5
	 4Ag7wwIgGzDv3lsVHdca6lR0dbWjEQXvqdNY8pXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/402] watchdog: bd9576_wdt: switch to using devm_fwnode_gpiod_get()
Date: Thu, 13 Jun 2024 13:32:54 +0200
Message-ID: <20240613113310.613664524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

[ Upstream commit 4f719022a753bb15720c9ddeb0387a93caa372ce ]

I would like to stop exporting OF-specific devm_gpiod_get_from_of_node()
so that gpiolib can be cleaned a bit, so let's switch to the generic
fwnode property API.

While at it, switch the rest of the calls to read properties in
bd9576_wdt_probe() to the generic device property API as well.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220903-gpiod_get_from_of_node-remove-v1-10-b29adfb27a6c@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Stable-dep-of: e3b3afd34d84 ("watchdog: bd9576: Drop "always-running" property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bd9576_wdt.c | 51 +++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/bd9576_wdt.c b/drivers/watchdog/bd9576_wdt.c
index 0b6999f3b6e83..4a20e07fbb699 100644
--- a/drivers/watchdog/bd9576_wdt.c
+++ b/drivers/watchdog/bd9576_wdt.c
@@ -9,8 +9,8 @@
 #include <linux/gpio/consumer.h>
 #include <linux/mfd/rohm-bd957x.h>
 #include <linux/module.h>
-#include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/watchdog.h>
 
@@ -202,10 +202,10 @@ static int bd957x_set_wdt_mode(struct bd9576_wdt_priv *priv, int hw_margin,
 static int bd9576_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->parent->of_node;
 	struct bd9576_wdt_priv *priv;
 	u32 hw_margin[2];
 	u32 hw_margin_max = BD957X_WDT_DEFAULT_MARGIN, hw_margin_min = 0;
+	int count;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -221,40 +221,51 @@ static int bd9576_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	priv->gpiod_en = devm_gpiod_get_from_of_node(dev, dev->parent->of_node,
-						     "rohm,watchdog-enable-gpios",
-						     0, GPIOD_OUT_LOW,
-						     "watchdog-enable");
+	priv->gpiod_en = devm_fwnode_gpiod_get(dev, dev_fwnode(dev->parent),
+					       "rohm,watchdog-enable",
+					       GPIOD_OUT_LOW,
+					       "watchdog-enable");
 	if (IS_ERR(priv->gpiod_en))
 		return dev_err_probe(dev, PTR_ERR(priv->gpiod_en),
 			      "getting watchdog-enable GPIO failed\n");
 
-	priv->gpiod_ping = devm_gpiod_get_from_of_node(dev, dev->parent->of_node,
-						     "rohm,watchdog-ping-gpios",
-						     0, GPIOD_OUT_LOW,
-						     "watchdog-ping");
+	priv->gpiod_ping = devm_fwnode_gpiod_get(dev, dev_fwnode(dev->parent),
+						 "rohm,watchdog-ping",
+						 GPIOD_OUT_LOW,
+						 "watchdog-ping");
 	if (IS_ERR(priv->gpiod_ping))
 		return dev_err_probe(dev, PTR_ERR(priv->gpiod_ping),
 				     "getting watchdog-ping GPIO failed\n");
 
-	ret = of_property_read_variable_u32_array(np, "rohm,hw-timeout-ms",
-						  &hw_margin[0], 1, 2);
-	if (ret < 0 && ret != -EINVAL)
-		return ret;
+	count = device_property_count_u32(dev->parent, "rohm,hw-timeout-ms");
+	if (count < 0 && count != -EINVAL)
+		return count;
+
+	if (count > 0) {
+		if (count > ARRAY_SIZE(hw_margin))
+			return -EINVAL;
 
-	if (ret == 1)
-		hw_margin_max = hw_margin[0];
+		ret = device_property_read_u32_array(dev->parent,
+						     "rohm,hw-timeout-ms",
+						     hw_margin, count);
+		if (ret < 0)
+			return ret;
 
-	if (ret == 2) {
-		hw_margin_max = hw_margin[1];
-		hw_margin_min = hw_margin[0];
+		if (count == 1)
+			hw_margin_max = hw_margin[0];
+
+		if (count == 2) {
+			hw_margin_max = hw_margin[1];
+			hw_margin_min = hw_margin[0];
+		}
 	}
 
 	ret = bd957x_set_wdt_mode(priv, hw_margin_max, hw_margin_min);
 	if (ret)
 		return ret;
 
-	priv->always_running = of_property_read_bool(np, "always-running");
+	priv->always_running = device_property_read_bool(dev->parent,
+							 "always-running");
 
 	watchdog_set_drvdata(&priv->wdd, priv);
 
-- 
2.43.0



