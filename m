Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E10155725;
	Wed,  5 Feb 2025 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765431; cv=none; b=kEoUQ2v+faCP1m83puTUBGAxKsiktaoYXt76WVx+tFA9jsidebc1kp5nXcbNRrauRUdjLWGh5NhOFFrND0d0T53F6MtgGGVkm2TS7ugkLx4lBp5PjG33CRNqAYhD78MkHnoK78DBDKYqyce30GEE22HH/trsLpv/ShejneNz3Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765431; c=relaxed/simple;
	bh=Wj0H5q+IOvI2fm4Kdq8H7Z1tlb11wQe/PSRv/gUwgOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QGWdKhXIPvvwr+lk8JtTWtnXtNYBiBJx+s86VLBep9sx1PBOK3VVxKq4c9CTrttS0UM4L3pm2hBwWBz4b4aZWdzqkyxjOcHN2Es/LU1SCKnceev6eQOFjs6qik3DFd5OO89qz43Fr6WlOMbTOyWCQjk3XRoABFkj8DiMypaAV68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENBhY1Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENBhY1Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062CC4CED1;
	Wed,  5 Feb 2025 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765431;
	bh=Wj0H5q+IOvI2fm4Kdq8H7Z1tlb11wQe/PSRv/gUwgOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENBhY1FfSqlMfVlgFXGzNmoO7vkFK21RTCJ6I5HR4LnFOAfUGCqN6rEeX+4AjXnNG
	 +ci2+tMDt2IDG4IkMfiwqFAzkOGWM8Vz5cBeeu26GdC9xidY2qEMQ2mMZCwe6iPk8o
	 1VbT+GbpTFV6Ho/h1akvmIJxP3fNwro+Qrs1y9IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/590] pwm: stm32: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:39:34 +0100
Message-ID: <20250205134503.664155955@linuxfoundation.org>
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
index eb24054f97297..4f231f8aae7d4 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -688,8 +688,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	chip->ops = &stm32pwm_ops;
 
 	/* Initialize clock refcount to number of enabled PWM channels. */
-	for (i = 0; i < num_enabled; i++)
-		clk_enable(priv->clk);
+	for (i = 0; i < num_enabled; i++) {
+		ret = clk_enable(priv->clk);
+		if (ret)
+			return ret;
+	}
 
 	ret = devm_pwmchip_add(dev, chip);
 	if (ret < 0)
-- 
2.39.5



