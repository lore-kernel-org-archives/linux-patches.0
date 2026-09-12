Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D44739150A;
	Sat, 12 Sep 2026 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243110; cv=none; b=bGZSwhTdQL05Ea/Ba+hWixFZlaTiPYTEGGqvETxERFrywGHqkFK8ieWMOybvzABqRxp5dyxbI5kqd+50p1jAwc/IrYOOQJszVFcRbDdo46ED//pCWEzc/HTJSToZg22eHZp/55EfZPHsHHNhK0eeBxcsw1anTEXClv/HECMGe8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243110; c=relaxed/simple;
	bh=SFJl84tBxnezVBJNAGMsqmdQvhLDONl8M8Vxr4QuqIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXkm0FLMUX4TX75ln2RIilrVIgLz60P+mG5t+jcgW1GTSNqSNvXEzugU87dQ0kcxBjq0W5r4VAHihY5Ja8aUjwaV/dFUKZN6Lo4ACcRH/1XQ+zSGLfwgF5DOpn07G4sLXQYav5YStVnXsbzQxXNuTGI6fVqH2fcPkn10Vw97MNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3JnJawK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3JnJawK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57961F000FF;
	Sat, 12 Sep 2026 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243109;
	bh=1hqOGk/pQu9FUgpap+K2z8TuJa6Ij26McPv/FDHOzsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3JnJawKzGA4QWDhqqRuprv94csACJVd+STt61BURb151UOV5UJ6Q24i6a1sE9Lve
	 j5ajS7HrxRBDzFR4uJW1sGxAv1XOBr+u5fn4GSzB/t+UsCqvjrPootSTo8hpvd6/YJ
	 Ln/1SodqVWn0F6uErnVgLG1fVaWXB4xKhoOrkEOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 639/798] drm/amdgpu/gfx6: Use PFP on the compute queues too
Date: Sat, 12 Sep 2026 09:04:27 +0200
Message-ID: <20260912065531.765204547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df24fb8afe704..37592cc9f2c50 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2363,7 +2363,7 @@ static int gfx_v6_0_cp_resume(struct amdgpu_device *adev)
 
 static void gfx_v6_0_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 	uint32_t seq = ring->fence_drv.sync_seq;
 	uint64_t addr = ring->fence_drv.gpu_addr;
 
@@ -2381,7 +2381,7 @@ static void gfx_v6_0_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
 static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
 					unsigned vmid, uint64_t pd_addr)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 
 	amdgpu_gmc_emit_flush_gpu_tlb(ring, vmid, pd_addr);
 
@@ -2405,7 +2405,7 @@ static void gfx_v6_0_ring_emit_vm_flush(struct amdgpu_ring *ring,
 static void gfx_v6_0_ring_emit_wreg(struct amdgpu_ring *ring,
 				    uint32_t reg, uint32_t val)
 {
-	int usepfp = (ring->funcs->type == AMDGPU_RING_TYPE_GFX);
+	int usepfp = 1;
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(usepfp) |
@@ -3598,7 +3598,7 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_compute = {
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



