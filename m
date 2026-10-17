Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D7381B0D;
	Sat, 17 Oct 2026 16:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254852; cv=none; b=ecb20Heinw27eqwlqAD/mf1MDI4XwCUuuaZBU2U9/ysl4vaCb2NKv2+6RYicZN/SxWjCHEdEC6gbRd4I4eECg3526bnIDTMfe7X8k67hNYSMvm0lSWoW/1jz3JrCxE8xzoYRTuATcSyYzkLW7Q6lRkk+tHr8OLUfhl1Yo8z5iNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254852; c=relaxed/simple;
	bh=jPNRWlKM2S0xf0IJfJipz1dKD+ILkMa0ImVqFKR8n3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P33Ry0qQ9MnhfG9gRW1ZeYnCwIWanyuymi55HSQtlXFxbbUopUDzH9tlZjT8xpIE5TxbtcwlPpRBJfZg5wGQxM4UtOONIdfQsTcWdtwfoPeCafmF37ZoiJouDIo/6Qmrwafut8rPsVIzY8OofwLA+l0EsrkYvO657dYbXHFLTao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URo9NY6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URo9NY6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3431F000C4;
	Sat, 17 Oct 2026 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254851;
	bh=YcxYbEenw/98Dc8vh3D5gvtyQahqdMWKaaone9vlr88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URo9NY6HUkQQEm4x3AYGfR7FbP2DZk7X0QAtagRsHN4+291wJRNa6uutfOtb56Kph
	 soPQScoVDQwpae6fAwAVeCblmv7Hu87DSm8EUoaoRughaCWzyYtpvbgY3W5KxrGZXc
	 TRTk+1WS4jT4TC0I1rrjzdo2WJ0FNAEtv/v661hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 583/869] drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram
Date: Sat, 17 Oct 2026 17:57:04 +0200
Message-ID: <20261017160052.005874772@linuxfoundation.org>
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

[ Upstream commit 520e345ffe05aabef1db82beda4288afb1757ff2 ]

When migration vm range is hole at cpu side(MIGRATE_PFN_MIGRATE set +
MIGRATE_PFN_VALID unset) driver still allocates device pages. There is no
dma map of src pages and migration. j is 0 and svm_migrate_copy_memory_gart()
will return an uninitialized r. That can trigger out_free_vram_pages to drop
all VRAM just set up.

Initialize r and only call the last svm_migrate_copy_memory_gart if j > 0.

Current code postponed the last page to the final copy. This patch flushes on
the last page when reach to the end of current drm_buddy_block; avoids another
svm_migrate_copy_memory_gart.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 1befda9f40685..bdfba8b3faffa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -132,7 +132,7 @@ svm_migrate_copy_memory_gart(struct amdgpu_device *adev, dma_addr_t *sys,
 	u64 gart_s, gart_d;
 	struct dma_fence *next;
 	u64 size;
-	int r;
+	int r = 0;
 
 	mutex_lock(&adev->mman.gtt_window_lock);
 
@@ -287,7 +287,7 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 	dma_addr_t *src;
 	u64 *dst;
 	u64 i, j;
-	int r;
+	int r = 0;
 
 	pr_debug("svms 0x%p [0x%lx 0x%lx 0x%llx]\n", prange->svms, prange->start,
 		 prange->last, ttm_res_offset);
@@ -313,6 +313,7 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 					      DMA_BIDIRECTIONAL);
 			r = dma_mapping_error(dev, src[i]);
 			if (r) {
+				src[i] = 0;
 				dev_err(dev, "%s: fail %d dma_map_page\n",
 					__func__, r);
 				goto out_free_vram_pages;
@@ -337,7 +338,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 		pr_debug_ratelimited("dma mapping src to 0x%llx, pfn 0x%lx\n",
 				     src[i] >> PAGE_SHIFT, page_to_pfn(spage));
 
-		if (j >= (cursor.size >> PAGE_SHIFT) - 1 && i < npages - 1) {
+		/* accumulated j + 1 pages reach end of current drm_buddy_block */
+		if (j + 1 >= (cursor.size >> PAGE_SHIFT)) {
 			r = svm_migrate_copy_memory_gart(adev, src + i - j,
 							 dst + i - j, j + 1,
 							 FROM_RAM_TO_VRAM,
@@ -351,7 +353,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 		}
 	}
 
-	r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
+	if (j > 0)
+		r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
 					 FROM_RAM_TO_VRAM, mfence);
 
 out_free_vram_pages:
-- 
2.53.0



