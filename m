Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B317C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A92BC4339B;
	Mon, 24 Apr 2023 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343040;
	bh=TOHLKMNE2N04ShlJ935cEwbbALFg+w5eCiem8giX+pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa4qo6noGtyddRaV0ss9J7du8QlvNC6hxVBnUTU6QYGRmygEVUVLUT+3aw8CYx/0c
	 MOE2LJ//YggdSzV41ICcD4TeqpHt2IX9bEF0oZ1tAL1eGhK8M0o1a35sbdIAxa4GQe
	 soqeDu2weYzBNnt6pjXiMTmB+NM+xo/Z7GLG6cWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Munehisa Kamata <kamatam@amazon.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 6.2 054/110] pwm: Zero-initialize the pwm_state passed to drivers .get_state()
Date: Mon, 24 Apr 2023 15:17:16 +0200
Message-Id: <20230424131138.305899483@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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

commit 1271a7b98e7989ba6bb978e14403fc84efe16e13 upstream.

This is just to ensure that .usage_power is properly initialized and
doesn't contain random stack data. The other members of struct pwm_state
should get a value assigned in a successful call to .get_state(). So in
the absence of bugs in driver implementations, this is only a safe-guard
and no fix.

Reported-by: Munehisa Kamata <kamatam@amazon.com>
Link: https://lore.kernel.org/r/20230310214004.2619480-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -115,7 +115,14 @@ static int pwm_device_request(struct pwm
 	}
 
 	if (pwm->chip->ops->get_state) {
-		struct pwm_state state;
+		/*
+		 * Zero-initialize state because most drivers are unaware of
+		 * .usage_power. The other members of state are supposed to be
+		 * set by lowlevel drivers. We still initialize the whole
+		 * structure for simplicity even though this might paper over
+		 * faulty implementations of .get_state().
+		 */
+		struct pwm_state state = { 0, };
 
 		err = pwm->chip->ops->get_state(pwm->chip, pwm, &state);
 		trace_pwm_get(pwm, &state, err);
@@ -448,7 +455,7 @@ static void pwm_apply_state_debug(struct
 {
 	struct pwm_state *last = &pwm->last;
 	struct pwm_chip *chip = pwm->chip;
-	struct pwm_state s1, s2;
+	struct pwm_state s1 = { 0 }, s2 = { 0 };
 	int err;
 
 	if (!IS_ENABLED(CONFIG_PWM_DEBUG))
@@ -530,6 +537,7 @@ static void pwm_apply_state_debug(struct
 		return;
 	}
 
+	*last = (struct pwm_state){ 0 };
 	err = chip->ops->get_state(chip, pwm, last);
 	trace_pwm_get(pwm, last, err);
 	if (err)


