Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8215187DE;
	Wed, 30 Sep 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788199; cv=none; b=SslOx2uh3TEj+svzA72kKjSqhVeOKxkkkatd6357nKq95aVczGnyjuwCBlCj4DHcq+F2HRb+mkjWZroWJrqr2a1DbxRfGeHlEbgk8xnptqh+4B175M6wqLV1tneK6Dp55xnPsUcfyeJd2kNx+5dWpSE65qi2Svacfx4asgRqTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788199; c=relaxed/simple;
	bh=IqhSGIKb3VNQdi+cQScsZof8SdkFGiiuHAvDGnI+F3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9aSsZpQFdh07hOxTEZUodW72LCQzziXRdL4/VdpE/GFs4mnS11cF9FUWj3svEiWEwrdzG/SYyJZt8Oavf3J/hSoceiISHdvT+ESSatWhKHMmblFPJ98Cbn5RMkX3uUWhTSs9Rett9RNoUf9ic6luv3H6R9ckOsBwiIwMFuhcvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtxSjg7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtxSjg7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B32A1F000FF;
	Wed, 30 Sep 2026 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788197;
	bh=Sir8MVrjayAKiTc1sLazuVlt7B/UyOQMI1TsEJ28NYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtxSjg7aktn5rWdIq6g+o+e6vS4jwq2UttPRDS6fDkkA/yJl3wvdE6rMWVuUjoXAW
	 UWhot4+vz3v5812dhmRIbU7ojNf6Q31R6P1tmlSysh1y1d4Wd9hOL+hkBYnAUUZBT6
	 m4uY14s4oQprqKECKRtJTVszfapeEHx6B3SxxnuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/877] dmaengine: sprd: Fix runtime PM reference leak in probe
Date: Wed, 30 Sep 2026 17:15:51 +0200
Message-ID: <20260930152415.609313156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f54ff37c5e05..f000d5a5add52 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1212,7 +1212,7 @@ static int sprd_dma_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		goto err_rpm;
+		goto err_register;
 
 	ret = dma_async_device_register(&sdev->dma_dev);
 	if (ret < 0) {
@@ -1234,7 +1234,6 @@ static int sprd_dma_probe(struct platform_device *pdev)
 err_register:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err_rpm:
 	sprd_dma_disable(sdev);
 	return ret;
 }
-- 
2.53.0



