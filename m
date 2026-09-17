Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B53E9F9E;
	Thu, 17 Sep 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667953; cv=none; b=LTu/h8E12BEQuEOdd/0rHMVIDiayrqNsFGpKqVQyH33Bjxs3pdheRKdB/FWBKlkcfDqg86TAOgFzj0AJNekZ8AdkKWDcTkN2sbmONPXe066LaZHzE0umRS+bJQllTqsSo/fNcOcpBYCcbvEvSwMt5ZzqUC/7cEwxMUAFYcqQPNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667953; c=relaxed/simple;
	bh=eXTM6AALbfFqWy2JO6n0gbKh2CtyGFDXqDJV74/RBZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6zvs/30hcvncYsOLGynUTJt4TVcZlQ0Yjqi+VfCfcXKmesgp1teoLmyMLeFxlPTlj+igoWlnD/poYt3h9v5klG0IXcTAR4iMdRxFljnd3rI6zoosqWK8IilpfN8fisDC3fi1yt+s5oVxl+7igd3mh+kPGmYACs2I5Q6aKsTaXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYOnxhQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYOnxhQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659421F000FF;
	Thu, 17 Sep 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667951;
	bh=iftC37FqHebA7lntX0AAJJ5whnMC5OsN4y1L0BQ43BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYOnxhQ9MYgDyyTIgLzyVSnasSi5RvLzfiw9+xxnqFQtFOAX6sBoqrxhFKrTr3kqB
	 jCAdUaKhe3YjsjWGXRfHO9eBYw0IddEZYF8LC7oxhkBBIZSXKpnNGbEYn6ms+yJqsU
	 Gnk3MeP5SXQI8Byfo1MJk9t7XwfNzzp0McGrvABs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Chakraborty <chakrabortyshubham66@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0265/1102] hwmon: (raspberrypi) Fix delayed-work teardown race
Date: Thu, 17 Sep 2026 16:03:28 +0100
Message-ID: <20260917151546.255350066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 65cc52e47db08..af785d04b1958 100644
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
@@ -123,8 +129,8 @@ static int rpi_hwmon_probe(struct platform_device *pdev)
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



