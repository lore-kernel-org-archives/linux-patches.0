Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE533E1681;
	Wed, 30 Sep 2026 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795951; cv=none; b=g6OQhhBy2Qq1zmDUwp7xiFy/31N6wBxT1xnhEu8E6kYXTRP321sRxzpGaDLC2yMlt/3fhRWoSYOQYzKRZfcQphhhFxpSfYUQhpHhVdyAWM/ZOepWmdSywRfMz3u5P5zgSCrHIwK3+vUfrf0ZVuyDLd44ALPteC7lBSs6BTZV1A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795951; c=relaxed/simple;
	bh=LHbhnZmssEgv/vgBxyBDoj2U3zBaDrgzqhyAOtqVuTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+kG+cJVKc6e4DoQAYpxhbcDJHgeybBC1kkGtkhyD+V8zeyHB11ylpef0Ks+/ezMCTFt5rdmQhYdmK/7VhTlpV/Rz3+lP3J6j+dhv0x8SYCStwHfJdIv26Lv6jtizyfXbYTXyed3Z3XOHSRGRmc1HMpRN7rk0eJH+Bkgw6t+mfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSd2GOaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSd2GOaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4211F0089A;
	Wed, 30 Sep 2026 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795950;
	bh=I/KQwsdVAf9OjLQRrCWRwW97XTQG8A4nan12e36OLsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSd2GOaUZmqlpAF28E1tcTxgm6Wtodz+J6qKzBfNNO5IGccywr7DnX9yYkfWlD5xT
	 M2SyjTW6Fl5Xu9ABYN2Ue5ZrS3J8ibR3eFsLFdgijOuxCuxiXWYRuvzlGEpuV0AVsj
	 ccNxAUKt2Lu8DodkzySV9JxQM3J8Ll4EsLukeDQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0740/1193] dmaengine: sprd: Fix runtime PM reference leak in probe
Date: Wed, 30 Sep 2026 17:23:44 +0200
Message-ID: <20260930152450.691812163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 168aa0bd73a0d..ce7b0bbc8175d 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1205,7 +1205,7 @@ static int sprd_dma_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		goto err_rpm;
+		goto err_register;
 
 	ret = dma_async_device_register(&sdev->dma_dev);
 	if (ret < 0) {
@@ -1227,7 +1227,6 @@ static int sprd_dma_probe(struct platform_device *pdev)
 err_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err_rpm:
 	sprd_dma_disable(sdev);
 	return ret;
 }
-- 
2.53.0



