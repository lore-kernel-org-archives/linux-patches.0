Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0352DC783;
	Mon, 17 Aug 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977396; cv=none; b=BuRKmD+I31xwUbc2yNYiHkpAcF8bTtENzYPNGSu8hnwy8udgkJNexNBDfRyLB1vjaaAUldn2PzaYQetQqSvx8tWCVDy5OMOvAbbeItjfOjWqNUzgIgzKK5h7OX2PuhTQjOfroxGNT8NRyLV9yRUQC4GG00b9WlIQQB8SzvKjnNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977396; c=relaxed/simple;
	bh=G2Id+jUO5AEz7kmOE2mlNUrRiooNDQbFgfHB/GQHJXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsjZxORxOGfLHHtvtWlo8I9UK3kdJ/d/ceN7au949QYf/wEC498ijSFGzzs7DS1XiE3TDsC5aniHhae5MMdztlii4L7gkMuuQWDVc2E+oEq9y6MF8fGBBirspaooWZP457d804T2OROjHqgH/87pfC+a1smMLg7WiEgRTVP+RP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h81ntuS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h81ntuS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C51F000E9;
	Mon, 17 Aug 2026 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977394;
	bh=cfa8Fp4X4E5dLd+DTIjCrr5zOD8Y+39OiR43z/eJ3Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h81ntuS620cxLBDu5SMe124rHo2ylX2wbAr0dzrqpmlvYJxXqT+3OfMaOWev17k8w
	 oPpznF8uQwV2GzD5OADpVtkfBb0msGO45A/oIWvqSzU+h/JTYXaJccEO9nV8E4jpT0
	 najR0C4CV1mwTxTFSVg8pOm8SOdcY1+E0FcCaEfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/456] hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read
Date: Mon, 17 Aug 2026 15:31:04 +0200
Message-ID: <20260817132550.687461444@linuxfoundation.org>
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
index 3fcc10d0d3639..394f0aba3493a 100644
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



