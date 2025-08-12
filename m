Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2BB3D994;
	Tue, 12 Aug 2025 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026432; cv=none; b=PrYMkIcDlWJd+NgQV47QTvps0JlTITKy+5yP+baAq5HzdT4pcWQ4TFj8P+aD/VZCcZVEZ8drOH0cFZ0Bp3DhAnD7Kw7/s3Iw8C9twI6ArR4dfYRa+ENMuH4Qv6uLAK6DMQGKTvsrcSUl6bK8Nh0mNPchavhYFdl0hsyrAdjucdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026432; c=relaxed/simple;
	bh=Q6/QDn55EcyWZqL5hD0FxkpVJ6SfVf3s5ShaDBKdRFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PawDMuYSxs9DXMybYzFF78kzs85GbLMYfiQuF1VbljRT1adBl9QxFC/HSKcsE8aeS2jqlJDloWvCFt/fHQPx85wii2HR28SZMfsOY0/wWdIUMix+rWkfP7sKwARcUS06m1Cgw4x35pr9qjTIv7uIijxlm0ZW63O2h/KMCE690OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyWo8kdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyWo8kdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC68C4CEF0;
	Tue, 12 Aug 2025 19:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026432;
	bh=Q6/QDn55EcyWZqL5hD0FxkpVJ6SfVf3s5ShaDBKdRFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyWo8kdYi8ffTsphPPS1goXoZNXR29uGOLZ0iHtmPfYeVQkQSmW8fJjyNTdukpYMC
	 TNQLbHyRGsRcDsq4NycKokjUhZSoGzym3Nn5xlf6iakLat6jbPkKNZgCpZr/3wiUh9
	 J1WWOtXtorZcCE6SXCIKBB+VjnbY5egt4AYS1P30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 292/480] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 12 Aug 2025 19:48:20 +0200
Message-ID: <20250812174409.476220820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1e3048f2bb38..6c4e40d0365f 100644
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



