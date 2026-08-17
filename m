Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD3A43F092;
	Mon, 17 Aug 2026 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977315; cv=none; b=DZCdHmh0Qh8ipswU6A56fCt5PKmOgD+b1fK0nc/BgJ1gApUSGJYeKEXkPW/RGA3vgrb4KDIisZjMuNvtxdn0DKkjXHjOTTxTgk9ck7htZcK8CYqJhFXgmaUHie1MKkS7z/hkd9BMJMcxqQIde4gBjSZbm0PRbT4aVcuxKlET4k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977315; c=relaxed/simple;
	bh=GNjj+mAGpG30H1OLTqbEba0RSztgWYng8ULlBY1Qzpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMmDfktzqKJ+HaVbFTm1lP8j7bPERi/8ay5RG/f256zn6tAVandsC3lPyLAKx+qaABtiycIMjnCwzaexXXtJJ9I02LiyupchZRFoD9P2sLxkGgkjdXQdM9XJhEr05p/yLDeesDYRZn6/kmgGlW6wbuFTaCZlMvTv9PUcSRogLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRK0iRGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRK0iRGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEC41F000E9;
	Mon, 17 Aug 2026 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977312;
	bh=8/KORotAK55t6gCd004uJeZd1e/Yd1ctKDtMB4W6ZmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRK0iRGI4XvHncATYaVHDzztIcwoZOv8n0/GBA3/Mt/O6cnhy7ccdw0Sh40lKtLro
	 +C/mCXYQX9j8sWPRkRDH+R7ZUYPUdff+0Ue+d13w2tH21tgcxTEr4KU6COHLFQQPta
	 GLhXgqwrJsDIyy9gY/zjLTV7YXhg/9+F/cbL3qRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/456] hwmon: (adt7470) Fix cache updated before hardware write on I2C error
Date: Mon, 17 Aug 2026 15:30:59 +0200
Message-ID: <20260817132550.510957923@linuxfoundation.org>
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
index 57c78e82a5f27..6aa6152e00337 100644
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



