Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E038A19E7EE;
	Thu,  6 Jun 2024 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683113; cv=none; b=TZR3Q74NZrbOV7F9OR0PUxa4YJZIfJqgDfF5dVuBlJ8QsgDc3t4d9ICcN1s6gVePouRkt1XcFu8KdySzoCKhZfugAYyG2B14M6t3EInM8+ewR2w3DTWYTac+o4kO3oO6qqWtYUH5u+k4lqCc8Kc0+XnzRWBmFd/rMFJIs8ZbmMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683113; c=relaxed/simple;
	bh=sxsOldCffvFixJRfAtrzxE/DW61fKdd5P5FtKKDhJMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BCDFU/DXmpTbbRKDJy0o449+71rtd+kK6rz8R60nBV2+KYxiMuUaBKHPY5g1ivJtcbk9A3/K9hbT9QzfjtGYPD48osUcaW+WN00pQXupIVbz0bey19BYz5hHBeSJv8FlUSR6tKqJWq7F/LRFS43Jq9dv0ib+mkUMJqhzq/tBAZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V36QPUGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V36QPUGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF388C2BD10;
	Thu,  6 Jun 2024 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683112;
	bh=sxsOldCffvFixJRfAtrzxE/DW61fKdd5P5FtKKDhJMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V36QPUGI5efJrvhDeOIakNRJiOROWc1ekAwBbd6JxAhfuZPs1AnR591xtB0Y+fxxD
	 i3HJA68Fj70hfEBQKZDp5iW9JnD0bzYOHucvCq4oUJaOymgEV+7EaYtftl5OmwwrYM
	 tXqJCt9rEcw4cQSNavKYDJ09SzhyPH5ZZVqkDxXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/744] drm/amdgpu: Fix the ring buffer size for queue VM flush
Date: Thu,  6 Jun 2024 15:55:16 +0200
Message-ID: <20240606131733.867105312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit fe93b0927bc58cb1d64230f45744e527d9d8482c ]

Here are the corrections needed for the queue ring buffer size
calculation for the following cases:
- Remove the KIQ VM flush ring usage.
- Add the invalidate TLBs packet for gfx10 and gfx11 queue.
- There's no VM flush and PFP sync, so remove the gfx9 real
  ring and compute ring buffer usage.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 3 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c  | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 495eb4cad0e1a..3560a3f2c848e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9157,7 +9157,7 @@ static const struct amdgpu_ring_funcs gfx_v10_0_ring_funcs_gfx = {
 		7 + /* PIPELINE_SYNC */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* VM_FLUSH */
+		4 + /* VM_FLUSH */
 		8 + /* FENCE for VM_FLUSH */
 		20 + /* GDS switch */
 		4 + /* double SWITCH_BUFFER,
@@ -9248,7 +9248,6 @@ static const struct amdgpu_ring_funcs gfx_v10_0_ring_funcs_kiq = {
 		7 + /* gfx_v10_0_ring_emit_pipeline_sync */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* gfx_v10_0_ring_emit_vm_flush */
 		8 + 8 + 8, /* gfx_v10_0_ring_emit_fence_kiq x3 for user fence, vm fence */
 	.emit_ib_size =	7, /* gfx_v10_0_ring_emit_ib_compute */
 	.emit_ib = gfx_v10_0_ring_emit_ib_compute,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c9058d58c95a7..daab4c7a073ac 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6102,7 +6102,7 @@ static const struct amdgpu_ring_funcs gfx_v11_0_ring_funcs_gfx = {
 		7 + /* PIPELINE_SYNC */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* VM_FLUSH */
+		4 + /* VM_FLUSH */
 		8 + /* FENCE for VM_FLUSH */
 		20 + /* GDS switch */
 		5 + /* COND_EXEC */
@@ -6187,7 +6187,6 @@ static const struct amdgpu_ring_funcs gfx_v11_0_ring_funcs_kiq = {
 		7 + /* gfx_v11_0_ring_emit_pipeline_sync */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* gfx_v11_0_ring_emit_vm_flush */
 		8 + 8 + 8, /* gfx_v11_0_ring_emit_fence_kiq x3 for user fence, vm fence */
 	.emit_ib_size =	7, /* gfx_v11_0_ring_emit_ib_compute */
 	.emit_ib = gfx_v11_0_ring_emit_ib_compute,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index d7d15b618c374..8168836a08d2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -6988,7 +6988,6 @@ static const struct amdgpu_ring_funcs gfx_v9_0_ring_funcs_compute = {
 		7 + /* gfx_v9_0_ring_emit_pipeline_sync */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* gfx_v9_0_ring_emit_vm_flush */
 		8 + 8 + 8 + /* gfx_v9_0_ring_emit_fence x3 for user fence, vm fence */
 		7 + /* gfx_v9_0_emit_mem_sync */
 		5 + /* gfx_v9_0_emit_wave_limit for updating mmSPI_WCL_PIPE_PERCENT_GFX register */
@@ -7026,7 +7025,6 @@ static const struct amdgpu_ring_funcs gfx_v9_0_ring_funcs_kiq = {
 		7 + /* gfx_v9_0_ring_emit_pipeline_sync */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 5 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 7 +
-		2 + /* gfx_v9_0_ring_emit_vm_flush */
 		8 + 8 + 8, /* gfx_v9_0_ring_emit_fence_kiq x3 for user fence, vm fence */
 	.emit_ib_size =	7, /* gfx_v9_0_ring_emit_ib_compute */
 	.emit_fence = gfx_v9_0_ring_emit_fence_kiq,
-- 
2.43.0



