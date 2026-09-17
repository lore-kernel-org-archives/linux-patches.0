Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E323CA48E;
	Thu, 17 Sep 2026 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668254; cv=none; b=jdSzbqAzv2cqZXIaWZTVoMfbwlO55bkzP3oo6RAsTRcV9i/Ix5VsJ3YhCwLmRuRSNyFtycm4wFITd1k5Nj8Ch8CrTB+T4l5jTt1hTrmgE7Sc4wh4MpVBd3J8Bemtz68FNz/XNOFW0Sa/ot1WFvaRPp5kAr4poeGCMRddg3288jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668254; c=relaxed/simple;
	bh=i2LKjE4cFx5t0Sa1bbmH6DU35RfCxNzncjNXDOB378k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrMzFMWH6ULO/pkMK6A5S0wwH688gmtNxr64XgwyMzzAs5/14aTxfHua33KWkxTn77w+1czPsYVnflzcmbmBsTzK1G8rZFAImnZXv6Ogh5EtKRlkgjYwW8QfS0lJQY5PACBivppQ46XwQFdr9+eS55ED0VqkU1eZR+xkeemye3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1LnKegD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1LnKegD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B00B1F00893;
	Thu, 17 Sep 2026 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668253;
	bh=t1Y+MfWWO5xUgvCVMbe+lRChFKe16wEMtaSM+T//L28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1LnKegDTbwNclrWEndO5CPtZiYsATBpRpLCUS+dGmFHoga5/iA/qXoWKb2Wa73HZ
	 e1IueiIq6eTPgsvPx2ypm7hsHwXAbU+FEJAJQMEpZ7bVTxjZbOIv+nqlv4A2MTqcz5
	 4V/RqA8sKAZJzFm3Pk+Jnscr78kewMHj9VkZdgRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0327/1102] leds: trigger: gpio: Use GPIOD_FLAGS_BIT_NONEXCLUSIVE
Date: Thu, 17 Sep 2026 16:04:30 +0100
Message-ID: <20260917151547.841097365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 26e15f2558f66b6747ef981df8054d0d92d01b60 ]

When a GPIO is shared between the LED trigger driver and another driver,
the LED trigger driver needs to request the GPIO with
GPIOD_FLAGS_BIT_NONEXCLUSIVE to allow both drivers to monitor the same
GPIO pin.

Without this flag, if another driver has already claimed the GPIO,
the LED trigger driver's gpiod_get_optional() call fails silently,
and the LED trigger doesn't work.

This is needed for scenarios like:
- SFP module presence/status LED triggered by SFP Mod_ABS/Rx_LOS

Both GPIOs are also monitored by the SFP driver for module state
management, so they need to be shared.

Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Link: https://patch.msgid.link/20260408115106.379834-1-piotr@kubik.pl
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-gpio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
index 7f6a2352b0acd..3199275fd250b 100644
--- a/drivers/leds/trigger/ledtrig-gpio.c
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -86,7 +86,8 @@ static int gpio_trig_activate(struct led_classdev *led)
 	 * The generic property "trigger-sources" is followed,
 	 * and we hope that this is a GPIO.
 	 */
-	gpio_data->gpiod = gpiod_get_optional(dev, "trigger-sources", GPIOD_IN);
+	gpio_data->gpiod = gpiod_get_optional(dev, "trigger-sources",
+					      GPIOD_IN | GPIOD_FLAGS_BIT_NONEXCLUSIVE);
 	if (IS_ERR(gpio_data->gpiod)) {
 		ret = PTR_ERR(gpio_data->gpiod);
 		kfree(gpio_data);
-- 
2.53.0



