Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A98F2882DE;
	Sat, 12 Sep 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231005; cv=none; b=uYm30/kATh2V2cW+Mnwjt8klYGaDcVNC3EWt33cBvfpGIb0R/JW5ySePhpVRvTBzntNPT92KhurGzqeCmDK9Et9M6KhsW0a4wjrJQernSAd4p62qdwT6GfC984hgh2pjBIyWjtYUnjkKBukmN6ntyadl3ObXhN7cZliar+BajK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231005; c=relaxed/simple;
	bh=8GVGSGChBU7ttLdZeeZdgHeyNagQBSq9gL8Akp/Qkno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BkC3ceQOz/x4njJ6U4I6U3dKLPJZhaf/sMRVv1Zm0qTk430x8n1nfAdYryTJeuHOi3CWcypx84+osnHE2JccPpwjdry0qSJtDltTziOTeSNmIX/ONAeepCkm3ISTO9Z9aHJWnDOTytE6ZaECUb8PdYZQPeDYfNwGrTDJ83VjQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHryp72/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHryp72/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B0F1F000FF;
	Sat, 12 Sep 2026 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231003;
	bh=L0i7Io1ll7d3pNEG0te4c6cAklftj3++eyj5230pDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHryp72/ozZZDPo7iWtYWvJLlEdHX2F/zHSXOSCGhQaKMHA6Kt83c8e2u9jjPtdzz
	 sIm2DT6wWCfw8AKNRphjCUSDWh8uarjTrv7TtwC35PuNvqChPQeqUjgp/a8uR92rqS
	 vQ03fAIcBwlly7GOt3qGwQ0JZnNWVY/drn3aWN+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0909/1191] drm/amdgpu/gfx6: Fixup emitting SWITCH_BUFFER packets
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065608.650994314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7aac4242a11991d530eee3e141d6e445d5f11c22 ]

Implement the emit_switch_buffer() function instead of emitting
them duing emit_ib, emit_pipeline_sync and emit_vm_flush.

Note that it isn't necessary to emit these in both
emit_pipeline_sync() and emit_vm_flush() because
amdgpu_vm_flush() already calls these when calling
either of those functions.

Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 38 ++++++++++-----------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index df27323abde5b..c813902f00aee 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -1919,12 +1919,6 @@ static void gfx_v6_0_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	/* insert SWITCH_BUFFER packet before first IB in the ring frame */
-	if (flags & AMDGPU_HAVE_CTX_SWITCH) {
-		amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
-		amdgpu_ring_write(ring, 0);
-	}
-
 	if (ib->flags & AMDGPU_IB_FLAG_CE)
 		header = PACKET3(PACKET3_INDIRECT_BUFFER_CONST, 2);
 	else
@@ -2359,14 +2353,6 @@ static void gfx_v6_0_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
 	amdgpu_ring_write(ring, seq);
 	amdgpu_ring_write(ring, 0xffffffff);
 	amdgpu_ring_write(ring, 4); /* poll interval */
-
-	if (usepfp) {
-		/* synce CE with ME to prevent CE fetch CEIB before context switch done */
-		amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
-		amdgpu_ring_write(ring, 0);
-		amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
-		amdgpu_ring_write(ring, 0);
-	}
 }
 
 static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
@@ -2390,12 +2376,6 @@ static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
 		/* sync PFP to ME, otherwise we might get invalid PFP reads */
 		amdgpu_ring_write(ring, PACKET3(PACKET3_PFP_SYNC_ME, 0));
 		amdgpu_ring_write(ring, 0x0);
-
-		/* synce CE with ME to prevent CE fetch CEIB before context switch done */
-		amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
-		amdgpu_ring_write(ring, 0);
-		amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
-		amdgpu_ring_write(ring, 0);
 	}
 }
 
@@ -3014,6 +2994,12 @@ static uint64_t gfx_v6_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 	return clock;
 }
 
+static void gfx_v6_0_ring_emit_sb(struct amdgpu_ring *ring)
+{
+	amdgpu_ring_write(ring, PACKET3(PACKET3_SWITCH_BUFFER, 0));
+	amdgpu_ring_write(ring, 0);
+}
+
 static void gfx_v6_ring_emit_cntxcntl(struct amdgpu_ring *ring, uint32_t flags)
 {
 	u32 dw2 = 0x80000000; /* set load_enable otherwise this package is just NOPs */
@@ -3562,11 +3548,12 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_gfx = {
 	.emit_frame_size =
 		5 + 5 + /* hdp flush / invalidate */
 		14 + 14 + 14 + /* gfx_v6_0_ring_emit_fence x3 for user fence, vm fence */
-		7 + 4 + /* gfx_v6_0_ring_emit_pipeline_sync */
-		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + 6 + /* gfx_v6_0_ring_emit_vm_flush */
+		7 + /* gfx_v6_0_ring_emit_pipeline_sync */
+		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + 2 + /* gfx_v6_0_ring_emit_vm_flush */
+		3 * 2 + /* gfx_v6_0_ring_emit_sb x3 (from amdgpu_vm_flush, amdgpu_ib_schedule) */
 		3 + 2 + 2 + /* gfx_v6_ring_emit_cntxcntl including VGT flush */
 		5, /* SURFACE_SYNC */
-	.emit_ib_size = 6, /* gfx_v6_0_ring_emit_ib */
+	.emit_ib_size = 4, /* gfx_v6_0_ring_emit_ib */
 	.emit_ib = gfx_v6_0_ring_emit_ib,
 	.emit_fence = gfx_v6_0_ring_emit_fence,
 	.emit_pipeline_sync = gfx_v6_0_ring_emit_pipeline_sync,
@@ -3574,6 +3561,7 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_gfx = {
 	.test_ring = gfx_v6_0_ring_test_ring,
 	.test_ib = gfx_v6_0_ring_test_ib,
 	.insert_nop = amdgpu_ring_insert_nop,
+	.emit_switch_buffer = gfx_v6_0_ring_emit_sb,
 	.emit_cntxcntl = gfx_v6_ring_emit_cntxcntl,
 	.emit_wreg = gfx_v6_0_ring_emit_wreg,
 	.emit_mem_sync = gfx_v6_0_emit_mem_sync,
@@ -3591,8 +3579,9 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_compute = {
 		7 + /* gfx_v6_0_ring_emit_pipeline_sync */
 		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + /* gfx_v6_0_ring_emit_vm_flush */
 		14 + 14 + 14 + /* gfx_v6_0_ring_emit_fence x3 for user fence, vm fence */
+		3 * 2 + /* gfx_v6_0_ring_emit_sb x3 (from amdgpu_vm_flush, amdgpu_ib_schedule) */
 		5, /* SURFACE_SYNC */
-	.emit_ib_size = 6, /* gfx_v6_0_ring_emit_ib */
+	.emit_ib_size = 4, /* gfx_v6_0_ring_emit_ib */
 	.emit_ib = gfx_v6_0_ring_emit_ib,
 	.emit_fence = gfx_v6_0_ring_emit_fence,
 	.emit_pipeline_sync = gfx_v6_0_ring_emit_pipeline_sync,
@@ -3600,6 +3589,7 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_compute = {
 	.test_ring = gfx_v6_0_ring_test_ring,
 	.test_ib = gfx_v6_0_ring_test_ib,
 	.insert_nop = amdgpu_ring_insert_nop,
+	.emit_switch_buffer = gfx_v6_0_ring_emit_sb,
 	.emit_wreg = gfx_v6_0_ring_emit_wreg,
 	.emit_mem_sync = gfx_v6_0_emit_mem_sync,
 };
-- 
2.53.0



