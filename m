Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005E30FF1D;
	Sat, 12 Sep 2026 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206838; cv=none; b=kg+KNuhD3ehtHl/CaHpunlu+Lj7UfTALohooooqKXvq+QrglKdkmHojeXRSqlAEprEtP7feVtWkrU7kehMO7j1EykHwg/RzWv2I4Wdu+CuNCVZr+3nC6D5m4hxwddJLsnqCbPd7Fu2QAfnLRFnC7OLDAZeeQqqVh8Wz73DXi7H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206838; c=relaxed/simple;
	bh=axWTR58EChfFsAM8vDeNRyPETeSav6GCMKv1TK62JGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmG1rwTRO/y12ku5yBsrHKg9k2eZsEokhhE6Yq6nmp0rz2TbTEXTQKPORt2jZ/51D2+QAXIWqW7y3rOs60MYu1JuHaTUAgUqE7YNnku0kusdDkpKdqz8Qtvjki3VUPEbsono9mmCykjkZZXuaRpU+bue15bKhVEhwWIiFYQQAz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTBTLvtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTBTLvtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F161F000FF;
	Sat, 12 Sep 2026 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206837;
	bh=HJhBLQySj/a3Copc65f75bsRTVtEr5045bo8R6eoX/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTBTLvtVXJyuLD2zDvAy/aW6odfKF5A1oF64tTj0vv0CEsUGllph/MXGGyStcOMAE
	 9BB/sLgSzeXl6hK/8keaxNy4yDqzAQcYIkbKYvPefwSne1dyXj77L3cCYW/8R46JXY
	 mEqxTYgfuZbVJv3fgj6QDjqVQuSc5R63dYbooJEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0290/1518] leds: st1202: Fix brightness having no effect while pattern mode is active
Date: Sat, 12 Sep 2026 08:40:59 +0200
Message-ID: <20260912065630.042235793@linuxfoundation.org>
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

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 7cbe470366bdd43c7e8114fb2c4d74fa69093121 ]

Once a hardware pattern is running (PATS=1), writing to the brightness
sysfs attribute only updates the ILED register. The visible output is
ILED x Pattern_PWM / 4095, so the change has little effect and the LED
never returns to steady static operation as the user expects.

The LED1202 has a single global sequencer shared across all channels.
Stopping it in brightness_set() to force static mode would halt running
patterns on all other active LEDs.

Instead, set all 8 PWM slots for the channel to ST1202_PATTERN_PWM_FULL
before writing ILED. With every step at full duty cycle, the output is
ILED x FULL / 4095 = ILED regardless of the sequencer state, without
disturbing other channels.

This also enables basic LED operation without the pattern trigger: with
the trigger set to none, the brightness sysfs attribute fully controls
the LED as a simple on/off device.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB8497570FD162D0D42A9864E3C5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 4627b244c12fe..680ccb4395773 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -137,6 +137,8 @@ static void st1202_brightness_set(struct led_classdev *led_cdev,
 
 	guard(mutex)(&chip->lock);
 
+	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++)
+		st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
 	st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
 }
 
-- 
2.53.0



