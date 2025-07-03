Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29FE2DE6E5;
	Thu,  3 Jul 2025 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553878; cv=none; b=m250SsAxGSGRCA0r0lKV+YgJLfJdWyPewtF7gvk1EnaRNnxW/DKuZZ7Ju9rmPLjDmgd8FH+zpFttKVXortbCHwgT9eypcoXTRtAcLK+1KfYglZDjXrrE55id8Q3ROSOU5Yo6whangBiSnzGi+XVWgNxGz0E92DkYN9OIINNbddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553878; c=relaxed/simple;
	bh=b9d6MzUGrFBdjytHRPj4Eb2J+lkoBwSoaLVOtbVQT+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+ig4s/OmiFRG1f5BYmOBmQo0o1wbQrgepWEw3uA5fEf2frVCqyWIjJFoAHC8KMPvCMpwNHqg/SEJhN8oq/0xBoOF1N0F26VMjc5Ql28J5mhE8rJk41dksaHv32n5rrUzl2GLN2hZoY6MpH23w1iLcNYn0jDMw5Wnr54ppIJcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6yw98gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6yw98gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAFEC4CEE3;
	Thu,  3 Jul 2025 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553877;
	bh=b9d6MzUGrFBdjytHRPj4Eb2J+lkoBwSoaLVOtbVQT+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6yw98gWZgp6fI/J2T9FXqj8x7Xf6x2msP4IZmwwyI9JQTtipS+b/yr5yMTZ0d6bE
	 jIkuZ9bQbOIMzlEmbP0P6KOjk8OVkn+G1pGDHecc5VOAlnahoaMAXji8skQXjzxZj1
	 wgzSlh0vfVQkJenqWopiLivs60XZurSAibLmfLSs=
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
Subject: [PATCH 6.12 011/218] leds: multicolor: Fix intensity setting while SW blinking
Date: Thu,  3 Jul 2025 16:39:19 +0200
Message-ID: <20250703143956.411416747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 30c1ecb5f361e..c707be97049b7 100644
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



