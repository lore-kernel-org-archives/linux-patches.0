Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624161C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF6BC433F0;
	Wed, 28 Dec 2022 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245268;
	bh=xiA8YweXtP5y68sH9U3r4YWn0jZmWZyVPNXq1vaYWaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnOSya9CVseweVAJA89Ea/KSD3TjZu1wHoyJOhNko2QeZiDaiWgfX7hZBpLVYlINx
	 3nL7rtQx7x6GOYXCqIPHRrpFHTHUAOkDFazP9bZZRYIuaJEeQ1tahXAO19IA/Cdoos
	 teTckKjj6Qxv0ujWIr95oDDykN7P0AChoKE6WkwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0821/1146] pwm: tegra: Improve required rate calculation
Date: Wed, 28 Dec 2022 15:39:20 +0100
Message-Id: <20221228144352.456705779@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit f271946117dde2ca8741b8138b347b2d68e6ad56 ]

For the case where dev_pm_opp_set_rate() is called to set the PWM clock
rate, the requested rate is calculated as ...

 required_clk_rate = (NSEC_PER_SEC / period_ns) << PWM_DUTY_WIDTH;

The above calculation may lead to rounding errors because the
NSEC_PER_SEC is divided by 'period_ns' before applying the
PWM_DUTY_WIDTH multiplication factor. For example, if the period is
45334ns, the above calculation yields a rate of 5646848Hz instead of
5646976Hz. Fix this by applying the multiplication factor before
dividing and using the DIV_ROUND_UP macro which yields the expected
result of 5646976Hz.

Fixes: 1d7796bdb63a ("pwm: tegra: Support dynamic clock frequency configuration")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index dad9978c9186..b05ea2e8accc 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -145,8 +145,8 @@ static int tegra_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		 * source clock rate as required_clk_rate, PWM controller will
 		 * be able to configure the requested period.
 		 */
-		required_clk_rate =
-			(NSEC_PER_SEC / period_ns) << PWM_DUTY_WIDTH;
+		required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
+						     period_ns);
 
 		err = dev_pm_opp_set_rate(pc->dev, required_clk_rate);
 		if (err < 0)
-- 
2.35.1



