Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780236E484;
	Sat, 12 Sep 2026 09:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206833; cv=none; b=U4x5j5PYYTdkzoVUmrQfc1dCbV5c/8ztPn1tyTsEDscQZCaSdP+thNR+jKQ73jOZ9F1qcbSfOng6876A1o3KonAIBkAJLZ3xgoFulfxClXMULhIz330gNn6+wjNxS+KWG3TAoI4F4ufVpmoGnufVmz2GN94shjdk83D55eQ0QQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206833; c=relaxed/simple;
	bh=6zNCpOIbQpYHzkdy1qn/iDK2ODLcAIKNNTfPN3yEM+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk/b7i3tPPPFn8+D5mX/UEPQzKKIz2TiwQ7A5hNQLvxdFdyKDpBbMzgkkok5RU3DMBGN/XgR9scAfbE1BwhHWpdsClEMJERzjO9Cnu6GpMj2xdEFBdeURWcIh1hOBQN+MQUbjeXbBmEnELxwpNBxmBJgRd9u5C8RaQkyzFIwbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePPa0buG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePPa0buG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CAB1F000FF;
	Sat, 12 Sep 2026 09:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206832;
	bh=CIQNjfihW7btsrVhv/pIFdgh7oufKQOg4M/Z3UcOzz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePPa0buGvduc707IS4Uxp4rgBA7ewagS5sEpGRIeCqeJo/uR5berM5fISE9DVzL2h
	 MC0bUtFOuQYtx5EBfdJF4JzdnzNLEDAjit2xGru4q90DQBHVIZMOG9IIEz4SAs24Na
	 aYTNEsqWlK+N9TqqhXTGcIY97xpnZR/lQyH8z1WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0289/1518] leds: st1202: Set all pattern PWM slots to full after clearing pattern
Date: Sat, 12 Sep 2026 08:40:58 +0200
Message-ID: <20260912065630.019803443@linuxfoundation.org>
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
index 413c2bd68dab5..4627b244c12fe 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -36,6 +36,7 @@
 #define ST1202_MILLIS_PATTERN_DUR_MIN      22
 #define ST1202_PATTERN_DUR                 0x16
 #define ST1202_PATTERN_PWM                 0x1E
+#define ST1202_PATTERN_PWM_FULL            0x0FFF
 #define ST1202_PATTERN_REP                 0x15
 
 struct st1202_led {
@@ -206,7 +207,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 		return ret;
 
 	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++) {
-		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, LED_OFF);
+		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
 		if (ret != 0)
 			return ret;
 
-- 
2.53.0



