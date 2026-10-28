Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216216;
	b=0NkVoC3ip8ejj9G7iiQuQqQdl47ZdeFMWcBjaeiKmxVWYgajvLgj2xctpKNooZCoaREM
	 JH2TA08ZlyJy6Ka0toDAmpqxvSk/hmyF0s5jI6MgNvekIgi7iGKdVHvFdbMVZ5pFsYJoa
	 rizuIefxj2IPax3Gq1/CIciiskkm47AF/hb1TgnwdwKhoMBxcPrmr17qNwSZ+OG4KE1rw
	 g7yHeYicoBomT0XiHJmeUdVysUNPoHYWgfW+tKhd57GFlcqfnrkQKiqJk+77imIeVVquo
	 EBVuXcQ6LDkOPY7gJ8/VKjLSmmrx6/ySzP7O63l+2vKl+gjOyUjFNKFyxZqPqfpz2Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEeR+77cA45WEa/ZoPd5ZYnGTid85jOGmzEoRe1fLtM=;
	b=0/zSaUNMcNYmS/1Q6d6ktiSB+5ZojBR743FNkQGPB5/iijyt1nrwbWRSwit127Nc5Dc+
	 0h9eMqF4djlm1DT3kLmlYBwKu3lDBwW/fp7K0uIaDKF1ldV4vth0l7XKw+BSynajT+J6j
	 CzP1hq9jfPpNzWl45s9P3R7wpKvhNB76O+PPSRMEs3i6axRoxNppA0wSvxSM+ILpdUWu4
	 m8ujS61M58oZO7abgXF7ZRGaDBAk6ye382lhzaywTrefp/kePhtukN16WaXxoCco92fDy
	 cJx+Yf40B8ez9kIdyD+aBUMxlZT70fwDjKu6Ks5fbhrC7JUwB2ct68LE94Zvkz5CJpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjrT4vS5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684F606A323;
	Wed, 28 Oct 2026 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjrT4vS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79C01F01828;
	Wed, 28 Oct 2026 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216216;
	bh=XEeR+77cA45WEa/ZoPd5ZYnGTid85jOGmzEoRe1fLtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjrT4vS5qxnKgMT1PDBOXKvrRvmzR7XGREWbsrXYjiM6ar2Xq4qG57Yy77fITPbGw
	 oJVbTvrFLeINScBjHjDbO0phGqCBM1qjK5hCww1EMoGmgcd90ItBZfmnihNU9MZQHK
	 uSgLPGtuBA5nMd3LOYOxiNmXtaw7TXapCLQzAHFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1481/1887] drm/amdkfd: Fix error path at svm_migrate_copy_to_ram
Date: Wed, 28 Oct 2026 17:59:37 +0100
Message-ID: <20261028170533.153314580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index be9a7144f3d4b..c964850b667f9 100644
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
 static unsigned long svm_migrate_successful_pages(struct migrate_vma *migrate)
 {
 	unsigned long cpages = 0;
@@ -569,9 +560,10 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
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
@@ -625,6 +617,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 		r = dma_mapping_error(dev, dst[i]);
 		if (r) {
 			dev_err(adev->dev, "%s: fail %d dma_map_page\n", __func__, r);
+			dst[i] = 0;
 			goto out_oom;
 		}
 
@@ -632,17 +625,39 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
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



