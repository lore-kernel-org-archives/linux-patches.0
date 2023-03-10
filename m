Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E373881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78863C4339C;
	Fri, 10 Mar 2023 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459264;
	bh=t9l0rL79DdQH08zb7LFZMujbo5p/7YFo4WxHblT69XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVoy88++6CDF9LF5o7ELoPv0MiWL8X5mbqbqjwvrPBwMe78zRxOrryf78yXPFogT5
	 cUjFjESU23FeN8Lm9xItDfjjWnF1/IFUQQjVpVqXRuPxXJqM4yGc+d/gqFt1U8g3nO
	 yiaFVfuyB8QwtWDLGjeGOuNVsAn+MF7pNZeC9GbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 286/357] pwm: sifive: Always let the first pwm_apply_state succeed
Date: Fri, 10 Mar 2023 14:39:35 +0100
Message-Id: <20230310133747.377146274@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emil Renner Berthing <emil.renner.berthing@canonical.com>

[ Upstream commit 334c7b13d38321e47d1a51dba0bef9f4c403ec75 ]

Commit 2cfe9bbec56ea579135cdd92409fff371841904f added support for the
RGB and green PWM controlled LEDs on the HiFive Unmatched board
managed by the leds-pwm-multicolor and leds-pwm drivers respectively.
All three colours of the RGB LED and the green LED run from different
lines of the same PWM, but with the same period so this works fine when
the LED drivers are loaded one after the other.

Unfortunately it does expose a race in the PWM driver when both LED
drivers are loaded at roughly the same time. Here is an example:

  |          Thread A           |          Thread B           |
  |  led_pwm_mc_probe           |  led_pwm_probe              |
  |    devm_fwnode_pwm_get      |                             |
  |      pwm_sifive_request     |                             |
  |        ddata->user_count++  |                             |
  |                             |    devm_fwnode_pwm_get      |
  |                             |      pwm_sifive_request     |
  |                             |        ddata->user_count++  |
  |         ...                 |          ...                |
  |    pwm_state_apply          |    pwm_state_apply          |
  |      pwm_sifive_apply       |      pwm_sifive_apply       |

Now both calls to pwm_sifive_apply will see that ddata->approx_period,
initially 0, is different from the requested period and the clock needs
to be updated. But since ddata->user_count >= 2 both calls will fail
with -EBUSY, which will then cause both LED drivers to fail to probe.

Fix it by letting the first call to pwm_sifive_apply update the clock
even when ddata->user_count != 1.

Fixes: 9e37a53eb051 ("pwm: sifive: Add a driver for SiFive SoC PWM")
Signed-off-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 980ddcdd52953..16c70147ec40e 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -187,7 +187,13 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	mutex_lock(&ddata->lock);
 	if (state->period != ddata->approx_period) {
-		if (ddata->user_count != 1) {
+		/*
+		 * Don't let a 2nd user change the period underneath the 1st user.
+		 * However if ddate->approx_period == 0 this is the first time we set
+		 * any period, so let whoever gets here first set the period so other
+		 * users who agree on the period won't fail.
+		 */
+		if (ddata->user_count != 1 && ddata->approx_period) {
 			mutex_unlock(&ddata->lock);
 			ret = -EBUSY;
 			goto exit;
-- 
2.39.2



