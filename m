Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D873D41D138;
	Fri,  7 Aug 2026 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116844; cv=none; b=Ley5UGWb+Qq88wxQDc1pWu/rSS4x/cUN+ULiOc0XQv6hCXjHu1Rd1GIfX4Zfp4oa/TMYHYwYBgL31H9MZ3T+TLkILlMLntlwnqLv//9dO6fceCFoS1kCWoGs7lxvhO/ThDeSmO+VWkypcl4OxamefAUrKFm87M4LKeYUZnWIZXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116844; c=relaxed/simple;
	bh=0kxbfzcKEzyuAwy38gyZFv2GjIiuMHvQP65mYn/kVEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AotMSgTy2MeZEZWzUiRTtUP/UVcncfiAWqhFGE/1+t4GnnTFm5GmWwmETp/ahY3LJEDamp8jyXn5hbjnYwoH8mMjBAP1ujxx0VEbGoXH9Do2vhI6FIDGzvC4boRpyv1fjN3USnxuiZeRL397xq3Be5mox68ghKL1YYBRKyPzxMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvU6xYqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvU6xYqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F4D1F000E9;
	Fri,  7 Aug 2026 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116842;
	bh=A1wcDfsXA4cKH3RRfBWdeHifvJ72EDfPGYjbMkeQWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvU6xYqIr3QDd7eKGAYGycW+EnI+htu691XHwj28cwLkuq3iPhQIhTwtF4RhuzM8m
	 IvTRuD5BGLA4vpCUQXVyZO/eBI3Gg8ZkGcU+KkQu4htHCQ6eeBXl744eorCdxOi6df
	 lprly9I2Zl5CmpmuZwApqmHezeaAfQ/YTGCjqTBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 108/438] hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read
Date: Fri,  7 Aug 2026 16:35:04 +0200
Message-ID: <20260807143430.291330170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 1b46fe9dc8f8de59310f37e6c5e5c0e05ded46c3 ]

If the fan data becomes 0 between the FAN_DATA_VALID() check and the
FAN_PERIOD_TO_RPM() conversion, it will result in a divide-by-zero crash
due to a race with a concurrent update of the cached fan value.

Fix a TOCTOU issue by reading fan data once.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/r/20260727034929.E29B71F000E9@smtp.kernel.org/
Fixes: fc958a61ff6d ("hwmon: (adt7470) Convert to devm_hwmon_device_register_with_info API")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-7-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 1fbca4869b7b6..772d2a409bb5c 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -660,36 +660,33 @@ static ssize_t alarm_mask_store(struct device *dev,
 static int adt7470_fan_read(struct device *dev, u32 attr, int channel, long *val)
 {
 	struct adt7470_data *data = adt7470_update_device(dev);
+	u16 fan_data;
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	switch (attr) {
 	case hwmon_fan_input:
-		if (FAN_DATA_VALID(data->fan[channel]))
-			*val = FAN_PERIOD_TO_RPM(data->fan[channel]);
-		else
-			*val = 0;
+		fan_data = READ_ONCE(data->fan[channel]);
 		break;
 	case hwmon_fan_min:
-		if (FAN_DATA_VALID(data->fan_min[channel]))
-			*val = FAN_PERIOD_TO_RPM(data->fan_min[channel]);
-		else
-			*val = 0;
+		fan_data = READ_ONCE(data->fan_min[channel]);
 		break;
 	case hwmon_fan_max:
-		if (FAN_DATA_VALID(data->fan_max[channel]))
-			*val = FAN_PERIOD_TO_RPM(data->fan_max[channel]);
-		else
-			*val = 0;
+		fan_data = READ_ONCE(data->fan_max[channel]);
 		break;
 	case hwmon_fan_alarm:
 		*val = !!(data->alarm & FAN_ALARM_BIT(channel));
-		break;
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	if (FAN_DATA_VALID(fan_data))
+		*val = FAN_PERIOD_TO_RPM(fan_data);
+	else
+		*val = 0;
+
 	return 0;
 }
 
-- 
2.53.0



