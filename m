Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D73522578A;
	Thu,  3 Jul 2025 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554585; cv=none; b=uMYC3qx2Z+JL8asKNrkjNie5F3RY0Y5yKYtbTnNYYPWCyqeYvz9vMH1j60+gaUiicBS4RMr+czUTCTOMs2DpE3Gwvm4u10J2FhlmTDTDmXAp8x72zbo1rvKOwE0VVt1StpqYsziQWvp3spQyBQIfW9HXb1y2d7/Sgd1F8NbsCDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554585; c=relaxed/simple;
	bh=biSn4JtFE7e1UVP5HUXoEygzswTewflV0ALj5iJr4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6a2r7VOGcuWmzwB8XtgLBv5ZxhgvKhjj9n8t+VAEPcpGjDY3W47TN8z5JAJqXGHimmGW5x2E4S1sM2Jv25p9MQbnsj2l7n12fbpsKW5AahgAbqDAV2CrMh1bqpmCmcuTHXPvny0V2px8Fu6dxEb8XYrFrk8Ps35QrQ3Wd3PsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5V9UzfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5V9UzfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0BDC4CEE3;
	Thu,  3 Jul 2025 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554585;
	bh=biSn4JtFE7e1UVP5HUXoEygzswTewflV0ALj5iJr4tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5V9UzfAhL8UkqK460lemCnwOnuamL4jViNQ0r9mO+vINCUm+xKQnGcc5K6nsCtuC
	 Do88wvfzS3p/NVfUKBQArgWKL4Qzleh72mmRUILB2PscfS1fL1wqresdhGzFeBTdbW
	 pScRf/wWAGMAzNc67AzOj4TefSWZf5kuVF9MENlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Sven Schwermer <sven.schwermer@disruptive-technologies.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 016/263] leds: multicolor: Fix intensity setting while SW blinking
Date: Thu,  3 Jul 2025 16:38:56 +0200
Message-ID: <20250703144004.948427834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schwermer <sven.schwermer@disruptive-technologies.com>

[ Upstream commit e35ca991a777ef513040cbb36bc8245a031a2633 ]

When writing to the multi_intensity file, don't unconditionally call
led_set_brightness. By only doing this if blinking is inactive we
prevent blinking from stopping if the blinking is in its off phase while
the file is written.

Instead, if blinking is active, the changed intensity values are applied
upon the next blink. This is consistent with changing the brightness on
monochrome LEDs with active blinking.

Suggested-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Tobias Deiminger <tobias.deiminger@linutronix.de>
Tested-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Signed-off-by: Sven Schwermer <sven.schwermer@disruptive-technologies.com>
Link: https://lore.kernel.org/r/20250404184043.227116-1-sven@svenschwermer.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-multicolor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-multicolor.c b/drivers/leds/led-class-multicolor.c
index b2a87c9948165..fd66d2bdeace8 100644
--- a/drivers/leds/led-class-multicolor.c
+++ b/drivers/leds/led-class-multicolor.c
@@ -59,7 +59,8 @@ static ssize_t multi_intensity_store(struct device *dev,
 	for (i = 0; i < mcled_cdev->num_colors; i++)
 		mcled_cdev->subled_info[i].intensity = intensity_value[i];
 
-	led_set_brightness(led_cdev, led_cdev->brightness);
+	if (!test_bit(LED_BLINK_SW, &led_cdev->work_flags))
+		led_set_brightness(led_cdev, led_cdev->brightness);
 	ret = size;
 err_out:
 	mutex_unlock(&led_cdev->led_access);
-- 
2.39.5



