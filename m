Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB383A8FA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaVEVA8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33F0C433C9;
	Wed, 15 Nov 2023 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078495;
	bh=SoitURy6utUwZM8fxDJol4XHEjuhG1jWVmUwUrsQlqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaVEVA8kszxNFeQDNLVZN7Ou1IMgv6DgVmnohdrDwVBf4oiKMd/y9vPGG/UcfjdBv
	 Vbl5xF2ws/MCWE54xmfrroCZhQE63coIsxg/7yN5LKGumMy5OjnXFZwP2c9f62jEiZ
	 27Lbi7yvqK10Dpzu1aqh35n4iqSm8DeKV93f+21o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/379] pwm: brcmstb: Utilize appropriate clock APIs in suspend/resume
Date: Wed, 15 Nov 2023 14:26:47 -0500
Message-ID: <20231115192704.798750838@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit e9bc4411548aaa738905d37851a0146c16b3bb21 ]

The suspend/resume functions currently utilize
clk_disable()/clk_enable() respectively which may be no-ops with certain
clock providers such as SCMI. Fix this to use clk_disable_unprepare()
and clk_prepare_enable() respectively as we should.

Fixes: 3a9f5957020f ("pwm: Add Broadcom BCM7038 PWM controller support")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-brcmstb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-brcmstb.c b/drivers/pwm/pwm-brcmstb.c
index 3db3f96edf78d..6afd34d651c77 100644
--- a/drivers/pwm/pwm-brcmstb.c
+++ b/drivers/pwm/pwm-brcmstb.c
@@ -290,7 +290,7 @@ static int brcmstb_pwm_suspend(struct device *dev)
 {
 	struct brcmstb_pwm *p = dev_get_drvdata(dev);
 
-	clk_disable(p->clk);
+	clk_disable_unprepare(p->clk);
 
 	return 0;
 }
@@ -299,7 +299,7 @@ static int brcmstb_pwm_resume(struct device *dev)
 {
 	struct brcmstb_pwm *p = dev_get_drvdata(dev);
 
-	clk_enable(p->clk);
+	clk_prepare_enable(p->clk);
 
 	return 0;
 }
-- 
2.42.0



