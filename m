Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936F91A2C0F;
	Thu, 15 Aug 2024 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731063; cv=none; b=ROvTJ0RjdA3pWtt+02pXFoDTYnlRHJJ8KWlEfsNndxFrDgsfWgmvNIho58NUBplO3AqGYpRvZamyyVmLQoORl3U7zbiGvHsFYKT9KHZ30rmL3gRhoN7KWKU8Oxic2nS5Gnv7F3UFtwRtB6L9GwC10U4EdqLgihmXIYyZoBCArfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731063; c=relaxed/simple;
	bh=A6oJ/rdARD/bJkFye4nEjl2AxeGQNIifz8AdZprThWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6Gq493l06XmXoWbURv8DcT8xCgaXt42OKYZTYAbmfdVd9l14cV2GaluB/Y/D3Z3MzMeqZUm5rO/xk1TprAqUbTD3/hAU6HRXG7uMG4aOyfskL0vFi7Q44aNCQIfcwC+AeVcXfLvr7bMh1Y7zHuhaW9hWIRdnvInLWftGpKJqn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTnf/55M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTnf/55M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D3FC4AF0C;
	Thu, 15 Aug 2024 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731063;
	bh=A6oJ/rdARD/bJkFye4nEjl2AxeGQNIifz8AdZprThWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTnf/55MCW5aR5zNxbmvVjh7mgEh9QjzhEdKIPy5SlaAteDHrTE59o2GxCqV2mrF/
	 HKTXZXIvyI4KPh0gkfOpbT7LMBtJW+VzcsQiW64rU4AIkY3zQMYZZhnwA6j/irPsVy
	 Se3YlCX5RWH0iFK59cde7b7O3jdRi1hWLA68mMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/259] pwm: stm32: Always do lazy disabling
Date: Thu, 15 Aug 2024 15:22:25 +0200
Message-ID: <20240815131903.267873749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4b20ff6f687b8..9e94a797dcf31 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -451,8 +451,9 @@ static int stm32_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
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



