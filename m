Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDAA2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03075C433D2;
	Wed, 12 Apr 2023 08:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289213;
	bh=UPSBXQrUPWEfNPDUuAdtUlcZe+56sNgmoQ7r0QlRKkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFpbpmEQgfNDC1oQU/OamqleLNGdxIha1+C94ktS8f+92LG1u7/3UGywXqp56ETHk
	 MxmqfPdST4og54S/XCVw3MwDX6Zikt3W4UBo5jkwPTKRhb4PoVyF461k3JoLsvk6nc
	 T1ZNaoikYqUaeVVAGlMBr1Z+GUROHPf8/slGiRnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Munehisa Kamata <kamatam@amazon.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 014/173] pwm: meson: Explicitly set .polarity in .get_state()
Date: Wed, 12 Apr 2023 10:32:20 +0200
Message-Id: <20230412082838.684701266@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

This fixes a regression that was possible since commit c73a3107624d
("pwm: Handle .get_state() failures") which stopped to zero-initialize
the state passed to the .get_state() callback. This was reported at
https://forum.odroid.com/viewtopic.php?f=177&t=46360 . While this was an
unintended side effect, the real issue is the driver's callback not
setting the polarity.

There is a complicating fact, that the .apply() callback fakes support
for inversed polarity. This is not (and cannot) be matched by
.get_state(). As fixing this isn't easy, only point it out in a comment
to prevent authors of other drivers from copying that approach.

Fixes: c375bcbaabdb ("pwm: meson: Read the full hardware state in meson_pwm_get_state()")
Reported-by: Munehisa Kamata <kamatam@amazon.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230310191405.2606296-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 16d79ca5d8f53..5cd7b90872c62 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -162,6 +162,12 @@ static int meson_pwm_calc(struct meson_pwm *meson, struct pwm_device *pwm,
 	duty = state->duty_cycle;
 	period = state->period;
 
+	/*
+	 * Note this is wrong. The result is an output wave that isn't really
+	 * inverted and so is wrongly identified by .get_state as normal.
+	 * Fixing this needs some care however as some machines might rely on
+	 * this.
+	 */
 	if (state->polarity == PWM_POLARITY_INVERSED)
 		duty = period - duty;
 
@@ -358,6 +364,8 @@ static int meson_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 		state->duty_cycle = 0;
 	}
 
+	state->polarity = PWM_POLARITY_NORMAL;
+
 	return 0;
 }
 
-- 
2.39.2



