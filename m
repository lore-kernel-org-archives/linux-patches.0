Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C6641B8E4;
	Sat, 12 Sep 2026 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210641; cv=none; b=o9qGhJjJGgE39snoNo/peFQ1fEwUqeeB95DqdCIqXHre6OYTAKIzXfgAwuXMvXUa9W6tZJeQdqPk1mwb5BaLuiS0Y3EnR4pW0pLdEn9Kh8nj1WOFON3VaNlTIm157Fv1NfVz768Uot4rRUHMD+8e0q8kiE22f3qE89jmO3CvAt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210641; c=relaxed/simple;
	bh=/p6hzTh74yNft+apkQGTv6XX/RcuMOt60dhZ1KBHOv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rrxz3Su8y5XBLCFYLKM6RidqJfP3mBi3m3mkwGGzeyCA1/s88bJlY73zlcPVlgmFwxaVBAGoP0Y+w+2t8LQkG/A86BqoQPble6NebrgH6YPmlmH2g/MtFqutZ2Y1ueKlLHZegr4VZIrgSePMd5YYzKiNjVRu3+mIBHGUlfodVsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5+Ps1B7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5+Ps1B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85AB1F000FF;
	Sat, 12 Sep 2026 10:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210640;
	bh=VtnHULR3Kn8JwPWSqw3PLCenoa5vshngLPe5T0/oxhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5+Ps1B76dRHVbdv2UCP2L11IJh2L4nlhVrsEayGzJGiNzYdoYjwWPoFpNM7lL3oF
	 MA4V7GJ0mKtCLGDjZsK0H9XRBeNHirtHzZb50raI//sCoqYy6YjvusSgj9Iwaefa6R
	 +0mVjngCsIgEDyx53g1g0wOmxLBo9kcq0wYb/l+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1069/1518] hwrng: imx-rngc - Disable clock on registration failure
Date: Sat, 12 Sep 2026 08:53:58 +0200
Message-ID: <20260912065647.631256770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 241664a9b5d9a..447424f7ded1c 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -314,8 +314,10 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
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



