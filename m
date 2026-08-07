Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB932F0C74;
	Fri,  7 Aug 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115930; cv=none; b=WYmwSDAFw5D7KsIrLpjFLL2ip8SVoXOBkFeSJ04kRhA6VX3WTMiIGC33GrEnraD6AOHPeQPhvdDpdn6vNdMmVjv0AvMckDXRs11zs6IlISMyPerReshrRT+W3WTMx8UyZqz0Alm0CGDE+hozat696UOC5YOUm437hQ3GvXsg70s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115930; c=relaxed/simple;
	bh=/R0nDAcZRPXyNS1cyqh1Y6IbzBZlMM2L53HRihVtV1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/v8pK2hOPuPwctaVl7ZWp8pF8ev4+QjH7W4rmywu095j+csZ4pALF5aSwJBwAbU4CzEhkX8AAA6DYwQa/QoAGgV7ym3UlUdjlQjDa70GjnUQW2UG3r47O6uFi91U4pJ6baAPzOSre43grbnsFvZG2QkJx2HIs59mofo1dwjUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJWheyRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJWheyRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D641A1F000E9;
	Fri,  7 Aug 2026 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115929;
	bh=17Xl9ZqE4rxde8zV89tKmhekUgabvtAJQL4RNuGuHAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJWheyRKVN8sIXMWSz0HBr1Ka5NcqgW1ZGnycvN6+gIIeVkX/CivSWbroLkc/nXa/
	 wFVR3/jtegxt27ohOFtE+m5XydLV/bEIPETxweCiaUuUQ6yh4Zx/7sYlvi6h6jnCLh
	 diFr7TaCLwaVtmyxczLiYYGiQLdKqLCWJXgUxovw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/261] hwmon: (adt7470) Fix cache updated before hardware write on I2C error
Date: Fri,  7 Aug 2026 16:36:48 +0200
Message-ID: <20260807143416.487636471@linuxfoundation.org>
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

[ Upstream commit 05270bd38d9bf88a2f4c212246a8fa29f4032078 ]

adt7470_temp_write() and adt7470_pwm_write() update the driver's
cached values (temp_min, temp_max, pwm_input, pwm_enable) before issuing
the corresponding regmap_write(), and never check whether the write
succeeded before committing that update. If the I2C transaction fails,
the function correctly propagates the error to the caller, but the cache
silently keeps the new value, which was never actually applied to the
hardware. Subsequent reads then report a value that does not match the
device state.

Reorder both write paths to update the cache only after a successful
regmap_write(), so the cache always reflects what was actually
written to the hardware.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-2-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 0e0d2236dc536..3d4b4b6bd47fd 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -589,14 +589,16 @@ static int adt7470_temp_write(struct device *dev, u32 attr, int channel, long va
 	switch (attr) {
 	case hwmon_temp_min:
 		mutex_lock(&data->lock);
-		data->temp_min[channel] = val;
 		err = regmap_write(data->regmap, ADT7470_TEMP_MIN_REG(channel), val);
+		if (!err)
+			data->temp_min[channel] = val;
 		mutex_unlock(&data->lock);
 		break;
 	case hwmon_temp_max:
 		mutex_lock(&data->lock);
-		data->temp_max[channel] = val;
 		err = regmap_write(data->regmap, ADT7470_TEMP_MAX_REG(channel), val);
+		if (!err)
+			data->temp_max[channel] = val;
 		mutex_unlock(&data->lock);
 		break;
 	default:
@@ -839,9 +841,10 @@ static int adt7470_pwm_write(struct device *dev, u32 attr, int channel, long val
 	case hwmon_pwm_input:
 		val = clamp_val(val, 0, 255);
 		mutex_lock(&data->lock);
-		data->pwm[channel] = val;
 		err = regmap_write(data->regmap, ADT7470_REG_PWM(channel),
-				   data->pwm[channel]);
+				   val);
+		if (!err)
+			data->pwm[channel] = val;
 		mutex_unlock(&data->lock);
 		break;
 	case hwmon_pwm_enable:
@@ -855,10 +858,11 @@ static int adt7470_pwm_write(struct device *dev, u32 attr, int channel, long val
 		val--;
 
 		mutex_lock(&data->lock);
-		data->pwm_automatic[channel] = val;
 		err = regmap_update_bits(data->regmap, ADT7470_REG_PWM_CFG(channel),
 					 pwm_auto_reg_mask,
 					 val ? pwm_auto_reg_mask : 0);
+		if (!err)
+			data->pwm_automatic[channel] = val;
 		mutex_unlock(&data->lock);
 		break;
 	case hwmon_pwm_freq:
-- 
2.53.0



