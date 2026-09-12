Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A9288B9;
	Sat, 12 Sep 2026 16:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231009; cv=none; b=kB6/4Q5joUoaCmSv50uPsXIb00Zfeoyyfcwa+PatB09GAqnR31ymbuL0Y7ADbJZjU/Z/jwGlUqDFWIuyrEag28EnGM4BJxFjDstz0koQV+Axvz/wYsTa7Bh2rx3DhbnAmcVyyLqmVXSnKhr97H19Mv98NaFCr+S2v3zO+jG1UiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231009; c=relaxed/simple;
	bh=NPOvDR8bxE5lGGT6V10RZ2qIp9Q6raAlUnMKdjJDJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I07HDsr643n61vLX6C+8BDdWNN+caaVZ2UipyI/Vn0G/AkynhkuO6hnwvSC7Cj4ejOAqWsWi+ljuQzFVaXQ9PzYeo4gQDWvQl6hXmz/cDbwpW0Q0XZltIqofb8GNiClQV7BlFqm8PWVMK7BI/xi9rVnGOSR2g/lApYPgElRS7n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGX6o2hI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGX6o2hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84851F000FF;
	Sat, 12 Sep 2026 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231007;
	bh=5EJq1ykRFUX9wK/KdcJU+laU+BoE5jOFvGFrZ8JHjyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGX6o2hIPoI3ztoyQMvyaEIVN//aB63ZDdOW+7tbFTqLLlcRkyZSrmaGh1GMzZgtH
	 IFr+7QvNjiiqvChuBZRO1rcgbUav4Did+eZN8CxNZ6ezjsaQvR3El0y8ekA69/5qJQ
	 +O1xbwjc0FNccT79B2MkQCG09XsFV0CmtUBqJS70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0910/1191] drm/amdgpu/gfx6: Use PFP on the compute queues too
Date: Sat, 12 Sep 2026 09:00:38 +0200
Message-ID: <20260912065608.674462348@linuxfoundation.org>
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

[ Upstream commit 60f20946cd318518ddc2c0da12103c666b2b9564 ]

On GFX6, the compute rings use the same CP path as
the graphics ring. The only difference is that they
don't support draw commands. (As opposed to GFX7 and
newer which have a separate command parser that is
called MEC for compute queues.)

This means that we have to take into consideration
that the PFP also exists on compute queues on GFX6:

Use PFP for register writes on both graphics and
compute queues.

In the pipeline sync, use the PFP to wait for the
previous fence (and not the ME) to prevent the PFP
from starting to execute the next submission while
the ME is still in the previous submission.

After a VM flush, emit PFP_SYNC_ME on compute
queues as well.

Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index c813902f00aee..fe565dff703f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2340,7 +2340,7 @@ static int gfx_v6_0_cp_resume(struct amdgpu_device *adev)
 
 static void gfx_v6_0_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 	uint32_t seq = ring->fence_drv.sync_seq;
 	uint64_t addr = ring->fence_drv.gpu_addr;
 
@@ -2358,7 +2358,7 @@ static void gfx_v6_0_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
 static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
 					unsigned vmid, uint64_t pd_addr)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 
 	amdgpu_gmc_emit_flush_gpu_tlb(ring, vmid, pd_addr);
 
@@ -2382,7 +2382,7 @@ static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
 static void gfx_v6_0_ring_emit_wreg(struct amdgpu_ring *ring,
 				    uint32_t reg, uint32_t val)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(usepfp) |
@@ -3577,7 +3577,7 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_compute = {
 	.emit_frame_size =
 		5 + 5 + /* hdp flush / invalidate */
 		7 + /* gfx_v6_0_ring_emit_pipeline_sync */
-		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + /* gfx_v6_0_ring_emit_vm_flush */
+		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + 2 + /* gfx_v6_0_ring_emit_vm_flush */
 		14 + 14 + 14 + /* gfx_v6_0_ring_emit_fence x3 for user fence, vm fence */
 		3 * 2 + /* gfx_v6_0_ring_emit_sb x3 (from amdgpu_vm_flush, amdgpu_ib_schedule) */
 		5, /* SURFACE_SYNC */
-- 
2.53.0



