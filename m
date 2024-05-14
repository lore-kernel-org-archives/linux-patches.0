Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F312F5A4;
	Tue, 14 May 2024 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686772; cv=none; b=iwcwFZTr1pIMHltRf2viwg+foawzyLrqJerg146AwvsguYiSQNxp1HIffA8DpdMtXQuctTH2sqvSxNPW3m35gbeWrvnFoUVqH5R+9jTZaQT9wW68Jl8ByBxJYsNSH4wIMyiLpML7MJhO4emQ9lVvbDZwpZLkAqCOGif6qKOspk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686772; c=relaxed/simple;
	bh=/xWqcMqpRuPPwcWH0R3DAi72EaWaKVTP09PhSrw7Hik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDZQrhf1mTl8G0lUxQfc8LKrqo9XsenwpHOCeC8i7nXdFDHxs3luFjMF8lOpmE5R3q/uJRWOzbb/f+0J39zs1GIdlCFTji3gg8F23AcO+3ng261JAajS9OU4x0X1XxdjrzvKLsGUn2sOH6xb0GSyj7GKF8geZ14HZPfOF0Gpm2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xMV3+5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xMV3+5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69590C2BD10;
	Tue, 14 May 2024 11:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686771;
	bh=/xWqcMqpRuPPwcWH0R3DAi72EaWaKVTP09PhSrw7Hik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xMV3+5c3VW/LxsVGmzS2G2LapDJJ+1uJHwwnof2rtx2GHdqrHd0TLfnLQ1y3rbls
	 W6amAaQxpLQvSvBza2703sgYJnjePc4LLlEmFjugtgUtgPVNf+hFXb3D9HbXcvAqA8
	 SG89yYxb7HkPkkDd2jgYu8NqVSbYBc5m97JWR6wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <JinHuiEric.Huang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/63] drm/amdkfd: change system memory overcommit limit
Date: Tue, 14 May 2024 12:19:25 +0200
Message-ID: <20240514100948.179672209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <JinhuiEric.Huang@amd.com>

[ Upstream commit 5d240da93edc29adb68320c5e475dc9c7fcad5dd ]

It is to improve system limit by:
1. replacing userptrlimit with a total memory limit that
conunts TTM memory usage and userptr usage.
2. counting acc size for all BOs.

