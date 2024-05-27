Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2F461FDF;
	Mon, 27 May 2024 19:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838689; cv=none; b=oXx/BR39dbGSyVcfhmXAuUGTohKmGDeQdY14j8+DtxWm9VAJzl0Sy+SA9bTDs0RfCkjrb/+69F5MPDYtteBwQ6CGBPGsMmFoog5pJ+pDMp6BtTsRPNhXrHJjP3SWiS7n7+tDmtXeIViXqnS1ObWS5w/4noyJ2AwtNZJujbhY5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838689; c=relaxed/simple;
	bh=LyeDXIntMXFbVOjiw+3UM3dcFBAHrUqr10zq0XyuZEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfS84XmWHNx5BV/BYv6hfLDw1NOw9/Zg7XYjps3GAK76O9KS4yhgPwlfvf5MJ2Gz8U74Qjyrn9DJ2zrt3wuU1Tn+Zs2rAZ1A37xu56IRqSl5sNqckHkWfBKfgrxY3HzFZYvJ/W91i6zomJOOhw4pt3v5Imz4SJMiJan4LRCnIpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCfUjgaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCfUjgaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FB2C2BBFC;
	Mon, 27 May 2024 19:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838689;
	bh=LyeDXIntMXFbVOjiw+3UM3dcFBAHrUqr10zq0XyuZEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCfUjgaPvqoI3r/UrqHRzCdO7Aq4zmamAB/Mob/gb+2GLTY5uc1R6Reov1G2d/0wW
	 duYZs9rwGfu+oF/J7JG30VvZTqnaS7knHOuJ7LT6k4y7NrhzuoUp7iO44CaloMlY5z
	 A0Fryij7hYiOLPuIPBDO01Kx7KLaazbJFBIkVvBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 491/493] pwm: Fix setting period with #pwm-cells = <1> and of_pwm_single_xlate()
Date: Mon, 27 May 2024 20:58:13 +0200
Message-ID: <20240527185646.192296793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 73dfe970c038d0548beccc5bfb2707e1d543b01f ]

For drivers making use of of_pwm_single_xlate() (i.e. those that don't
pass a hwpwm index) and also don't pass flags, setting period was
wrongly skipped. This affects the pwm-pxa and ti-sn65dsi86 drivers.

Reported-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/D05IVTPYH35N.2CLDG6LSILRSN@matfyz.cz
Fixes: 40ade0c2e794 ("pwm: Let the of_xlate callbacks accept references without period")
Tested-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20240329103544.545290-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 830a697826af5..9d2dc5e1c8aac 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -443,7 +443,7 @@ of_pwm_single_xlate(struct pwm_chip *chip, const struct of_phandle_args *args)
 	if (IS_ERR(pwm))
 		return pwm;
 
-	if (args->args_count > 1)
+	if (args->args_count > 0)
 		pwm->args.period = args->args[0];
 
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
-- 
2.43.0



