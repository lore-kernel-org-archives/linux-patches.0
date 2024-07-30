Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C8F29A2;
	Tue, 30 Jul 2024 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355008; cv=none; b=l2v+eCG8JCqvJZFHUo3pg0yDOZRZGx3IjRwM95+f1pV7oQxeuJrkaKN33AGugW/D1RwA7zVANPhoORbsQ143QjMCtP332vkU60c7/Vo9AQeScfDo2+zB5Uk6HO+rkzqOAGlQOpY451/7EA9HAgApp6+zs8Z83J0wDk0+20S9Dno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355008; c=relaxed/simple;
	bh=EDrzYtPAihkmbKQ8HViqnRjaCCinFdcZPfPDNVuINr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zc4WF/OPx89lpPf8aHsupFRSOn545EvzA/YNDMEucb+KLWTWLf0fAt59NbkiYl0lLBfiQBGpUmxTgcunQgHgjFXL0fEpWXz9jb4tuf4kgcwKXFwPePERhFPSPis2MjzqbJXIA+jgPlymA+rYXYFx0Bb9oNL6dhjx2oMdBWP1PiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkDp9YB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkDp9YB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BE3C32782;
	Tue, 30 Jul 2024 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355007;
	bh=EDrzYtPAihkmbKQ8HViqnRjaCCinFdcZPfPDNVuINr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkDp9YB7o1+koI5cysXOU5gq0VpP7laqm5orl+XpXTKzMIuZZlFL9B1lJr7wHuFhg
	 ctXM62K03AVk0tyXvDsINI6VQv+hdT3XTZHhJtz9NAqeqsW2O3elwRpgwmtUFzIUVn
	 wOOVDxhTqP0MrxofmBF2sf1K6SS5ofcew+cvx4cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/440] pwm: stm32: Always do lazy disabling
Date: Tue, 30 Jul 2024 17:44:15 +0200
Message-ID: <20240730151616.632418257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 7346e7a058a2c9aa9ff1cc699c7bf18a402d9f84 ]

When the state changes from enabled to disabled, polarity, duty_cycle
and period are not configured in hardware and TIM_CCER_CCxE is just
cleared. However if the state changes from one disabled state to
another, all parameters are written to hardware because the early exit
from stm32_pwm_apply() is only taken if the pwm is currently enabled.

This yields surprises like: Applying

	{ .period = 1, .duty_cycle = 0, .enabled = false }

succeeds if the pwm is initially on, but fails if it's already off
because 1 is a too small period.

Update the check for lazy disable to always exit early if the target
state is disabled, no matter what is currently configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20240703110010.672654-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index c40a6548ce7d4..2070d107c6328 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -452,8 +452,9 @@ static int stm32_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	enabled = pwm->state.enabled;
 
-	if (enabled && !state->enabled) {
-		stm32_pwm_disable(priv, pwm->hwpwm);
+	if (!state->enabled) {
+		if (enabled)
+			stm32_pwm_disable(priv, pwm->hwpwm);
 		return 0;
 	}
 
-- 
2.43.0