Signed-off-by: Eric Huang <JinHuiEric.Huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 25e9227c6afd ("drm/amdgpu: Fix leak when GPU memory allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 99 +++++++++++--------
 1 file changed, 58 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 4488aad64643b..13a03f467688a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -46,9 +46,9 @@
 /* Impose limit on how much memory KFD can use */
 static struct {
 	uint64_t max_system_mem_limit;
-	uint64_t max_userptr_mem_limit;
+	uint64_t max_ttm_mem_limit;
 	int64_t system_mem_used;
-	int64_t userptr_mem_used;
+	int64_t ttm_mem_used;
 	spinlock_t mem_limit_lock;
 } kfd_mem_limit;
 
@@ -90,8 +90,8 @@ static bool check_if_add_bo_to_vm(struct amdgpu_vm *avm,
 }
 
 /* Set memory usage limits. Current, limits are
- *  System (kernel) memory - 3/8th System RAM
- *  Userptr memory - 3/4th System RAM
+ *  System (TTM + userptr) memory - 3/4th System RAM
+ *  TTM memory - 3/8th System RAM
  */
 void amdgpu_amdkfd_gpuvm_init_mem_limits(void)
 {
@@ -103,48 +103,54 @@ void amdgpu_amdkfd_gpuvm_init_mem_limits(void)
 	mem *= si.mem_unit;
 
 	spin_lock_init(&kfd_mem_limit.mem_limit_lock);
-	kfd_mem_limit.max_system_mem_limit = (mem >> 1) - (mem >> 3);
-	kfd_mem_limit.max_userptr_mem_limit = mem - (mem >> 2);
-	pr_debug("Kernel memory limit %lluM, userptr limit %lluM\n",
+	kfd_mem_limit.max_system_mem_limit = (mem >> 1) + (mem >> 2);
+	kfd_mem_limit.max_ttm_mem_limit = (mem >> 1) - (mem >> 3);
+	pr_debug("Kernel memory limit %lluM, TTM limit %lluM\n",
 		(kfd_mem_limit.max_system_mem_limit >> 20),
-		(kfd_mem_limit.max_userptr_mem_limit >> 20));
+		(kfd_mem_limit.max_ttm_mem_limit >> 20));
 }
 
 static int amdgpu_amdkfd_reserve_system_mem_limit(struct amdgpu_device *adev,
-					      uint64_t size, u32 domain)
+		uint64_t size, u32 domain, bool sg)
 {
-	size_t acc_size;
+	size_t acc_size, system_mem_needed, ttm_mem_needed;
 	int ret = 0;
 
 	acc_size = ttm_bo_dma_acc_size(&adev->mman.bdev, size,
 				       sizeof(struct amdgpu_bo));
 
 	spin_lock(&kfd_mem_limit.mem_limit_lock);
+
 	if (domain == AMDGPU_GEM_DOMAIN_GTT) {
-		if (kfd_mem_limit.system_mem_used + (acc_size + size) >
-			kfd_mem_limit.max_system_mem_limit) {
-			ret = -ENOMEM;
-			goto err_no_mem;
-		}
-		kfd_mem_limit.system_mem_used += (acc_size + size);
-	} else if (domain == AMDGPU_GEM_DOMAIN_CPU) {
-		if ((kfd_mem_limit.system_mem_used + acc_size >
-			kfd_mem_limit.max_system_mem_limit) ||
-			(kfd_mem_limit.userptr_mem_used + (size + acc_size) >
-			kfd_mem_limit.max_userptr_mem_limit)) {
-			ret = -ENOMEM;
-			goto err_no_mem;
-		}
-		kfd_mem_limit.system_mem_used += acc_size;
-		kfd_mem_limit.userptr_mem_used += size;
+		/* TTM GTT memory */
+		system_mem_needed = acc_size + size;
+		ttm_mem_needed = acc_size + size;
+	} else if (domain == AMDGPU_GEM_DOMAIN_CPU && !sg) {
+		/* Userptr */
+		system_mem_needed = acc_size + size;
+		ttm_mem_needed = acc_size;
+	} else {
+		/* VRAM and SG */
+		system_mem_needed = acc_size;
+		ttm_mem_needed = acc_size;
+	}
+
+	if ((kfd_mem_limit.system_mem_used + system_mem_needed >
+		kfd_mem_limit.max_system_mem_limit) ||
+		(kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
+		kfd_mem_limit.max_ttm_mem_limit))
+		ret = -ENOMEM;
+	else {
+		kfd_mem_limit.system_mem_used += system_mem_needed;
+		kfd_mem_limit.ttm_mem_used += ttm_mem_needed;
 	}
-err_no_mem:
+
 	spin_unlock(&kfd_mem_limit.mem_limit_lock);
 	return ret;
 }
 
 static void unreserve_system_mem_limit(struct amdgpu_device *adev,
-				       uint64_t size, u32 domain)
+		uint64_t size, u32 domain, bool sg)
 {
 	size_t acc_size;
 
@@ -154,14 +160,18 @@ static void unreserve_system_mem_limit(struct amdgpu_device *adev,
 	spin_lock(&kfd_mem_limit.mem_limit_lock);
 	if (domain == AMDGPU_GEM_DOMAIN_GTT) {
 		kfd_mem_limit.system_mem_used -= (acc_size + size);
-	} else if (domain == AMDGPU_GEM_DOMAIN_CPU) {
+		kfd_mem_limit.ttm_mem_used -= (acc_size + size);
+	} else if (domain == AMDGPU_GEM_DOMAIN_CPU && !sg) {
+		kfd_mem_limit.system_mem_used -= (acc_size + size);
+		kfd_mem_limit.ttm_mem_used -= acc_size;
+	} else {
 		kfd_mem_limit.system_mem_used -= acc_size;
-		kfd_mem_limit.userptr_mem_used -= size;
+		kfd_mem_limit.ttm_mem_used -= acc_size;
 	}
 	WARN_ONCE(kfd_mem_limit.system_mem_used < 0,
 		  "kfd system memory accounting unbalanced");
-	WARN_ONCE(kfd_mem_limit.userptr_mem_used < 0,
-		  "kfd userptr memory accounting unbalanced");
+	WARN_ONCE(kfd_mem_limit.ttm_mem_used < 0,
+		  "kfd TTM memory accounting unbalanced");
 
 	spin_unlock(&kfd_mem_limit.mem_limit_lock);
 }
@@ -171,16 +181,22 @@ void amdgpu_amdkfd_unreserve_system_memory_limit(struct amdgpu_bo *bo)
 	spin_lock(&kfd_mem_limit.mem_limit_lock);
 
 	if (bo->flags & AMDGPU_AMDKFD_USERPTR_BO) {
-		kfd_mem_limit.system_mem_used -= bo->tbo.acc_size;
-		kfd_mem_limit.userptr_mem_used -= amdgpu_bo_size(bo);
+		kfd_mem_limit.system_mem_used -=
+			(bo->tbo.acc_size + amdgpu_bo_size(bo));
+		kfd_mem_limit.ttm_mem_used -= bo->tbo.acc_size;
 	} else if (bo->preferred_domains == AMDGPU_GEM_DOMAIN_GTT) {
 		kfd_mem_limit.system_mem_used -=
 			(bo->tbo.acc_size + amdgpu_bo_size(bo));
+		kfd_mem_limit.ttm_mem_used -=
+			(bo->tbo.acc_size + amdgpu_bo_size(bo));
+	} else {
+		kfd_mem_limit.system_mem_used -= bo->tbo.acc_size;
+		kfd_mem_limit.ttm_mem_used -= bo->tbo.acc_size;
 	}
 	WARN_ONCE(kfd_mem_limit.system_mem_used < 0,
 		  "kfd system memory accounting unbalanced");
-	WARN_ONCE(kfd_mem_limit.userptr_mem_used < 0,
-		  "kfd userptr memory accounting unbalanced");
+	WARN_ONCE(kfd_mem_limit.ttm_mem_used < 0,
+		  "kfd TTM memory accounting unbalanced");
 
 	spin_unlock(&kfd_mem_limit.mem_limit_lock);
 }
@@ -1201,10 +1217,11 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 
 	amdgpu_sync_create(&(*mem)->sync);
 
-	ret = amdgpu_amdkfd_reserve_system_mem_limit(adev, size, alloc_domain);
+	ret = amdgpu_amdkfd_reserve_system_mem_limit(adev, size,
+						     alloc_domain, false);
 	if (ret) {
 		pr_debug("Insufficient system memory\n");
-		goto err_reserve_system_mem;
+		goto err_reserve_limit;
 	}
 
 	pr_debug("\tcreate BO VA 0x%llx size 0x%llx domain %s\n",
@@ -1252,10 +1269,10 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 allocate_init_user_pages_failed:
 	amdgpu_bo_unref(&bo);
 	/* Don't unreserve system mem limit twice */
-	goto err_reserve_system_mem;
+	goto err_reserve_limit;
 err_bo_create:
-	unreserve_system_mem_limit(adev, size, alloc_domain);
-err_reserve_system_mem:
+	unreserve_system_mem_limit(adev, size, alloc_domain, false);
+err_reserve_limit:
 	mutex_destroy(&(*mem)->lock);
 	kfree(*mem);
 	return ret;
-- 
2.43.0



