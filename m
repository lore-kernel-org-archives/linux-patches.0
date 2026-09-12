Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3030A2882AB;
	Sat, 12 Sep 2026 16:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230976; cv=none; b=TbraEVadgskzSQnGXBxoQBKg1eHeo0DH6RH/snvQ0Aw7/fMu/YwJAaqNAIixn13PGbJp/QHklZG5SbERwduqCvL/5Eci+wK1LlOwiki2DHIdHYIbUB8ZVEFpfed139Xrrow+9DUQBWNL3aUlklNbIAe5gYc6hDOtTe1M6EQkXWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230976; c=relaxed/simple;
	bh=fctLlq3g5WpTXrD3bC6afkFt0DtznoXAXkPkmVfTpL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjJJxhDmz+BacNep5eX28EaOBHBFVaauC1u3qFz6DJN6LLwc9bi51naMZyeoP/pFYuaxizQQaks6R6WDHIlyDPi15iw/AxykVkGMisWJC37ym5PAu/EIMtrtEO02hf0ljWkjS478mmtZSIzANSOJO/r2NKTNPHlJPCHOkrjYNcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEDdG/Ei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEDdG/Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D731F000FF;
	Sat, 12 Sep 2026 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230975;
	bh=qHblu+dqumlOYbGTphVG7K+IXxLR4L2M2BikwBn3DkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEDdG/EiTaJ/3CN4/wsiFrjnvmNbsU+4G7jFOgoAAijCVHobv+zX/TJ1hD9+KnNkI
	 6Z2M9xblNx5NwuiQoaek+JglbusXF+BSjhyjBfVlwrpZs8CGcav3mGhcc6quyPmhN5
	 3P8p/TdG3ECphKoKUDH+x1IDTX4wF82BO1dLDE2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0903/1191] drm/amdgpu/gfx6: Fixup emit_cntxcntl()
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065608.517980000@linuxfoundation.org>
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

[ Upstream commit 1edb323406aaf05739804d2faa2561f2d43bcd09 ]

Set bits on dword 2 like GFX7-8 except load_global_uconfig
which doesn't exist on GFX6.

Emit VS_PARTIAL_FLUSH before VGT_FLUSH like GFX7-8.

For reference see old PAL which explains the bit fields in
this register and that load_global_uconfig doesn't exist on GFX6
and also see gfx_v7_ring_emit_cntxcntl() for the GFX7 code
which this commit follows.

Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 28 ++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 09cf6604e3d2c..df27323abde5b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -1874,11 +1874,13 @@ static int gfx_v6_0_ring_test_ring(struct amdgpu_ring *ring)
 	return r;
 }
 
-static void gfx_v6_0_ring_emit_vgt_flush(struct amdgpu_ring *ring)
+static void gfx_v6_0_ring_emit_event_write(struct amdgpu_ring *ring,
+					   uint32_t event_type,
+					   uint32_t event_index)
 {
 	amdgpu_ring_write(ring, PACKET3(PACKET3_EVENT_WRITE, 0));
-	amdgpu_ring_write(ring, EVENT_TYPE(VGT_FLUSH) |
-		EVENT_INDEX(0));
+	amdgpu_ring_write(ring, EVENT_TYPE(event_type) |
+				EVENT_INDEX(event_index));
 }
 
 static void gfx_v6_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr,
@@ -3014,10 +3016,22 @@ static uint64_t gfx_v6_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 
 static void gfx_v6_ring_emit_cntxcntl(struct amdgpu_ring *ring, uint32_t flags)
 {
-	if (flags & AMDGPU_HAVE_CTX_SWITCH)
-		gfx_v6_0_ring_emit_vgt_flush(ring);
+	u32 dw2 = 0x80000000; /* set load_enable otherwise this package is just NOPs */
+
+	if (flags & AMDGPU_HAVE_CTX_SWITCH) {
+		gfx_v6_0_ring_emit_event_write(ring, VS_PARTIAL_FLUSH, 4);
+		gfx_v6_0_ring_emit_event_write(ring, VGT_FLUSH, 0);
+
+		/* set load_global_config (load_global_uconfig doesn't exist on GFX6) */
+		dw2 |= 0x1;
+		/* set load_cs_sh_regs */
+		dw2 |= 0x01000000;
+		/* set load_per_context_state & load_gfx_sh_regs */
+		dw2 |= 0x10002;
+	}
+
 	amdgpu_ring_write(ring, PACKET3(PACKET3_CONTEXT_CONTROL, 1));
-	amdgpu_ring_write(ring, 0x80000000);
+	amdgpu_ring_write(ring, dw2);
 	amdgpu_ring_write(ring, 0);
 }
 
@@ -3550,7 +3564,7 @@ static const struct amdgpu_ring_funcs gfx_v6_0_ring_funcs_gfx = {
 		14 + 14 + 14 + /* gfx_v6_0_ring_emit_fence x3 for user fence, vm fence */
 		7 + 4 + /* gfx_v6_0_ring_emit_pipeline_sync */
 		SI_FLUSH_GPU_TLB_NUM_WREG * 5 + 7 + 6 + /* gfx_v6_0_ring_emit_vm_flush */
-		3 + 2 + /* gfx_v6_ring_emit_cntxcntl including vgt flush */
+		3 + 2 + 2 + /* gfx_v6_ring_emit_cntxcntl including VGT flush */
 		5, /* SURFACE_SYNC */
 	.emit_ib_size = 6, /* gfx_v6_0_ring_emit_ib */
 	.emit_ib = gfx_v6_0_ring_emit_ib,
-- 
2.53.0



