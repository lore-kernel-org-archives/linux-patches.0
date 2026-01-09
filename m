Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558FB26ED41;
	Fri,  9 Jan 2026 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961188; cv=none; b=Lhf1B8+7mWVeyfSQrR8fz0IDVL4qZXhytcdR4XjbdZjic9ViAgia1/gVqBOdvCv65gFdeP41s6iIL2nkyuKiP3ovK6s7pBPfjztru7XoDkfqPDz917Bbp+MFDC8RSiuMLZ9nb5QcPe+yfcL6ug7XF9enGREAHmAVlGCRb29iaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961188; c=relaxed/simple;
	bh=2qgrfd0B6OSVhi/eMr29fmZwpTj1M+BhopQyMqX3g6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQspnnOeRaykb07d1N5B4cF0tUjo21TgSIRPq0d1tIYqmtggd7vxXEuEjxjvFZjCEU9w0Rj51sScE1yFEqMusKR/h+tFU+fDswSmrbZCuGP4hVXvah0XrCHvRTRMwbXl3jEOFZr6xbcZU+92wj78vlIr9eQosfeNH8v6u6XO7RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcmU7CtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcmU7CtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A1DC4CEF1;
	Fri,  9 Jan 2026 12:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961188;
	bh=2qgrfd0B6OSVhi/eMr29fmZwpTj1M+BhopQyMqX3g6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcmU7CtXfyqI2uyvptTEO2HzDtvTMpr4iPNAXLGpgOJLo84IUcjdkckv47cfPgNi2
	 e/6Vs3fPQwx9Xuef/omkznwl+EzObw7GYWuSEc9bkJ27zqi/wz8q0iFfalVGULygo3
	 55hitgQN2GcA+VaQKx0uDQliKXzPypw46MrHx4SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Philipp Stanner <pstanner@redhat.com>,
	Jyri Sarha <jyri.sarha@iki.fi>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 665/737] drm/tilcdc: request and mapp iomem with devres
Date: Fri,  9 Jan 2026 12:43:24 +0100
Message-ID: <20260109112159.058152341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit a196a5166e0812db267281c32fa0724fc5be6582 ]

tilcdc currently just ioremaps its iomem, without doing the (a bit more
robust) request on the memory first. The devm_ functions provide a handy
way to both request and ioremap the memory with automatic cleanup.

Replace the manual ioremap with the devm_ version.

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Jyri Sarha <jyri.sarha@iki.fi>
Tested-by: Jyri Sarha <jyri.sarha@iki.fi>
Signed-off-by: Jyri Sarha <jyri.sarha@iki.fi>
Link: https://patchwork.freedesktop.org/patch/msgid/20231222115216.19218-2-pstanner@redhat.com
Stable-dep-of: a585c7ef9cab ("drm/tilcdc: Fix removal actions in case of failed probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -182,9 +182,6 @@ static void tilcdc_fini(struct drm_devic
 	if (priv->clk)
 		clk_put(priv->clk);
 
-	if (priv->mmio)
-		iounmap(priv->mmio);
-
 	if (priv->wq)
 		destroy_workqueue(priv->wq);
 
@@ -201,7 +198,6 @@ static int tilcdc_init(const struct drm_
 	struct platform_device *pdev = to_platform_device(dev);
 	struct device_node *node = dev->of_node;
 	struct tilcdc_drm_private *priv;
-	struct resource *res;
 	u32 bpp = 0;
 	int ret;
 
@@ -226,17 +222,10 @@ static int tilcdc_init(const struct drm_
 		goto init_failed;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to get memory resource\n");
-		ret = -EINVAL;
-		goto init_failed;
-	}
-
-	priv->mmio = ioremap(res->start, resource_size(res));
-	if (!priv->mmio) {
-		dev_err(dev, "failed to ioremap\n");
-		ret = -ENOMEM;
+	priv->mmio = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->mmio)) {
+		dev_err(dev, "failed to request / ioremap\n");
+		ret = PTR_ERR(priv->mmio);
 		goto init_failed;
 	}
 


