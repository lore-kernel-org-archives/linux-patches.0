Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D58F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324B6C433C8;
	Sun, 16 Jul 2023 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538985;
	bh=lN9GC96fFjomqeeakVzw8SDRD0GIjjAzMzuPCM4RI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjNFf5qG9VxmCiUrXwnjq7Dxs14f8sdNRAko5hfO0ocCAfg4HM6x+yNVpMQz7Jctu
	 qMxx4ilGbrDyTCONdklge/cwiimCNEjVoVbC7mNIYMTjCBN0k5Dfaw6nX5HA1IsGV+
	 HAxr4PZpwH3m9Jb2E2zMNNkN8ordvgzaZveVx0Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fancy Fang <chen.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 646/800] pwm: imx-tpm: force real_period to be zero in suspend
Date: Sun, 16 Jul 2023 21:48:19 +0200
Message-ID: <20230716195004.120025226@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 5e2b452ee5f2e..98ab65c896850 100644
--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -397,6 +397,13 @@ static int __maybe_unused pwm_imx_tpm_suspend(struct device *dev)
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



