Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570591A8F99;
	Mon, 23 Dec 2024 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970728; cv=none; b=cDcDCHngPjoFs1gw5G2U1YLtWa/3Dl5HOH0Qk7STWqddRHxNI0xMo0zOag4asaCTIp5TMCADcez9L2reeh0nX3bVCrM1fVfdGumX2IlPJ7i82Y0F5Z2H2kIdFMNkRNGHFmUigh0OriA+zCRyP3WIRgPRKT0INwXG3u5zrPGqGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970728; c=relaxed/simple;
	bh=sRpuoLDcA2jHeyI9VlibpxceD0B9cGPCnF1IEp0JX2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKp+Af7qf5cn/ca/JBQlHODg9RQdQBSD+Cvy310KQcatsIpjmullHx6XSWhB8Y+CiqpyQbSN4oR7hI0FotH/xxRLExArhPlHs26xsxA9mMYv448tRN24xACHB4UF3nakv2RiY8BJJ1NGnoTxuKPk1zHWwpXa71USIaUyVhA1DMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LahO58Yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LahO58Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC4FC4CED3;
	Mon, 23 Dec 2024 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970728;
	bh=sRpuoLDcA2jHeyI9VlibpxceD0B9cGPCnF1IEp0JX2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LahO58YqB5Qe0Lr/hhf+xh2kWCyHO56I92F2lvC5pf6SZ5MNdNItlbKDE32Zt6otr
	 EEYHrdi+WH0F+JHEex+t6afzRPc/iAo9RS3MxF5tRlzJ7s9m0M+O5KfIW8NHfcI2Jv
	 NZ8XyWLVK00eVTOQy9N8qaCRM5igogptXQO9BTV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/83] hwmon: (tmp513) Simplify with dev_err_probe()
Date: Mon, 23 Dec 2024 16:59:30 +0100
Message-ID: <20241223155355.608361334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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
index fe3f1113b64e..53525d3a32a0 100644
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
@@ -730,22 +730,17 @@ static int tmp51x_probe(struct i2c_client *client)
 		data->id = i2c_match_id(tmp51x_id, client)->driver_data;
 
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



