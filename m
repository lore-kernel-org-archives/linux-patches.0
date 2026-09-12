Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D737998A;
	Sat, 12 Sep 2026 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200687; cv=none; b=Qq7ImORXmrtC4t5pLNVDzJlmtBU6gINriq5d2NWAX6hmTHnhyReGSZu3kIzzgWQZIAFxU4oYs+ZkHD/hDM9Y+P5J8Mn9BYjiD5oQUE0n4zCrOMCwF3Jlhy4bBQ8gRURb6bFrJOMQYNkDHmroNg+vvad7OVgahEbiQ1zAP/qN2H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200687; c=relaxed/simple;
	bh=XWcbfjCF+6aLOup5LyEHM/3oErMFyJRMKNEYTfRO8JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iycoLtLP02Xy4Exl4pSC91d7PNkrQY8fmi2j4frMf+Hffl8lCt+87vmyQWk7zcPlhduUbHpNDR3K8d4ouZpIl3rxPbSmIZSg86hPLUvx4KbLBeaTok9D4ttWVBBwJIj0vI80WFZBqvjeINDVLfkyrYhlPza7s3TmAlHe5PBgHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxFOZthR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxFOZthR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B841F000FF;
	Sat, 12 Sep 2026 08:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200685;
	bh=OOtlbsN8rIUcRSprl/aA1QG2zPuD2sIh8r8VI6easlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxFOZthRGiEXuInoIrmYfskwvW1/9jNcYvWeyM10Mh2MQrTkTPe805fNhSLui+bAG
	 dWJFKqiYmJqCeEHHHL4bDepcqLNDETKRUVK9MUJTVeB7RA6C8Y0yA3lafHSxSrXut1
	 WynlP+EvDdyIfjgQ33rPku7VbnKRemhBId8jJT/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Mostafa Saleh <smostafa@google.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0841/1815] iommu/dma: Check atomic pool allocation result directly
Date: Sat, 12 Sep 2026 08:43:11 +0200
Message-ID: <20260912065708.660595949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

[ Upstream commit af95a0ebc0a0db0762be75f51eadf770bad01aaa ]

The non-blocking, non-coherent allocation path uses dma_alloc_from_pool(),
which returns the allocated page and fills cpu_addr only on success.

Do not rely on cpu_addr to detect allocation failure in this path. Check
the returned page directly before using it for the IOMMU mapping.

Fixes: 9420139f516d ("dma-pool: fix coherent pool allocations for IOMMU mappings")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Link: https://lore.kernel.org/r/20260717180442.110954-4-aneesh.kumar@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9abaec0703efb..68c686c1e81a2 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1671,13 +1671,16 @@ void *iommu_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 	}
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    !gfpflags_allow_blocking(gfp) && !coherent)
+	    !gfpflags_allow_blocking(gfp) && !coherent) {
 		page = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &cpu_addr,
-					       gfp, NULL);
-	else
+					   gfp, NULL);
+		if (!page)
+			return NULL;
+	} else {
 		cpu_addr = iommu_dma_alloc_pages(dev, size, &page, gfp, attrs);
-	if (!cpu_addr)
-		return NULL;
+		if (!cpu_addr)
+			return NULL;
+	}
 
 	*handle = __iommu_dma_map(dev, page_to_phys(page), size, ioprot,
 			dev->coherent_dma_mask);
-- 
2.53.0



