Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0492440A13;
	Mon, 17 Aug 2026 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979874; cv=none; b=Y6DWXJ/XPzXLacJtBfSIDX6c8ICRiupSZT81PyB0qI0cYW6j+jJCFyLUexEZQVXWjqrgkSK4fZVeuD6zI8eQdWw+vseVme9JOPvkKVs+i9QGd+q/nCqbQ5Ax8Py6omGgYidkV+RYinoS35nVmslSDTuasWfaIG+39UEDtKSGpdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979874; c=relaxed/simple;
	bh=UJAzMi23dk7mLDLlw0akUZIgUpt4tLAGzWyju+P6Dr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWwJYWnl7bKjK5SZdaewWpqj+XJ9w3pfxstKnTgfPGbdl8sl9v9OWv9l14BfQyOtxIvvtNZZSkOzSzlCwcxo4r23T8AAiqKaTRCrmLYa5tX4FLhsncgm57LXevgpa76zeBwil47mbz68PqTTY+0dzgbYr+ab1CI2MY4yYaw+kjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLyVnzbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLyVnzbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166441F000E9;
	Mon, 17 Aug 2026 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979873;
	bh=Sbgmsfg7GYFKVcZ3shPzPgNcNn4Jjzf3LHlkHmCxNpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLyVnzbA3JBgao6UFw3fBjBVII6JwYMPWsVIdc8/8ho0X8c9duVTaAISVRULFpBVq
	 7M8OTTJmq8kYruiz6vTE/4/W2atQGW5hdeL3af8LrkhngaLnUNv/+/npUTf3zU63sQ
	 RdcHLJHLPmtvX0IaVLaA+OMQS9vwhvu3l+tfrwxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 360/609] hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read
Date: Mon, 17 Aug 2026 15:30:56 +0200
Message-ID: <20260817132556.332851586@linuxfoundation.org>
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
index 1ac26a510bfe2..8010ed6f86a18 100644
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



