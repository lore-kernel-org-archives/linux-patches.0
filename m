Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A152B1F7;
	Wed, 23 Sep 2026 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172859; cv=none; b=Jdpm01aY6IBGCGhpzg44YXKjTw7j2PUH/BShPYXEs5VjGK27L/cveOo1H5AbrMx8aut9a7mkSCKsphrFa1Qr1yASOGQP5sEx8BSvETmbp4OrLLTYkzy+KVaycAS9jQDYz3V+qe2Ol9K9rPU1fe/K7reyJqqphCZ9wfCkNevxsnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172859; c=relaxed/simple;
	bh=77fH53NI1TUunKIpj2J7R8lv8DwP2ZUcBpVWcZsdnBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3gGQI38CPYeKuZUBj3WHNQ28ROZxCeB7huliC+gU2zpYU/XYqjdkJuqmXAxpk/btozEyBwxBBqfwVkoGMQxDngZgIEe8DyG036Q5hXE4qunCliuI9BTWJakuWRP6VQkxe1NqKmCTUvM0SzN81LFNniZsZIekzkk+eFWVfXOg0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc9NeVsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc9NeVsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BCE1F00893;
	Wed, 23 Sep 2026 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172858;
	bh=rIqb5lBxo9Mvci0YHLswD2A0GkE89mTHUiZX2yszUno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zc9NeVsOTWtzPOpN+vIjhOKJeghC57TGtSgec41YalUUR12UH2qBoMRoEKi0EwWoT
	 +ao+ZqiUAbVnD0OCtBtRbwj1/4Rt+tkJVZRCpP4rOjlbz9d+MHFAX43WICBSoxv7Lw
	 U5C4R/XBrgr/6MgvBVepM53GFR6Kphl6qtCXm1EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 046/438] dmaengine: sprd: Fix runtime PM reference leak in probe
Date: Wed, 23 Sep 2026 16:01:07 +0200
Message-ID: <20260923140645.977913055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 087fea3af2e41..19b32a23c882d 100644
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



