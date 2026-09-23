Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A2D3AA19B;
	Wed, 23 Sep 2026 14:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173385; cv=none; b=uyM3Bzz7lr+t1O28w2TYAIcoxlkXKXtquMcw85qolTVUdBj4rJm2c07eU4Y4UtEA9+uOxrUJw++4wGcsvMYjJ22/GdIAEWbcNHQbsI6FNxtBbD4RJRV1amZDOKlg0miAz1QkgZhWUP9g1aRQWvT5YPWHtZYiWK+Ko54SkH1M7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173385; c=relaxed/simple;
	bh=Z6LPmvq7M+8vJuzDjW86TGkLfbJMNt9C90UuTpMroUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5xL276JyOlSd23MMUBIHFx+U7FnDDBa5rIPfRbv8SWW/HfwRCvNP6L61JVBB6YEL3y7ntXo765B197aSU38+UMFe9Nen0xTDAEUt88xHxIHVsaH59vcioejzWl8M/ohGQdPasTjaeOO5im6AF6Jxy/Gdo1A0iik6ZhtKwgIcho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlbsBp98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlbsBp98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64891F00893;
	Wed, 23 Sep 2026 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173384;
	bh=35dCsEeUl8ns4xf4ELuyFRfgzH9U4eJ11bjj0CgFraY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlbsBp986XWcaDVOBGs8J007t+0sNBwq1b6ycwIUHLeybFPyG+ajJGc85Xf+lNs5L
	 aLR5LjKKP8TpjypSjd0BCZnFLDQ7i4YpgkigDJ7LvHUroZ/7j9MA3ASnMgV2jX+IcU
	 Mpg0xmpEVK+M5eKSJZ0BnHMbOrkgokSJW3TXovag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 230/438] hwmon: (gpio-fan) return IRQ_HANDLED from the shared alarm IRQ handler
Date: Wed, 23 Sep 2026 16:04:11 +0200
Message-ID: <20260923140650.727852436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit bdf5f731957de48acada392f28e82bc019713adb ]

fan_alarm_irq_handler() always schedules alarm_work but returns IRQ_NONE,
so the kernel treats every alarm interrupt as unhandled. On a shared
line that risks the whole line being disabled as spurious.

v1 just fixed that, but it was still IRQF_SHARED, and always returning
IRQ_HANDLED there defeats spurious-interrupt detection for the line --
if the interrupt ever fires without a real event, nothing catches it,
and a fault could spin the CPU in the handler.

Sashiko flagged this in v1, and Guenter confirmed: this interrupt must
not be shared. So v2 drops IRQF_SHARED too.

Fixes: d6fe1360f42e ("hwmon: add generic GPIO fan driver")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260901160931.DD3811F00A3D@smtp.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260914104136.1797979-1-congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index df8bd97076050..3f78375eeb448 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -68,7 +68,7 @@ static irqreturn_t fan_alarm_irq_handler(int irq, void *dev_id)
 
 	schedule_work(&fan_data->alarm_work);
 
-	return IRQ_NONE;
+	return IRQ_HANDLED;
 }
 
 static ssize_t fan1_alarm_show(struct device *dev,
@@ -103,7 +103,7 @@ static int fan_alarm_init(struct gpio_fan_data *fan_data)
 
 	irq_set_irq_type(alarm_irq, IRQ_TYPE_EDGE_BOTH);
 	return devm_request_irq(dev, alarm_irq, fan_alarm_irq_handler,
-				IRQF_SHARED, "GPIO fan alarm", fan_data);
+				0, "GPIO fan alarm", fan_data);
 }
 
 /*
-- 
2.53.0



