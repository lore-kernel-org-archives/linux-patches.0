Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896091170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E695C433CD;
	Mon, 11 Sep 2023 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441243;
	bh=2PaOZub06fCjM0V1L/ZEBFXPlzaaQK9jyeXeXejdyeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTMUfpLNMtm56Au4gOVUmlnRYvUYiziyhCJC/9sDJQEO82lBuw8V7Ox0GsErU6G4m
	 e0gaAWm5/9RsDobG45KpWJaiWm7hkD4KRlkHr9GtHsHVcLP2AL10khJHgvB7dqkYmz
	 6D3IRwpyiSNr/SmLtBbA6ZFlevMn6+R9DKem2+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 318/739] drm/msm/a2xx: Call adreno_gpu_init() earlier
Date: Mon, 11 Sep 2023 15:41:57 +0200
Message-ID: <20230911134659.989574610@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit db07ce5da8b26bfeaf437a676ae49bd3bb1eace6 ]

The adreno_is_a20x() and adreno_is_a225() functions rely on the
GPU revision, but such information is retrieved inside adreno_gpu_init(),
which is called afterwards.

Fix this problem by caling adreno_gpu_init() earlier, so that
the GPU information revision is available when adreno_is_a20x()
and adreno_is_a225() run.

Tested on a imx53-qsb board.

Fixes: 21af872cd8c6 ("drm/msm/adreno: add a2xx")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/543456/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index c67089a7ebc10..ad4570d60abf2 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -540,6 +540,10 @@ struct msm_gpu *a2xx_gpu_init(struct drm_device *dev)
 	gpu->perfcntrs = perfcntrs;
 	gpu->num_perfcntrs = ARRAY_SIZE(perfcntrs);
 
+	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
+	if (ret)
+		goto fail;
+
 	if (adreno_is_a20x(adreno_gpu))
 		adreno_gpu->registers = a200_registers;
 	else if (adreno_is_a225(adreno_gpu))
@@ -547,10 +551,6 @@ struct msm_gpu *a2xx_gpu_init(struct drm_device *dev)
 	else
 		adreno_gpu->registers = a220_registers;
 
-	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
-	if (ret)
-		goto fail;
-
 	if (!gpu->aspace) {
 		dev_err(dev->dev, "No memory protection without MMU\n");
 		if (!allow_vram_carveout) {
-- 
2.40.1



