Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD312BE63F;
	Fri,  7 Aug 2026 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114912; cv=none; b=EJF6ZHL7Qpba4C5TSY10ESE1l7uAxpMxYO1cfZR0Eobfxk3HzhXfp/7D+QqM1UA2qzkA+dXnuuNmpP3sU6zGN00tyW0gRWiK840d7uTR4+1UZ5AuJHMkuS0pM0XQGvm6ZoCan3fmudOGo4vfhowcP7ONM0t1AkbBV6R1UJgRM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114912; c=relaxed/simple;
	bh=JxGsMzl5WB06cyb3XNyPU6IW1PuDZRATQ9mKwI+9PaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz0/6RZ6EbIlI4xJGDsXjKUJt3jRxT1xb/aDv/PuLhZYSuwRTKhPH/7AAs9CJRdnrdVAuyK/bvl1UzEZZoKaJSqqWMHIopLDB8du+uKqpI7IjkRC2meUnBS7SxiACTy4OMnc2l985fcrjxn13ZpqiEc51doEbTVnbZxE2SLFlZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYXHYt5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYXHYt5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC41F000E9;
	Fri,  7 Aug 2026 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114911;
	bh=YiEk5JJ+0wCJX16aVn5yCsyrBvYpB5RyJd+bpma8Hy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYXHYt5KfE3gQDamd1G9mYKnMgSU4j9deL7AKzZKaT0Gg2Fa3Ximv3VcMDCWsj5ri
	 PojRQhc0OrqNDn4Lbvjrk22POA56Dm2Y5RDAtQB4elTM4sUqGHQ67tvpkOTLxLUHjp
	 p3zPA47PhciEW8Hvk9GSExzOUgso2Ss1vZoG/srU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/396] hwmon: (adt7470) Use cached PWM frequency value
Date: Fri,  7 Aug 2026 16:34:09 +0200
Message-ID: <20260807143426.197675382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f0a45538ded6d..43c0130342622 100644
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
 
@@ -796,7 +797,7 @@ static int adt7470_pwm_read(struct device *dev, u32 attr, int channel, long *val
 		*val = 1 + data->pwm_automatic[channel];
 		break;
 	case hwmon_pwm_freq:
-		*val = pwm1_freq_get(dev);
+		*val = data->pwm_freq;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -809,12 +810,14 @@ static int pwm1_freq_set(struct device *dev, long freq)
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
@@ -832,6 +835,10 @@ static int pwm1_freq_set(struct device *dev, long freq)
 	err = regmap_update_bits(data->regmap, ADT7470_REG_CFG_2,
 				 ADT7470_FREQ_MASK,
 				 index << ADT7470_FREQ_SHIFT);
+	if (err < 0)
+		goto out;
+
+	data->pwm_freq = closest_freq;
 out:
 	mutex_unlock(&data->lock);
 
@@ -1285,6 +1292,7 @@ static int adt7470_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct adt7470_data *data;
 	struct device *hwmon_dev;
+	int freq_val;
 	int err;
 
 	data = devm_kzalloc(dev, sizeof(struct adt7470_data), GFP_KERNEL);
@@ -1309,6 +1317,14 @@ static int adt7470_probe(struct i2c_client *client)
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



