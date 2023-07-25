Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5191ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30201C433C8;
	Tue, 25 Jul 2023 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285266;
	bh=Vud6obfizqYdyeFkw/M+7j5NiNWHYlmmN5zXvDLTbJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ehn9SgT2YL/S/Kpw7u4LAMfmVJW18eq+hOqJ9LdySA8p2lM70I4naEAm2xj1bGtng
	 wctCosF+kqVDH1dNtMCwIDmbTNXQeFxVnFQCvKjSoP8/LFHHskwn+AgLOuOWURz8Mj
	 rqsNpWH2p1l0rvDkTdhE56ZyYCAkIoiJwl9Wj794=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fancy Fang <chen.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/313] pwm: imx-tpm: force real_period to be zero in suspend
Date: Tue, 25 Jul 2023 12:44:56 +0200
Message-ID: <20230725104527.172341409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fancy Fang <chen.fang@nxp.com>

[ Upstream commit 661dfb7f46298e53f6c3deaa772fa527aae86193 ]

During suspend, all the tpm registers will lose values.
So the 'real_period' value of struct 'imx_tpm_pwm_chip'
should be forced to be zero to force the period update
code can be executed after system resume back.

Signed-off-by: Fancy Fang <chen.fang@nxp.com>
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 738a1cfec2ed ("pwm: Add i.MX TPM PWM driver support")
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx-tpm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pwm/pwm-imx-tpm.c b/drivers/pwm/pwm-imx-tpm.c
index 9145f61606497..85aad55b7a8f0 100644
--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -405,6 +405,13 @@ static int __maybe_unused pwm_imx_tpm_suspend(struct device *dev)
 	if (tpm->enable_count > 0)
 		return -EBUSY;
 
+	/*
+	 * Force 'real_period' to be zero to force period update code
+	 * can be executed after system resume back, since suspend causes
+	 * the period related registers to become their reset values.
+	 */
+	tpm->real_period = 0;
+
 	clk_disable_unprepare(tpm->clk);
 
 	return 0;
-- 
2.39.2



