Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA04A37CD22;
	Wed, 30 Sep 2026 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785729; cv=none; b=QkVXwR3QkwfAjfnJ9WJu2TpmmZINHIkp3pgGkgnRFdPE6MpxpoTH+vBW3A74+/tltys/fGkMlbHdrLHcSjuaZpQHXy6hyU7b4rlstW5HFP0LosDVoKabMxYSEV4V4Uw2XZDbbFitgeMwtbtTmK4PPubbAiul2npl2LEsDys66Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785729; c=relaxed/simple;
	bh=uP+9MvNpzzhaWgOdW/7c7F4i0yK99n8bpL2L7/1Hhco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxUOe8B1YQ1eM3kGdUkS4zRFnU+5dh89LJ96IYkN7580ZA5EkQ8452nQwc50WOvqyrcKApDBwIamkiaOOJyjVOu5tx50eSibFd/F+QsdVgF0I6+CChcP2saX+I66hYEDK9GcMumwlE55gwS5MTGYPNclxbpoOwWuqztWV2txljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcyqgqTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcyqgqTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12381F000FF;
	Wed, 30 Sep 2026 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785727;
	bh=v476h1bA2fK4EYPFt3N4aXv3v8lo5zGAxGkZZbRCgao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcyqgqTh1/CR5mbtldOCAqBdMW9jppi63/r03KZRqRWwJTbx+cVT9sqaes2V2PFal
	 SdsJgq0OzBsgNbAU4TnrYlelOgA6dtClZlmBiidZTlU674H1gF/iGR6EWCmCR9HRHN
	 2QTU9D1ecrMubBdb49UWo0HXR+pyr/9naierBaNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 611/982] dmaengine: sprd: Fix runtime PM reference leak in probe
Date: Wed, 30 Sep 2026 17:22:27 +0200
Message-ID: <20260930152429.901015268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit a7df136ec529ee49a789c5029bc37b98b0d4bedd ]

pm_runtime_get_sync() increments a device's usage counter even when it
fails. sprd_dma_probe() currently jumps directly to controller clock
cleanup on that error, bypassing both pm_runtime_put_noidle() and
pm_runtime_disable(). This can happen if the preceding unchecked
pm_runtime_set_active() fails and the following runtime-resume attempt
also returns an error.

Enter the existing runtime-PM unwind path instead. This drops the
reference without idling the partially initialized device, disables
runtime PM, and then releases the controller clocks. The success path
and propagated error code are unchanged.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 9b3b8171f7f4 ("dmaengine: sprd: Add Spreadtrum DMA driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20260813153149.3953497-1-ruoyuw560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 474d3ba8ec9f9..cb48e4d2640cd 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1206,7 +1206,7 @@ static int sprd_dma_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		goto err_rpm;
+		goto err_register;
 
 	ret = dma_async_device_register(&sdev->dma_dev);
 	if (ret < 0) {
@@ -1228,7 +1228,6 @@ static int sprd_dma_probe(struct platform_device *pdev)
 err_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err_rpm:
 	sprd_dma_disable(sdev);
 	return ret;
 }
-- 
2.53.0



