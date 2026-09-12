Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6C41B8CA;
	Sat, 12 Sep 2026 08:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202223; cv=none; b=hnQuDj0oDDNQSBmky3vUVitEwjneGJRp3fCCs4VQPlmkXon7iRW9uYQ8QtD0kv/BT9+lZ9m06FJHv+kcUFtxsJLRt5ORpjFTlujArB5efAr4I3NleJG1V/GhIkX728xl102668aM6mruE7UqJ8qOytNJnmqkumHuJYq3Pwamgm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202223; c=relaxed/simple;
	bh=P7K6QJ7i5PNHt3rv8y+WJvhjSLyutTPuR2wi0m5GKo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIT26redv6KwCusU6xM8uEIa/4J953PJr00/vh5J+E1zHOIfxBil2dwDBlFlYSbQIwL7in6o8V9pRVvHK8qh/+3l7ZGPwk6fGciNx6DNp6ECiso0Ie1X7rSACapVnHhabOngucALsnH/wslV3YeislbvotNiX0JH6nOZOI3+Vrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thL1dsAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thL1dsAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E769A1F0089B;
	Sat, 12 Sep 2026 08:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202222;
	bh=UlAhfxG6Xxg64pbtHoDSPs011CZhZgZnrw2OpTxHGr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thL1dsAYhml1blebm1iJlsZpUJ2qt0r1mC7IAaR6ve/I/dEdlUHYWxfgZYFZ7VYu1
	 b66eUYfWHKcoKiJNkvAlUtg5MxQTuSiL7qSCWnfRzCcAxuibCTisPjoN18OL3c6ZNv
	 2h0+gLWP25dvhO5tW41ygSrINAPPEErmczcNg/9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steve Dunnagan <sdunnaga@redhat.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1159/1815] leds: gpio: Clear error pointers for skipped LEDs
Date: Sat, 12 Sep 2026 08:48:29 +0200
Message-ID: <20260912065716.222852085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 08d5a911ac259..dbb84949c3c26 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -295,6 +295,7 @@ static int gpio_led_probe(struct platform_device *pdev)
 			if (IS_ERR(led_dat->gpiod)) {
 				dev_info(dev, "Skipping unavailable LED gpio %s\n",
 					 template->name);
+				led_dat->gpiod = NULL;
 				continue;
 			}
 
-- 
2.53.0



