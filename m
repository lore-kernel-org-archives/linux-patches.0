Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6FF79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3010FC433D2;
	Thu, 12 Jan 2023 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533818;
	bh=Uz2Ee5ijYTBcy0o61+oYjR3HI+RC7M096y88ACEfYhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2wzG6c5KnH4ulVyUZiZgWg4FA5OIvdWxeOOg/pVZgP/G/j7Z8u2m42Tiq6Qzq5Af
	 Y8WtS4D+8N/nSb7pJce3GZoaK+MnHfFp+P6Gav5Smzyyhz+DkWTU57CIDwdWlQ6jzu
	 hTrbBUcPpz8PCf1K43o+/KsclNjJaJXSCljsm0Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 571/783] pwm: tegra: Fix 32 bit build
Date: Thu, 12 Jan 2023 14:54:47 +0100
Message-Id: <20230112135550.702353952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

[ Upstream commit dd1f1da4ada5d8ac774c2ebe97230637820b3323 ]

The value of NSEC_PER_SEC << PWM_DUTY_WIDTH doesn't fix within a 32 bit
integer causing a build warning/error (and the value truncated):

  drivers/pwm/pwm-tegra.c: In function ‘tegra_pwm_config’:
  drivers/pwm/pwm-tegra.c:148:53: error: result of ‘1000000000 << 8’ requires 39 bits to represent, but ‘long int’ only has 32 bits [-Werror=shift-overflow=]
    148 |   required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
        |                                                     ^~

Explicitly cast to a u64 to ensure the correct result.

Fixes: cfcb68817fb3 ("pwm: tegra: Improve required rate calculation")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 36cc1452cb7a..f3528c56e894 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -142,7 +142,7 @@ static int tegra_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		 * source clock rate as required_clk_rate, PWM controller will
 		 * be able to configure the requested period.
 		 */
-		required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
+		required_clk_rate = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC << PWM_DUTY_WIDTH,
 						     period_ns);
 
 		err = clk_set_rate(pc->clk, required_clk_rate);
-- 
2.35.1



