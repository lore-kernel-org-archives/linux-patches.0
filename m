Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122F442FA4;
	Mon, 17 Aug 2026 15:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979844; cv=none; b=g6xs2cWDIR/YPhEZK43kksQANZUqtGdYFwG+M5E7cVjW872Yusm1dMwc5rA9SaI8bU1EW/pvPJM56Frw00BA0YYmv2gUaVIsKkJ4DZ2QBFZm33pnGcqUYwbnjHTCCbkOcDPcPWvSY0zEj2T0esu4gwsxiRB0zmbXhBQT3a2p+rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979844; c=relaxed/simple;
	bh=kgiqxwMEE/+swZG5mNWj7EZUz9MRuy57+MFeOuxTDdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzhEQfdCTRqwJqZa4w1oj0hPPeUyL05h83cAYIKm+G0TKuPmdFegBJLqilYF4JGMC1QQOkzvk/t+d+TX3g2Vozr0sAkFXOKQClBEkxqKglbiMr2FkyrsPTtzkjFlvbEFc0cb/Hk8z7rC+phu2jY8M9XyddGK19yLVVZ/7eGztuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaP2IsGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaP2IsGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2C01F000E9;
	Mon, 17 Aug 2026 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979841;
	bh=QOCWvir80vTF2RvYX1xLF2vSvFOfp5F6acgqGMCZhrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaP2IsGfiN5eC1jpwb6sgjx8m5shXi2Y69hGD2FbXt4fiRZTuxWOWY6riWjYsvuMl
	 ITVC3txnFRFSEzKXyyrvqag03WDkoZeIdMdn2vd/YL7JfLT2/qrV5yoR3Vsn7Xthkc
	 9Ker6NyBb/k4mMjoV/Zs+mMG0hzP29T33kVEcxkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 359/609] hwmon: (adt7470) Use cached PWM frequency value
Date: Mon, 17 Aug 2026 15:30:55 +0200
Message-ID: <20260817132556.299214889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 60677cd4c28f44d5b307d3029dccece38fcce90f ]

adt7470_pwm_read() currently ignores failures returned by
pwm1_freq_get(). If the register read fails, the negative error code is
returned through *val while the function itself reports success,
potentially exposing a negative PWM frequency through sysfs.

Fix this by using the cached PWM frequency maintained by the driver,
eliminating the register access from the read path.

Apart from the corrected error propagation and using the cached value,
no functional change is intended.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-6-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index a5bef97c8e0d3..1ac26a510bfe2 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -182,6 +182,7 @@ struct adt7470_data {
 	u8			pwm_min[ADT7470_PWM_COUNT];
 	s8			pwm_tmin[ADT7470_PWM_COUNT];
 	u8			pwm_auto_temp[ADT7470_PWM_COUNT];
+	u32			pwm_freq;
 
 	struct task_struct	*auto_update;
 	unsigned int		auto_update_interval;
@@ -756,7 +757,7 @@ static ssize_t force_pwm_max_store(struct device *dev,
 }
 
 /* These are the valid PWM frequencies to the nearest Hz */
-static const int adt7470_freq_map[] = {
+static const u32 adt7470_freq_map[] = {
 	11, 15, 22, 29, 35, 44, 59, 88, 1400, 22500
 };
 
@@ -804,7 +805,7 @@ static int adt7470_pwm_read(struct device *dev, u32 attr, int channel, long *val
 		*val = 1 + data->pwm_automatic[channel];
 		break;
 	case hwmon_pwm_freq:
-		*val = pwm1_freq_get(dev);
+		*val = data->pwm_freq;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -817,12 +818,14 @@ static int pwm1_freq_set(struct device *dev, long freq)
 {
 	struct adt7470_data *data = dev_get_drvdata(dev);
 	unsigned int low_freq = ADT7470_CFG_LF;
+	u32 closest_freq;
 	int index;
 	int err;
 
 	/* Round the user value given to the closest available frequency */
 	index = find_closest(freq, adt7470_freq_map,
 			     ARRAY_SIZE(adt7470_freq_map));
+	closest_freq = adt7470_freq_map[index];
 
 	if (index >= 8) {
 		index -= 8;
@@ -840,6 +843,10 @@ static int pwm1_freq_set(struct device *dev, long freq)
 	err = regmap_update_bits(data->regmap, ADT7470_REG_CFG_2,
 				 ADT7470_FREQ_MASK,
 				 index << ADT7470_FREQ_SHIFT);
+	if (err < 0)
+		goto out;
+
+	data->pwm_freq = closest_freq;
 out:
 	mutex_unlock(&data->lock);
 
@@ -1293,6 +1300,7 @@ static int adt7470_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct adt7470_data *data;
 	struct device *hwmon_dev;
+	int freq_val;
 	int err;
 
 	data = devm_kzalloc(dev, sizeof(struct adt7470_data), GFP_KERNEL);
@@ -1317,6 +1325,14 @@ static int adt7470_probe(struct i2c_client *client)
 	if (err < 0)
 		return err;
 
+	freq_val = pwm1_freq_get(dev);
+	if (freq_val <= 0) {
+		err = freq_val < 0 ? freq_val : -EINVAL;
+		return err;
+	}
+
+	data->pwm_freq = (u32)freq_val;
+
 	/* Register sysfs hooks */
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name, data,
 							 &adt7470_chip_info,
-- 
2.53.0



