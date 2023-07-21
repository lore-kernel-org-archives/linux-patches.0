Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60670200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC495C433C7;
	Fri, 21 Jul 2023 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966024;
	bh=3bWOXFNycvTg51YlQThkRNr4GZ4tVRJM3V2cIC31SGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIkZSHCw6RF4poM9yNuo5lcHjCBZlmY/GEo/y3rEXMl1h5ONT/oRMDkRrwgVMiMv8
	 1xowGyK+v/UvnVsRchwbwJdb0TviuKHZLVrbYXWP13hZJCxnXj/5sXwrYuaOqnHAo6
	 xYwx/Aps9fOgAwfY7w0dyc7Ayz1JeepDHo3crsS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/532] hwmon: (gsc-hwmon) fix fan pwm temperature scaling
Date: Fri, 21 Jul 2023 18:01:04 +0200
Message-ID: <20230721160623.090119352@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit a6d80df47ee2c69db99e4f2f8871aa4db154620b ]

The GSC fan pwm temperature register is in centidegrees celcius but the
Linux hwmon convention is to use milidegrees celcius. Fix the scaling.

Fixes: 3bce5377ef66 ("hwmon: Add Gateworks System Controller support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Link: https://lore.kernel.org/r/20230606153004.1448086-1-tharvey@gateworks.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gsc-hwmon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/gsc-hwmon.c b/drivers/hwmon/gsc-hwmon.c
index f29ce49294daf..89d036bf88df7 100644
--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -82,8 +82,8 @@ static ssize_t pwm_auto_point_temp_store(struct device *dev,
 	if (kstrtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = clamp_val(temp, 0, 10000);
-	temp = DIV_ROUND_CLOSEST(temp, 10);
+	temp = clamp_val(temp, 0, 100000);
+	temp = DIV_ROUND_CLOSEST(temp, 100);
 
 	regs[0] = temp & 0xff;
 	regs[1] = (temp >> 8) & 0xff;
@@ -100,7 +100,7 @@ static ssize_t pwm_auto_point_pwm_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)) / 100);
+	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)));
 }
 
 static SENSOR_DEVICE_ATTR_RO(pwm1_auto_point1_pwm, pwm_auto_point_pwm, 0);
-- 
2.39.2



