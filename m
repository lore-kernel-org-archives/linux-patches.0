Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD54347BA5;
	Tue, 11 Nov 2025 01:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824332; cv=none; b=DuxFzN2T8prqbSMsW1x7AUyfyGR0hmD02F1x5G0r8xBab6y73SUm6ZtN9xFN7JpknMx6NRaLE1E1l8PCErpYbb1/AK3zRyFHjhMGj9AvW2SCQOSIvRQX+d+8ar72Xmp8l/tnAUiAJW+E2FzS7onNUQ1y0vYFU+Y+7Q4/RiTzbtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824332; c=relaxed/simple;
	bh=1er9HtlST1+oI1RuOh/abVTao1/Z6c3d3wDMdJlV3Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baR629gDBYwfX0b+teGih7tAkG8x7kztsZDf2tmybG+1utOOfXBDQYtE+fzkFMIYLMIjP/hSo38NlXZIfUEAYNC/blNMXMEjnMxLxj84537HJtoDwvhVUjoRTOCs15aVYEU6K2AMnXn/NtBVeh4uPN2eyiGPvdpciphdexRKfWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qy6XACK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qy6XACK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A3AC16AAE;
	Tue, 11 Nov 2025 01:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824332;
	bh=1er9HtlST1+oI1RuOh/abVTao1/Z6c3d3wDMdJlV3Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qy6XACK0Wks22pqQKWuQ+VVb1H9nsQqiueS4iouB+4rcKKWLA9rvWMgCDgvjDU65p
	 x1A9pSEUF0riMWIidFNJEj0JorZvfAX9Tfal35KxAElDv2UB4wOowRW5h+es9MVx5W
	 1H9+/XLJTg+L/CWMQ3iVqrHCWqR0QE0FDwX+tdew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 475/849] drm/msm/adreno: Add fenced regwrite support
Date: Tue, 11 Nov 2025 09:40:45 +0900
Message-ID: <20251111004547.929424542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit a27d774045566b587bfc1ae9fb122642b06677b8 ]

There are some special registers which are accessible even when GX power
domain is collapsed during an IFPC sleep. Accessing these registers
wakes up GPU from power collapse and allow programming these registers
without additional handshake with GMU. This patch adds support for this
special register write sequence.

Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/673368/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c     | 80 ++++++++++++++++++++++-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h     |  1 +
 drivers/gpu/drm/msm/adreno/a6xx_preempt.c | 20 +++---
 3 files changed, 90 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index f8992a68df7fb..536da1acf615e 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -16,6 +16,84 @@
 
 #define GPU_PAS_ID 13
 
