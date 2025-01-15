Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C2248BA1;
	Wed, 15 Jan 2025 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938230; cv=none; b=hP9uRcz+OIjI33u46Ma3RH2yAv6r8MupirZou+fjQ73jMRJBzzC3i6yPh9I35Lky1t2GHXb99C4720XRi0VvddvwIqiEA5XoPuhQuMz2LEiAHZ4vLaEjcvZJb2LLaYnEvj4fNa0la0CzspZppdaOY5M5z8Xk/oCuqO5KUcpyG5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938230; c=relaxed/simple;
	bh=Gb+N8afyn5CWkUWtMT9t6jqBHXR8AxjTc05In2E5j1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyk8ckFZNDG2a+JQg8r+rqCeNiTIhOupFGS0T4QGEpzdyGVcMxHtbILt/iwBfmE61OztSmOTRKIgZDuUxAT5zxWD6EfMhBNsFEIRdwBK44BMVwBV7SDP4ySJqOTE7BUgYkFlaJoKgdnMc+R2uxIPCg4elACtV0yOFsZ91UnAcfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlMMj4A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlMMj4A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D74C4CEDF;
	Wed, 15 Jan 2025 10:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938230;
	bh=Gb+N8afyn5CWkUWtMT9t6jqBHXR8AxjTc05In2E5j1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlMMj4A5QglCyAJW7qB6ruuvI/E3hSzAdSkUSJsyOCfUnjNovlXjHCRptsUPdlIt+
	 Tci/DBwLUNVyl1suSYy7vysc4A5M2Qc5kbxjD3imvpW96j4GafZJ4NfiAneYN8hIfy
	 Ydl9EdIRUPz5XSx62alAuDuYRUotdj2Z4oSLyGlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 121/189] drm/amdgpu: Add a lock when accessing the buddy trim function
Date: Wed, 15 Jan 2025 11:36:57 +0100
Message-ID: <20250115103611.282958337@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 75c8b703e5bded1e33b08fb09b829e7c2c1ed50a upstream.

When running YouTube videos and Steam games simultaneously,
the tester found a system hang / race condition issue with
the multi-display configuration setting. Adding a lock to
the buddy allocator's trim function would be the solution.

<log snip>
[ 7197.250436] general protection fault, probably for non-canonical address 0xdead000000000108
[ 7197.250447] RIP: 0010:__alloc_range+0x8b/0x340 [amddrm_buddy]
[ 7197.250470] Call Trace:
[ 7197.250472]  <TASK>
[ 7197.250475]  ? show_regs+0x6d/0x80
[ 7197.250481]  ? die_addr+0x37/0xa0
[ 7197.250483]  ? exc_general_protection+0x1db/0x480
[ 7197.250488]  ? drm_suballoc_new+0x13c/0x93d [drm_suballoc_helper]
[ 7197.250493]  ? asm_exc_general_protection+0x27/0x30
[ 7197.250498]  ? __alloc_range+0x8b/0x340 [amddrm_buddy]
[ 7197.250501]  ? __alloc_range+0x109/0x340 [amddrm_buddy]
[ 7197.250506]  amddrm_buddy_block_trim+0x1b5/0x260 [amddrm_buddy]
[ 7197.250511]  amdgpu_vram_mgr_new+0x4f5/0x590 [amdgpu]
[ 7197.250682]  amdttm_resource_alloc+0x46/0xb0 [amdttm]
[ 7197.250689]  ttm_bo_alloc_resource+0xe4/0x370 [amdttm]
[ 7197.250696]  amdttm_bo_validate+0x9d/0x180 [amdttm]
[ 7197.250701]  amdgpu_bo_pin+0x15a/0x2f0 [amdgpu]
[ 7197.250831]  amdgpu_dm_plane_helper_prepare_fb+0xb2/0x360 [amdgpu]
[ 7197.251025]  ? try_wait_for_completion+0x59/0x70
[ 7197.251030]  drm_atomic_helper_prepare_planes.part.0+0x2f/0x1e0
[ 7197.251035]  drm_atomic_helper_prepare_planes+0x5d/0x70
[ 7197.251037]  drm_atomic_helper_commit+0x84/0x160
[ 7197.251040]  drm_atomic_nonblocking_commit+0x59/0x70
[ 7197.251043]  drm_mode_atomic_ioctl+0x720/0x850
[ 7197.251047]  ? __pfx_drm_mode_atomic_ioctl+0x10/0x10
[ 7197.251049]  drm_ioctl_kernel+0xb9/0x120
[ 7197.251053]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 7197.251056]  drm_ioctl+0x2d4/0x550
[ 7197.251058]  ? __pfx_drm_mode_atomic_ioctl+0x10/0x10
[ 7197.251063]  amdgpu_drm_ioctl+0x4e/0x90 [amdgpu]
[ 7197.251186]  __x64_sys_ioctl+0xa0/0xf0
[ 7197.251190]  x64_sys_call+0x143b/0x25c0
[ 7197.251193]  do_syscall_64+0x7f/0x180
[ 7197.251197]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 7197.251199]  ? amdgpu_display_user_framebuffer_create+0x215/0x320 [amdgpu]
[ 7197.251329]  ? drm_internal_framebuffer_create+0xb7/0x1a0
[ 7197.251332]  ? srso_alias_return_thunk+0x5/0xfbef5

Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Fixes: 4a5ad08f5377 ("drm/amdgpu: Add address alignment support to DCC buffers")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3318ba94e56b9183d0304577c74b33b6b01ce516)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 7d26a962f811..ff5e52025266 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -567,7 +567,6 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 		else
 			remaining_size -= size;
 	}
-	mutex_unlock(&mgr->lock);
 
 	if (bo->flags & AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS && adjust_dcc_size) {
 		struct drm_buddy_block *dcc_block;
@@ -584,6 +583,7 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 				     (u64)vres->base.size,
 				     &vres->blocks);
 	}
+	mutex_unlock(&mgr->lock);
 
 	vres->base.start = 0;
 	size = max_t(u64, amdgpu_vram_mgr_blocks_size(&vres->blocks),
-- 
2.48.0



