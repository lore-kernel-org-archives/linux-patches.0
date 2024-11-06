Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F51D416E;
	Wed,  6 Nov 2024 12:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895157; cv=none; b=fFb19WuqOAgyK19GYGuxxFpvhz3sWm+y1KUIzCr7qQc4ZM9gx6dj6mbMZ1sWHAJci/G1sPqID4r385LJt62itoTzzmHxCV3K4vBIf/9NrWjbPRNrk753zThxD0z90pFYcgMAIdwiii7oao0UztSfCn41aOWqJEQYMRBT9aR+Oe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895157; c=relaxed/simple;
	bh=hBkt1gyDTSIqDG99aklKCRqq3sT7sgvbSrHpuS84p0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT+UHTDZ0g7TM+now1Y7hGj3vs3FI5b2boK0ci5VOmTnam975gbBNGl2WDnydF1fJ52plq56rwDIU0dwXBmR2iGLHqbJaHAkpi7rrUVExlgJZSQ3Q6vYoE27CxfPrKmoMWhE5+eBxiW6z3K5dqVtRnZBCjwzX2aD+IK31atUUDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIThcrE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIThcrE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7EAC4CECD;
	Wed,  6 Nov 2024 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895157;
	bh=hBkt1gyDTSIqDG99aklKCRqq3sT7sgvbSrHpuS84p0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIThcrE8OXoMrjBYgML1ODY+E/s4TLzh3V4lU4TTyaw1MnL6433fKVqY4Nt6uYMtS
	 shDXb4lNerK7UVpkALeOGDlkuu8FJsg1hVHZOP5fthSAtDcnvHXXXqjg+QjwU5/am9
	 HyvdBF+XMC4tAnLr8IChu29VIblJncrSvHrmtTM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/350] soc: versatile: realview: fix memory leak during device remove
Date: Wed,  6 Nov 2024 13:00:51 +0100
Message-ID: <20241106120323.945619676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1c4f26a41f9d052f334f6ae629e01f598ed93508 ]

If device is unbound, the memory allocated for soc_dev_attr should be
freed to prevent leaks.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-2-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c774f2564c00 ("soc: versatile: realview: fix soc_dev leak during device remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/versatile/soc-realview.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/versatile/soc-realview.c b/drivers/soc/versatile/soc-realview.c
index caf698e5f0b0b..98b6c60de7f64 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -95,7 +95,7 @@ static int realview_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(&pdev->dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
@@ -107,10 +107,9 @@ static int realview_soc_probe(struct platform_device *pdev)
 	soc_dev_attr->machine = "RealView";
 	soc_dev_attr->family = "Versatile";
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		kfree(soc_dev_attr);
+	if (IS_ERR(soc_dev))
 		return -ENODEV;
-	}
+
 	ret = regmap_read(syscon_regmap, REALVIEW_SYS_ID_OFFSET,
 			  &realview_coreid);
 	if (ret)
-- 
2.43.0



