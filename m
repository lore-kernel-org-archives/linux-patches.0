Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0B352FFC;
	Tue, 26 Aug 2025 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217461; cv=none; b=fdUj9Emo/ze9/5u4ntmXN8eJ1M8PJI/Uu1Ub3klf9FdX5adgfRG9nuTMFRALeBHHGM2kqwWFPqb6hCMGBxvAcuBOsThmYG71U1yu+H38jNVO67xw0Gr1Kj2vK5yE6UJS8z/DUKthA4OHmGqmreCM9o0accAeetnHUq88cc2xG+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217461; c=relaxed/simple;
	bh=8sX86CUW9zX9W9eR69TYvSwHaxil+miCfX0at+pGo5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um/TAbBa0B36eoCGOvAb82HjVs8N59v3cr0UrTygOcaaGp9KOXm8L5Ts59Ksp/kbp+VCTl/lSLXGYs+FGtE/ft2zO0gynKCQnTeq0P5TiE8EuMwj7a10GzbV9zFTGNTA2dXjJGAuTigYtLEEDoKBlP9QuFleJok3q2/oRm2zAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJ3z9qh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJ3z9qh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE7DC113CF;
	Tue, 26 Aug 2025 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217461;
	bh=8sX86CUW9zX9W9eR69TYvSwHaxil+miCfX0at+pGo5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJ3z9qh8YHmOSGPtQwUPMPwZBpz6DQ/ya8LEcMjb8NfnimV2VS3xU1MJt7VA2l2fD
	 KTp8bMdpZcsKoOStxVS3Icz+cpmjR/nxV4644IAl0r7E0A4jKXYvtDGzR4r8dd9/Op
	 zxeFWqwviPgu/M/d5GQzvvyelrVVb7zVY1xEnbmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/523] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 26 Aug 2025 13:05:44 +0200
Message-ID: <20250826110927.808560580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit 522a242a18adc5c63a24836715dbeec4dc3faee1 ]

Although unlikely, devm_pm_runtime_enable() call might fail, so handle
the return value.

Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 3e00506543b6..72269d0f2a4e 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.39.5



