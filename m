Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09774371D1F;
	Fri,  7 Aug 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114055; cv=none; b=odJKfBctkoNdBaUyCN72z8axruF14TsoM6JbPS6kNyUl4jowDKe9xOTEMl1Pfwh19TLYbKBc6OpCFq6yJMymOqYVuiACJXW17U2hLJFGRSUfUCMHiyxCGk2m/xMkBCAQGiwK7Esl6sBYkqGZ/V05Afez7dWIly6ddPr4QZzwMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114055; c=relaxed/simple;
	bh=JaYGq0gP/+oaFGhN3mpL/p1lcInEXltCf7fGmWm3J+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QS270PDgEzcrDIK7/HIz/xr+2FQnpT7+zqsxuO5QRd3z4TMdpKHh3brKA+G3as73vVawN6IaMkYcfkAX2yT4OIMucIWImp434HJMho5MS3GQwl8NnoXdszQwpvowWskFm2v5EGQwaEv5bBI5gvUWhscnOQ3y+P0VL/LAmBXolvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWxLkVxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWxLkVxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C69A1F00A3A;
	Fri,  7 Aug 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114048;
	bh=y+7WISGLjXScJi/ApwZtP6gw1i8AjEIMHL2J6rYGdyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWxLkVxEC0RcUqMeyaLysWonHHUp19wetmkTZmgUjETDIQeYrS5GNPcNlElUPDA1u
	 s4F8MFI72em2LcJABrcxwjy4+TkJZFzzp1zqWtKvFDZ0UQj+WE6XYAo1AxvespoXTD
	 QJ9OjMVH1lOKMIoZGTPYxLFCs2EgNB3xRcql173A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/337] hwmon: (adt7470) Use cached PWM frequency value
Date: Fri,  7 Aug 2026 16:34:44 +0200
Message-ID: <20260807143420.269785018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



