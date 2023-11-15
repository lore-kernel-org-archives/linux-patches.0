Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F00D18657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZVVuXPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CEBC433CA;
	Wed, 15 Nov 2023 20:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081884;
	bh=C9T6L5p+l321sqi/DwwDw0DwW5FP9HVcH6TvCFomdsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZVVuXPMqldxoJrYnnYCLaA1+XP7x2gj1Vf/XbvN+AuNT9VNPvbGlX1U89qZ9CMjJ
	 GS2WIqyo+4odjubr7tD1IqH1ZGPLAeT3gVHwxQrxN90LF8NuEZ+pZsTCAvrSAU8tF3
	 /RX3nmXaxgZZx6AC8j1/igFd1PhgP5XsNoXFBM4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee.jones@linaro.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/191] pwm: sti: Avoid conditional gotos
Date: Wed, 15 Nov 2023 15:47:16 -0500
Message-ID: <20231115204654.124890374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Thierry Reding <thierry.reding@gmail.com>

[ Upstream commit fd3ae02bb66f091e55f363d32eca7b4039977bf5 ]

Using gotos for conditional code complicates this code significantly.
Convert the code to simple conditional blocks to increase readability.

Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 2d6812b41e0d ("pwm: sti: Reduce number of allocations and drop usage of chip_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sti.c | 48 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 1508616d794cd..973f76856a508 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -593,38 +593,34 @@ static int sti_pwm_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (!cdata->pwm_num_devs)
-		goto skip_pwm;
-
-	pc->pwm_clk = of_clk_get_by_name(dev->of_node, "pwm");
-	if (IS_ERR(pc->pwm_clk)) {
-		dev_err(dev, "failed to get PWM clock\n");
-		return PTR_ERR(pc->pwm_clk);
-	}
+	if (cdata->pwm_num_devs) {
+		pc->pwm_clk = of_clk_get_by_name(dev->of_node, "pwm");
+		if (IS_ERR(pc->pwm_clk)) {
+			dev_err(dev, "failed to get PWM clock\n");
+			return PTR_ERR(pc->pwm_clk);
+		}
 
-	ret = clk_prepare(pc->pwm_clk);
-	if (ret) {
-		dev_err(dev, "failed to prepare clock\n");
-		return ret;
+		ret = clk_prepare(pc->pwm_clk);
+		if (ret) {
+			dev_err(dev, "failed to prepare clock\n");
+			return ret;
+		}
 	}
 
-skip_pwm:
-	if (!cdata->cpt_num_devs)
-		goto skip_cpt;
-
-	pc->cpt_clk = of_clk_get_by_name(dev->of_node, "capture");
-	if (IS_ERR(pc->cpt_clk)) {
-		dev_err(dev, "failed to get PWM capture clock\n");
-		return PTR_ERR(pc->cpt_clk);
-	}
+	if (cdata->cpt_num_devs) {
+		pc->cpt_clk = of_clk_get_by_name(dev->of_node, "capture");
+		if (IS_ERR(pc->cpt_clk)) {
+			dev_err(dev, "failed to get PWM capture clock\n");
+			return PTR_ERR(pc->cpt_clk);
+		}
 
-	ret = clk_prepare(pc->cpt_clk);
-	if (ret) {
-		dev_err(dev, "failed to prepare clock\n");
-		return ret;
+		ret = clk_prepare(pc->cpt_clk);
+		if (ret) {
+			dev_err(dev, "failed to prepare clock\n");
+			return ret;
+		}
 	}
 
-skip_cpt:
 	pc->chip.dev = dev;
 	pc->chip.ops = &sti_pwm_ops;
 	pc->chip.base = -1;
-- 
2.42.0



