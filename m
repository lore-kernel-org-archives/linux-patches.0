Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB151FF1C8;
	Tue, 30 Sep 2025 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244611; cv=none; b=PyS4eQj1UDUO2pDMRPqdAf6UgYNd13k6+/Am2FUnyfwbR5JH9O/JxeFpMm+10fd2u12ds60cgWlAi10Ual61A6eOQG83A5qj9TDPrqsMky4zr/4GUKdZQ9w6iFpqX9ajsZMX+fbbh7cQCfidJrMuau9l2+MeAELxXtSzqDOrdTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244611; c=relaxed/simple;
	bh=EnPtj/ddQj5jZBQYLejAubFMoIcTOrTX7JfnXHeQn5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihw00BhuQyIe6qQPB5taAUT8s9Ttp+jSIHY2b4MJnHS/D6zwkIj1zT6W81oF52npJWGus/IdVyXSnDIaKbCq912uhAk6ggKY93uulkEi7dAdsQrB3V+e03PV2z7NL4/SGD/gQp6fRWruoLs5yNuizHqPnNFxd/uT5zlILUObXIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG+5E6g0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG+5E6g0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721A9C4CEF0;
	Tue, 30 Sep 2025 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244610;
	bh=EnPtj/ddQj5jZBQYLejAubFMoIcTOrTX7JfnXHeQn5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG+5E6g0y712JjfzLkZJK88+U2ABNLCuVJOeD8yvNkGh7YA9NCNV6pLrXvXdc1t32
	 FoLMTGx+jH44x+wYy9eSokye0RCnt/00dzFVhjYPFPI5UXnRIEUXEVn/DqN5Lc5Kou
	 /zbWaQ5cvrYsX24xquImn3XN/4vyHX5nmDCjoyiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 053/143] amd/amdkfd: correct mem limit calculation for small APUs
Date: Tue, 30 Sep 2025 16:46:17 +0200
Message-ID: <20250930143833.346996651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 53503556273a5ead8b75534085e2dcb46e96f883 ]

Current mem limit check leaks some GTT memory (reserved_for_pt
reserved_for_ras + adev->vram_pin_size) for small APUs.

Since carveout VRAM is tunable on APUs, there are three case
regarding the carveout VRAM size relative to GTT:

1. 0 < carveout < gtt
   apu_prefer_gtt = true, is_app_apu = false

2. carveout > gtt / 2
   apu_prefer_gtt = false, is_app_apu = false

3. 0 = carveout
   apu_prefer_gtt = true, is_app_apu = true

It doesn't make sense to check below limitation in case 1
(default case, small carveout) because the values in the below
expression are mixed with carveout and gtt.

adev->kfd.vram_used[xcp_id] + vram_needed >
    vram_size - reserved_for_pt - reserved_for_ras -
    atomic64_read(&adev->vram_pin_size)

gtt: kfd.vram_used, vram_needed, vram_size
carveout: reserved_for_pt, reserved_for_ras, adev->vram_pin_size

In case 1, vram allocation will go to gtt domain, skip vram check
since ttm_mem_limit check already cover this allocation.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa7c99f04f6dd299388e9282812b14e95558ac8e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 260165bbe3736..b16cce7c22c37 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -213,19 +213,35 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 	spin_lock(&kfd_mem_limit.mem_limit_lock);
 
 	if (kfd_mem_limit.system_mem_used + system_mem_needed >
-	    kfd_mem_limit.max_system_mem_limit)
+	    kfd_mem_limit.max_system_mem_limit) {
 		pr_debug("Set no_system_mem_limit=1 if using shared memory\n");
+		if (!no_system_mem_limit) {
+			ret = -ENOMEM;
+			goto release;
+		}
+	}
 
-	if ((kfd_mem_limit.system_mem_used + system_mem_needed >
-	     kfd_mem_limit.max_system_mem_limit && !no_system_mem_limit) ||
-	    (kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
-	     kfd_mem_limit.max_ttm_mem_limit) ||
-	    (adev && xcp_id >= 0 && adev->kfd.vram_used[xcp_id] + vram_needed >
-	     vram_size - reserved_for_pt - reserved_for_ras - atomic64_read(&adev->vram_pin_size))) {
+	if (kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
+		kfd_mem_limit.max_ttm_mem_limit) {
 		ret = -ENOMEM;
 		goto release;
 	}
 
+	/*if is_app_apu is false and apu_prefer_gtt is true, it is an APU with
+	 * carve out < gtt. In that case, VRAM allocation will go to gtt domain, skip
+	 * VRAM check since ttm_mem_limit check already cover this allocation
+	 */
+
+	if (adev && xcp_id >= 0 && (!adev->apu_prefer_gtt || adev->gmc.is_app_apu)) {
+		uint64_t vram_available =
+			vram_size - reserved_for_pt - reserved_for_ras -
+			atomic64_read(&adev->vram_pin_size);
+		if (adev->kfd.vram_used[xcp_id] + vram_needed > vram_available) {
+			ret = -ENOMEM;
+			goto release;
+		}
+	}
+
 	/* Update memory accounting by decreasing available system
 	 * memory, TTM memory and GPU memory as computed above
 	 */
@@ -1626,11 +1642,15 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 	uint64_t vram_available, system_mem_available, ttm_mem_available;
 
 	spin_lock(&kfd_mem_limit.mem_limit_lock);
-	vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
-		- adev->kfd.vram_used_aligned[xcp_id]
-		- atomic64_read(&adev->vram_pin_size)
-		- reserved_for_pt
-		- reserved_for_ras;
+	if (adev->apu_prefer_gtt && !adev->gmc.is_app_apu)
+		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
+			- adev->kfd.vram_used_aligned[xcp_id];
+	else
+		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
+			- adev->kfd.vram_used_aligned[xcp_id]
+			- atomic64_read(&adev->vram_pin_size)
+			- reserved_for_pt
+			- reserved_for_ras;
 
 	if (adev->apu_prefer_gtt) {
 		system_mem_available = no_system_mem_limit ?
-- 
2.51.0



