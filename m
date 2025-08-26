Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF04356905;
	Tue, 26 Aug 2025 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218830; cv=none; b=UbHxy5NYqviGz3si967nZPEJneeWICgcKNQaFqzOOf5fvszbDvFXNQ9V2TctGJRRHdpaw6r4S5CfolJFoh9CVYnPXT/XtfnMxt4BLwwSaIcMU1YZzPMH1P7f/siESZ2WZ2+ATX8rNMrMBkktyF8N+6RnIYivOrLmbzuirxP6GO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218830; c=relaxed/simple;
	bh=BG+8WucidtYCtkc3Cuh8Bg3dm3sDhgumpJ4BO1ITy8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyzUFK4H8l2kTAMnjjqjA1knbBqsvOIgRJjd5wcdlG9TSSXitZtjw6zTtgORt459X+YYBWplgYkE2r6QuqXUeGn40xZSRS7zKHLynf7aP2Kj/hEp5pzx3Uc7uBCzkGvWxwGRTpf03zH8d/F8hHNGXWXL/VaGIKW5hjlDUh4JU8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3CniW4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3CniW4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B5BC4CEF1;
	Tue, 26 Aug 2025 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218830;
	bh=BG+8WucidtYCtkc3Cuh8Bg3dm3sDhgumpJ4BO1ITy8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3CniW4pNq5Wb44DuAUcJyt4Ywpplg+0i8yFMy25/ayh8UqtBNzupPH7/Bbv46jwM
	 lK/ojBhvMwiqginARd9JSeko5okOazPZBFm7jKGD1ZzagV43/zG4jSwoIdWN+Wdpaz
	 HLlat67DUH5Mfoyo5eFsThECpiWkitLT1VMVVC6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/403] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 26 Aug 2025 13:07:24 +0200
Message-ID: <20250826110909.994509299@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6c21eb749b51..f5325fe4f1de 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -149,7 +149,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
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



