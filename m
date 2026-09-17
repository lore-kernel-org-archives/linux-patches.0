Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B02A4398F5;
	Thu, 17 Sep 2026 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671118; cv=none; b=HMMT1XfO3zZ5O6erB9WuJJ9VFggIYPjQ8B4u7ODyw/hKVViFf1bM6YdSCYFmVbMTV1+D906fVTA3bT5RzyZKrmD3Zya5bSJYrFjyF1LqddFItg903GCq2jZTR+9PMYm+1a2wKrV8XhMYoyC/bl2vgFD94jybKLSza1YVZCvV5EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671118; c=relaxed/simple;
	bh=xFawTjfr+nLjKAuxCr1ftBQYnWxI9FkblIir4XVRspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXM+ZldaqurnFc+Asz7S2H6TC1XlIh06ZY9hf/+nrkGmnA+Y+OXGTgx6IJecquKEO+kfy6KeoPEq1jZ/Re+435G8C1zX7HqhplcwPgyCml6oVUd6zzu3P3PPSckLLSsafRMSHj6q3srVo4M6JDPo/m9YE4z0a3N6aBigEafjEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrSg8GZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrSg8GZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C7C1F000FF;
	Thu, 17 Sep 2026 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671117;
	bh=BEoVL/xmf/F/8m6eMwfXsSJMJKA71+LUkQBn/fFkSrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrSg8GZaqZNfZt6FwMVPwdEuXwr2NIzFBbp8G3eGQIB8azF3UxOz3zz2fiqcrarYp
	 00+9qN9oeuXbGZT8tGAqToYrQeHHFFfBbasGr9qu4E99uyDgfYiZZ2K0PtR+9Sxuff
	 qKu39MNXRDd8tjOh1r5AqfUwAuObJssW7pHmV7Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 0872/1102] hwmon: (gpio-fan) Fix use-after-free in alarm work
Date: Thu, 17 Sep 2026 16:13:35 +0100
Message-ID: <20260917151602.452019766@linuxfoundation.org>
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
@@ -80,6 +81,7 @@ static DEVICE_ATTR_RO(fan1_alarm);
 static int fan_alarm_init(struct gpio_fan_data *fan_data)
 {
 	int alarm_irq;
+	int err;
 	struct device *dev = fan_data->dev;
 
 	/*
@@ -90,7 +92,11 @@ static int fan_alarm_init(struct gpio_fa
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


