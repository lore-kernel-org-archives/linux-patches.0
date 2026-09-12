Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA8236E484;
	Sat, 12 Sep 2026 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206814; cv=none; b=UvW94ou3WQn6QXAXGPnsU7b6M1hlSqLRljnlz4oEXEYIcBY3dBHvuYXZXWjGGfTdeiS698hxd3QDvzqQbN7j+RX2JBtJeonwHp+0K9RjeshUdx1wFEU+tPi/ie1I+o9+yKaBSmQKM221w7Ir7xmWX5FxcLMFuwO4hRSD51GqffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206814; c=relaxed/simple;
	bh=eGQzh18hifkUzi2lVYh39rA+JKBKAryub0AcrNVaDhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTHt5ln1oXIqSQXisnapYgbM/5GnVOXrFCh95TVOjwjNUm9hNAOvJz82TW1i9StdhhKDTrKLIXytf494QHtWJAZzQzWN/Gjl92yk1TbrMBjsJxsfXCWqLODRRy6YJEjyKbXNUtEVJv1lUJwHYzB/9/TqxS1LhptipQlTRExTT7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTLz8pff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTLz8pff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8D11F000FF;
	Sat, 12 Sep 2026 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206813;
	bh=WtuBcONsVnmYLL8O+J/VB+coMWHwi9Ds4R9EX7xgycA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTLz8pff4uKzZQAhDwfiE0Kq1TMMMGD4ryFSIAbJ9ZyKxMcZLkppP+nUuww5ThthF
	 vmMHX/Vmklb7xCHj+XNhPoi+3wUxj9EXJ8S9jduiXcbAXiqldDewxksUS4AMdqZSIV
	 OCNibsszekSjDD3jAn1kMyyk9WwikAuaK9Wnlisc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0285/1518] leds: pca9532: Fix inverted GPIO output polarity
Date: Sat, 12 Sep 2026 08:40:54 +0200
Message-ID: <20260912065629.928916162@linuxfoundation.org>
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
index 0344189bb991c..80bf94e699d41 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -325,9 +325,9 @@ static int pca9532_gpio_set_value(struct gpio_chip *gc, unsigned int offset,
 	struct pca9532_led *led = &data->leds[offset];
 
 	if (val)
-		led->state = PCA9532_ON;
-	else
 		led->state = PCA9532_OFF;
+	else
+		led->state = PCA9532_ON;
 
 	pca9532_setled(led);
 
@@ -347,7 +347,7 @@ static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
 static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	/* To use as input ensure pin is not driven */
-	pca9532_gpio_set_value(gc, offset, 0);
+	pca9532_gpio_set_value(gc, offset, 1);
 
 	return 0;
 }
-- 
2.53.0



