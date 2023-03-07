Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93EBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD0C433EF;
	Tue,  7 Mar 2023 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211018;
	bh=dX3M/JMtCTTg4NqjSbt+bAKBciMcdkBrD5v2pExXWFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBnS4Mk5kS/Ky/zBn3eUHIUvqQ86Dlv9S3BM3rK/WngFkTvgfMvEDz00PAK5Qrkiv
	 wW/78mzYYFHAFFRXvDYcLCJxgXDemasYt8EJsu0Lfa6xYIs3tAFKsCGQirmu8+s9Xq
	 vmYr/ns7zjwJSmLs3a87Sgfl6+iz71Uw7HYPGXHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0697/1001] drm/amdkfd: Page aligned memory reserve size
Date: Tue,  7 Mar 2023 17:57:49 +0100
Message-Id: <20230307170051.870989789@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 0c2dece8fb541ab07b68c3312a1065fa9c927a81 ]

Use page aligned size to reserve memory usage because page aligned TTM
BO size is used to unreserve memory usage, otherwise no page aligned
size causes memory usage accounting unbalanced.

Change vram_used definition type to int64_t to be able to trigger
WARN_ONCE(adev && adev->kfd.vram_used < 0, "..."), to help debug the
accounting issue with warning and backtrace.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 12 +++++++-----
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         |  9 +++++++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 0040deaf8a83a..90a5254ec1387 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -97,7 +97,7 @@ struct amdgpu_amdkfd_fence {
 
 struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
-	uint64_t vram_used;
+	int64_t vram_used;
 	uint64_t vram_used_aligned;
 	bool init_complete;
 	struct work_struct reset_work;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 3b5c53712d319..05b884fe0a927 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1612,6 +1612,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	struct amdgpu_bo *bo;
 	struct drm_gem_object *gobj = NULL;
 	u32 domain, alloc_domain;
+	uint64_t aligned_size;
 	u64 alloc_flags;
 	int ret;
 
@@ -1667,22 +1668,23 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	 * the memory.
 	 */
 	if ((*mem)->aql_queue)
-		size = size >> 1;
+		size >>= 1;
+	aligned_size = PAGE_ALIGN(size);
 
 	(*mem)->alloc_flags = flags;
 
 	amdgpu_sync_create(&(*mem)->sync);
 
-	ret = amdgpu_amdkfd_reserve_mem_limit(adev, size, flags);
+	ret = amdgpu_amdkfd_reserve_mem_limit(adev, aligned_size, flags);
 	if (ret) {
 		pr_debug("Insufficient memory\n");
 		goto err_reserve_limit;
 	}
 
 	pr_debug("\tcreate BO VA 0x%llx size 0x%llx domain %s\n",
-			va, size, domain_string(alloc_domain));
+			va, (*mem)->aql_queue ? size << 1 : size, domain_string(alloc_domain));
 
-	ret = amdgpu_gem_object_create(adev, size, 1, alloc_domain, alloc_flags,
+	ret = amdgpu_gem_object_create(adev, aligned_size, 1, alloc_domain, alloc_flags,
 				       bo_type, NULL, &gobj);
 	if (ret) {
 		pr_debug("Failed to create BO on domain %s. ret %d\n",
@@ -1739,7 +1741,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	/* Don't unreserve system mem limit twice */
 	goto err_reserve_limit;
 err_bo_create:
-	amdgpu_amdkfd_unreserve_mem_limit(adev, size, flags);
+	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags);
 err_reserve_limit:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 6d291aa6386bd..f79b8e964140e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1127,8 +1127,13 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	}
 
 	/* Update the VRAM usage count */
-	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)
-		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + args->size);
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM) {
+		uint64_t size = args->size;
+
+		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
+			size >>= 1;
+		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + PAGE_ALIGN(size));
+	}
 
 	mutex_unlock(&p->mutex);
 
-- 
2.39.2



