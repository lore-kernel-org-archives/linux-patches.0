Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E72192D8A;
	Sat, 12 Sep 2026 07:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198013; cv=none; b=jO8VzPlWvYnLU6+yPkYc01EhMaEm3jN/9iQpfgsjMYtiBgLhWEnrxBNiRW5ea+aXVxZCDUquG095PKtUaJ5YFr0y2IrRCmkjuE8hCwToMgsSEN+S/JDZId4aP8vL71IHLiUkh7Ky1etS6eg6iMcyqsMtJarU/4/IacEOys8E7j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198013; c=relaxed/simple;
	bh=wLLX7Hquq+mhGEE4RlN3twwVjgWSsBKef9CVLIuN2fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/y9GcGix7/4VfbdGSOVBayj2dVDv7Hu75y7f2GeMnpmmg2dCogopGPPN+uCXl7Xc8TP/Ss+FEE0qDpxqRAK5jFG9RhFZXSJ9JiZdSp9uWbufHnFacsB4BSY6uS65xUEKjFVOqN122h9dSmUiuPzjI8aKa+5I6Ek9b+inXWhGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLoFugMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLoFugMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83021F000FF;
	Sat, 12 Sep 2026 07:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198011;
	bh=DmixDtfMIg99Lh4Fs+i3iyVLjsFekhfj4Gyf97PZIpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLoFugMYSaAMRJtlPNyOmicO6lx2NXTT+PRWcl4QPMIUMp0nYOlX8YbUi2wCmdbF6
	 IT4xonu6YYugiCBWtdkOfOAiuMJOEzKocE5qargVLZSlqJJ4xueCBgcPDY7eSq6WY2
	 gan23BkIc32Aj7ReBVVr7z88bSk8u9evQUELe/Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0293/1815] leds: st1202: Fix pattern duration prescaler and pattern_clear skip marker
Date: Sat, 12 Sep 2026 08:34:03 +0200
Message-ID: <20260912065655.833961377@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit d32f8bdc2b417a3013e1316a54a0b314f973bbc1 ]

The PATy_DUR register encodes duration as N × 22.2 ms, with register
value 0 reserved as a pattern skip indicator (§7.10). The driver
incorrectly subtracted 1 from the register value:

  value / ST1202_MILLIS_PATTERN_DUR_MIN - 1

This caused two problems:

  - All programmed durations were off by one step (~22 ms too short).
  - Writing the minimum duration (22 ms) produced register value 0,
    silently skipping the pattern step instead of setting a 22 ms
    duration.

The maximum duration constant was also wrong at 5660 ms. The 8-bit
register saturates at 255, giving a maximum of 5610 ms (22 ms × 255).
Values above 5653 ms were already producing a uint8_t overflow and
writing 0 to the hardware.

Fix the formula by removing the erroneous subtraction, and derive the
maximum from the register width so the relationship is explicit. Update
the documentation to reflect the correct maximum.

This exposes a secondary issue: pattern_clear() was calling
st1202_duration_pattern_write() with ST1202_MILLIS_PATTERN_DUR_MIN to
reset unused slots, accidentally relying on the broken formula to
produce register value 0. With the corrected formula, the same call
writes 0x01 (22 ms), leaving unused slots as valid 22 ms zero-PWM
steps and making the LED appear off for 7 × 22 ms out of every cycle.

Write 0 directly to the duration registers in pattern_clear() so unused
slots are always explicitly marked as skip, independently of the
conversion formula.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB84971D3AF982F4F707A378F0C5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/leds/leds-st1202.rst | 2 +-
 drivers/leds/leds-st1202.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/leds/leds-st1202.rst b/Documentation/leds/leds-st1202.rst
index 1a09fbfcedcff..a2353549469ee 100644
--- a/Documentation/leds/leds-st1202.rst
+++ b/Documentation/leds/leds-st1202.rst
@@ -17,7 +17,7 @@ To be compatible with the hardware pattern format, maximum 8 tuples of
 brightness (PWM) and duration must be written to hw_pattern.
 
 - Min pattern duration: 22 ms
-- Max pattern duration: 5660 ms
+- Max pattern duration: 5610 ms
 
 The format of the hardware pattern values should be:
 "brightness duration brightness duration ..."
diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 316ed8eb054f9..6bf3493f8e707 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -31,7 +31,7 @@
 #define ST1202_ILED_REG0                   0x09
 #define ST1202_MAX_LEDS                    12
 #define ST1202_MAX_PATTERNS                8
-#define ST1202_MILLIS_PATTERN_DUR_MAX      5660
+#define ST1202_MILLIS_PATTERN_DUR_MAX      (ST1202_MILLIS_PATTERN_DUR_MIN * U8_MAX)
 #define ST1202_MILLIS_PATTERN_DUR_MIN      22
 #define ST1202_PATTERN_DUR                 0x16
 #define ST1202_PATTERN_PWM                 0x1E
@@ -85,7 +85,7 @@ static int st1202_write_reg(struct st1202_chip *chip, int reg, uint8_t val)
 
 static uint8_t st1202_prescalar_to_miliseconds(unsigned int value)
 {
-	return value / ST1202_MILLIS_PATTERN_DUR_MIN - 1;
+	return value / ST1202_MILLIS_PATTERN_DUR_MIN;
 }
 
 static int st1202_pwm_pattern_write(struct st1202_chip *chip, int led_num,
@@ -209,7 +209,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 		if (ret != 0)
 			return ret;
 
-		ret = st1202_duration_pattern_write(chip, patt, ST1202_MILLIS_PATTERN_DUR_MIN);
+		ret = st1202_write_reg(chip, ST1202_PATTERN_DUR + patt, 0);
 		if (ret != 0)
 			return ret;
 	}
-- 
2.53.0



