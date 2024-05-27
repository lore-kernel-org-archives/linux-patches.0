Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22643262BE;
	Mon, 27 May 2024 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838084; cv=none; b=nvX4MAxBrR0xHCP+42GLv/Fyr+Fap2S9UtSgdr8S225rLYZjdYSdyoXuRm3Vvo0yHeQzfWU4Ya3smTTMEQYFWhBNgzq0gDYWjbYCFmu7AhvP3YacpUZfYPahLyk12wxyag7lcyu+8Pp7TVDL3x81c5R24WY6NzlYf/KtyiKGH+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838084; c=relaxed/simple;
	bh=h4fiEiD231ZWQRH10cN9M+/G9mRr7m4pcIZ7ed+wtbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNehSVRCmWZaW1sAaVcV9rfppdlhyKIExQdWQdHU5cUsFTxHk6gPHTsP39yzSIII9L2xP/ijxxcGVd6/gN6anuLvNcR9zlQAfWEgVb/c7YE/HHY5eYgSIJbx4vy4VEemu4tfOv/7X6Iks2l+fkxvvOdG66Hriv8m2QZi/u6tNjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyHYCiJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyHYCiJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD15EC2BBFC;
	Mon, 27 May 2024 19:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838084;
	bh=h4fiEiD231ZWQRH10cN9M+/G9mRr7m4pcIZ7ed+wtbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyHYCiJs5z36oeSXi0uWfZC4iJeCIk44u9owMZd5cy1PHCMY6QvPXDcZxQgmEBELn
	 J2v0VDa67529++Z6/Fg1fheAqUNx8YtS8MJwzpWn9X3huf6KRf9Yvioyju4+8Oa06O
	 1qJUrbK96GuW6aXrw82bLVKy9wH2yGnsb7QM0UFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 258/493] pwm: Let the of_xlate callbacks accept references without period
Date: Mon, 27 May 2024 20:54:20 +0200
Message-ID: <20240527185638.730057765@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 40ade0c2e7940becad70a0643ba90488b905b468 ]

With this extension of_pwm_xlate_with_flags() is suitable to replace the
custom xlate function of the pwm-clps711x driver.

While touching these very similar functions align their implementations.

Link: https://lore.kernel.org/r/127622315d07d9d419ae8e6373c7e5be7fab7a62.1704835845.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 3e551115aee0 ("pwm: meson: Add check for error from clk_round_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 31f210872a079..606d9ef0c7097 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -107,8 +107,8 @@ of_pwm_xlate_with_flags(struct pwm_chip *chip, const struct of_phandle_args *arg
 {
 	struct pwm_device *pwm;
 
-	/* flags in the third cell are optional */
-	if (args->args_count < 2)
+	/* period in the second cell and flags in the third cell are optional */
+	if (args->args_count < 1)
 		return ERR_PTR(-EINVAL);
 
 	if (args->args[0] >= chip->npwm)
@@ -118,9 +118,10 @@ of_pwm_xlate_with_flags(struct pwm_chip *chip, const struct of_phandle_args *arg
 	if (IS_ERR(pwm))
 		return pwm;
 
-	pwm->args.period = args->args[1];
-	pwm->args.polarity = PWM_POLARITY_NORMAL;
+	if (args->args_count > 1)
+		pwm->args.period = args->args[1];
 
+	pwm->args.polarity = PWM_POLARITY_NORMAL;
 	if (args->args_count > 2 && args->args[2] & PWM_POLARITY_INVERTED)
 		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
@@ -133,18 +134,15 @@ of_pwm_single_xlate(struct pwm_chip *chip, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	/* validate that one cell is specified, optionally with flags */
-	if (args->args_count != 1 && args->args_count != 2)
-		return ERR_PTR(-EINVAL);
-
 	pwm = pwm_request_from_chip(chip, 0, NULL);
 	if (IS_ERR(pwm))
 		return pwm;
 
-	pwm->args.period = args->args[0];
-	pwm->args.polarity = PWM_POLARITY_NORMAL;
+	if (args->args_count > 1)
+		pwm->args.period = args->args[0];
 
-	if (args->args_count == 2 && args->args[1] & PWM_POLARITY_INVERTED)
+	pwm->args.polarity = PWM_POLARITY_NORMAL;
+	if (args->args_count > 1 && args->args[1] & PWM_POLARITY_INVERTED)
 		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
 	return pwm;
-- 
2.43.0



