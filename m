Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD4511E99;
	Thu, 17 Sep 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666505; cv=none; b=cEdinqNlAJBhy0pPVGHmmn4fSdqakXRhuuCb90f4FpMfBAdmpg2BFpHvhoAYPhgK2KqYRJmAWeYCnEO380JTV9zNMjf6vPaYPO3nu1MsNropRnil+LphM2CPDRZ/SyMoocJVDp3k5IJuLs4ock6h01MH5+E/lAwrXZmNuh3BFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666505; c=relaxed/simple;
	bh=p92YZYzZsEt+yh2pdfcSgXS6/xJp4nBBmKT0zCSngQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLFBtXY2QQIunjjk5Yp2VhZ8j0ZUflEleMPRcIDH4U2AcTKcG0/XrHIimBvZZMa9o4JXEC+jIKz/DDAqWvO9F9/SZ7armeho8u9Rr4NZi8ng4pmGs+HxH/AsEybevdSWcvJzAYkyHi3taip77/zng4PussUzUS7RKMcdAlnelbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsByjCgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsByjCgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC0D1F000FF;
	Thu, 17 Sep 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666503;
	bh=gkroEnxmTU96TsxUPG60RhhREosSgqAXB0ES5Kp1zdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsByjCgN304mj08do9C23FQ/uzdt4iVMnUD4bjArnkCAfw6ErOnsOckPIXBLGFeTD
	 sDqZe7oH+/Rxj2d8amUWdLAZLpllWBsq/EpOZE59/KXTq4MTndkmMiFGPYyPcxEAck
	 qck39Cutr13+L8wPGFHVSxZWVv1L3HCDmEhR0IQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1058/1250] hwmon: (gpio-fan) Fix use-after-free in alarm work
Date: Thu, 17 Sep 2026 16:14:13 +0100
Message-ID: <20260917151620.800980405@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit a2471ed17b0e6ff7bfb6b2ea8e6e5b04c309d293 upstream.

fan_alarm_irq_handler() queues fan_data->alarm_work, but nothing
cancels it.  fan_alarm_notify() dereferences fan_data and its hwmon
device.  On unbind, devres frees the interrupt, which only waits for
the handler itself, and then releases the hwmon device and fan_data,
so a pending fan_alarm_notify() can run after those frees.

Replace INIT_WORK() with devm_work_autocancel(), registered before
devm_request_irq().  The devres cleanup then frees the interrupt
first, so no new work can be queued, and cancels the work while
fan_data and the hwmon device are still alive.

This issue was found by an in-house static analysis tool.

Fixes: d6fe1360f42e ("hwmon: add generic GPIO fan driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260819033317.446191-1-fanwu01@zju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gpio-fan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/devm-helpers.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/kstrtox.h>
@@ -84,6 +85,7 @@ static DEVICE_ATTR_RO(fan1_alarm);
 static int fan_alarm_init(struct gpio_fan_data *fan_data)
 {
 	int alarm_irq;
+	int err;
 	struct device *dev = fan_data->dev;
 
 	/*
@@ -94,7 +96,11 @@ static int fan_alarm_init(struct gpio_fa
 	if (alarm_irq <= 0)
 		return 0;
 
-	INIT_WORK(&fan_data->alarm_work, fan_alarm_notify);
+	err = devm_work_autocancel(dev, &fan_data->alarm_work,
+				   fan_alarm_notify);
+	if (err)
+		return err;
+
 	irq_set_irq_type(alarm_irq, IRQ_TYPE_EDGE_BOTH);
 	return devm_request_irq(dev, alarm_irq, fan_alarm_irq_handler,
 				IRQF_SHARED, "GPIO fan alarm", fan_data);


