Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FD1549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80189C433D2;
	Mon,  8 May 2023 09:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539921;
	bh=cxmpl7VmItIFpX27rqZRthfsFNnsIhrQm9vxsXwRfH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4PhmFxpCxfDbi/E3K0Z37VZqRmBL+kAz04QZ79+rDAbLPjVpTXjeK2QoGKqJp4vV
	 T60N5yTxIVkTXtZF+g6IHusHU+ecHZ+tB5YTPsldF6g9Lv88CGW4Nnuhnk/SPsN6Yl
	 4TaVUfGQMVYZB9QRi7SVpWXxj0KeEDmOymFGcdec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Adam Skladowski <a39.skl@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/611] drm: msm: adreno: Disable preemption on Adreno 510
Date: Mon,  8 May 2023 11:40:23 +0200
Message-Id: <20230508094428.247269266@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 010c8bbad2cb8c33c47963e29f051f1e917e45a5 ]

Downstream driver appears to not support preemption on A510 target,
trying to use one make device slow and fill log with rings related errors.
Set num_rings to 1 to disable preemption.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: e20c9284c8f2 ("drm/msm/adreno: Add support for Adreno 510 GPU")
Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/526898/
Link: https://lore.kernel.org/r/20230314221757.13096-1-a39.skl@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 4f0dbeebb79fb..02ff306f96f42 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1750,6 +1750,7 @@ struct msm_gpu *a5xx_gpu_init(struct drm_device *dev)
 	struct a5xx_gpu *a5xx_gpu = NULL;
 	struct adreno_gpu *adreno_gpu;
 	struct msm_gpu *gpu;
+	unsigned int nr_rings;
 	int ret;
 
 	if (!pdev) {
@@ -1770,7 +1771,12 @@ struct msm_gpu *a5xx_gpu_init(struct drm_device *dev)
 
 	check_speed_bin(&pdev->dev);
 
-	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 4);
+	nr_rings = 4;
+
+	if (adreno_is_a510(adreno_gpu))
+		nr_rings = 1;
+
+	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, nr_rings);
 	if (ret) {
 		a5xx_destroy(&(a5xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.39.2



