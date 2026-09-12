Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21B1415F36;
	Sat, 12 Sep 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210012; cv=none; b=FL4eNs0HO2ElVbL70sI7XfrpKKPjUv4hS2tFojDgXaotlqqTertJxIROXir6vCdWTNC9/dBHduNw+/3iCQsos5ZPwpIY9v8YIgZWaW2hzdPiY/XN0EFGPO6J+oRDbZZEmUMuu7Nypy/NfM45fvRSAWbTcaRwYmyPRqHFZ55O4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210012; c=relaxed/simple;
	bh=/AKJ0LKr/qGw6Mj2ebcChz4jsKoS/uXcUijGKH/2oAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTdfDjYidTKf441DGAxr2F1+RPgHngEno5fHw4cfOYj7pBKRRR14Y2nqzvMgf7XaTS76HRkTaexH5Q1r4SnP3d1vBPuQJY71qcP5eCKCP4kaY51zcDgqtghv0WSqL+x+JapPXcl+qVsq+KJgwAkSdV924ifiwD6V4e5lNtECe6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiYtfkRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiYtfkRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEFA1F000FF;
	Sat, 12 Sep 2026 10:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210011;
	bh=kxTSg4dzqfwHaesw3prJaMQiYKO7jxdcCGPZd0RipM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiYtfkRK5+ubQ+A/olL4EVbcwXlBPiDZU9g3xAwnLQXHHL0s3wPHYuXaVaKLaDIRR
	 0PuiwhwkvasMfiE7k9nYabFGG3RVuFvGqo4PJxVmYPrT7OeOF6L/hGHqIdjptAaF3C
	 SXZ6qdy63EnAot80di+S3CIa7iW1LojSv+B5UgEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steve Dunnagan <sdunnaga@redhat.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0939/1518] leds: gpio: Clear error pointers for skipped LEDs
Date: Sat, 12 Sep 2026 08:51:48 +0200
Message-ID: <20260912065644.695314106@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Dunnagan <sdunnaga@redhat.com>

[ Upstream commit 942901eeda934f1bebf2605a781155e9d6bc7f6e ]

gpio_led_get_gpiod() returns an error pointer when a platform-data
LED's GPIO is unavailable. gpio_led_probe() skips registration in that
case, but leaves the error pointer in led_dat->gpiod.

The skipped entry remains included in priv->num_leds. During shutdown,
gpio_led_shutdown() walks those entries and passes the error pointer to
gpio_led_set(), producing:

  gpiod_set_value: invalid GPIO (errorpointer: -ENOENT)

Clear led_dat->gpiod before skipping the LED so skipped entries do not
retain error-valued descriptors.

Fixes: 45d4c6de4e49 ("leds: gpio: Try to lookup gpiod from device")
Suggested-by: Lee Jones <lee@kernel.org>
Assisted-by: ChatGPT:GPT-5.5-Thinking
Signed-off-by: Steve Dunnagan <sdunnaga@redhat.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260724180412.43150-1-sdunnaga@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 9cbcf7e40a159..df7be79dbf242 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -296,6 +296,7 @@ static int gpio_led_probe(struct platform_device *pdev)
 			if (IS_ERR(led_dat->gpiod)) {
 				dev_info(dev, "Skipping unavailable LED gpio %s\n",
 					 template->name);
+				led_dat->gpiod = NULL;
 				continue;
 			}
 
-- 
2.53.0