+static bool fence_status_check(struct msm_gpu *gpu, u32 offset, u32 value, u32 status, u32 mask)
+{
+	/* Success if !writedropped0/1 */
+	if (!(status & mask))
+		return true;
+
+	udelay(10);
+
+	/* Try to update fenced register again */
+	gpu_write(gpu, offset, value);
+
+	/* We can't do a posted write here because the power domain could be
+	 * in collapse state. So use the heaviest barrier instead
+	 */
+	mb();
+	return false;
+}
+
+static int fenced_write(struct a6xx_gpu *a6xx_gpu, u32 offset, u32 value, u32 mask)
+{
+	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
+	struct msm_gpu *gpu = &adreno_gpu->base;
+	struct a6xx_gmu *gmu = &a6xx_gpu->gmu;
+	u32 status;
+
+	gpu_write(gpu, offset, value);
+
+	/* Nothing else to be done in the case of no-GMU */
+	if (adreno_has_gmu_wrapper(adreno_gpu))
+		return 0;
+
+	/* We can't do a posted write here because the power domain could be
+	 * in collapse state. So use the heaviest barrier instead
+	 */
+	mb();
+
+	if (!gmu_poll_timeout(gmu, REG_A6XX_GMU_AHB_FENCE_STATUS, status,
+			fence_status_check(gpu, offset, value, status, mask), 0, 1000))
+		return 0;
+
+	/* Try again for another 1ms before failing */
+	gpu_write(gpu, offset, value);
+	mb();
+
+	if (!gmu_poll_timeout(gmu, REG_A6XX_GMU_AHB_FENCE_STATUS, status,
+			fence_status_check(gpu, offset, value, status, mask), 0, 1000)) {
+		/*
+		 * The 'delay' warning is here because the pause to print this
+		 * warning will allow gpu to move to power collapse which
+		 * defeats the purpose of continuous polling for 2 ms
+		 */
+		dev_err_ratelimited(gmu->dev, "delay in fenced register write (0x%x)\n",
+				offset);
+		return 0;
+	}
+
+	dev_err_ratelimited(gmu->dev, "fenced register write (0x%x) fail\n",
+			offset);
+
+	return -ETIMEDOUT;
+}
+
+int a6xx_fenced_write(struct a6xx_gpu *a6xx_gpu, u32 offset, u64 value, u32 mask, bool is_64b)
+{
+	int ret;
+
+	ret = fenced_write(a6xx_gpu, offset, lower_32_bits(value), mask);
+	if (ret)
+		return ret;
+
+	if (!is_64b)
+		return 0;
+
+	ret = fenced_write(a6xx_gpu, offset + 1, upper_32_bits(value), mask);
+
+	return ret;
+}
+
 static inline bool _a6xx_check_idle(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
@@ -86,7 +164,7 @@ static void a6xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 	/* Update HW if this is the current ring and we are not in preempt*/
 	if (!a6xx_in_preempt(a6xx_gpu)) {
 		if (a6xx_gpu->cur_ring == ring)
-			gpu_write(gpu, REG_A6XX_CP_RB_WPTR, wptr);
+			a6xx_fenced_write(a6xx_gpu, REG_A6XX_CP_RB_WPTR, wptr, BIT(0), false);
 		else
 			ring->restore_wptr = true;
 	} else {
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
index 6e71f617fc3d0..e736c59d566b3 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -295,5 +295,6 @@ int a6xx_gpu_state_put(struct msm_gpu_state *state);
 
 void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu, bool gx_off);
 void a6xx_gpu_sw_reset(struct msm_gpu *gpu, bool assert);
+int a6xx_fenced_write(struct a6xx_gpu *gpu, u32 offset, u64 value, u32 mask, bool is_64b);
 
 #endif /* __A6XX_GPU_H__ */
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_preempt.c b/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
index 6a12a35dabff1..10625ffbc4cfc 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
@@ -41,7 +41,7 @@ static inline void set_preempt_state(struct a6xx_gpu *gpu,
 }
 
 /* Write the most recent wptr for the given ring into the hardware */
-static inline void update_wptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
+static inline void update_wptr(struct a6xx_gpu *a6xx_gpu, struct msm_ringbuffer *ring)
 {
 	unsigned long flags;
 	uint32_t wptr;
@@ -51,7 +51,7 @@ static inline void update_wptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 	if (ring->restore_wptr) {
 		wptr = get_wptr(ring);
 
-		gpu_write(gpu, REG_A6XX_CP_RB_WPTR, wptr);
+		a6xx_fenced_write(a6xx_gpu, REG_A6XX_CP_RB_WPTR, wptr, BIT(0), false);
 
 		ring->restore_wptr = false;
 	}
@@ -172,7 +172,7 @@ void a6xx_preempt_irq(struct msm_gpu *gpu)
 
 	set_preempt_state(a6xx_gpu, PREEMPT_FINISH);
 
-	update_wptr(gpu, a6xx_gpu->cur_ring);
+	update_wptr(a6xx_gpu, a6xx_gpu->cur_ring);
 
 	set_preempt_state(a6xx_gpu, PREEMPT_NONE);
 
@@ -268,7 +268,7 @@ void a6xx_preempt_trigger(struct msm_gpu *gpu)
 	 */
 	if (!ring || (a6xx_gpu->cur_ring == ring)) {
 		set_preempt_state(a6xx_gpu, PREEMPT_FINISH);
-		update_wptr(gpu, a6xx_gpu->cur_ring);
+		update_wptr(a6xx_gpu, a6xx_gpu->cur_ring);
 		set_preempt_state(a6xx_gpu, PREEMPT_NONE);
 		spin_unlock_irqrestore(&a6xx_gpu->eval_lock, flags);
 		return;
@@ -302,13 +302,13 @@ void a6xx_preempt_trigger(struct msm_gpu *gpu)
 
 	spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
-	gpu_write64(gpu,
-		REG_A6XX_CP_CONTEXT_SWITCH_SMMU_INFO,
-		a6xx_gpu->preempt_smmu_iova[ring->id]);
+	a6xx_fenced_write(a6xx_gpu,
+		REG_A6XX_CP_CONTEXT_SWITCH_SMMU_INFO, a6xx_gpu->preempt_smmu_iova[ring->id],
+		BIT(1), true);
 
-	gpu_write64(gpu,
+	a6xx_fenced_write(a6xx_gpu,
 		REG_A6XX_CP_CONTEXT_SWITCH_PRIV_NON_SECURE_RESTORE_ADDR,
-		a6xx_gpu->preempt_iova[ring->id]);
+		a6xx_gpu->preempt_iova[ring->id], BIT(1), true);
 
 	a6xx_gpu->next_ring = ring;
 
@@ -328,7 +328,7 @@ void a6xx_preempt_trigger(struct msm_gpu *gpu)
 	set_preempt_state(a6xx_gpu, PREEMPT_TRIGGERED);
 
 	/* Trigger the preemption */
-	gpu_write(gpu, REG_A6XX_CP_CONTEXT_SWITCH_CNTL, cntl);
+	a6xx_fenced_write(a6xx_gpu, REG_A6XX_CP_CONTEXT_SWITCH_CNTL, cntl, BIT(1), false);
 }
 
 static int preempt_init_ring(struct a6xx_gpu *a6xx_gpu,
-- 
2.51.0



