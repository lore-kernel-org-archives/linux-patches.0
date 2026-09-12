Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED921BD9C9;
	Sat, 12 Sep 2026 08:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202973; cv=none; b=RL2jgllVZgeWjeTqU6NM11KOIRU8J2ttfyiYkpYyMrBEhg7c72LIVoju2DHvpcXUoGmOhr4kzt+M6SqvJH+MkLvQVkJCInLIS3T11s/VEyC744wrEWqkUm++01ggSq3XtJ556z+Y6oW2aUHnx74wYyUqDSsN2FU8CTOc5xCj5fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202973; c=relaxed/simple;
	bh=9SbY1qNsMxZfq8fMBktXuN4TObSFQ+UlNyFV97aCTvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THkhiswxcvqgEe+FUCa/HX8UwZTjBfu/8AccRTJN2fC5BxZ/roJPjcnr6S2OibUvSgr3wcD55lT5qSetcUwBl47rqQ6dO1D7Tal3eWcg32dlUckchuBak6gywmUlobck80iAXaRm+rxiUeF8UflP4SBeo2+fs8L6AN/UVEPUQXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvY8rlAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvY8rlAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87221F000FF;
	Sat, 12 Sep 2026 08:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202972;
	bh=OdQOPTHiPCg7/GyaixpA+wkhCtnRh1bji9u5RuOiJDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvY8rlAL3Z24igkGqU3R6kPkvfHvhR6KgdVtibh4dTc6j1Mzjkdm3HnxuRFgcBIt1
	 5w3aSqwZ/iCLQ0krYu00Xrs9g7BzeE2289Q7zvAXlqsJg3AmVZy0LMYpmABRp7lsTH
	 zNJJudjFXaa7U7aQmbNfKS5RiBw3IBZQFeqr4pu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1312/1815] hwmon: (cros_ec) Store the hwmon device in cros_ec_hwmon_priv
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065719.819596902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 434baf3aea987ae61d0d54b6cdf8fccf78383b4e ]

The upcoming locking scheme for thermal devices will require access
to the hwmon device.

Add it do the priv struct.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20260711-cros_ec-hwmon-locking-v1-2-cb6d0fdbb2d3@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 26db27364088 ("hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cros_ec_hwmon.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/cros_ec_hwmon.c b/drivers/hwmon/cros_ec_hwmon.c
index 60341b5cef248..12d0f1bb2a0d3 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -24,6 +24,7 @@
 
 struct cros_ec_hwmon_priv {
 	struct cros_ec_device *cros_ec;
+	struct device *hwmon_dev;
 	const char *temp_sensor_names[EC_TEMP_SENSOR_ENTRIES + EC_TEMP_SENSOR_B_ENTRIES];
 	u8 usable_fans;
 	bool fan_control_supported;
@@ -547,7 +548,6 @@ static int cros_ec_hwmon_probe(struct platform_device *pdev)
 	struct cros_ec_dev *ec_dev = dev_get_drvdata(dev->parent);
 	struct cros_ec_device *cros_ec = ec_dev->ec_dev;
 	struct cros_ec_hwmon_priv *priv;
-	struct device *hwmon_dev;
 	u8 thermal_version;
 	int ret;
 
@@ -571,10 +571,10 @@ static int cros_ec_hwmon_probe(struct platform_device *pdev)
 	priv->temp_threshold_supported = is_cros_ec_cmd_available(priv->cros_ec,
 								  EC_CMD_THERMAL_GET_THRESHOLD, 1);
 
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, "cros_ec", priv,
-							 &cros_ec_hwmon_chip_info, NULL);
-	if (IS_ERR(hwmon_dev))
-		return PTR_ERR(hwmon_dev);
+	priv->hwmon_dev = devm_hwmon_device_register_with_info(dev, "cros_ec", priv,
+							       &cros_ec_hwmon_chip_info, NULL);
+	if (IS_ERR(priv->hwmon_dev))
+		return PTR_ERR(priv->hwmon_dev);
 
 	cros_ec_hwmon_register_fan_cooling_devices(dev, priv);
 
-- 
2.53.0



