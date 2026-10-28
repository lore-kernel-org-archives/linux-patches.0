Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216214;
	b=WEztDQBGCMkLDw9fCBvwI7CiclrzNhTBeEVZfcFpo0uxMiPiHRzakvzieDWXFWJr2bJ8
	 +HPJdnX/+ShQZ0/PMJEmyGkEcQ+gDFZ0g2Bo9yoF0spL1qqeGLDoPI7B9bv07T8V2A3Yi
	 PDfkI9ZqDxhsCCPbJr3U57BX9qtFGCjtXJjTpDerJbfsxlPaDFNclGEexcEsX3qovzxQC
	 AalMcnGg9pR+TyQIAVdzL1h7L8QBLNqLshWWJL07SSppG3mDpmzBP8X/1gEcs+rhGn+O1
	 98Ep+dmcbQe9UXZFhuP3jeaw5GZd5oRV0F6ltvQh5gwRHVTl3lbs9OQ5ampJW0tAAMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npomps0Qs2fJ62AnlEmaDDKblb6dCFZyBrb2keB7cu8=;
	b=o5h8CjoFd7C/ZW4lwbFAfm9xJG9oXpMUTxx1V583flAFD+OS2LzT2xOcs4DcwFD0e4q8
	 2WJO0peDPuH3KlKdtR8CR1u+L2AVWMCKCz1yR6XpkCxiWTnE3vJqHOB5WQd0h2dycZ+ca
	 5Pn0vq7qzs35/ZVdkxkpAWz+0vrFSuxbXr8G5dOgL5TT2iZf5+oS3e8dyqiqAvCMf1J8O
	 ckPOLYQEUyUHIsdKB7gqbwoQilKSV35PxQdWHubLUeUNydzqFRuWjBfZBTYjAqOQjXvOR
	 kltXHUK5ks5FmoK27UuYiE/MUZ0rfTjbN5NhN4+nwSa4pr0RaJvdeYfG/Y/B47tvXFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQb0LbCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8290606A31C;
	Wed, 28 Oct 2026 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQb0LbCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1326B1F01825;
	Wed, 28 Oct 2026 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216213;
	bh=npomps0Qs2fJ62AnlEmaDDKblb6dCFZyBrb2keB7cu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQb0LbCX0B6KyakTPefy+kDEd+AQME+sXqlltm1lcNMF8m+9d+1H8X5+kIpGacIOd
	 XtSDgK7M+c76u+pMAlIIu6dxCKTQA+z/VaZo14t6gWz8k8M/B8nDW9VMOpotTZzm+3
	 aRGJKjIM9weIMZOLsg3U0SgO44yH3BITd4mdPJ08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1480/1887] drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028170533.131130383@linuxfoundation.org>
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
index 72e84b26370ef..be9a7144f3d4b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -132,7 +132,7 @@ svm_migrate_copy_memory_gart(struct amdgpu_device *adev, dma_addr_t *sys,
 	uint64_t gart_s, gart_d;
 	struct dma_fence *next;
 	uint64_t size;
-	int r;
+	int r = 0;
 
 	mutex_lock(&adev->mman.gtt_window_lock);
 
@@ -298,7 +298,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 	dma_addr_t *src;
 	uint64_t *dst;
 	uint64_t i, j;
-	int r;
+	int r = 0;
 
 	pr_debug("svms 0x%p [0x%lx 0x%lx 0x%llx]\n", prange->svms, prange->start,
 		 prange->last, ttm_res_offset);
@@ -322,6 +322,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 					      DMA_BIDIRECTIONAL);
 			r = dma_mapping_error(dev, src[i]);
 			if (r) {
+				src[i] = 0;
 				dev_err(adev->dev, "%s: fail %d dma_map_page\n",
 					__func__, r);
 				goto out_free_vram_pages;
@@ -346,7 +347,8 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 		pr_debug_ratelimited("dma mapping src to 0x%llx, pfn 0x%lx\n",
 				     src[i] >> PAGE_SHIFT, page_to_pfn(spage));
 
-		if (j >= (cursor.size >> PAGE_SHIFT) - 1 && i < npages - 1) {
+		/* accumulated j + 1 pages reach end of current drm_buddy_block */
+		if (j + 1 >= (cursor.size >> PAGE_SHIFT)) {
 			r = svm_migrate_copy_memory_gart(adev, src + i - j,
 							 dst + i - j, j + 1,
 							 FROM_RAM_TO_VRAM,
@@ -360,7 +362,8 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 		}
 	}
 
-	r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
+	if (j > 0)
+		r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
 					 FROM_RAM_TO_VRAM, mfence);
 
 out_free_vram_pages:
-- 
2.53.0



