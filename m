Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3597E0FF;
	Mon, 23 Dec 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970424; cv=none; b=S/Con2darKoUzHbHf5Tm+dOL0Nx9hUtHe0gXd34fVedxYHjwdLDq5NF2XtuJu2iF4bex2d0izonnTUM+wZb9BEqWS7ZhMPID08e2Vk5MkjVWl/tEod8tXMQrziXC1azU1dP9ofpFHKOFnQGqXPwQ2tsVHkKtiAbj/18wdVp20T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970424; c=relaxed/simple;
	bh=JX4kdH2IRcWIyTNgyGR6Yx9gFGWQJrazI+wPZRRo+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8RJL8YrHYnuQl95Gu2nynbAWpaiO6inBdtiGuuNVT6tUJmTsuiH5lR16lG9DoRG51zSdAvqof3j4ICgs948+iLThPQCKj4Jh2G9KZ80kKUJ6uDUchILlDgRppzoqb9dv9yjHafYlQRo0P8ERD3pw5p2K6kohM93ojJucohVptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJ8tX47S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJ8tX47S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD73C4CED3;
	Mon, 23 Dec 2024 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970424;
	bh=JX4kdH2IRcWIyTNgyGR6Yx9gFGWQJrazI+wPZRRo+1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJ8tX47SSvNUiV4k5TFIrKgvpE/k1AilE7z6cLczb5OodqZZF/o0X3oiDUMAqezgu
	 Z+F7EhaHzrKHNFzSxNTgjpnVVokvtA4+zzPf6AWm5KPUSmxsAv2rDteOrxnJ3maGdW
	 UxO0hQ91pYi8N0kN9yNPg8+N5HLfTfUQcnPum4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/116] hwmon: (tmp513) Simplify with dev_err_probe()
Date: Mon, 23 Dec 2024 16:59:10 +0100
Message-ID: <20241223155402.681080209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit df989762bc4b71068e6adc0c2b5ef6f76b6acf74 ]

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and also it prints the error value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231128180654.395692-3-andriy.shevchenko@linux.intel.com
[groeck: Fixed excessive line length]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 74d7e038fd07 ("hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index ca665033fe52..67b13ac5512c 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -632,9 +632,9 @@ static int tmp51x_vbus_range_to_reg(struct device *dev,
 	} else if (data->vbus_range_uvolt == TMP51X_VBUS_RANGE_16V) {
 		data->shunt_config &= ~TMP51X_BUS_VOLTAGE_MASK;
 	} else {
-		dev_err(dev, "ti,bus-range-microvolt is invalid: %u\n",
-			data->vbus_range_uvolt);
-		return -EINVAL;
+		return dev_err_probe(dev, -EINVAL,
+				     "ti,bus-range-microvolt is invalid: %u\n",
+				     data->vbus_range_uvolt);
 	}
 	return 0;
 }
@@ -650,8 +650,8 @@ static int tmp51x_pga_gain_to_reg(struct device *dev, struct tmp51x_data *data)
 	} else if (data->pga_gain == 1) {
 		data->shunt_config |= CURRENT_SENSE_VOLTAGE_40_MASK;
 	} else {
-		dev_err(dev, "ti,pga-gain is invalid: %u\n", data->pga_gain);
-		return -EINVAL;
+		return dev_err_probe(dev, -EINVAL,
+				     "ti,pga-gain is invalid: %u\n", data->pga_gain);
 	}
 	return 0;
 }
@@ -684,9 +684,9 @@ static int tmp51x_read_properties(struct device *dev, struct tmp51x_data *data)
 
 	// Check if shunt value is compatible with pga-gain
 	if (data->shunt_uohms > data->pga_gain * 40 * 1000 * 1000) {
-		dev_err(dev, "shunt-resistor: %u too big for pga_gain: %u\n",
-			data->shunt_uohms, data->pga_gain);
-		return -EINVAL;
+		return dev_err_probe(dev, -EINVAL,
+				     "shunt-resistor: %u too big for pga_gain: %u\n",
+				     data->shunt_uohms, data->pga_gain);
 	}
 
 	return 0;
@@ -727,22 +727,17 @@ static int tmp51x_probe(struct i2c_client *client)
 	data->id = (uintptr_t)i2c_get_match_data(client);
 
 	ret = tmp51x_configure(dev, data);
-	if (ret < 0) {
-		dev_err(dev, "error configuring the device: %d\n", ret);
-		return ret;
-	}
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "error configuring the device\n");
 
 	data->regmap = devm_regmap_init_i2c(client, &tmp51x_regmap_config);
-	if (IS_ERR(data->regmap)) {
-		dev_err(dev, "failed to allocate register map\n");
-		return PTR_ERR(data->regmap);
-	}
+	if (IS_ERR(data->regmap))
+		return dev_err_probe(dev, PTR_ERR(data->regmap),
+				     "failed to allocate register map\n");
 
 	ret = tmp51x_init(data);
-	if (ret < 0) {
-		dev_err(dev, "error configuring the device: %d\n", ret);
-		return -ENODEV;
-	}
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "error configuring the device\n");
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
 							 data,
-- 
2.39.5



