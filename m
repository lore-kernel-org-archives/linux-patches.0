Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AF2390C90;
	Fri,  7 Aug 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114057; cv=none; b=C4JsrRbvHZBzFanPc2fiiBxuRSb/5JkTbMRwZYB9+Nny7y8dTjRxHyByYUd6cpDGrqj49dHUFVj8gjE+aIXehIL7NWZ2BcicLEOxj+24gwPOQ/pNrH4mNjbA1/PwqQdA6JiGU1+FfspReK59glYPHa8VvgL2gHrnhBNniFWvFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114057; c=relaxed/simple;
	bh=7jVjdZ8lTGKrSvv+a8uYmUZBCTkaNLOdqRbAyFROEJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpxrlWO9FceUVmIoAxU6ySrtu7FNBHPYLx72F07w98HQ9Aw7ZSSk+wjaz3gmKNoZwCoN71ZSrmHlQY842WjXM3MzIr2u+WoaiU09dPz0vVdi05APwLHBIzDDtDOg4cWWCQFMi5IVSkRyQ+lZs501ZJ9R/3WgSSaJ9Z7RAVKpWvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVTtRIfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVTtRIfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217E61F000E9;
	Fri,  7 Aug 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114051;
	bh=HUHv+Pu0sKMp04eQYhNgVx/dme2BXqPN8L3d7ixXXNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVTtRIfrInQzYRIg07oF99zO4u8EqqHDAAzFvUOpwcB46hnLVKFZwpCGp6VR1lazh
	 swewlLoGw6D6jIJvZzbWX8IsJlUKDFPlT0hmz3eR8H5YZHeA1t7dfLNu1UehAL8ZTz
	 mMVGnXFN4mBNdxkH80C0aF1rj0fP45bipfxrGSRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/337] hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read
Date: Fri,  7 Aug 2026 16:34:45 +0200
Message-ID: <20260807143420.290450906@linuxfoundation.org>
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
index 43c0130342622..3a2d408a45be8 100644
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



