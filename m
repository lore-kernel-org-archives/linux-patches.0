Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413631DB127;
	Tue,  8 Jul 2025 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993775; cv=none; b=TYjj0/aCKsqfHCuXJFjTO3fdP6BIVSFJM9mck/uTjPz2ceUQMJ8W3pCPXEhUHU8t2mG9M+BV9tGkcBP5VXR7SHW4lkOEaAGZzA3uAQTWlJqbzN5BtIYQh9sb5UHH+XkRsr61Cv82TpeFksg5Xb5+/RcXrvCWR5NrsOX9NYnykjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993775; c=relaxed/simple;
	bh=j17j+zV80cw6Q4SQsP7Pq7ybwbQluq1nlR6h7YPtuXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrTV/0NlwNQjGkKkj2L/koKc4IZdf9TqahNrg+Dj0W9hof6A1SmOWEx3NU3BcSvEo+VilmXf4lsxSKbjHP1cKgWbKpYlKq7OoeL5IlMgVJQHRPGbQup65WB5fcUT4YtRSKCo5Jiq5Kpr9VE4IGxDAJUA0r9o+Osci/AT4yZTHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRKs0TH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRKs0TH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC84BC4CEED;
	Tue,  8 Jul 2025 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993775;
	bh=j17j+zV80cw6Q4SQsP7Pq7ybwbQluq1nlR6h7YPtuXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRKs0TH6Vw0XT4RI0HJirO5oNRmZviucncwIjhoIMMYFvaKJyW6hi4ccHW9WIcdm2
	 xUUDGrwyqmGwft9SAcPq/Q/5ZrTO/IfUtInY1DmNM4iIFAMF+bkyjWox+Ha2TU6abN
	 6n+I+yl8QLxDGQbwg19hBT2raQD1XCNKj/iLsnQY=
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
Subject: [PATCH 5.15 006/160] leds: multicolor: Fix intensity setting while SW blinking
Date: Tue,  8 Jul 2025 18:20:43 +0200
Message-ID: <20250708162231.684669682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec62a48116135..e0785935f4ba6 100644
--- a/drivers/leds/led-class-multicolor.c
+++ b/drivers/leds/led-class-multicolor.c
@@ -61,7 +61,8 @@ static ssize_t multi_intensity_store(struct device *dev,
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



