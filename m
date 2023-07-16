Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE98F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEE6C433C8;
	Sun, 16 Jul 2023 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538988;
	bh=KQuGWxw2uvq6MAh0ZJuNmSFZ0aFdpkItQbEtiRsO/AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8MSvgqL5jJWCmu7H2bjzyqj9QNg6WHBWUUlchKPeSY65y7RA800pdqMg68QGbqmU
	 u3AozXbnvyhGiuDWpslYtuwYL2NF+YWeV4V/NrXYGN9M2lpITUgqnILKMm8kSiwQ3z
	 aCP4oCe9BjjNykGQ4SRCMCTBdd1A0dHX8r1cgEOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Brian Norris <briannorris@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 647/800] pwm: sysfs: Do not apply state to already disabled PWMs
Date: Sun, 16 Jul 2023 21:48:20 +0200
Message-ID: <20230716195004.143502984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 1a106ec329392..8d1254761e4dd 100644
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
@@ -448,7 +455,17 @@ static int pwm_class_suspend(struct device *parent)
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



