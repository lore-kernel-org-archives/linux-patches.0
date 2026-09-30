Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7979430CD95;
	Wed, 30 Sep 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791716; cv=none; b=X5+w0YaylI3h15KbTQVh9nMhVPmeXoKVasR34zuE/0yxLY3zehIM8VzisYm1FyJdgPJu604tGox2FHnvjv2XIopNdTQrB90xdl6f5yaQDDqbGRr98Xo63++e9O3MCCCjU+f1tDY/eb+6w+bJ317B3h91hHuqcqPScimoYd9xZJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791716; c=relaxed/simple;
	bh=MYSTqEu8waBKR3fRkrmUiHCfka1ULydHmNWiSieART8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1M70Xyw17Fvu0onEB65HqM0dpf6ctf/OpRIWshg1wBBANHoUIlQBpwTYawKq752Y9aK3wNOO8ScoXyYR3Y3g0YYuBd6E84pA+uchuNRox/Ooz4zRnCqZfiEIiWknhs86/83CA1OMe5nXFr8jIv++NG9yhJqabprO1GjjQZc9O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6CepU4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6CepU4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D346F1F000FF;
	Wed, 30 Sep 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791715;
	bh=0SwkL13nw+4hQMOHNWx2cgQ14pCVX06NAdrVV7syYFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6CepU4YVbfHMQuAfz8wwEyO5fOgqF9PcdDOSiaGaGibHhZcwzs3JXG9q+NXQjgme
	 B9M5WprApW3Gt+rKOaEoVQddCIiGi8ISxW0s/KHSB32yvjMB6PDGaRsqWW+bdriSpu
	 /vRXFlPYy2neVzJ9SmIYL3dBybwSJlFzf63Dessw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 399/752] hwmon: (gpio-fan) Fix use-after-free in alarm work
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152406.916709924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
 #include <linux/mutex.h>
@@ -81,6 +82,7 @@ static DEVICE_ATTR_RO(fan1_alarm);
 static int fan_alarm_init(struct gpio_fan_data *fan_data)
 {
 	int alarm_irq;
+	int err;
 	struct device *dev = fan_data->dev;
 
 	/*
@@ -91,7 +93,11 @@ static int fan_alarm_init(struct gpio_fa
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


