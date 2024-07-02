Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D51BE22F;
	Tue,  2 Jul 2024 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940063; cv=none; b=ZJy1ByBAjkN1xx92zHcHslJO53lSLyecXp4RGALtvP50coy6kdTY0IGqQGmZxUwHy5MbD9OKvzG1948SCT4VRkHt//d6s5wyHzKffZt+jjIgK1fUeiOYqc8KC9YxlEd5nthovllMYd8oNnHVBLh7DcJf6FL36q0GF6ZHNtqjigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940063; c=relaxed/simple;
	bh=9ub4YLPs1Euwdk9z+3X3pW7tOhjJylLu2jZw0UlIkmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwKqlbXXJ4ZQ8VVHS2fcxyslv4xVEW8S8pTYm48mOhFjUFcE2w1xmhXQ+kUmVEug1blsYc7ixvtDyqfizd3c1y/3ZcF+4FNeMu/dYXJyXmnOssnRw8waNsIFqdbNHvC0uQYTf/qr6/ZuHUiKKOjMdvDSlkfPokSJPwlj04VnZro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKzIPG1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKzIPG1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62BFC116B1;
	Tue,  2 Jul 2024 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940063;
	bh=9ub4YLPs1Euwdk9z+3X3pW7tOhjJylLu2jZw0UlIkmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKzIPG1nYmEHh18f/WcUBTbcrtFoW8dU8vgyda+Sgx0GG19ys6MPPCvO4wp81+wej
	 6htJWLgGRQyoaHGsGnQDkxqTNxLi0nGXY9ZNO1Zom1PnPWdHJbowcGJ1e9y0/H4pry
	 aQcX/z9VnMbkumO0ujj6mN3P+heG548kicKWdxqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/222] pwm: stm32: Refuse too small period requests
Date: Tue,  2 Jul 2024 19:00:52 +0200
Message-ID: <20240702170244.519414513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit c45fcf46ca2368dafe7e5c513a711a6f0f974308 ]

If period_ns is small, prd might well become 0. Catch that case because
otherwise with

	regmap_write(priv->regmap, TIM_ARR, prd - 1);

a few lines down quite a big period is configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b86f62f099983646f97eeb6bfc0117bb2d0c340d.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 1c8911353b81d..a8a1075f932df 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -337,6 +337,8 @@ static int stm32_pwm_config(struct stm32_pwm *priv, unsigned int ch,
 
 	prd = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
 				  (u64)NSEC_PER_SEC * (prescaler + 1));
+	if (!prd)
+		return -EINVAL;
 
 	/*
 	 * All channels share the same prescaler and counter so when two
-- 
2.43.0



