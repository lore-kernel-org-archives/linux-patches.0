Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EA925E83B;
	Tue, 11 Mar 2025 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706474; cv=none; b=MhTqKHsLiDhuE2JjU/yKHzOeEV2pWV7d7J1q2FZEFij60ujG8YE3GKJpV5skJ0ORDFgtBUB9UPaPtCxlIJGgxsZMfzDQWHkoqBF3NzOq/xge2eIZGRABm+NfFQ3hBFyr97nxi4m+o5TYW1UFDao8jm7ZtODfcD6rFZrB05GtTsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706474; c=relaxed/simple;
	bh=t9EUY2PCC8kkQfHmLZoVxVYKkhX9MTzBVMhuJNTO9Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GQdRE3eJadT5PZbGcPvDiJ3HjLtBtWO9LcUBRJdlGstOv+e7rt3AigHhAGvguLzW6F4+ckD83ttNZRkM/v/lPJ5uDUuTUexhCPRCEbulnCwazTSuQ1c7/kzv1KdzuRhvpLz6+WWGj+9sXObXje9GVbAqvlNwnjrcV7nToIMeIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uL/unaPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uL/unaPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8760DC4CEE9;
	Tue, 11 Mar 2025 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706473;
	bh=t9EUY2PCC8kkQfHmLZoVxVYKkhX9MTzBVMhuJNTO9Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL/unaPx1X39NueRJA5oe9KX1r1yFg/cZgxafM+2btKET/QeColOV64YX1PEUJVrx
	 AZzmnEcE30SQcD8RZA9Er7BPXfCWYCaT9kjwxRKzYApGxzPBLL/mKokFoFZrDA+t4M
	 s+g5cs527K1ZiDfz1jhFKGJ952xsdtTVtbXy/PRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/462] pwm: stm32: Add check for clk_enable()
Date: Tue, 11 Mar 2025 15:55:09 +0100
Message-ID: <20250311145800.052007204@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7146b3f6755bc..2ca2855255be1 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -634,8 +634,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	priv->chip.npwm = stm32_pwm_detect_channels(priv, &num_enabled);
 
 	/* Initialize clock refcount to number of enabled PWM channels. */
-	for (i = 0; i < num_enabled; i++)
-		clk_enable(priv->clk);
+	for (i = 0; i < num_enabled; i++) {
+		ret = clk_enable(priv->clk);
+		if (ret)
+			return ret;
+	}
 
 	ret = pwmchip_add(&priv->chip);
 	if (ret < 0)
-- 
2.39.5



