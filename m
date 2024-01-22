Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E13129A8A;
	Tue, 23 Jan 2024 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968723; cv=none; b=RXMB/zBTSLaD1sat2xn1GgAfc5oyA0Lqt1NEZ8aS5O2IipudAA0AZfizCaQoBypcgQWVglvoxiWMCE+uRMjwpcaGPsoCR8XXxEGLbvWmNk0sbWStT42eyqBGmAhsvkem0vcvpk8ZWrueFl2o1QtxcX1tgOJ4Gn9scQ17ta5xEME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968723; c=relaxed/simple;
	bh=lJIOeyRIYFFBSQLBEOm28iHwTF4AARPYxllXd5oNti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqpvka0p5hkilp6TMrdgicJaSRs7Ny+sJIi8bOs3MOQlPvD5sa6Z8wZ3cgAV9UVLxlrJw9VDVTvj1Xrmalsd6p/QeRUsoEWRA+VcKhJEjwqi67dQCL3bd+kwTCqfPK3f716z1VTPtuKRu6c9kPEs/FbczRHzarmMoMJ9cstz15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJFvBUiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJFvBUiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C930C43390;
	Tue, 23 Jan 2024 00:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968723;
	bh=lJIOeyRIYFFBSQLBEOm28iHwTF4AARPYxllXd5oNti4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJFvBUiFOz+Y+cxecglBkBki7fPjOS6t/HQrSQF78iq3d8Hs4l1dd1NBxVEMT3zP1
	 BqDKcBa7GTpY2F+hAU50SBBUnmP4m8xCAp3LjSXgT1GQZLrZJ6FfRa24yAlZzuYGHm
	 MbECVTvjhWA0CLi+roBF+cxnegqU+FUsWtLd6I/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/194] drm/exynos: fix a wrong error checking
Date: Mon, 22 Jan 2024 15:55:45 -0800
Message-ID: <20240122235719.863429756@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inki Dae <inki.dae@samsung.com>

[ Upstream commit 8d1b7809684c688005706125b804e1f9792d2b1b ]

Fix a wrong error checking in exynos_drm_dma.c module.

In the exynos_drm_register_dma function, both arm_iommu_create_mapping()
and iommu_get_domain_for_dev() functions are expected to return NULL as
an error.

However, the error checking is performed using the statement
if(IS_ERR(mapping)), which doesn't provide a suitable error value.
So check if 'mapping' is NULL, and if it is, return -ENODEV.

This issue[1] was reported by Dan.

Changelog v1:
- fix build warning.

[1] https://lore.kernel.org/all/33e52277-1349-472b-a55b-ab5c3462bfcf@moroto.mountain/

Reported-by : Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_dma.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dma.c b/drivers/gpu/drm/exynos/exynos_drm_dma.c
index a3c9d8b9e1a1..e07d31b9a921 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dma.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dma.c
@@ -133,18 +133,16 @@ int exynos_drm_register_dma(struct drm_device *drm, struct device *dev,
 		return 0;
 
 	if (!priv->mapping) {
-		void *mapping;
+		void *mapping = NULL;
 
 		if (IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU))
 			mapping = arm_iommu_create_mapping(&platform_bus_type,
 				EXYNOS_DEV_ADDR_START, EXYNOS_DEV_ADDR_SIZE);
 		else if (IS_ENABLED(CONFIG_IOMMU_DMA))
 			mapping = iommu_get_domain_for_dev(priv->dma_dev);
-		else
-			mapping = ERR_PTR(-ENODEV);
 
-		if (IS_ERR(mapping))
-			return PTR_ERR(mapping);
+		if (!mapping)
+			return -ENODEV;
 		priv->mapping = mapping;
 	}
 
-- 
2.43.0



