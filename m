Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035751519AA;
	Wed,  5 Feb 2025 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764080; cv=none; b=RaXhBbve4QyHpdGfZrFD3vL5dukYb0I78tMT/z8iCphnZgnVSB5LygVZ9fm7sCj35N6hL3kxfCusPLczQ1mFpDv1y1G3gnfWqKJIuKgHLUalOcwKbAtI+IsvLsDB14YVTG0UJw3Kocf8IuiUjKoqB1Gii1XCv8dBbcs2Etd3HJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764080; c=relaxed/simple;
	bh=958lKAmpgfeWPYfDai4mxhAE1AoxwXNXYBE5RhnSHME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvmJ1hyvWbI1QbA32CA6o2UWI3PRs2XJgIy9/ZeeBldK5EQa5/nNQUwau7hxBG/G7kOUHLkxsA0YfKy0+4ahaf1crw5xeWeQiWnAWwUbBxgxMhP7X0/VH8fReEn6w+roxBCDWx/8BnP2RZTd2xFVjQac/P6C5NdcAKJeBdp637Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuoT2P9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuoT2P9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C00C4CEDD;
	Wed,  5 Feb 2025 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764079;
	bh=958lKAmpgfeWPYfDai4mxhAE1AoxwXNXYBE5RhnSHME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuoT2P9VeM8UhgfuI9vnnkvWXeGSTv/RIXSS5H/EZw2/Z84N0R07IkCQNzH1s5lNQ
	 /Pr/l9Cfa4fWJ1aIT4r0S3F1DsmLyCL+4RwJkmgxw6t30G73vo0P+UmZs5/Da1gaEq
	 bT0FL4eJcBUWA6yf6/D83kA4SPyafAXnXfnht+EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/393] pwm: stm32: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:40:57 +0100
Message-ID: <20250205134425.581997894@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit e8c59791ebb60790c74b2c3ab520f04a8a57219a ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: 19f1016ea960 ("pwm: stm32: Fix enable count for clk in .probe()")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241215224752.220318-1-zmw12306@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index b91a14c895bea..67414b97ef4d2 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -635,8 +635,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	priv->chip.npwm = stm32_pwm_detect_channels(priv, &num_enabled);
 
 	/* Initialize clock refcount to number of enabled PWM channels. */
-	for (i = 0; i < num_enabled; i++)
-		clk_enable(priv->clk);
+	for (i = 0; i < num_enabled; i++) {
+		ret = clk_enable(priv->clk);
+		if (ret)
+			return ret;
+	}
 
 	ret = devm_pwmchip_add(dev, &priv->chip);
 	if (ret < 0)
-- 
2.39.5



