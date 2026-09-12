Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33CB33ADB9;
	Sat, 12 Sep 2026 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202890; cv=none; b=irnh9wI+VVl+T8LDADR0JSxg/dKVS264bTIQwPWUziieTI59+kE533BL01xdK/G+Bv34iUW6M4h7EjBwFqMqThOmn/p4ftFdRlVDO/ZHPle5oxxcxgYb6IRCBtMcS3Bk23TinbWgXTrsQVfALkz3fD/F76rjmRbv6HM7YlRLRnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202890; c=relaxed/simple;
	bh=RS6KTecyECQaBNXt/DXLW7UXPuEWi6OXi+cz1A3X7cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgugi0gUgco0L1o657F8yIgdDqKigeupwaeemICgngMoMKUxfoVo+2Gvt6P5Lccs7N0xykBvfhnN+kLFivIGGLXeMEH9tpMCGGWbZpyxYddeeX87ewGWw8ZyqZ00xNll9Si6wGXMIV03l2t3yI6D6K8gCmQzNrikOVJNWcf8gV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT9/bxiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT9/bxiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D7C1F000FF;
	Sat, 12 Sep 2026 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202888;
	bh=Gvp25f+nOTqmaAHceenWyWo99VsTLrJkuUC5QSWbif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zT9/bxiRgR7bOKjO7hjISluL4PfoxH9rN7Swp2e4QPsZKN4LTPWKcgUQX9uE8rL1G
	 1PfLhNshnerEbtDkHAhF+sxYtJ/bgjo1JmlfpHTUfwweWJbox2UrSpOPcREwujAzTl
	 6EjXXJqlDsAK628p/mtsJP027SBGF/Kls889v8Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1297/1815] hwrng: imx-rngc - Disable clock on registration failure
Date: Sat, 12 Sep 2026 08:50:47 +0200
Message-ID: <20260912065719.466169218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 188bb9ad86c3b2d527385328a30c1d9510253202 ]

The RNGC clock is enabled manually before runtime PM is configured. If
devm_hwrng_register() fails, probe returns without disabling the clock.
The devm_pm_runtime_enable() cleanup only disables runtime PM and does not
call imx_rngc_suspend().

Disable the clock before returning from this failure path.

Fixes: 7a96a64e8689 ("hwrng: imx-rngc - add runtime pm")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/imx-rngc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 28c56c2d1bf6d..a2db26d7f790e 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -313,8 +313,10 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 	devm_pm_runtime_enable(&pdev->dev);
 
 	ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rngc->clk);
 		return dev_err_probe(&pdev->dev, ret, "hwrng registration failed\n");
+	}
 
 	dev_info(&pdev->dev,
 		"Freescale RNG%c registered (HW revision %d.%02d)\n",
-- 
2.53.0



