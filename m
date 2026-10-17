Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B19537701A;
	Sat, 17 Oct 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259824; cv=none; b=E8bBw39wtwHtb0LLIiOKEQ1NSD9DE9dnIWFuNZd9zkfGoskKFdH4s17s5jZHI++u/pJJCqOJP8pbUtRzdxUkyExT7qojAMiIhIwg5htPoNPyRW9a2WEN7bFLpdJwSeTUuUphTmS/OqCzoboqw4xWWGxBkfeYQKsMObuIVFklKC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259824; c=relaxed/simple;
	bh=8xfm/C6XXj9qrbSI4WltWu3pzbDqeIbvTj+Nsa3BQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM0LUepn1VwjWlPy7960/vwR1bOIqql13nuKDtLE2ho6zfMERy7nJeOiX7OCJkAIEQ7qcyac2/Zi3DJjNsupXLQGZ6ZJ/Ljv57g//VuA9ZHI8SB/9mRbRaf5NiR8oqTzSN/91jrC74ONewuILDZU92gnJxpi7hu+T35gLccoZME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luOOZAvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luOOZAvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BBF1F000C4;
	Sat, 17 Oct 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259823;
	bh=GA2XJSdhtopuNpgYx39Z8F1Kan3SZb98tla9ZkQfBrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luOOZAvWZ/mRZZipczZiske62HUchm3LVrUabB6YIZnnfXJtXAa/LDKL8yvhmhsSB
	 eHCNo8XYvtG32JJ0g55eqSJMhwhsNfNiWjDaqUNVf1syH+D5xms7h+3P59aqaodCRg
	 El9JdsQ6wULFvBEghG5rthgkmwlNj+aJ/rAUnB1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1342/1674] drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram
Date: Sat, 17 Oct 2026 18:00:14 +0200
Message-ID: <20261017160505.598558847@linuxfoundation.org>
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
index 59575e2424d07..e2539119a8c87 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -131,7 +131,7 @@ svm_migrate_copy_memory_gart(struct amdgpu_device *adev, dma_addr_t *sys,
 	uint64_t gart_s, gart_d;
 	struct dma_fence *next;
 	uint64_t size;
-	int r;
+	int r = 0;
 
 	mutex_lock(&adev->mman.gtt_window_lock);
 
@@ -298,7 +298,7 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 	dma_addr_t *src;
 	uint64_t *dst;
 	uint64_t i, j;
-	int r;
+	int r = 0;
 
 	pr_debug("svms 0x%p [0x%lx 0x%lx 0x%llx]\n", prange->svms, prange->start,
 		 prange->last, ttm_res_offset);
@@ -322,6 +322,7 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 					      DMA_BIDIRECTIONAL);
 			r = dma_mapping_error(dev, src[i]);
 			if (r) {
+				src[i] = 0;
 				dev_err(dev, "%s: fail %d dma_map_page\n",
 					__func__, r);
 				goto out_free_vram_pages;
@@ -346,7 +347,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 		pr_debug_ratelimited("dma mapping src to 0x%llx, pfn 0x%lx\n",
 				     src[i] >> PAGE_SHIFT, page_to_pfn(spage));
 
-		if (j >= (cursor.size >> PAGE_SHIFT) - 1 && i < npages - 1) {
+		/* accumulated j + 1 pages reach end of current drm_buddy_block */
+		if (j + 1 >= (cursor.size >> PAGE_SHIFT)) {
 			r = svm_migrate_copy_memory_gart(adev, src + i - j,
 							 dst + i - j, j + 1,
 							 FROM_RAM_TO_VRAM,
@@ -360,7 +362,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 		}
 	}
 
-	r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
+	if (j > 0)
+		r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
 					 FROM_RAM_TO_VRAM, mfence);
 
 out_free_vram_pages:
-- 
2.53.0



