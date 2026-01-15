Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661963D3488;
	Thu, 15 Jan 2026 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499938; cv=none; b=rC9V31YWntfG/yMAROuFIKpp2oWLNaFnRa8MwTUgkwZnYlO92acb5uRuFpI0ENEuMgr2X+mUb2B5hy1vnW7n7Hp147FzBd2CjwG3TH8eGsxCy0E35LyHkhZeug1uU7s7OY2qHJLUat28Imt2tFIGc2tgqRVuTopquZLy3mJQ99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499938; c=relaxed/simple;
	bh=/9TVuY373tl5l8haA/W0DwrVnW+dj2ThtlMtd4/2LNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFJkKKmYtXUXxlaXiRnogFrYJ2hJ+TpZAJaNAellW93ccpQvt7pkuf40pEb09oOHQiP9sTnWKz5Amh3BUEhGhHnX6nZNSEUneksgxPV/fPoG/wb+3kWEFpYhEPFLxTa5NKIVZ3AyxWaws7Bb9EornzMnU0u3tqF2qTkRwhAiUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi+/eFYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi+/eFYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8516C116D0;
	Thu, 15 Jan 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499938;
	bh=/9TVuY373tl5l8haA/W0DwrVnW+dj2ThtlMtd4/2LNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi+/eFYUoBRpJ4TdG9ih3AfLC+B4u45Up1y9o9lLJHjtKH0JBPNQuua2tTX2GqbPO
	 xfxIY0IRy9M1vawDkgP2/+AXhrHe8KiE3+fx+97igM9FvSoViVsFdRnWZfRo0dxTMO
	 8WKry/TIWii49UYQz+XcQldcTfYpYJ01oPFbZzdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/451] leds: lp50xx: Reduce level of dereferences
Date: Thu, 15 Jan 2026 17:50:02 +0100
Message-ID: <20260115164245.444641744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 556f15fe023ec1d9f9cd2781ba6cd14bda650d22 ]

The priv->dev is effectively the same as &priv->client->dev.
So, drop the latter for the former.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 434959618c47 ("leds: leds-lp50xx: Enable chip before any communication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -322,7 +322,7 @@ static int lp50xx_brightness_set(struct
 
 	ret = regmap_write(led->priv->regmap, reg_val, brightness);
 	if (ret) {
-		dev_err(&led->priv->client->dev,
+		dev_err(led->priv->dev,
 			"Cannot write brightness value %d\n", ret);
 		goto out;
 	}
@@ -338,7 +338,7 @@ static int lp50xx_brightness_set(struct
 		ret = regmap_write(led->priv->regmap, reg_val,
 				   mc_dev->subled_info[i].intensity);
 		if (ret) {
-			dev_err(&led->priv->client->dev,
+			dev_err(led->priv->dev,
 				"Cannot write intensity value %d\n", ret);
 			goto out;
 		}
@@ -402,7 +402,7 @@ static int lp50xx_probe_leds(struct fwno
 
 	if (num_leds > 1) {
 		if (num_leds > priv->chip_info->max_modules) {
-			dev_err(&priv->client->dev, "reg property is invalid\n");
+			dev_err(priv->dev, "reg property is invalid\n");
 			return -EINVAL;
 		}
 
@@ -410,13 +410,13 @@ static int lp50xx_probe_leds(struct fwno
 
 		ret = fwnode_property_read_u32_array(child, "reg", led_banks, num_leds);
 		if (ret) {
-			dev_err(&priv->client->dev, "reg property is missing\n");
+			dev_err(priv->dev, "reg property is missing\n");
 			return ret;
 		}
 
 		ret = lp50xx_set_banks(priv, led_banks, num_leds);
 		if (ret) {
-			dev_err(&priv->client->dev, "Cannot setup banked LEDs\n");
+			dev_err(priv->dev, "Cannot setup banked LEDs\n");
 			return ret;
 		}
 
@@ -424,12 +424,12 @@ static int lp50xx_probe_leds(struct fwno
 	} else {
 		ret = fwnode_property_read_u32(child, "reg", &led_number);
 		if (ret) {
-			dev_err(&priv->client->dev, "led reg property missing\n");
+			dev_err(priv->dev, "led reg property missing\n");
 			return ret;
 		}
 
 		if (led_number > priv->chip_info->num_leds) {
-			dev_err(&priv->client->dev, "led-sources property is invalid\n");
+			dev_err(priv->dev, "led-sources property is invalid\n");
 			return -EINVAL;
 		}
 
@@ -468,7 +468,7 @@ static int lp50xx_probe_dt(struct lp50xx
 		led = &priv->leds[i];
 		ret = fwnode_property_count_u32(child, "reg");
 		if (ret < 0) {
-			dev_err(&priv->client->dev, "reg property is invalid\n");
+			dev_err(priv->dev, "reg property is invalid\n");
 			goto child_out;
 		}
 
@@ -518,12 +518,11 @@ static int lp50xx_probe_dt(struct lp50xx
 		led_cdev = &led->mc_cdev.led_cdev;
 		led_cdev->brightness_set_blocking = lp50xx_brightness_set;
 
-		ret = devm_led_classdev_multicolor_register_ext(&priv->client->dev,
+		ret = devm_led_classdev_multicolor_register_ext(priv->dev,
 						       &led->mc_cdev,
 						       &init_data);
 		if (ret) {
-			dev_err(&priv->client->dev, "led register err: %d\n",
-				ret);
+			dev_err(priv->dev, "led register err: %d\n", ret);
 			goto child_out;
 		}
 		i++;
@@ -586,15 +585,14 @@ static int lp50xx_remove(struct i2c_clie
 
 	ret = lp50xx_enable_disable(led, 0);
 	if (ret) {
-		dev_err(&led->client->dev, "Failed to disable chip\n");
+		dev_err(led->dev, "Failed to disable chip\n");
 		return ret;
 	}
 
 	if (led->regulator) {
 		ret = regulator_disable(led->regulator);
 		if (ret)
-			dev_err(&led->client->dev,
-				"Failed to disable regulator\n");
+			dev_err(led->dev, "Failed to disable regulator\n");
 	}
 
 	mutex_destroy(&led->lock);


