Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FF91ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D5C433C7;
	Tue, 25 Jul 2023 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284160;
	bh=60XPIcNlGnhMKU3gMnOvVNCgEaWji4YYk+vu0/CWXgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNRnhX1x2uq067qV7bZXGmgO6tRAwsgyKlBrpweHQ2na2Cc4i20g10Y04XGYxTV8P
	 LczjsNNN00SzJt5Pk6qYJNLv9C4/u2yyU29Ixdiu09XOa/xK01s31+i3hx+wyW8FoF
	 Ho6PTMrwfbD9jqvgObsqc3sXQyTMJQLudkNq9A/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Brian Norris <briannorris@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/509] pwm: sysfs: Do not apply state to already disabled PWMs
Date: Tue, 25 Jul 2023 12:43:16 +0200
Message-ID: <20230725104605.518647148@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 38ba83598633373f47951384cfc389181c8d1bed ]

If the PWM is exported but not enabled, do not call pwm_class_apply_state().
First of all, in this case, period may still be unconfigured and this would
make pwm_class_apply_state() return -EINVAL, and then suspend would fail.
Second, it makes little sense to apply state onto PWM that is not enabled
before suspend.

Failing case:
"
$ echo 1 > /sys/class/pwm/pwmchip4/export
$ echo mem > /sys/power/state
...
pwm pwmchip4: PM: dpm_run_callback(): pwm_class_suspend+0x1/0xa8 returns -22
pwm pwmchip4: PM: failed to suspend: error -22
PM: Some devices failed to suspend, or early wake event detected
"

Working case:
"
$ echo 1 > /sys/class/pwm/pwmchip4/export
$ echo 100 > /sys/class/pwm/pwmchip4/pwm1/period
$ echo 10 > /sys/class/pwm/pwmchip4/pwm1/duty_cycle
$ echo mem > /sys/power/state
...
"

Do not call pwm_class_apply_state() in case the PWM is disabled
to fix this issue.

Fixes: 7fd4edc57bbae ("pwm: sysfs: Add suspend/resume support")
Signed-off-by: Marek Vasut <marex@denx.de>
Fixes: ef2bf4997f7d ("pwm: Improve args checking in pwm_apply_state()")
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/sysfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index 9903c3a7ecedc..b8417a8d2ef97 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -424,6 +424,13 @@ static int pwm_class_resume_npwm(struct device *parent, unsigned int npwm)
 		if (!export)
 			continue;
 
+		/* If pwmchip was not enabled before suspend, do nothing. */
+		if (!export->suspend.enabled) {
+			/* release lock taken in pwm_class_get_state */
+			mutex_unlock(&export->lock);
+			continue;
+		}
+
 		state.enabled = export->suspend.enabled;
 		ret = pwm_class_apply_state(export, pwm, &state);
 		if (ret < 0)
@@ -448,7 +455,17 @@ static int __maybe_unused pwm_class_suspend(struct device *parent)
 		if (!export)
 			continue;
 
+		/*
+		 * If pwmchip was not enabled before suspend, save
+		 * state for resume time and do nothing else.
+		 */
 		export->suspend = state;
+		if (!state.enabled) {
+			/* release lock taken in pwm_class_get_state */
+			mutex_unlock(&export->lock);
+			continue;
+		}
+
 		state.enabled = false;
 		ret = pwm_class_apply_state(export, pwm, &state);
 		if (ret < 0) {
-- 
2.39.2



