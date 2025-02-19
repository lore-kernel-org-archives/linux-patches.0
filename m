Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887C71D61B5;
	Wed, 19 Feb 2025 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956178; cv=none; b=XbMQaFZ+QZw2kr2i6aeRTXOxgEtBZxN8Cd+yXeZYb1BRRSNeu1DNPgKXLLFcS4/aExPQScbW5n8K/vLDatmUUIU0nU/6WsoMfk5+Q7l0+XFTYMixg4xpImAasw1b4CJjGvtcoSq2SHt9bm/qG0cLsBEH3Csys5QgL3jKHLgP6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956178; c=relaxed/simple;
	bh=35rE8HXnt7MCL3j38+qb0zdgX0zOa7d1VO3fWy9hOug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irrVki/JQ7PsIS/Td23VN+eXaSWbG8pBhaNtM/m7uBfaGwFd7FIBmTZL7XnXIw0vBxN0S6HozPQPnzIBjKGQFXJ9lx02tcWzVTbjzH+hlsLAUuTWLfLMRaEZ3mDTeCskGCBxhlYJM2Z06hyCPdqig+hUljJrYSAYlepdPKQ6ILk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgQ4oFKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgQ4oFKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1300EC4CED1;
	Wed, 19 Feb 2025 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956178;
	bh=35rE8HXnt7MCL3j38+qb0zdgX0zOa7d1VO3fWy9hOug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgQ4oFKpq/YiX4izmQj2iCTVJPovUpcWko4me52UADm93lg6cmBx1MhUT9+ZeciWQ
	 nlgsmg2LYBxCGTJ3eyKKrFgCmxZ1gsyAJK0twm4x92sxIN3phI4I90gI5uXMlGruA1
	 HMHOi0/w1KrfCfDXneOvTtbq2fWum1u3JKt0B40Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/578] pwm: stm32: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:21:36 +0100
Message-ID: <20250219082656.579180505@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2070d107c6328..fda7d76f08b1b 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -631,8 +631,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
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



