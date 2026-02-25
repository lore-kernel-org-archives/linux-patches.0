Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C3718DB2A;
	Wed, 25 Feb 2026 01:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983126; cv=none; b=obMa1nB36+NdWHYPE0Gn7u1DrCs1+m0nSZ6HOl92CxNsc9YWXPWb4v1GxraOmpzmh53l0FgD62Um5Zjiy2Vo0nDeuBTIY8sPOpjNb9daUUW39hLiA5/nWD9Mc8HjtWCvbLk2QjF8z+mvDrfI91lJ8LrdnEtkZaeWomNdTy9oh0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983126; c=relaxed/simple;
	bh=NRtGu61Png4nVCRbs1Z/lRvDWnbhCHcIOemNuf479D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=btHrZFD5bQB3ezCOgINftwCFFrS408K12ft3Yj7x4rZFGPRvrDEDSuX56TdTFwPyvmT7DBzTy5fpLZ+oCrn362RPHjX9W5CfaOSrAYkXBLaQh/U7hatra8B+5l5q/EpOvPQSMcn0WTTqIi3kKpl8LDEaJWzzztPIh1YmJrNWwDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0V2uBar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0V2uBar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B92BC116D0;
	Wed, 25 Feb 2026 01:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983126;
	bh=NRtGu61Png4nVCRbs1Z/lRvDWnbhCHcIOemNuf479D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0V2uBarNBz82ZBKrPF+UEqtN/7VZzAAiqQq6K/w+3zerJd1NAv1qD49O125KpJFb
	 kjrsKqG2gnSzKGbjusunWxV5J5LEZkVkQbUkClFMDnq5Rt0r7wo51m+CHyUBECioW+
	 AHM2J0Jt2mR8zz770/9ZUPJFAa0BpD6SfawERujU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Praveen <g-praveen@ti.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 284/781] pwm: tiehrpwm: Enable pwmchips parent device before setting configuration
Date: Tue, 24 Feb 2026 17:16:33 -0800
Message-ID: <20260225012406.668195510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gokul Praveen <g-praveen@ti.com>

[ Upstream commit 75e7ed52ac7c1da90f304dcda2906636404df921 ]

The period and duty cycle configurations on J7200 and J784S4 SoCs
does not get reflected after setting them using sysfs nodes.
This is because at the end of ehrpwm_pwm_config function,
the put_sync function is called which resets the hardware.

Hold the PWM controller out of low-power mode during .apply() to
make sure it accepts the writes to its registers.

This renders the calls to pm_runtime_get_sync() and
pm_runtime_put_sync() in ehrpwm_pwm_config() into no-ops, so
these can be dropped.

Fixes: 5f027d9b83db ("pwm: tiehrpwm: Implement .apply() callback")
Signed-off-by: Gokul Praveen <g-praveen@ti.com>
Suggested-by: Uwe Kleine-König <ukleinek@kernel.org>
Link: https://patch.msgid.link/20260121061134.15466-1-g-praveen@ti.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 7a86cb090f76f..2533c95b0ba9d 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -237,8 +237,6 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (period_cycles < 1)
 		period_cycles = 1;
 
-	pm_runtime_get_sync(pwmchip_parent(chip));
-
 	/* Update clock prescaler values */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_CLKDIV_MASK, tb_divval);
 
@@ -290,8 +288,6 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (!(duty_cycles > period_cycles))
 		ehrpwm_write(pc->mmio_base, cmp_reg, duty_cycles);
 
-	pm_runtime_put_sync(pwmchip_parent(chip));
-
 	return 0;
 }
 
@@ -378,6 +374,8 @@ static int ehrpwm_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int err;
 	bool enabled = pwm->state.enabled;
 
+	guard(pm_runtime_active)(pwmchip_parent(chip));
+
 	if (state->polarity != pwm->state.polarity) {
 		if (enabled) {
 			ehrpwm_pwm_disable(chip, pwm);
-- 
2.51.0



