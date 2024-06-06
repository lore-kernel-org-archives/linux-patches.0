Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4FE1BE23E;
	Thu,  6 Jun 2024 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683532; cv=none; b=twk22ZtU+cJycbOKViP5OeZFQVPLODy1nEx34zgkkNPfxNnQmCuEYw3Mk+AcbzACga09pExcfEiLXxCP6w9eweq/GHpLfUI/Ev77pKHQPrOv5n95u4/MDhynvuVmxn0kq/qjc3A1xrYIC/E7lI18CvOkGFM50uQ5aeh4ipa1IlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683532; c=relaxed/simple;
	bh=q/ocA9YPOctYLQj3SsnOcG6HsrM7R8bESiwT6P+pLes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COnznBOQ/GoJGnlq3jfOpPBJOVJccrCxDvRuNML9EP4L+TCgydg5UPe7r0NFMKtdeVLjR3gwduBLNvxf8z0lSKu7hhyDmpC5faChyzldwKy7TzLKXce7G+F0y/25Z3F+1YHf340s72KdTgxP1WdOGbMeAnb8DFpRwOWmahAJPhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXw8OKxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXw8OKxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1719DC32782;
	Thu,  6 Jun 2024 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683532;
	bh=q/ocA9YPOctYLQj3SsnOcG6HsrM7R8bESiwT6P+pLes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXw8OKxdSfMCGrJ2EzV4vQdZNG+4E4OsEQ9RPXuRqNSWS6FFd/fxEs8zQQi7NGjXY
	 5heeGguXFZd+uDNgfzFJd960Sek/ZFeQ5Vefg5CCpYz9vEuiTWSMFYcgb7+5/Zf2AB
	 k6nEZBfuDpt8Koq2MYHvZ1U5YXZgdLgHzK+MoMrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 472/744] leds: pwm: Disable PWM when going to suspend
Date: Thu,  6 Jun 2024 16:02:24 +0200
Message-ID: <20240606131747.600212143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 974afccd37947a6951a052ef8118c961e57eaf7b ]

On stm32mp1xx based machines (and others) a PWM consumer has to disable
the PWM because an enabled PWM refuses to suspend. So check the
LED_SUSPENDED flag and depending on that set the .enabled property.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218559
Fixes: 76fe464c8e64 ("leds: pwm: Don't disable the PWM when the LED should be off")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20240417153846.271751-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pwm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 4e3936a39d0ed..e1b414b403534 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -53,7 +53,13 @@ static int led_pwm_set(struct led_classdev *led_cdev,
 		duty = led_dat->pwmstate.period - duty;
 
 	led_dat->pwmstate.duty_cycle = duty;
-	led_dat->pwmstate.enabled = true;
+	/*
+	 * Disabling a PWM doesn't guarantee that it emits the inactive level.
+	 * So keep it on. Only for suspending the PWM should be disabled because
+	 * otherwise it refuses to suspend. The possible downside is that the
+	 * LED might stay (or even go) on.
+	 */
+	led_dat->pwmstate.enabled = !(led_cdev->flags & LED_SUSPENDED);
 	return pwm_apply_might_sleep(led_dat->pwm, &led_dat->pwmstate);
 }
 
-- 
2.43.0



