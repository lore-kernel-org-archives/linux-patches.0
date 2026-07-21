Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BDF3C1400;
	Tue, 21 Jul 2026 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673536; cv=none; b=Vvqh0tjQYkx9h37lqUC22/fC8m9Nv8T7R5hJ/vOnFJDbAJ1HcgsrIY47S3fTEw/2osjDdoYfT+cQpd0997PjWwrl5/TAInDu8UxuGpl1QsY3s1FutJyjUriL31hskUKWZFVEebXSwhnFQM1PWOjjY1SyoYeRL9Zhhol7avxAC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673536; c=relaxed/simple;
	bh=Bx/K+8UNlGfwsFBfGYQNHayV6rRmFIwvWg1eXUvuJmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kGRYpA9+QzXNn140g6QnvMDK5rD1tddpm66g9wrRiuHOtBLDGdcRdPlLzliePfJUyYekDue7TJobt3jIPlZ3tpLQ/DkEZ6XnwF2K4UlcuFXZrhuBuENWbJxyeHzSmh82cPzPFZUL7zo6/G0vV01x5tiqdbrZ12QCJt7Q4ahNPxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1rr4dMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1rr4dMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE851F000E9;
	Tue, 21 Jul 2026 22:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673535;
	bh=HoyCsjdip52osqM86SU/1UqM8kB1cx2igeTYtPeNWKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1rr4dMFKfd+bpPP7niL2mF0iK4gZMbKr0I0j0TslRA8XT3H1iFP/zBy3mE1LGLaL
	 uySuBwBGeDvXMOOT2G4FNHfrdxUJMgmiN8TzD8mm01tQljhtuotw6iEnR9HX0M1bW/
	 yw8LJCU+GM9fipKzowGpRImDsqFoPnDihswlCV+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronaldo Nunez <rnunez@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/699] pwm: imx27: Fix variable truncation in .apply()
Date: Tue, 21 Jul 2026 17:19:18 +0200
Message-ID: <20260721152400.187750181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronaldo Nunez <rnunez@baylibre.com>

[ Upstream commit dc9e08fdbcc3eb08a1d2b868b535081c44425e27 ]

Fix a variable truncation when calculating period in microseconds as
part of the solution for the ERR051198 in .apply() callback.

Example scenario:
 - Period of 3us (PWMPR = 196 and prescaler = 1)
 - Expected value in tmp: 198000000000 (NSEC_PER_SEC * (196 + 2) * 1)
 - Actual value is 431504384 (truncation to u32)

Signed-off-by: Ronaldo Nunez <rnunez@baylibre.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260522191348.6227-1-rnunez@baylibre.com
Fixes: a25351e4c774 ("pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index 3c7929ca3b9212..683435f075f19f 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -216,7 +216,7 @@ static void pwm_imx27_wait_fifo_slot(struct pwm_chip *chip,
 static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			   const struct pwm_state *state)
 {
-	unsigned long period_cycles, duty_cycles, prescale, period_us, tmp;
+	unsigned long period_cycles, duty_cycles, prescale, period_us;
 	struct pwm_imx27_chip *imx = to_pwm_imx27_chip(chip);
 	struct pwm_state cstate;
 	unsigned long long c;
@@ -225,6 +225,7 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int val;
 	int ret;
 	u32 cr;
+	u64 tmp;
 
 	pwm_get_state(pwm, &cstate);
 
@@ -268,6 +269,11 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	val = readl(imx->mmio_base + MX3_PWMPR);
 	val = val >= MX3_PWMPR_MAX ? MX3_PWMPR_MAX : val;
 	cr = readl(imx->mmio_base + MX3_PWMCR);
+
+	/*
+	 * tmp stores period in nanoseconds. Result fits in u64 since
+	 * val <= 0xfffe and prescaler in [1, 0x1000].
+	 */
 	tmp = NSEC_PER_SEC * (u64)(val + 2) * MX3_PWMCR_PRESCALER_GET(cr);
 	tmp = DIV_ROUND_UP_ULL(tmp, clkrate);
 	period_us = DIV_ROUND_UP_ULL(tmp, 1000);
-- 
2.53.0



