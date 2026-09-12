Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8812F7F17;
	Sat, 12 Sep 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229341; cv=none; b=DPD/FgPAwlLTfg3rTHJfwzvK50hRJ/carii3bvWkqutlQriDFcwXPt6sGm/YvUljyaeEYu2tNKvBWi18QSjopKcgXRa8iNvBZQG9CQvZTDww0VduyACxtihZcFy+lAxUj+CgZadt8IIb/MwHlz6+s4IWAnIe+XSQF7m1SS7weeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229341; c=relaxed/simple;
	bh=hPOIv0yegT8qTEJI36wrGwtz+GvKzFOl1kjpFRSlCjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tx6SCGpPMzyCjPobOIhXOqwEpURbopE3SUUH3GJ6d+a4HMmC/eHdyLQb1QUL/S+AgTHtHpOZs7GQvdIC4qJwqiA9JGCQwidsokh2SwwXkneS5C5/Jfh7u3cbbq84jMosxRAZhbDOAaUkbkrPoXemKIH+RFD23gwG9N0UUE3BPvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DI5xmtpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DI5xmtpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66251F000FF;
	Sat, 12 Sep 2026 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229340;
	bh=jwZOvYyAp+Uf2tnk8MzRW3732x14Xr2omSM24LvBkOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI5xmtpn4S9DpuIkM2ficGNkhLgfNbFc6bWNAr07yUZloxa89/P7Bu2nh7CUttDqI
	 fM+QCeb//wzZLkga1ktpHG+qlQe48YORPnNQa6qd+0gvll25+sMD7Ul+qb3yYzmhrq
	 3NcODiuZuvFq5/ZjjmlEamcR4NGP17Z96oJdSbSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0571/1191] leds: pca9532: Fix inverted GPIO output polarity
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065601.072265170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index df83d97cb4796..568af581460a6 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -285,9 +285,9 @@ static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned offset, int va
 	struct pca9532_led *led = &data->leds[offset];
 
 	if (val)
-		led->state = PCA9532_ON;
-	else
 		led->state = PCA9532_OFF;
+	else
+		led->state = PCA9532_ON;
 
 	pca9532_setled(led);
 }
@@ -305,7 +305,7 @@ static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned offset)
 static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	/* To use as input ensure pin is not driven */
-	pca9532_gpio_set_value(gc, offset, 0);
+	pca9532_gpio_set_value(gc, offset, 1);
 
 	return 0;
 }
-- 
2.53.0



