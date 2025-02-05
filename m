Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD319F510;
	Wed,  5 Feb 2025 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764293; cv=none; b=oV/36w+bf4Tjn/v/p6IZ96XmMdiGGwiBfjKOK7IOam1EqiYJaYddZKzf0zrw9IbdS+xiI9ILtbrTRkCH8MVwskKsCp1+geJ5NxrXyLx8tC555g9tBLbKB7gGZDGD17CwVc5jsvyEZvVd5nR/yd4io9nFCaINNc5vROG8UoJ/1Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764293; c=relaxed/simple;
	bh=XUSf2ahAcusniPHis5gXeWuBXF7FiJrTm6pHKTmbMII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvueFzYM9Wv8TUVdRQh2aHbqezcwwizCr0qdOvAlRePmvznMgXtFVsZRuK/gqabKCcL4LIqtiFsSF06CZ5gqYSJoAz0MKrJbybm9TYafpm07Jlx3ynQCB86Sy+swze16noIfHfxsgPru4KCXfFlqyUkGsE76rY2vBN16avoC38g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM2QZQUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM2QZQUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E95C4CED1;
	Wed,  5 Feb 2025 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764292;
	bh=XUSf2ahAcusniPHis5gXeWuBXF7FiJrTm6pHKTmbMII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM2QZQULU4AFjku+F5M5eqLYTVz8WLYEqjBmZJajAUMxxNBERPr02VSsTBl/JHzv9
	 UPtbCKCutNZBriy4mtedCbpEcBP9d/g4oySKMKVh0plSzWMTdS7zmKoTvKkqfAdohT
	 fu50D+msyke1tQljqcNUkrBhNL6pQ0DktGp85vxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/590] pwm: stm32-lp: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:37:45 +0100
Message-ID: <20250205134459.466217714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit cce16e7f6216227964cda25f5f23634bce2c500f ]

Add check for the return value of clk_enable() to catch the potential
error.
We used APP-Miner to find it.

Fixes: e70a540b4e02 ("pwm: Add STM32 LPTimer PWM driver")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241206215318.3402860-1-zmw12306@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32-lp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 989731256f503..5832dce8ed9d5 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -167,8 +167,12 @@ static int stm32_pwm_lp_get_state(struct pwm_chip *chip,
 	regmap_read(priv->regmap, STM32_LPTIM_CR, &val);
 	state->enabled = !!FIELD_GET(STM32_LPTIM_ENABLE, val);
 	/* Keep PWM counter clock refcount in sync with PWM initial state */
-	if (state->enabled)
-		clk_enable(priv->clk);
+	if (state->enabled) {
+		int ret = clk_enable(priv->clk);
+
+		if (ret)
+			return ret;
+	}
 
 	regmap_read(priv->regmap, STM32_LPTIM_CFGR, &val);
 	presc = FIELD_GET(STM32_LPTIM_PRESC, val);
-- 
2.39.5



