Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1778481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D64C4339C;
	Fri, 10 Mar 2023 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457075;
	bh=0zI6VcRu3luBut8F6KbuWZP04gPQ/ZDrZxiRTlAOrFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4QwmdR68cenzUfamkv6vZPKyfTjzXZuGSGayulCA2+hV6MDSyJ+x+5MdmiK5Bp5q
	 GYcnzyDTlI27M3OM+kadkRlckRknDtmBkRe70aTo59Nn6ILKyFX/S5sCfc7iWFU2jn
	 jnSB2gEO3i7tB9kw+DdXeKs+lOzaRPXLtdZVdRko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/200] pwm: sifive: Always let the first pwm_apply_state succeed
Date: Fri, 10 Mar 2023 14:36:59 +0100
Message-Id: <20230310133717.425371015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index bb72393134016..89d53a0f91e65 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -159,7 +159,13 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
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
 			return -EBUSY;
 		}
-- 
2.39.2



