Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A6313527;
	Fri,  7 Aug 2026 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115927; cv=none; b=UD4pxPFEGld0amhXpX1a46GZXgPcr2AHADIiOGhwi/ncofFSgRXb9mAmUQSbSR5N9BZuPWFTl5VxI+yEj6DNENiWqvtj+k5GJEX+JjjvK/0grHNqteh8seUaSVwDrDZff79QlT9awBVl4R3X9qw0VpKmgLMcseCpJKEi5FdYnD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115927; c=relaxed/simple;
	bh=YhKrD/HuEv1ymWpgzW+JIi5jz6BN8RvJ87KckISYIVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sULcUuil3svx1DBV0d7nN0UFHZeJc+cttnmdYzzGaesiNiTVMH/9GirCK2kPuy8xNF2Vx6Kjk2lZuSSadrCO37fgqsugOzOudXzINknBAWe8vX/R51epJS9zWIpiOsbwjhgnf4EPKOGhfTV6ajkrDyoUs/A8nYLFfPLP0vxoJ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLTTUhFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLTTUhFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0609B1F000E9;
	Fri,  7 Aug 2026 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115926;
	bh=O5d4YPKtHgaH6pyfbboLY++svWGZXrDhVEOIg8qMQyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLTTUhFM81cA970YTt4phEV7tVQhHiea4CcjzEF9JUc2pq14WlvJtqPtAGmCkovbg
	 QLkLRr1Ybbd6nUJswj0FjB9oUeAP8StEqqpyE9FKfarS1nwQeSjSglMIBHdjbVRzDR
	 rCYCRj0KGM+6SIEbABFH/gQaZnYAdBq4zJsvEopI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/261] hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors
Date: Fri,  7 Aug 2026 16:36:47 +0200
Message-ID: <20260807143416.467417253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4b3a4a18670c..0e0d2236dc536 100644
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



