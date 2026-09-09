Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417657981D;
	Wed,  9 Sep 2026 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963091; cv=none; b=kW5vyVIV2sqQV9Qx6NJHQ7G9N1KDh8GZu/fA7Jh64KDNC6ZBhvSk7DQCfIC+wTou82iEC36nUMY5Xil+7hXFQaUzWhcur4aHlsDaasbFZ2G3iaYwOI7nz5pL+uJx1WZSmRXEL7PISP0m+MATL5H1pSZJgAKIkFqJ3oUciaMchnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963091; c=relaxed/simple;
	bh=HFAgLYnAvJOGUbf8wdh+NoITRAabFPlWEwg+93S5THA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAg6T2BBGPnM3ZXJyNzajzs00wOOUKd8kKjnYFJikmIkF8a0IhtTpqI0hmoW1WNsT7wuY2620Z6W6P9qPM6jNAEAS2muXQzFNxDugOcHFzAoEwPaHiwNL2cRPTRkFIr5amlnFR1Iu6d5ysXUE0RMWzmZ5QSjT3DxoEt6jExQRu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hsmou/nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hsmou/nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A33B1F00A3A;
	Wed,  9 Sep 2026 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963089;
	bh=caEIN3RugHUou8t8K4cCiXGBfYlcjkQWPY32dOm+i0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hsmou/nbiok/2OdczMNCPcFUsRqlCqo8aPSY9KWmGKZKGsCFKVrnEzuNSg3ZRk2cU
	 bJyMJfCam64FsmdZCZQDua6xFlp/dU3ihmWm8n8uriTseO/NcsuHT+lpdVoxB05sch
	 VTCyJtoF+Uwbigkk4S5txC19paiaRnnM1Vq43YQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 515/556] drm/amdkfd: Fix error path at svm_migrate_copy_to_ram
Date: Wed,  9 Sep 2026 15:43:15 +0200
Message-ID: <20260909134248.552122861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

commit 960c4a8069bfd352c48cc88592618f1ebe24c69e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   45 ++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -258,15 +258,6 @@ svm_migrate_get_sys_page(struct vm_area_
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
 	unsigned long mpages = 0;
@@ -591,9 +582,10 @@ svm_migrate_copy_to_ram(struct amdgpu_de
 			dma_addr_t *scratch, u64 npages)
 {
 	struct device *dev = adev->dev;
-	u64 *src;
+	struct page *dpage = NULL;
 	dma_addr_t *dst;
-	struct page *dpage;
+	u64 *src;
+
 	u64 i = 0, j;
 	u64 addr;
 	int r = 0;
@@ -647,6 +639,7 @@ svm_migrate_copy_to_ram(struct amdgpu_de
 		r = dma_mapping_error(dev, dst[i]);
 		if (r) {
 			dev_err(adev->dev, "%s: fail %d dma_map_page\n", __func__, r);
+			dst[i] = 0;
 			goto out_oom;
 		}
 
@@ -654,17 +647,39 @@ svm_migrate_copy_to_ram(struct amdgpu_de
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


