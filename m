Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D792AF07;
	Mon, 28 Oct 2024 06:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098101; cv=none; b=OCvrNGqfCWS64DDLerVXuIWjAcoum3oNbuX2Q0le7ZcPldTMYkDRKZY4Xo6LUOV58bZSTuLUJVGXl1VOxcFN5N6e24+QINfYN3igYclAonUcBmsu/brwoSM3Zv27NW0xpm1+KiNSkcF9yF2MSmhfnlrD9PrDZKbqQaD3Kv0ErNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098101; c=relaxed/simple;
	bh=YkXVeWMHCeIHIqIfoXclAzodVsZw6nQ7kJdhZmL8Vvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ0eZQrO+1ihUYQ5G+qlsHjGSuegv4ilxLV/PDs7pi3gC43LDzDK7eogII38kN+x5A+VMobiNr4HktvbOphpbdsv1TOan1hZIUW+5iHHJAuwa6NWK9ReASUJRwi4467QXGWKn9AZWmJY2odSWFh7CF0MsOJogZPOIwshUUvTGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+4GJ90p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+4GJ90p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBEEC4CEE8;
	Mon, 28 Oct 2024 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098101;
	bh=YkXVeWMHCeIHIqIfoXclAzodVsZw6nQ7kJdhZmL8Vvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+4GJ90p4tqv18VVIg9PnZkBao8tTYOwxVbhl+JJCrQaPpgLjXIVXyeMKk5GinLTX
	 /QQ7v2UbMEMZHBPwUtRRF2j0yKsBfcx8jYpMUvINqaCg73zFc5OklP2ucvn/4Kgn2n
	 mWUSTDXIGH5jpWa0x6/4ha0ib5dwfxl3DwR8+BJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/261] drm/msm/a6xx+: Insert a fence wait before SMMU table update
Date: Mon, 28 Oct 2024 07:23:39 +0100
Message-ID: <20241028062313.958456272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 77ad507dbb7ec1ecd60fc081d03616960ef596fd ]

The CP_SMMU_TABLE_UPDATE _should_ be waiting for idle, but on some
devices (x1-85, possibly others), it seems to pass that barrier while
there are still things in the event completion FIFO waiting to be
written back to memory.

Work around that by adding a fence wait before context switch.  The
CP_EVENT_WRITE that writes the fence is the last write from a submit,
so seeing this value hit memory is a reliable indication that it is
safe to proceed with the context switch.

v2: Only emit CP_WAIT_TIMESTAMP on a7xx, as it is not supported on a6xx.
    Conversely, I've not been able to reproduce this issue on a6xx, so
    hopefully it is limited to a7xx, or perhaps just certain a7xx
    devices.

Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/63
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index bcaec86ac67a5..89b379060596d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -101,9 +101,10 @@ static void get_stats_counter(struct msm_ringbuffer *ring, u32 counter,
 }
 
 static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
-		struct msm_ringbuffer *ring, struct msm_file_private *ctx)
+		struct msm_ringbuffer *ring, struct msm_gem_submit *submit)
 {
 	bool sysprof = refcount_read(&a6xx_gpu->base.base.sysprof_active) > 1;
+	struct msm_file_private *ctx = submit->queue->ctx;
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	phys_addr_t ttbr;
 	u32 asid;
@@ -115,6 +116,15 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 	if (msm_iommu_pagetable_params(ctx->aspace->mmu, &ttbr, &asid))
 		return;
 
+	if (adreno_gpu->info->family >= ADRENO_7XX_GEN1) {
+		/* Wait for previous submit to complete before continuing: */
+		OUT_PKT7(ring, CP_WAIT_TIMESTAMP, 4);
+		OUT_RING(ring, 0);
+		OUT_RING(ring, lower_32_bits(rbmemptr(ring, fence)));
+		OUT_RING(ring, upper_32_bits(rbmemptr(ring, fence)));
+		OUT_RING(ring, submit->seqno - 1);
+	}
+
 	if (!sysprof) {
 		if (!adreno_is_a7xx(adreno_gpu)) {
 			/* Turn off protected mode to write to special registers */
@@ -193,7 +203,7 @@ static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned int i, ibs = 0;
 
-	a6xx_set_pagetable(a6xx_gpu, ring, submit->queue->ctx);
+	a6xx_set_pagetable(a6xx_gpu, ring, submit);
 
 	get_stats_counter(ring, REG_A6XX_RBBM_PERFCTR_CP(0),
 		rbmemptr_stats(ring, index, cpcycles_start));
@@ -283,7 +293,7 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
 	OUT_RING(ring, CP_THREAD_CONTROL_0_SYNC_THREADS | CP_SET_THREAD_BR);
 
-	a6xx_set_pagetable(a6xx_gpu, ring, submit->queue->ctx);
+	a6xx_set_pagetable(a6xx_gpu, ring, submit);
 
 	get_stats_counter(ring, REG_A7XX_RBBM_PERFCTR_CP(0),
 		rbmemptr_stats(ring, index, cpcycles_start));
-- 
2.43.0



