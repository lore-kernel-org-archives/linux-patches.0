Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E98819DF85;
	Thu, 15 Aug 2024 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731891; cv=none; b=V2BQoSp4/hs218K1FX+G8Go1mCGdY7TNjt2RglvV26vbL6wBVVqXJjC7DXyShk+2rTxWsEJPIa5KaT3uUG70vt9IkQXW0b7xmmA+8/hUH8u4lnQcJA53jPzbSjtyNq1shR8nNf4VxLQF8PZVL1EI34IOZdEo1bsFZZmF5TM2NKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731891; c=relaxed/simple;
	bh=xOn5HlOGlEqtIUaSaQV3n7wcvWLMvW6dSWSYIQSzyGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qWc5er1fEBooFnnNYBJbQiBgRH8X41FPZ/9rIu6ThLI8uzRRBJI04aYMuiLovyWp12515cdEU4NlXuIxpaoeTnVVl/RvPnmA9JG6Eiyjgz2ZA5k0Vm7EgGtXj3VmsV/LnC9ZTYKQZmD5LLHvJMNFsmsyBL1xFmDm3xy/EHvUVTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xN3UjFFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xN3UjFFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75858C32786;
	Thu, 15 Aug 2024 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731890;
	bh=xOn5HlOGlEqtIUaSaQV3n7wcvWLMvW6dSWSYIQSzyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xN3UjFFKRrewdfbj6KNK1i23X3ErBZY8rqpWwTza5eY7R7H6Ry8cHFw4zYXEsc5U+
	 y+Dl7fffRa6Qk8AT7I1oD0MKAkXsLCgHnlX9QrK8FV4Rd72zoVJoRy7sAYUov+KkCJ
	 2+A7bTrBid9zA1//XVEa3wNoOzNzh6vKhof+E6ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/352] pwm: stm32: Always do lazy disabling
Date: Thu, 15 Aug 2024 15:21:16 +0200
Message-ID: <20240815131919.609106698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3e5f1b622af89..7146b3f6755bc 100644
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



