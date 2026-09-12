Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68486470EB9;
	Sat, 12 Sep 2026 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210703; cv=none; b=NntNdJ0oGylUZ//XxouqZ8gcQTRvfOOsRLKwBCi7BlBOpR1ZN5fFxw7oztiJBKv5hRg1Lc37itk1BjS8jAK6Wdh6uFevg6FLXmJQD5fKRRfulQ+b4jZdw+0agEbRMx//Gb2TNpVQxxtgO38iH981aCPFnaJz0KXYZXI5jCcgAlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210703; c=relaxed/simple;
	bh=B9Tx2/FYXU8uwRraY/mUlznll//fqOhKE9j4i84CGT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+rWnXPAmNkBSPEh/uOlBxxmCPaXMJrUC4b5Ep8awDXxayr5DJxzopc2uqrSJaL7rEYJkCffu77d4jA48ugEFR6cLEz0E/wXzqjBSAnwbGLyj2FnKDq2F2D1qM0ZXSF5AFx7qyH1n9DATzBz7f3DzqJjjD7B7PlY5MOnSBPxrk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1zK5giK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1zK5giK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090B01F000FF;
	Sat, 12 Sep 2026 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210701;
	bh=LyMVSFVEXCzePZdXPItxZZMqwS8HuirPgs1C24bOSHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1zK5giK2StWTxHeblpEqPvkSLEuDL4SigHe2J3SynGcTEA09pma+MB3uxBG0OPih
	 eVdnWALpRhCrUylo/dWF5F+l04pnk6ym9bn0uCVZXwL4YVoyzuNH+VlrW0Q4aNUWQo
	 O/79Q0X+DNUAxPOWF9CAlLMOVnpl3FsZC83Kd6ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1080/1518] hwmon: (cros_ec) Store the hwmon device in cros_ec_hwmon_priv
Date: Sat, 12 Sep 2026 08:54:09 +0200
Message-ID: <20260912065647.880997528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8065072b0988c..13f638b7d829f 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -25,6 +25,7 @@
 
 struct cros_ec_hwmon_priv {
 	struct cros_ec_device *cros_ec;
+	struct device *hwmon_dev;
 	const char *temp_sensor_names[EC_TEMP_SENSOR_ENTRIES + EC_TEMP_SENSOR_B_ENTRIES];
 	u8 usable_fans;
 	bool fan_control_supported;
@@ -524,7 +525,6 @@ static int cros_ec_hwmon_probe(struct platform_device *pdev)
 	struct cros_ec_dev *ec_dev = dev_get_drvdata(dev->parent);
 	struct cros_ec_device *cros_ec = ec_dev->ec_dev;
 	struct cros_ec_hwmon_priv *priv;
-	struct device *hwmon_dev;
 	u8 thermal_version;
 	int ret;
 
@@ -548,10 +548,10 @@ static int cros_ec_hwmon_probe(struct platform_device *pdev)
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



