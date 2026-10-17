Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1FD3B388C;
	Sat, 17 Oct 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259827; cv=none; b=K+XwnAbAxrIYHxTLIdPrQaUN3lN/v4wPZ54VQ5xeWXwcuYeEQUYFifYDV6aTivlVO7KOCre8a2in/g24Ai0iiKsyUzMdqGkZ+y6B8vTuww37n+/psyko/mgoFlveRNISO10JZIszPySSwask/QoJo/MN280Pj8thR5tmCBk45Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259827; c=relaxed/simple;
	bh=MCXbfTJqUzj5geq4kxmkYfqeeso2NNbs1Jx8bXtLiJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9gL4OCL/D5gjEJYn7gwrdALpdTBMZWzroRI7+bm6YZZQDaJC2u4gZM4gKkS4wCmFVvYV8g0ymoy0aBJl5TcfYvrDekzDxVF001iF5S30pqaQwFKZ74OeUS6DJnlpsYkoQqoBMIfaOKmaLlV5nwZmGIGEE9hu+ESOtcP9KCZujI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCtpelOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCtpelOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C1D1F000C4;
	Sat, 17 Oct 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259825;
	bh=nZdpPP709KO0hHWJbQvsbr+DgNH13bFKdf1RpJe2cLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCtpelOPgDtnUqDVsj9nWhAlFd4d3J/utcMlTK3kEzEdAYxUTnowyr9FSh/k6qJfG
	 9KrftBmT2tTltALfk/AdRxS/eFEsFj3utpZizYTg4g3EFPYhETTF/prr5vr1Os6Cry
	 SIKNg2fNAnSJval8qmqrXguCRb2s11bHqUKhIsm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1343/1674] drm/amdkfd: Fix error path at svm_migrate_copy_to_ram
Date: Sat, 17 Oct 2026 18:00:15 +0200
Message-ID: <20261017160505.627491133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 960c4a8069bfd352c48cc88592618f1ebe24c69e ]

If page migration from device to sys ram fails for some reasons driver needs
release and unlock allocated system pages. To do that driver should use page
physical address, or pfn, then get struct page*. Current driver uses dma
address(for adev) that is not correct with IOMMU enabled, or even in general.

The patch releases and unlocks allocated system pages based on where migration
failed by struct page* of sys ram pages. Also dma_unmap correspodent system
ram pages at error path.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 45 ++++++++++++++++--------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index e2539119a8c87..912209fd7dd7d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -251,15 +251,6 @@ svm_migrate_get_sys_page(struct vm_area_struct *vma, unsigned long addr)
 	return page;
 }
 
-static void svm_migrate_put_sys_page(unsigned long addr)
-{
-	struct page *page;
-
-	page = pfn_to_page(addr >> PAGE_SHIFT);
-	unlock_page(page);
-	put_page(page);
-}
-
 static unsigned long svm_migrate_successful_pages(struct migrate_vma *migrate)
 {
 	unsigned long cpages = 0;
@@ -585,9 +576,10 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 			dma_addr_t *scratch, uint64_t npages)
 {
 	struct device *dev = adev->dev;
-	uint64_t *src;
+	struct page *dpage = NULL;
 	dma_addr_t *dst;
-	struct page *dpage;
+	uint64_t *src;
+
 	uint64_t i = 0, j;
 	uint64_t addr;
 	int r = 0;
@@ -641,6 +633,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 		r = dma_mapping_error(dev, dst[i]);
 		if (r) {
 			dev_err(adev->dev, "%s: fail %d dma_map_page\n", __func__, r);
+			dst[i] = 0;
 			goto out_oom;
 		}
 
@@ -648,17 +641,39 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 				     dst[i] >> PAGE_SHIFT, page_to_pfn(dpage));
 
 		migrate->dst[i] = migrate_pfn(page_to_pfn(dpage));
+
+		dpage = NULL;
 		j++;
 	}
 
-	r = svm_migrate_copy_memory_gart(adev, dst + i - j, src + i - j, j,
-					 FROM_VRAM_TO_RAM, mfence);
-
+	if (j > 0)
+		r = svm_migrate_copy_memory_gart(adev, dst + i - j, src + i - j, j,
+						 FROM_VRAM_TO_RAM, mfence);
 out_oom:
 	if (r) {
 		pr_debug("failed %d copy to ram\n", r);
+
+		/* first release current dpage when dma_map_page fail */
+		if (dpage) {
+			unlock_page(dpage);
+			put_page(dpage);
+		}
+
+		/* release previous allocated sys pages and unmap dma address */
 		while (i--) {
-			svm_migrate_put_sys_page(dst[i]);
+
+			if (dst[i]) {
+				dma_unmap_page(dev, dst[i], PAGE_SIZE,
+					       DMA_BIDIRECTIONAL);
+				dst[i] = 0;
+			}
+
+			dpage = migrate_pfn_to_page(migrate->dst[i]);
+			if (!dpage)
+				continue;
+
+			unlock_page(dpage);
+			put_page(dpage);
 			migrate->dst[i] = 0;
 		}
 	}
-- 
2.53.0



