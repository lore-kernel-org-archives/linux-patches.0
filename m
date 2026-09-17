Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3B518133;
	Thu, 17 Sep 2026 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666968; cv=none; b=Rkv9b+0dr2S3+535IIktgO105fo4dnNRLzDtW2vh353vv2v1CYxOkRC0F2FdylyJPOIkWHaNUdtOxBjOrYgcvDehyHGyTtmrR68m2aOeFZacEVZi/viUNLbhOKRu5zLspdZ2HGbNehUq9A97/PLtC5JoYZiaZpqgEm/pdc8B9q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666968; c=relaxed/simple;
	bh=tLwDU4i801IBwKMoUs+XBoKP+TrNONSLmGfX24EQPGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMhadHaWWdkXxsRko55oXL1kqYPSic356Ltq05cRLJ84k0HPbQbZp7C9QsW1tjTi93uioGrQP3sfQ/nQlU6jmu1ayjdM50Xex7RhC++IhEt7BdJIUyNmvYjnpTVBJ9qtdvIaclWaRe0W7WaWVNzLbqLfbK8bSvNY7gtm9yQrpII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2bUVO36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2bUVO36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872CB1F000FF;
	Thu, 17 Sep 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666967;
	bh=9sH9p2DDjM6+BPHWiYOVuNlpV80uNETZ473BdVR4Fok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2bUVO36PV3DfpYlGTc+PWeMB8xiKo41h6v5StLFn618hcv6RgEJzBnhzNbPp9+Rq
	 MfMQOGFSrTyXYOSmuHfYJAYt8W+cpe7pITE7cpo+f0PaO6SYKtvhbijfc6Ra5m4SVx
	 FAdemy4+DsTaQGhO6l59PIuxmOSPinkFBqOFNIPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1183/1250] drm/amdgpu: reorder IB schedule sequence
Date: Thu, 17 Sep 2026 16:16:18 +0100
Message-ID: <20260917151624.347568594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d3499de3b737f3f6a2058382f7bff641c74f52a4 ]

This reorders the IB schedule sequence to cleanly
separate the vm operation from the IB submission.
This makes the two independent so we can cleanly
associate each one with its respective fence.

v2: fixes for VCN

Acked-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |   22 +++++++++++-----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   11 +++++++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -208,16 +208,6 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 		dma_fence_put(tmp);
 	}
 
-	if ((ib->flags & AMDGPU_IB_FLAG_EMIT_MEM_SYNC) && ring->funcs->emit_mem_sync)
-		ring->funcs->emit_mem_sync(ring);
-
-	if (ring->funcs->emit_wave_limit &&
-	    ring->hw_prio == AMDGPU_GFX_PIPE_PRIO_HIGH)
-		ring->funcs->emit_wave_limit(ring, true);
-
-	if (ring->funcs->insert_start)
-		ring->funcs->insert_start(ring);
-
 	if (job) {
 		r = amdgpu_vm_flush(ring, job, need_pipe_sync);
 		if (r) {
@@ -228,6 +218,16 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 
 	amdgpu_ring_ib_begin(ring);
 
+	if (ring->funcs->insert_start)
+		ring->funcs->insert_start(ring);
+
+	if ((ib->flags & AMDGPU_IB_FLAG_EMIT_MEM_SYNC) && ring->funcs->emit_mem_sync)
+		ring->funcs->emit_mem_sync(ring);
+
+	if (ring->funcs->emit_wave_limit &&
+	    ring->hw_prio == AMDGPU_GFX_PIPE_PRIO_HIGH)
+		ring->funcs->emit_wave_limit(ring, true);
+
 	if (ring->funcs->emit_gfx_shadow && adev->gfx.cp_gfx_shadow)
 		amdgpu_ring_emit_gfx_shadow(ring, shadow_va, csa_va, gds_va,
 					    init_shadow, vmid);
@@ -312,6 +312,7 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 	    ring->hw_prio == AMDGPU_GFX_PIPE_PRIO_HIGH)
 		ring->funcs->emit_wave_limit(ring, false);
 
+	amdgpu_ring_ib_end(ring);
 	/* Save the wptr associated with this fence.
 	 * This must be last for resets to work properly
 	 * as we need to save the wptr associated with this
@@ -320,7 +321,6 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 	 */
 	amdgpu_fence_save_wptr(*f);
 
-	amdgpu_ring_ib_end(ring);
 	amdgpu_ring_commit(ring);
 
 	return 0;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -814,6 +814,17 @@ int amdgpu_vm_flush(struct amdgpu_ring *
 		return 0;
 
 	amdgpu_ring_ib_begin(ring);
+
+	/* There is no matching insert_end for this on purpose for the vm flush.
+	 * The IB portion of the submission has both.  Having multiple
+	 * insert_start sequences is ok, but you can only have one insert_end
+	 * per submission based on the way VCN FW works.  For JPEG
+	 * you can as many insert_start and insert_end sequences as you like as
+	 * long as the rest of the packets come between start and end sequences.
+	 */
+	if (ring->funcs->insert_start)
+		ring->funcs->insert_start(ring);
+
 	if (ring->funcs->init_cond_exec)
 		patch = amdgpu_ring_init_cond_exec(ring,
 						   ring->cond_exe_gpu_addr);


