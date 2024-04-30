Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0312C47A;
	Tue, 30 Apr 2024 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475458; cv=none; b=T6luRExrGLiX7K8beeM47nlYjFnQZEvmZ5DpPUtCULxPmOVmqmlMSpX7JGdAKxJhTr6KZCclnNjBFSkbRmM5J7H+s0XK1IKwlLRGBIbTAvU3n5WdfNgudrWcHSddR4xAf9IJ2ozMlIxYUHbhxfm0mfYpuD9Rrb4+GRvsWD0iGB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475458; c=relaxed/simple;
	bh=asEug9Bwi6T6KbBdFN+1Nl9WOTNJbuiXGDRLwHB+T2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GVDDGazNOA7pV8j17vTct+Wt4T9hR5bNAGa0M5D0lvEfl+QMONjYbIVmY5sXTlKZzONrio9udi8rvTG83OJaoVeMis7qYHEnWKdHqgcYZPbZEklEPbFNgTGgYEfAfLYBaGwSSPtCRBrHnBms5kdgp2jeLS+hbdMLrHh2+Rz5qQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnIPOIub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnIPOIub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E341C4AF18;
	Tue, 30 Apr 2024 11:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475458;
	bh=asEug9Bwi6T6KbBdFN+1Nl9WOTNJbuiXGDRLwHB+T2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnIPOIub9OmfzVUbTeey9yECwYF/NA2FMbkIUALd5qZG8NzwWK/j5XAUrSUBKrY7H
	 mEbZ1ThJ3hoMLTCJEbj9yZe4aCyv5B83EdIAk1IKDTQShlmqdmCrlV6Shl6K6/H6YY
	 l19Sd+DehR7vJF5/COj+F62cfa8qluQUnYsFE4dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Rob Clark <robdclark@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.keonig@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/186] drm/amdgpu: add shared fdinfo stats
Date: Tue, 30 Apr 2024 12:39:13 +0200
Message-ID: <20240430103100.967558941@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ba1a58d5b907bdf1814f8f57434aebc86233430f ]

Add shared stats.  Useful for seeing shared memory.

v2: take dma-buf into account as well
v3: use the new gem helper

Link: https://lore.kernel.org/all/20231207180225.439482-1-alexander.deucher@amd.com/
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Rob Clark <robdclark@gmail.com>
Reviewed-by: Christian König <christian.keonig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Stable-dep-of: a6ff969fe9cb ("drm/amdgpu: fix visible VRAM handling during faults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c |  4 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 11 +++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h |  6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
index 6038b5021b27b..792c059ff7b35 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c
@@ -105,6 +105,10 @@ void amdgpu_show_fdinfo(struct drm_printer *p, struct drm_file *file)
 		   stats.requested_visible_vram/1024UL);
 	drm_printf(p, "amd-requested-gtt:\t%llu KiB\n",
 		   stats.requested_gtt/1024UL);
+	drm_printf(p, "drm-shared-vram:\t%llu KiB\n", stats.vram_shared/1024UL);
+	drm_printf(p, "drm-shared-gtt:\t%llu KiB\n", stats.gtt_shared/1024UL);
+	drm_printf(p, "drm-shared-cpu:\t%llu KiB\n", stats.cpu_shared/1024UL);
+
 	for (hw_ip = 0; hw_ip < AMDGPU_HW_IP_NUM; ++hw_ip) {
 		if (!usage[hw_ip])
 			continue;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 173b43a5aa13b..394f475877e3b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1281,25 +1281,36 @@ void amdgpu_bo_get_memory(struct amdgpu_bo *bo,
 			  struct amdgpu_mem_stats *stats)
 {
 	uint64_t size = amdgpu_bo_size(bo);
+	struct drm_gem_object *obj;
 	unsigned int domain;
+	bool shared;
 
 	/* Abort if the BO doesn't currently have a backing store */
 	if (!bo->tbo.resource)
 		return;
 
+	obj = &bo->tbo.base;
+	shared = drm_gem_object_is_shared_for_memory_stats(obj);
+
 	domain = amdgpu_mem_type_to_domain(bo->tbo.resource->mem_type);
 	switch (domain) {
 	case AMDGPU_GEM_DOMAIN_VRAM:
 		stats->vram += size;
 		if (amdgpu_bo_in_cpu_visible_vram(bo))
 			stats->visible_vram += size;
+		if (shared)
+			stats->vram_shared += size;
 		break;
 	case AMDGPU_GEM_DOMAIN_GTT:
 		stats->gtt += size;
+		if (shared)
+			stats->gtt_shared += size;
 		break;
 	case AMDGPU_GEM_DOMAIN_CPU:
 	default:
 		stats->cpu += size;
+		if (shared)
+			stats->cpu_shared += size;
 		break;
 	}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
index a3ea8a82db23a..be679c42b0b8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -138,12 +138,18 @@ struct amdgpu_bo_vm {
 struct amdgpu_mem_stats {
 	/* current VRAM usage, includes visible VRAM */
 	uint64_t vram;
+	/* current shared VRAM usage, includes visible VRAM */
+	uint64_t vram_shared;
 	/* current visible VRAM usage */
 	uint64_t visible_vram;
 	/* current GTT usage */
 	uint64_t gtt;
+	/* current shared GTT usage */
+	uint64_t gtt_shared;
 	/* current system memory usage */
 	uint64_t cpu;
+	/* current shared system memory usage */
+	uint64_t cpu_shared;
 	/* sum of evicted buffers, includes visible VRAM */
 	uint64_t evicted_vram;
 	/* sum of evicted buffers due to CPU access */
-- 
2.43.0



