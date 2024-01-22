Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EEF5397;
	Tue, 23 Jan 2024 00:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970807; cv=none; b=X2RsfalCmjjnErkAmnjsSGvA2iWV46G+y0m5Kr0ETKgU4vQOt6MKUEI6N6XHDpcZnCNovioeWVyzkNAe9rPvskhH4Onwe/bmd9QFpiDVd+2KPD/QEJoKFIELOcOzsV21RTakuRgsd6/Zo+ZfhpmFb9JWBHTo5Dqa+aBHiS5TPLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970807; c=relaxed/simple;
	bh=/XVWZ64vYAdeIy3v3OE9rGSryA2GsznWjqFsUc+TEx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpNlwJXsldsCmUTQ3NitBFlrF2yd1Z+F4pPCbmiUw8v4zh6XvGZXiqtzM4byPGoKMKf8hu4Ke1rthnMH3fTaFQk5UjRKw7OtEyYwaLUmEuEbDKr7L31RXELo71xgW239Zs1mf7K4Q0gDPtuq10Cor7m14sgaFByEjU4O12iakzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHsEpqAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHsEpqAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB38C433F1;
	Tue, 23 Jan 2024 00:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970806;
	bh=/XVWZ64vYAdeIy3v3OE9rGSryA2GsznWjqFsUc+TEx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHsEpqAK+kpfTWEWj6tJaBfTOt56DUnrgd2dY0b2yONimfEstCp/PD3vESmgKz7Lw
	 U/DgHibHerifnKNGnmsxNxAsRr+EpZpccJcWLPi7Ked/f5FVFYqB/uU7DPgxfiJUhK
	 g0DX1YD1pTyciT58ls477YdvaFIOYgcOq8S7evFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/286] drm/exynos: fix a wrong error checking
Date: Mon, 22 Jan 2024 15:55:26 -0800
Message-ID: <20240122235732.810525663@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bf33c3084cb4..6b4d6da3b1f4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dma.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dma.c
@@ -108,18 +108,16 @@ int exynos_drm_register_dma(struct drm_device *drm, struct device *dev,
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



