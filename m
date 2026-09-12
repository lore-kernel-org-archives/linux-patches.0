Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAF2343893;
	Sat, 12 Sep 2026 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206819; cv=none; b=KThbpA3JaLFA5T/v3mcb27sWC69L9ci8nhX+NfZrR/xoOWbyziHKV+kQokxW/tU4i8d7pGDO75qkXKnIJRbOvyYhXn+mAWXvDavdNiBI/oN76xs03WzhUv9tf2HGjbufujDp9alehgk+Ick7zpqxE+9KrqCXH4Ib4y454FrtSyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206819; c=relaxed/simple;
	bh=DoUciJk+A+gDrcHKJ3FTLISnJ4ut+oP8aj0DWVe2LmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV/BWZpeHkfqNCULTqM08tdKAe/xHmMUDaIkPFiPmdtYCsLmA+xluCW96UPR2JSigBPvI8utTbZ43PTl1OIQ/bS0KnnW1YUkkZOMg9g3bxRZF5wLb0VBRzjsTAclMNwOMIL6KlFc6A4GBfTyh/WhGBvem+TEZf5coSuk24QEZVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhHQXokv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhHQXokv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E281F000FF;
	Sat, 12 Sep 2026 09:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206817;
	bh=Dmpp/HdZAlYSrAOM656H0ap/K1YkJk344wUjNVWc6/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhHQXokvQr2nC7VaalgYbQbylGIxBpddBEFErAqH/2jqoah3ZpTjS8CCL04liRFP2
	 ZCS9Dzip1IW/dxwlF7738rRhXW1GTPeWeMgUsKz0tF1M2kfxfmPlTjtmegVlumD4XQ
	 TkhWntTfBsPD4yIppIsIIZtiuFgp0PLAyGmNrFo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0286/1518] leds: st1202: Stop pattern sequence before reprogramming
Date: Sat, 12 Sep 2026 08:40:55 +0200
Message-ID: <20260912065629.952461393@linuxfoundation.org>
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

[ Upstream commit 9c019a8cb95d820e0bd03e75cfbad2c5b13941b7 ]

The LED1202 datasheet (section 4.8) states that modifications to the
Pattern Sequence Repetition register (PAT_REP) and pattern duration
registers are only applied after the sequence has completed or been
stopped. When the device is running in infinite loop mode (PAT_REP =
0xFF) the sequence never completes on its own, so these writes are
silently ignored by the hardware.

Neither pattern_clear() nor pattern_set() stop the running sequence
before modifying pattern registers, causing any subsequent pattern
reprogramming to have no effect when the previous pattern was set to
infinite repeat.

Fix this by clearing PATS in the Configuration register before touching
any pattern registers in both functions, ensuring the hardware accepts
the new values immediately.

Note that the LED1202 has a single global pattern sequencer shared by
all channels: PATS, PATSR, the duration registers, and PAT_REP are
chip-wide. Stopping the sequencer in pattern_clear() therefore halts
any pattern running on other channels. This is an inherent hardware
constraint; pattern_set() restarts the sequencer when a new pattern is
programmed.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB84978D0F499774773C7DA1FCC5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 4e5dd76d714d8..1dbf2251f6bc9 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -201,6 +201,10 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
 	guard(mutex)(&chip->lock);
 
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	if (ret != 0)
+		return ret;
+
 	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++) {
 		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, LED_OFF);
 		if (ret != 0)
@@ -227,6 +231,10 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
 	guard(mutex)(&chip->lock);
 
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	if (ret != 0)
+		return ret;
+
 	for (int patt = 0; patt < len; patt++) {
 		if (pattern[patt].delta_t < ST1202_MILLIS_PATTERN_DUR_MIN ||
 				pattern[patt].delta_t > ST1202_MILLIS_PATTERN_DUR_MAX)
-- 
2.53.0



