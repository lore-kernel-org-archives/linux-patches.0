Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5EB186E56;
	Wed,  5 Feb 2025 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765935; cv=none; b=r3lW2QcBYgTCbC6JgqK29Xo2aYJ8Vid7SN5pwR89iMNBK54wdsiHK3QK1bHZcytCtvH+B+FR5Xn1vT42IIOMawSExDafCd4JzpjejvpqHUSuD/NTqSOpv1mDGbViyDSYmo0D3yVRi8np/RnhJqte532/E5ImrBaJ4bG5Izw6Gak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765935; c=relaxed/simple;
	bh=0PSNE/WMr7KGTEb7qlQjdRmtwTo3aLQqUa4oRmyERpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tz0L+1XFJBjOSadKsCccTnXRXw9vKldSQ+zZcqN2DaAR8HoIBVAGaDoAs1+WfPHuIdf1mPQASees8msyaUkY6e0SKgR1DItOGdyTN5i5+lwQJ43eFA07uQlsXt5FzQwFy8zCAnx1+HUsS/plCwsCgRKncIbwHiUcqhf42bn+71k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlNmBByy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlNmBByy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A80C4CED6;
	Wed,  5 Feb 2025 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765935;
	bh=0PSNE/WMr7KGTEb7qlQjdRmtwTo3aLQqUa4oRmyERpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlNmBByyVHUdf66H4xYubl2LZCl9kkAFJO0QX9N/UZWZ57bVOjShk2O8aGFuMtlq5
	 GtZcF+n5h/PW8QJmEQEny5iWZ0CwjNy3YsizYiFyFBiN9AUJeyQy3e1c8tiOL8Rlz2
	 x3xAOLvU+tGnfl0kwoi22IZh+oPIx499NQSDt9cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 227/623] pwm: stm32: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:39:29 +0100
Message-ID: <20250205134504.908251288@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 17e591f61efb6..a59de4de18b6e 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -858,8 +858,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
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



