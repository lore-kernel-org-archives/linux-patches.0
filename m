Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036851C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7483AC433EF;
	Wed, 28 Dec 2022 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245326;
	bh=ZOJDY+bFvZ1DNZuIJQdi9c3Fo1VNfbpy3RHy5PuQMWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvGET5A6T8OV6fHtoyc9iTE0NjylfRS1YxafuH5dzbvs74p2Ef8WDgoZoI1Oy6qGz
	 iVslcv+M8oOAc+s0d61fp5RwQ/zHmWxJqAkwug0srf0AAF7uIWJIH3AQljYTdi8+Ra
	 g/NxqckGDm57rQMOFX5yu6wu2Al4ia+GKUJNKk8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0822/1146] pwm: tegra: Ensure the clock rate is not less than needed
Date: Wed, 28 Dec 2022 15:39:21 +0100
Message-Id: <20221228144352.482373964@linuxfoundation.org>
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

[ Upstream commit 5eccd0d9fabc4d2ab8d2a0c056fb1d7e2ff892fc ]

When dynamically scaling the PWM clock, the function
dev_pm_opp_set_rate() may set the PWM clock to a rate that is lower than
what is required. The clock rate requested when calling
dev_pm_opp_set_rate() is the minimum clock rate that is needed to drive
the PWM to achieve the required period. Hence, if the actual clock
rate is less than the requested clock rate, then the required period
cannot be achieved and configuring the PWM fails. Fix this by
calling clk_round_rate() to check if the clock rate that will be provided
is sufficient and if not, double the required clock rate to ensure the
required period can be attained.

Fixes: 8c193f4714df ("pwm: tegra: Optimize period calculation")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index b05ea2e8accc..6fc4b69a3ba7 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -148,6 +148,17 @@ static int tegra_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
 						     period_ns);
 
+		if (required_clk_rate > clk_round_rate(pc->clk, required_clk_rate))
+			/*
+			 * required_clk_rate is a lower bound for the input
+			 * rate; for lower rates there is no value for PWM_SCALE
+			 * that yields a period less than or equal to the
+			 * requested period. Hence, for lower rates, double the
+			 * required_clk_rate to get a clock rate that can meet
+			 * the requested period.
+			 */
+			required_clk_rate *= 2;
+
 		err = dev_pm_opp_set_rate(pc->dev, required_clk_rate);
 		if (err < 0)
 			return -EINVAL;
-- 
2.35.1



