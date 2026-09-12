Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3784B3290B0;
	Sat, 12 Sep 2026 10:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210707; cv=none; b=Y6XWG45G9m8sZnZxFwScf0X+WSpsQu6OUnqPejCSEwCsylRvsq61hOT3oqG2C5PuGgJ8x/gxlnWGHaP9mOTTl6UihohDARbAKbiuig2IPhfJgFcSwO7+5PUrQt1GWvs/+jXFHpZRTVeTGgMYtnwkUJ66bmzB/T77CSQhT4siZhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210707; c=relaxed/simple;
	bh=3lzBqk7UfyI0Phv5E/ttpD4X9YxtdiGZaihtlap/wdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdoeanB9capq2BykfFcdOxfJkzB2hIhceN20dc9iuh9vgY7JBlKJErBg2FGBlOs4oQdHvVWJZI7PoxOjnirWea4TEa3SCMgiSjnE+Cps4PZNVaTm7SeylFSzCqCZPOBp3DHMsLLokExdmvnXofQKSb+KtsftI9rKxXO3/mxNoGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8ViL8vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8ViL8vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CE1F000FF;
	Sat, 12 Sep 2026 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210706;
	bh=nlAt/hnzXoqqlr+E92W1ERIfD6gtRZtmOVWrMg26yjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8ViL8vmDEPD/P+M0+AKpcziwMk4EwuhH5Qr1AFs9SBH9y9QPsv6hDW7tCHT2+yw2
	 9VNR+MUmuEi+Ypu0mwBxrpcj8hrZAENwbzWfsQjU85M6GjeaUUwBZJJIep7GYuovFI
	 wQNn8HxyerYaW9S41m9uHXm0bqZLmdYxyG8d6KtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1081/1518] hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks
Date: Sat, 12 Sep 2026 08:54:10 +0200
Message-ID: <20260912065647.904122488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 26db273640887276a24ca2546b06e334508871f8 ]

To guarantee consistency for the read-modify-write access in
cros_ec_hwmon_cooling_set_cur_state(), locking is necessary.

Use the existing hwmon device lock to do so.

Fixes: 5798b62867b4 ("hwmon: (cros_ec) register fans into thermal framework cooling devices")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20260711-cros_ec-hwmon-locking-v1-3-cb6d0fdbb2d3@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cros_ec_hwmon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/cros_ec_hwmon.c b/drivers/hwmon/cros_ec_hwmon.c
index 13f638b7d829f..f39401606e750 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2024 Thomas Weißschuh <linux@weissschuh.net>
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/hwmon.h>
 #include <linux/math.h>
@@ -379,6 +380,8 @@ static int cros_ec_hwmon_cooling_get_cur_state(struct thermal_cooling_device *cd
 	u8 read_val;
 	int ret;
 
+	guard(hwmon_lock)(priv->hwmon_priv->hwmon_dev);
+
 	ret = cros_ec_hwmon_read_pwm_value(priv->hwmon_priv->cros_ec, priv->index, &read_val);
 	if (ret)
 		return ret;
@@ -392,6 +395,8 @@ static int cros_ec_hwmon_cooling_set_cur_state(struct thermal_cooling_device *cd
 {
 	const struct cros_ec_hwmon_cooling_priv *priv = cdev->devdata;
 
+	guard(hwmon_lock)(priv->hwmon_priv->hwmon_dev);
+
 	return cros_ec_hwmon_write_pwm_input(priv->hwmon_priv->cros_ec, priv->index, val);
 }
 
-- 
2.53.0



