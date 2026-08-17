Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A313790B;
	Mon, 17 Aug 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976486; cv=none; b=k5tSLEudH5vN7jj3XYzodjX4I2+57e5fNbr2dGZLB8NKRuDnjORH2OU99gRG7FHhlRF8ea8QsJiPM/P8Cnlo4360qIFpXK073rKoz18fdcVLWmwqZzCH3Hd4CXbnv62h0qU6A/Cg6/8B4BHO2eAwhdR9aEwdcj7pPkjQFmCpq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976486; c=relaxed/simple;
	bh=YHNdFeJjkraaTp1wpltnciEC7/HR6rEdHL9LEKsYGrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCTvROWQjJev6uI5n3G35gPJDY86REi6Rv4P0JhYgw71q9XGqJo9FLxX2bOJfTBu+jJLgK4ZeF6P0AVR9vbS4sR0/kawFsy4q0vImrYUUGMAeCwMRip6+3aMbj1snjqserlTO82CMyvRUTevbofZYJG89DjcMuQEtpMskAI+WKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLmz2Vhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLmz2Vhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53231F000E9;
	Mon, 17 Aug 2026 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976485;
	bh=wVNAVW0P9GS8OIvqXFUz0p1VzimWuh0zoR6cGUO/VAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLmz2Vhv7vlopJAhQMUaIp3a1tMbUlNdiFBVtdQW3CUV6cwRwRtModXIsqILZS0VR
	 bFaeIhAPmyDRAHhbJwFxJO7t0fWU3hkfDLmnuY0hcYYVBPNr1kAHDB1lrH6ECbF/xh
	 2cTHsHsWKVqYUVa5AOxdOJMXU/lkOsAs1due1TGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 389/389] hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors
Date: Mon, 17 Aug 2026 15:33:48 +0200
Message-ID: <20260817132553.819289647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

commit 625a2c02a1c04571232a746fe188b4d9a8d63edd upstream.

During adt7470_read_temperatures(), the driver temporarily switches
the PWM channels to manual mode, performs the temperature collection,
and then restores the original configuration registers.

However, if an I2C transaction fails at any point after entering manual
mode, the function aborts and returns immediately. This leaves the
configuration registers un-restored, permanently trapping the fans in
manual mode.

Introduce a recovery path to ensure that the original PWM configuration
registers are always restored, even when intermediate I2C operations
fail.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/r/20260716213252.EACA71F000E9@smtp.kernel.org
Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-1-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/adt7470.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -205,11 +205,12 @@ static inline int adt7470_write_word_dat
 /* Probe for temperature sensors.  Assumes lock is held */
 static int adt7470_read_temperatures(struct adt7470_data *data)
 {
-	unsigned long res;
+	struct device *dev = regmap_get_device(data->regmap);
+	u8 pwm[ADT7470_FAN_COUNT];
 	unsigned int pwm_cfg[2];
-	int err;
+	unsigned long res;
+	int err, err2;
 	int i;
-	u8 pwm[ADT7470_FAN_COUNT];
 
 	/* save pwm[1-4] config register */
 	err = regmap_read(data->regmap, ADT7470_REG_PWM_CFG(0), &pwm_cfg[0]);
@@ -233,19 +234,19 @@ static int adt7470_read_temperatures(str
 	err = regmap_update_bits(data->regmap, ADT7470_REG_PWM_CFG(2),
 				 ADT7470_PWM_AUTO_MASK, 0);
 	if (err < 0)
-		return err;
+		goto out_restore;
 
 	/* write pwm control to whatever it was */
 	err = regmap_bulk_write(data->regmap, ADT7470_REG_PWM(0), &pwm[0],
 				ADT7470_PWM_COUNT);
 	if (err < 0)
-		return err;
+		goto out_restore;
 
 	/* start reading temperature sensors */
 	err = regmap_update_bits(data->regmap, ADT7470_REG_CFG,
 				 ADT7470_T05_STB_MASK, ADT7470_T05_STB_MASK);
 	if (err < 0)
-		return err;
+		goto out_restore;
 
 	/* Delay is 200ms * number of temp sensors. */
 	res = msleep_interruptible((data->num_temp_sensors >= 0 ?
@@ -256,13 +257,30 @@ static int adt7470_read_temperatures(str
 	err = regmap_update_bits(data->regmap, ADT7470_REG_CFG,
 				 ADT7470_T05_STB_MASK, 0);
 	if (err < 0)
-		return err;
+		goto out_restore;
 
+out_restore:
 	/* restore pwm[1-4] config registers */
-	err = regmap_write(data->regmap, ADT7470_REG_PWM_CFG(0), pwm_cfg[0]);
-	if (err < 0)
-		return err;
-	err = regmap_write(data->regmap, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
+	err2 = regmap_write(data->regmap, ADT7470_REG_PWM_CFG(0), pwm_cfg[0]);
+	if (err2 < 0) {
+		dev_warn_ratelimited(dev,
+				     "failed to restore PWM{1,2} config (%d)\n",
+				     err2);
+
+		if (!err)
+			err = err2;
+	}
+
+	err2 = regmap_write(data->regmap, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
+	if (err2 < 0) {
+		dev_warn_ratelimited(dev,
+				     "failed to restore PWM{3,4} config (%d)\n",
+				     err2);
+
+		if (!err)
+			err = err2;
+	}
+
 	if (err < 0)
 		return err;
 


