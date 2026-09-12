Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79FF2BDC0E;
	Sat, 12 Sep 2026 07:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198007; cv=none; b=NWXBRpgAPT7koGd0VwJ59XzHE2iR8jWGlBPAXYfDWjR2DnWDNwS8/KktmjlowinSH7WwpC8sI8e0CSQtqJLZVdmB1iz2/TqYyj5yol7nWQLOQmZdEVZ4DMlYAfMvS7fvzm4rUZp55uRR3M+4MoYs/KzGzMFJ6UY5F3L1Mt4ZVWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198007; c=relaxed/simple;
	bh=yUD5kui/FOfnuCdmYSDXGiyVq7KsBkmnvPl/bh8suy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md9ZcKjInCgvuT9pBCcPqMIIpGI6VWaQe2F4k/roWbKBqqPuOoWXEy4YPaGguuWOi7bBf150gpZHWOKsRINq9pCX1q52iej0Do9QbVHWKdh4ZL0GtQ9a9z2jUybjjcSYuq0paG1nHg1EnUcHzBYiFQLL9tJ7DEJ46zJaOYANngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNrYJh3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNrYJh3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C461F000FF;
	Sat, 12 Sep 2026 07:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198006;
	bh=gP58qe6zMF1hg/oX+bZhTPKonUGJ5TwR+3HvFfqXW2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNrYJh3JUVnBcx+7NGYabYm7gp/Jw/PRlg6/mNAJK5JRLtDa/HHsFuASzBJthSq8E
	 0CCN7SF79VbX8C/98nOwyGjEASTLGOZmUbHLyHrl5AZ1J/iIwv/FRczHJMd79s1gCD
	 uSd2g3LGExdFYtoP8z3v5X2YcFwosaBY1dTSi89s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0292/1815] leds: st1202: Stop pattern sequence before reprogramming
Date: Sat, 12 Sep 2026 08:34:02 +0200
Message-ID: <20260912065655.809856076@linuxfoundation.org>
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
index 7f68d956f6948..316ed8eb054f9 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -200,6 +200,10 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
 	guard(mutex)(&chip->lock);
 
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	if (ret != 0)
+		return ret;
+
 	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++) {
 		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, LED_OFF);
 		if (ret != 0)
@@ -226,6 +230,10 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
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



