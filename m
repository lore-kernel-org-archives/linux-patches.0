Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC71B4E7817;
	Thu, 17 Sep 2026 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664433; cv=none; b=hL3ix+Rpvf4MWtv/SaYIlIPboT1Lzv+UQMVpt+o8T7h8cTRQez6SxM/Mb8gJARCPJ6uBAFjVsOpOBaNji8e1gzLyewn3DhVhRuJ3iIYkzrFf8qrZVK0T4ZmW7owggtRTr4D7j0nA9XQoH7sjt9Nou5ezp3jPFzpGv4lwYBJOLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664433; c=relaxed/simple;
	bh=o7e0+yXiW8O0pldMF9omnQ7jtNvey2tWlj7ffIKRcUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3OnRayN0bNI0RSIEXrM2PxBSjKdpU4b5937bs3/eH3rGLRZUldIh7Y2N4suEOxQYnb9wNDeZJGb+KzpmjwRcKCzEYictcXyiOg6vsGdFt5uOiIPpSFKs7xJoWWuQpvhbcM/cKGx5dP3ndEZu7t4GN7Zz2IGHR6yKiWVCBCP16w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1A1jZaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1A1jZaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0681F000FF;
	Thu, 17 Sep 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664431;
	bh=qtPCXssHm9jT4gsZFStUkc/jAhwQHAAo4Mq9uUDO4mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1A1jZaF72lyati1Yd9v4BWbOK/jCxo+BkZCCxYPOxVMTyWnpJsHABkwbdRheraPz
	 y1mVCnauDS9oVEWiueY9Z3IhtidYCirSoWtj9MKF9Y2VY9+hqY8ffrtdij4u/ucdAR
	 h1buzfabG6Y8pRzyfFMY8gnasbcu3JOaGW4zh0AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Chakraborty <chakrabortyshubham66@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0371/1250] hwmon: (raspberrypi) Fix delayed-work teardown race
Date: Thu, 17 Sep 2026 16:02:46 +0100
Message-ID: <20260917151602.113188749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Shubham Chakraborty <chakrabortyshubham66@gmail.com>

[ Upstream commit eb0d491e2787aa359f0d930151ff6e5e5df70fb9 ]

The delayed polling work rearms itself from the work function, so use
explicit delayed-work setup and cleanup instead of
devm_delayed_work_autocancel().

Initialize the delayed work with INIT_DELAYED_WORK() and register a
devres cleanup action that calls disable_delayed_work_sync() during
teardown.

This addresses the concern raised during review about the polling work
being able to requeue itself while the driver is being removed.

Signed-off-by: Shubham Chakraborty <chakrabortyshubham66@gmail.com>
Link: https://lore.kernel.org/r/20260517080445.103962-4-chakrabortyshubham66@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/raspberrypi-hwmon.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/raspberrypi-hwmon.c b/drivers/hwmon/raspberrypi-hwmon.c
index a2938881ccd2f..b0f0f50986b9a 100644
--- a/drivers/hwmon/raspberrypi-hwmon.c
+++ b/drivers/hwmon/raspberrypi-hwmon.c
@@ -7,7 +7,6 @@
  * Copyright (C) 2018 Stefan Wahren <stefan.wahren@i2se.com>
  */
 #include <linux/device.h>
-#include <linux/devm-helpers.h>
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/module.h>
@@ -72,6 +71,13 @@ static void get_values_poll(struct work_struct *work)
 	schedule_delayed_work(&data->get_values_poll_work, 2 * HZ);
 }
 
+static void rpi_hwmon_cancel_poll_work(void *res)
+{
+	struct rpi_hwmon_data *data = res;
+
+	disable_delayed_work_sync(&data->get_values_poll_work);
+}
+
 static int rpi_read(struct device *dev, enum hwmon_sensor_types type,
 		    u32 attr, int channel, long *val)
 {
@@ -117,8 +123,8 @@ static int rpi_hwmon_probe(struct platform_device *pdev)
 	if (IS_ERR(data->hwmon_dev))
 		return PTR_ERR(data->hwmon_dev);
 
-	ret = devm_delayed_work_autocancel(dev, &data->get_values_poll_work,
-					   get_values_poll);
+	INIT_DELAYED_WORK(&data->get_values_poll_work, get_values_poll);
+	ret = devm_add_action_or_reset(dev, rpi_hwmon_cancel_poll_work, data);
 	if (ret)
 		return ret;
 	platform_set_drvdata(pdev, data);
-- 
2.53.0



