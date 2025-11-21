Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E683358BE;
	Fri, 21 Nov 2025 13:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733279; cv=none; b=FwIhzpiEeg5bC13yEeOwXT4weST5gwUlO40SEkywJeYDDcmRFW4lhS51iGgNvatAC0e/z/LPG1+FhckOwt0xgZzGlPXnE6M86lq+7H/hRmdmdaBlqvnqp3zPDbOQnLkVjupw0fNuxrLUKYLXVIkRhvvzIm5bFBYjMty+Q3HLrFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733279; c=relaxed/simple;
	bh=sjsxBV+x9Bp/Q8hFDaDes12h4Qzn4bpHevjTI2NMjto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWQCiXpHZkq7J/ck8FE/O2WuuwYq3UjjESAYzm7iPlDoGJB1AmqU9QQIEgGGeBnLQrzLJBoTGYFnI5T4YNrzbK5JZZTDMSiyHUhyniozaxfCVYayL6r7ofigTgcSxH+KaM1e3s0mcQ33jGAcf+qC+YSp8Zc74Eiqynis5fYyR9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlFuv/FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlFuv/FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC54EC4CEF1;
	Fri, 21 Nov 2025 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733278;
	bh=sjsxBV+x9Bp/Q8hFDaDes12h4Qzn4bpHevjTI2NMjto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlFuv/FLnx/nOA96sOQfwyVglWqrN/MaoXEIAkIGKw15wqDCgjT0Nv5z6arm7fWmd
	 05bdsmFeH9ecRWQCEe4Kz8Rj6ewMiOYaSohqViiTjtSQFDMc+onDay7Nda8gHJCxZz
	 h2P8kRrdEOK+irIeIQK3xhM9pg7k1dSfBMdIysBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 386/529] drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices
Date: Fri, 21 Nov 2025 14:11:25 +0100
Message-ID: <20251121130244.758112632@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jesse.Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 883f309add55060233bf11c1ea6947140372920f ]

Previously, APU platforms (and other scenarios with uninitialized VRAM managers)
triggered a NULL pointer dereference in `ttm_resource_manager_usage()`. The root
cause is not that the `struct ttm_resource_manager *man` pointer itself is NULL,
but that `man->bdev` (the backing device pointer within the manager) remains
uninitialized (NULL) on APUs—since APUs lack dedicated VRAM and do not fully
set up VRAM manager structures. When `ttm_resource_manager_usage()` attempts to
acquire `man->bdev->lru_lock`, it dereferences the NULL `man->bdev`, leading to
a kernel OOPS.

1. **amdgpu_cs.c**: Extend the existing bandwidth control check in
   `amdgpu_cs_get_threshold_for_moves()` to include a check for
   `ttm_resource_manager_used()`. If the manager is not used (uninitialized
   `bdev`), return 0 for migration thresholds immediately—skipping VRAM-specific
   logic that would trigger the NULL dereference.

2. **amdgpu_kms.c**: Update the `AMDGPU_INFO_VRAM_USAGE` ioctl and memory info
   reporting to use a conditional: if the manager is used, return the real VRAM
   usage; otherwise, return 0. This avoids accessing `man->bdev` when it is
   NULL.

3. **amdgpu_virt.c**: Modify the vf2pf (virtual function to physical function)
   data write path. Use `ttm_resource_manager_used()` to check validity: if the
   manager is usable, calculate `fb_usage` from VRAM usage; otherwise, set
   `fb_usage` to 0 (APUs have no discrete framebuffer to report).

This approach is more robust than APU-specific checks because it:
- Works for all scenarios where the VRAM manager is uninitialized (not just APUs),
- Aligns with TTM's design by using its native helper function,
- Preserves correct behavior for discrete GPUs (which have fully initialized
  `man->bdev` and pass the `ttm_resource_manager_used()` check).

v4: use ttm_resource_manager_used(&adev->mman.vram_mgr.manager) instead of checking the adev->gmc.is_app_apu flag (Christian)

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c   | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c  | 7 ++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 5b4d7fe148586..05712d322024a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -690,7 +690,7 @@ static void amdgpu_cs_get_threshold_for_moves(struct amdgpu_device *adev,
 	 */
 	const s64 us_upper_bound = 200000;
 
-	if (!adev->mm_stats.log2_max_MBps) {
+	if ((!adev->mm_stats.log2_max_MBps) || !ttm_resource_manager_used(&adev->mman.vram_mgr.manager)) {
 		*max_bytes = 0;
 		*max_vis_bytes = 0;
 		return;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 5797055b1148f..1f0de6e717112 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -651,7 +651,8 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		ui64 = atomic64_read(&adev->num_vram_cpu_page_faults);
 		return copy_to_user(out, &ui64, min(size, 8u)) ? -EFAULT : 0;
 	case AMDGPU_INFO_VRAM_USAGE:
-		ui64 = ttm_resource_manager_usage(&adev->mman.vram_mgr.manager);
+		ui64 = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+			ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) : 0;
 		return copy_to_user(out, &ui64, min(size, 8u)) ? -EFAULT : 0;
 	case AMDGPU_INFO_VIS_VRAM_USAGE:
 		ui64 = amdgpu_vram_mgr_vis_usage(&adev->mman.vram_mgr);
@@ -697,8 +698,8 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		mem.vram.usable_heap_size = adev->gmc.real_vram_size -
 			atomic64_read(&adev->vram_pin_size) -
 			AMDGPU_VM_RESERVED_VRAM;
-		mem.vram.heap_usage =
-			ttm_resource_manager_usage(vram_man);
+		mem.vram.heap_usage = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+				ttm_resource_manager_usage(vram_man) : 0;
 		mem.vram.max_allocation = mem.vram.usable_heap_size * 3 / 4;
 
 		mem.cpu_accessible_vram.total_heap_size =
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 7cb4b4118335a..5a4b1b625f037 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -604,8 +604,8 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 	vf2pf_info->driver_cert = 0;
 	vf2pf_info->os_info.all = 0;
 
-	vf2pf_info->fb_usage =
-		ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) >> 20;
+	vf2pf_info->fb_usage = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+		 ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) >> 20 : 0;
 	vf2pf_info->fb_vis_usage =
 		amdgpu_vram_mgr_vis_usage(&adev->mman.vram_mgr) >> 20;
 	vf2pf_info->fb_size = adev->gmc.real_vram_size >> 20;
-- 
2.51.0



