Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208511;
	b=G3q9ssCDy7UWArYit2Gl8HdZs+T3zkKO2apCcVz6BSFKuYhEj7WFDrCScBW02IrzxJSS
	 AwHcvnlbHxPZDtpy0ocdIhk6wSUVfmoCVe8DCLWxhd0ZNXt6uVstVUviNzqY1cmFqxuvh
	 5tUJT+1Pp5GkA0FKPd2dWK7AAQELdv6bYQSFIb6kJUYcldJLexToT0rfN3z2yhuNkxAWI
	 FMDA5/wd39IQ7w1przBPlSpi21RzWtiUQXF/vJyHXfPd8arccmCv0rX0zazGJx8SGlKih
	 KKNRFifD3Mb8IkggTV5mBSDVY0ntZedOfquceDywLt8ebaBhgbs3NSHAnWn37uSmhFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qBQLLhOrE1Cbgfng4QB/bLg/XKzyt/PLT6fmgGWzt40=;
	b=Wscid8qVFg8eFj+6Ya01hWA+K1GKFT7fmbroqolGhvK8lKNktC9CMVhMqnq4gICP6niM
	 Odo5WKSjqN4s/UVtKzzEjnpJa5Ymr/7Ext3FCaKt1mNa+/z8EeOoKSBmcDptj3VHZvS4c
	 7bqLTEDrEu405dOAkjYhOdIta9MtSB8RCHrH1jFzOx/8oO+vMxHqfAehDQx+iS9a38XwG
	 zO0EZpEZ/HZibiJMeYVqE0+LOOOcgRQ5//rycGZijaLFUKmz3gwqRvBPmEK6Yk1dPaFJL
	 x+tJ9hl//k63NUWyp1ZtaIAjPslrXSzpOCLr2eMp4FNqsH9iSjBBX8r6PeSlyHPt3lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhULl9FK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA64606A31A;
	Wed, 28 Oct 2026 17:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhULl9FK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F5B1F01825;
	Wed, 28 Oct 2026 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208511;
	bh=qBQLLhOrE1Cbgfng4QB/bLg/XKzyt/PLT6fmgGWzt40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhULl9FKTxwrggOhO4hUbhH5pD157EVG6ZXwt/Fq1bWEXHFT7GBJjbzuvxbITjRk5
	 gU/hL+3D6WuzgsnBHYNqF5CZM2BAXqLSnoLS8f18N7f4fDQub/XOdrphg8sExjhQ4u
	 WcasT8U+GBWSCELHcn4MnZKnZ4KUH8P02krmlzw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/516] hwmon: (gpio-fan) Fix use-after-free in alarm work
Date: Wed, 28 Oct 2026 17:54:14 +0100
Message-ID: <20261028170005.937697594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit a2471ed17b0e6ff7bfb6b2ea8e6e5b04c309d293 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index cfcd254a5ed18..441954acaddf4 100644
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
@@ -91,7 +93,11 @@ static int fan_alarm_init(struct gpio_fan_data *fan_data)
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
-- 
2.53.0



