Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9537CD32;
	Sat, 12 Sep 2026 07:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198022; cv=none; b=Vgu9u1gBrlc47QznrJZ2DKCySrezws1PJdowMyh6/5abQlZmQmg8R1JpT1XLTrCLO02BjNIzI77M5uUBdUFEuoipgmf40ba+xMIveHvKWtiU+ubzSLdoiEI1pqFuPiwvoRXGohGMMviGLKukPy3dKz3v23wP6G0qz5RcXOgmK8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198022; c=relaxed/simple;
	bh=+ciOgq2Pi+7AE95Dbh8V2KeHAgYOxZ6ff8hDLRMDthE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Koo0axpdYdClaZLVRJ8G1xKdNZTEwcg1iIDXAIrNA6vZAWfmVyiecJI4Ny94BbKc0jg8HN6jHlmD9zs3VgDcV7D9BHQXdTTjh9vtOweezwhgvzjgFI/KIy9ByK9PuaCZR8yWEvXqcwuMiB42ct4vjImBtcwP6esWRpFw7Idhl5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G68+eeJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G68+eeJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA08B1F000FF;
	Sat, 12 Sep 2026 07:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198021;
	bh=v9suHX4IPaGF+pPevWFvOpWWvoB0SrVY8mbSCoLeNOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G68+eeJGk3krIikdLhF//QQhh6xugd3niCyJFmJp7Yomt8V14001TIRakOUoILjWT
	 AI6pSK51QVatrt8YlziY5pFt7Bl2OW03HM716gyWewapUdmHIIBiHA9xpd1IyJw08O
	 LvOvC9xoPo5nwrggg+L3Zl7eq3RO2biR2AB3iKtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0295/1815] leds: st1202: Set all pattern PWM slots to full after clearing pattern
Date: Sat, 12 Sep 2026 08:34:05 +0200
Message-ID: <20260912065655.878387982@linuxfoundation.org>
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

[ Upstream commit d2ca0e2b6d6430f9c60bb2e0ee0b2b3dc4e5d86a ]

pattern_clear() sets all PWM registers for the channel to LED_OFF (0).
In static mode (PATS=0), the LED output is ILED x Pattern0_PWM / 4095;
with Pattern0 at zero the LED remains dark regardless of the ILED value.

The LED1202 has a single global sequencer shared across all channels.
If another channel starts the sequencer after this one has been cleared,
the cleared channel runs through all 8 steps at zero duty cycle and
stays dark regardless of ILED.

Set all 8 PWM slots to ST1202_PATTERN_PWM_FULL so that ILED alone
controls the channel brightness in both static and sequencer modes.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB849732C162CFE9E2C525AC16C5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 7cbe470366bd ("leds: st1202: Fix brightness having no effect while pattern mode is active")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index ce09cedc869fd..75a40ca445558 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -35,6 +35,7 @@
 #define ST1202_MILLIS_PATTERN_DUR_MIN      22
 #define ST1202_PATTERN_DUR                 0x16
 #define ST1202_PATTERN_PWM                 0x1E
+#define ST1202_PATTERN_PWM_FULL            0x0FFF
 #define ST1202_PATTERN_REP                 0x15
 
 struct st1202_led {
@@ -205,7 +206,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 		return ret;
 
 	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++) {
-		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, LED_OFF);
+		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
 		if (ret != 0)
 			return ret;
 
-- 
2.53.0



