Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD78410D10;
	Wed,  4 Feb 2026 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216813; cv=none; b=hd2X00sSQ1FTkD8V5m0oRnacC3ikTdxsgITGeGArcWLhKIDu3rVuz2waU5Mlw5dJtS3oXHBt5uh5BGZ9icg3qA9WcIVv03h/N46N1aZaQwuqalknAFkkdzq2MmAVCrTrjFO8sKGGb4Sa+ql2OyKJ0hqYxwk22l8AUJhFa+fD3V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216813; c=relaxed/simple;
	bh=I158yrltoyUFMgsfptMA/xQ4y6uY9eahrj2GqnRBES0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwDMmI5FshWgVVppRngBykTEmxRW/dzUcVG6U/9dqdupBD1bhJaVpTV6aJr5tQFkolofGmLioQTm9s8tOQDfFO910yozOLo2qBucVaIisMSypEawALCBTHfJKt/xJM/K+0y2V7OlE6loDOVhN/QVc9FtMFC+S5CVNubZNlZ5s8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ3vyIGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ3vyIGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77949C4CEF7;
	Wed,  4 Feb 2026 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216812;
	bh=I158yrltoyUFMgsfptMA/xQ4y6uY9eahrj2GqnRBES0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ3vyIGhWXl5Xyaz3CUnnqhP7fcwO1p+/axpMi0X9y/OtIyFVoc193HUFwDSRTF0m
	 +DGVwbo29UQY7u5xIUFS+9b0M3P9ijtfPZzBw4fI5s8VPf/wlSDo1WMstr1Attou5u
	 WkEWwr4xvSAwhn8VvPEJUn/iMshrIYsgTSzab290=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/206] dmaengine: omap-dma: fix dma_pool resource leak in error paths
Date: Wed,  4 Feb 2026 15:37:32 +0100
Message-ID: <20260204143858.966974741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2e1136acf8a8887c29f52e35a77b537309af321f ]

The dma_pool created by dma_pool_create() is not destroyed when
dma_async_device_register() or of_dma_controller_register() fails,
causing a resource leak in the probe error paths.

Add dma_pool_destroy() in both error paths to properly release the
allocated dma_pool resource.

Fixes: 7bedaa553760 ("dmaengine: add OMAP DMA engine driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251103073018.643-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/omap-dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index 7cb577e6587b1..be47a9b8ac96e 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1804,6 +1804,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 	if (rc) {
 		pr_warn("OMAP-DMA: failed to register slave DMA engine device: %d\n",
 			rc);
+		if (od->ll123_supported)
+			dma_pool_destroy(od->desc_pool);
 		omap_dma_free(od);
 		return rc;
 	}
@@ -1819,6 +1821,8 @@ static int omap_dma_probe(struct platform_device *pdev)
 		if (rc) {
 			pr_warn("OMAP-DMA: failed to register DMA controller\n");
 			dma_async_device_unregister(&od->ddev);
+			if (od->ll123_supported)
+				dma_pool_destroy(od->desc_pool);
 			omap_dma_free(od);
 		}
 	}
-- 
2.51.0



