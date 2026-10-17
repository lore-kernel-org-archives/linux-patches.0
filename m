Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC2E3A7F4C;
	Sat, 17 Oct 2026 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254858; cv=none; b=VZxmdctKFrd32dWePlsKoSn3a2xeGJdUvrahOV9xuRIZt58I3egcGNSLp01JFd1b2tf3/XCQrbc9u4eSavQcX/XepAOJetVPHj+Fh7HUHRH7Qn73U0BoylzeE3RMs9dyacCKT7QlVpKAoOTovd4mJwIeObzcv0/zLTZJcMEfZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254858; c=relaxed/simple;
	bh=d0jxRah7nW0UNxpKSPkY+KWrRXocmNuoeVjCOcn+tfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+4H2/Eff0mqWxGiA2HlUquf0T+BSAqxqjARxdWXM7YRl8NjJq+McON5aejjb+961DHvQMgu55xJmq/FybejvIYt7cu5XhvsRgQZ41vrVhttcgx3UUGj8jiMUuNm0az3EkQVOuUe5sFicoz7SlHdPx0+89/XMWabLfP51pD5ltQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4GK3dlo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4GK3dlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155881F000C4;
	Sat, 17 Oct 2026 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254857;
	bh=MIt3DnGKHsZWJrWEgyAilXiLDlzQyXAA5YSrWCYKQLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4GK3dloxTPLL8Jq91Tu96jigPspBODSs1k6Miz+LyL4jxYhJ3F60wqNdyJGLWTfl
	 6WLGTfJOYiio+YPllvBzUZqfyg65dpYNRM8HJZYQnV2pDsrfI+EtpkX47m0RFvmCta
	 LOccPgHnZ7RAbzdaOjczsA3LWo5idoh8iyl5/jqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 585/869] drm/amdkfd: Fix error path at svm_migrate_copy_to_ram
Date: Sat, 17 Oct 2026 17:57:06 +0200
Message-ID: <20261017160052.054788225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 47 +++++++++++++++---------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index b8e11ffc72204..39bc24e86c2a2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -252,15 +252,6 @@ svm_migrate_get_sys_page(struct vm_area_struct *vma, unsigned long addr)
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
 static long
 svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
@@ -578,10 +569,11 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 			dma_addr_t *scratch, u64 npages)
 {
 	struct device *dev = adev->dev;
-	u64 *src;
+	struct page *dpage = NULL;
 	dma_addr_t *dst;
-	struct page *dpage;
+	u64 *src;
 	long mpages;
+
 	u64 i = 0, j;
 	u64 addr;
 	int r = 0;
@@ -636,6 +628,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 		r = dma_mapping_error(dev, dst[i]);
 		if (r) {
 			dev_err(adev->dev, "%s: fail %d dma_map_page\n", __func__, r);
+			dst[i] = 0;
 			goto out_oom;
 		}
 
@@ -644,19 +637,39 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 
 		migrate->dst[i] = migrate_pfn(page_to_pfn(dpage));
 		mpages++;
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
-		while (i-- && mpages) {
-			if (!migrate->dst[i])
+
+		/* first release current dpage when dma_map_page fail */
+		if (dpage) {
+			unlock_page(dpage);
+			put_page(dpage);
+		}
+
+		/* release previous allocated sys pages and unmap dma address */
+		while (i--) {
+
+			if (dst[i]) {
+				dma_unmap_page(dev, dst[i], PAGE_SIZE,
+					       DMA_BIDIRECTIONAL);
+				dst[i] = 0;
+			}
+
+			dpage = migrate_pfn_to_page(migrate->dst[i]);
+			if (!dpage)
 				continue;
-			svm_migrate_put_sys_page(dst[i]);
+
+			unlock_page(dpage);
+			put_page(dpage);
 			migrate->dst[i] = 0;
 			mpages--;
 		}
-- 
2.53.0



