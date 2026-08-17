Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA943DA3A;
	Mon, 17 Aug 2026 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977281; cv=none; b=ieQS3md6dyZB4SCL/dqR7b4VxCEbDJ4CZRBIfqtdx1OPpyB/FhDCjo120/zXCpYUz8XAEKwG58AQX5daVK7qiCRAF4BTYUO1/BHotbC6Wsdk2T+71A/HrzgUWPQ5SEktpCxw9tqKGc1VBt6g9q/4qkLDh3G3eKFp0DO0f6AkZZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977281; c=relaxed/simple;
	bh=BkFIcqnZQImbkb0DRvZ3pcALgG18WFSyB1RLdmAYJc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MESuaYmKcipQo6jocNC/emrDN3UUUwx5fyhm1JGRoJ9N9xy6K1NMdwIH5IqslIa0XaBw+ZZJr0jCIPT1JLRrHM6QndB0g3L3FLF9TXwboTdtxtAN5FB6TFHbe4tdZ5LT85JxPXIuGoEAACZ6MzdADeQaHQMOW2NZBJBMSkPQQ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzJvZDqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzJvZDqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BEC1F000E9;
	Mon, 17 Aug 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977280;
	bh=nVT5LdIhmp0m+sEy7IJqK06tQMHDKzr7Ck+g7MDJfFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzJvZDqwxFjc+gQ7lM5FOIytwG89Z9M4o1riA2uirW3w9wyCCRP20EavEE5RS95jz
	 A0NFbk+Styb4Smpt28TjODjoDnN7t17EXIq2mSaZwq3jrb34CgSIRyoVnJS4Ps91XC
	 P7HKk05PtCP5PqQXBolXd0P78LuB7/rLSSwmfb6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/456] hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors
Date: Mon, 17 Aug 2026 15:30:58 +0200
Message-ID: <20260817132550.475065635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 625a2c02a1c04571232a746fe188b4d9a8d63edd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index c67cd037a93fd..57c78e82a5f27 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -205,11 +205,12 @@ static inline int adt7470_write_word_data(struct adt7470_data *data, unsigned in
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
@@ -233,19 +234,19 @@ static int adt7470_read_temperatures(struct adt7470_data *data)
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
@@ -256,13 +257,30 @@ static int adt7470_read_temperatures(struct adt7470_data *data)
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
 
-- 
2.53.0



