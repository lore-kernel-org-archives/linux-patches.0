Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E07D342146;
	Sat, 12 Sep 2026 07:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198003; cv=none; b=VKUKmwXz+fm2muD+wD8b+yFLekDD3UKBCODzU4gofJ7EXaaPrFLmLjXkx32h8k6bziD1Jef1BDpmrE2prFnrIbNAY1RJgJ0RHCkcQICMEZSlNHx/hYfAB4vt4LM5b4vCwkWQ+WJrZqDoxKzN4qeXg8jbkDBdNnrDBcdn4YaYqhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198003; c=relaxed/simple;
	bh=SJaIkaZc0KArdJS+L/NTnRrANO4FozUGAzkRgr9SvyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkLLh/I44iI8GspoTJYFX1VPPSayA0yZSvyw3Lym3eRSz4zl4ge2g+uxTFqsx61nSL1v1thPiLkov+ST3NPru1EnRQ71OnGzxY+eo5On6V2/v8AUEgIio0HKPi6os69irucImDktkJBSf5dhgqAVDbLMK2/b7siLRY6G5srvbg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyXt9dyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyXt9dyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4E11F000FF;
	Sat, 12 Sep 2026 07:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198002;
	bh=Znkg/UDVbuu7DJp9jozQ2JexxwJDerKdyb0z8/QxDtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyXt9dyJfsIa+ny5sbO4W/4QACz/nZZvx5ZF5bV4mu1UvpkM0wPNPYW1CEsHvuzuB
	 ZE5ID8+Q9D0PRm3f9btxeXfV+6apvZG4TIOgwkSQytdjJLExLIdVkcrkEpOotVBqpt
	 mDJeu//Mgk44rooYqsmG3hNm4lmRHImwgbxG7O7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0291/1815] leds: pca9532: Fix inverted GPIO output polarity
Date: Sat, 12 Sep 2026 08:34:01 +0200
Message-ID: <20260912065655.787225448@linuxfoundation.org>
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

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 65a38a28a0b04af19a5e1fbf3869051412eeac96 ]

The pca9532_gpio_set_value() function incorrectly mapped the requested
value to PCA9532_ON and PCA9532_OFF, inverting the GPIO output polarity.
A requested logical high (val=1) incorrectly enabled the LED output
driver, which on this open-drain device pulls the pin low, while a
requested logical low (val=0) released the pin.

Correct the mapping so that val=1 yields PCA9532_OFF (pin released /
high-impedance) and val=0 yields PCA9532_ON (pin driven low).

pca9532_gpio_direction_input() is also updated to pass val=1 to
pca9532_gpio_set_value() to align with the corrected polarity mapping,
ensuring the pin remains not driven when configured as an input.

Fixes: 3c1ab50d0a31 ("drivers/leds/leds-pca9532.c: add gpio capability")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260703014201.69829-1-chou.cosmo@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index f3bf59495b68d..2d37e00e459de 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -327,9 +327,9 @@ static int pca9532_gpio_set_value(struct gpio_chip *gc, unsigned int offset,
 	struct pca9532_led *led = &data->leds[offset];
 
 	if (val)
-		led->state = PCA9532_ON;
-	else
 		led->state = PCA9532_OFF;
+	else
+		led->state = PCA9532_ON;
 
 	pca9532_setled(led);
 
@@ -349,7 +349,7 @@ static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
 static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	/* To use as input ensure pin is not driven */
-	pca9532_gpio_set_value(gc, offset, 0);
+	pca9532_gpio_set_value(gc, offset, 1);
 
 	return 0;
 }
-- 
2.53.0



