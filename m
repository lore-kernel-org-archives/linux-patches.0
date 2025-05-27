Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166EA1DB34C;
	Tue, 27 May 2025 17:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366911; cv=none; b=sE6uGYO14FvgdsHOuo6XUy5cqj05ldidL3E1Ookyq8uwFUe7MHS/xjRs7JVZZAtLAC9XGzl8te1MKwdCfCHs4yE8j8cJ7C0EBwYVAtYU7S6Y0pDcd4TgPBvNojw/LYks2M////JMXD8aC09E2QFcTKiriXOE23ZIanEOccT7Sm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366911; c=relaxed/simple;
	bh=Lo0RTjbnOG50vLshtFakD0/Qp+ZS1t8RTX0cz/oaYPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8cEaUo5IzsH8x9/JZqpCY6iFhJGVJNOitu9gOK1mPyHj3Hl+J919aLAaxdXDdD0ksjIa1LkXAjlpcu0e+uU5wSsXyjYPNpfACEPeam3TxAz54VKVLtrmXx62QSR9iZKQZZpwo+fb1mhlPWimmvtfxDcWhn3GflwKqPMl3J18XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUH6tCmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUH6tCmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72003C4CEE9;
	Tue, 27 May 2025 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366910;
	bh=Lo0RTjbnOG50vLshtFakD0/Qp+ZS1t8RTX0cz/oaYPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUH6tCmC20TKzr/zQr/ENLecpJD5Nz1A1GOXzk0lYHUYNo7ECX/hNKA5fZ9rN27sc
	 fT//ay6cETyxnuuP4R4JBB0CgFCsp6Qp/TJNiZPVAPT0iy4Atzivxsa52JxQ9F3tyB
	 k86ebfJkQiN8qIjZvtXE6e+phevoOFHjnti9BXTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 186/783] drm/amdgpu/gfx12: dont read registers in mqd init
Date: Tue, 27 May 2025 18:19:43 +0200
Message-ID: <20250527162520.724551995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fc3c139cf0432b79fd08e23100a559ee51cd0be4 ]

Just use the default values.  There's not need to
get the value from hardware and it could cause problems
if we do that at runtime and gfxoff is active.

Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 48 ++++++++++++++++++--------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 0c08785099f32..2ec900d50d7f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -52,6 +52,24 @@
 
 #define RLCG_UCODE_LOADING_START_ADDRESS	0x00002000L
 
+#define regCP_GFX_MQD_CONTROL_DEFAULT                                             0x00000100
+#define regCP_GFX_HQD_VMID_DEFAULT                                                0x00000000
+#define regCP_GFX_HQD_QUEUE_PRIORITY_DEFAULT                                      0x00000000
+#define regCP_GFX_HQD_QUANTUM_DEFAULT                                             0x00000a01
+#define regCP_GFX_HQD_CNTL_DEFAULT                                                0x00f00000
+#define regCP_RB_DOORBELL_CONTROL_DEFAULT                                         0x00000000
+#define regCP_GFX_HQD_RPTR_DEFAULT                                                0x00000000
+
+#define regCP_HQD_EOP_CONTROL_DEFAULT                                             0x00000006
+#define regCP_HQD_PQ_DOORBELL_CONTROL_DEFAULT                                     0x00000000
+#define regCP_MQD_CONTROL_DEFAULT                                                 0x00000100
+#define regCP_HQD_PQ_CONTROL_DEFAULT                                              0x00308509
+#define regCP_HQD_PQ_DOORBELL_CONTROL_DEFAULT                                     0x00000000
+#define regCP_HQD_PQ_RPTR_DEFAULT                                                 0x00000000
+#define regCP_HQD_PERSISTENT_STATE_DEFAULT                                        0x0be05501
+#define regCP_HQD_IB_CONTROL_DEFAULT                                              0x00300000
+
+
 MODULE_FIRMWARE("amdgpu/gc_12_0_0_pfp.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_0_me.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_0_mec.bin");
@@ -2891,25 +2909,25 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_mqd_base_addr_hi = upper_32_bits(prop->mqd_gpu_addr);
 
 	/* set up mqd control */
-	tmp = RREG32_SOC15(GC, 0, regCP_GFX_MQD_CONTROL);
+	tmp = regCP_GFX_MQD_CONTROL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_MQD_CONTROL, VMID, 0);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_MQD_CONTROL, PRIV_STATE, 1);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_MQD_CONTROL, CACHE_POLICY, 0);
 	mqd->cp_gfx_mqd_control = tmp;
 
 	/* set up gfx_hqd_vimd with 0x0 to indicate the ring buffer's vmid */
-	tmp = RREG32_SOC15(GC, 0, regCP_GFX_HQD_VMID);
+	tmp = regCP_GFX_HQD_VMID_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_VMID, VMID, 0);
 	mqd->cp_gfx_hqd_vmid = 0;
 
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority */
-	tmp = RREG32_SOC15(GC, 0, regCP_GFX_HQD_QUEUE_PRIORITY);
+	tmp = regCP_GFX_HQD_QUEUE_PRIORITY_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_QUEUE_PRIORITY, PRIORITY_LEVEL, 0);
 	mqd->cp_gfx_hqd_queue_priority = tmp;
 
 	/* set up time quantum */
-	tmp = RREG32_SOC15(GC, 0, regCP_GFX_HQD_QUANTUM);
+	tmp = regCP_GFX_HQD_QUANTUM_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_QUANTUM, QUANTUM_EN, 1);
 	mqd->cp_gfx_hqd_quantum = tmp;
 
@@ -2931,7 +2949,7 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 
 	/* set up the gfx_hqd_control, similar as CP_RB0_CNTL */
 	rb_bufsz = order_base_2(prop->queue_size / 4) - 1;
-	tmp = RREG32_SOC15(GC, 0, regCP_GFX_HQD_CNTL);
+	tmp = regCP_GFX_HQD_CNTL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BLKSZ, rb_bufsz - 2);
 #ifdef __BIG_ENDIAN
@@ -2940,7 +2958,7 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_gfx_hqd_cntl = tmp;
 
 	/* set up cp_doorbell_control */
-	tmp = RREG32_SOC15(GC, 0, regCP_RB_DOORBELL_CONTROL);
+	tmp = regCP_RB_DOORBELL_CONTROL_DEFAULT;
 	if (prop->use_doorbell) {
 		tmp = REG_SET_FIELD(tmp, CP_RB_DOORBELL_CONTROL,
 				    DOORBELL_OFFSET, prop->doorbell_index);
@@ -2952,7 +2970,7 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_rb_doorbell_control = tmp;
 
 	/* reset read and write pointers, similar to CP_RB0_WPTR/_RPTR */
-	mqd->cp_gfx_hqd_rptr = RREG32_SOC15(GC, 0, regCP_GFX_HQD_RPTR);
+	mqd->cp_gfx_hqd_rptr = regCP_GFX_HQD_RPTR_DEFAULT;
 
 	/* active the queue */
 	mqd->cp_gfx_hqd_active = 1;
@@ -3047,14 +3065,14 @@ static int gfx_v12_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_hqd_eop_base_addr_hi = upper_32_bits(eop_base_addr);
 
 	/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
-	tmp = RREG32_SOC15(GC, 0, regCP_HQD_EOP_CONTROL);
+	tmp = regCP_HQD_EOP_CONTROL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_HQD_EOP_CONTROL, EOP_SIZE,
 			(order_base_2(GFX12_MEC_HPD_SIZE / 4) - 1));
 
 	mqd->cp_hqd_eop_control = tmp;
 
 	/* enable doorbell? */
-	tmp = RREG32_SOC15(GC, 0, regCP_HQD_PQ_DOORBELL_CONTROL);
+	tmp = regCP_HQD_PQ_DOORBELL_CONTROL_DEFAULT;
 
 	if (prop->use_doorbell) {
 		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_DOORBELL_CONTROL,
@@ -3083,7 +3101,7 @@ static int gfx_v12_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_mqd_base_addr_hi = upper_32_bits(prop->mqd_gpu_addr);
 
 	/* set MQD vmid to 0 */
-	tmp = RREG32_SOC15(GC, 0, regCP_MQD_CONTROL);
+	tmp = regCP_MQD_CONTROL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_MQD_CONTROL, VMID, 0);
 	mqd->cp_mqd_control = tmp;
 
@@ -3093,7 +3111,7 @@ static int gfx_v12_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_hqd_pq_base_hi = upper_32_bits(hqd_gpu_addr);
 
 	/* set up the HQD, this is similar to CP_RB0_CNTL */
-	tmp = RREG32_SOC15(GC, 0, regCP_HQD_PQ_CONTROL);
+	tmp = regCP_HQD_PQ_CONTROL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, QUEUE_SIZE,
 			    (order_base_2(prop->queue_size / 4) - 1));
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, RPTR_BLOCK_SIZE,
@@ -3118,7 +3136,7 @@ static int gfx_v12_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = 0;
 	/* enable the doorbell if requested */
 	if (prop->use_doorbell) {
-		tmp = RREG32_SOC15(GC, 0, regCP_HQD_PQ_DOORBELL_CONTROL);
+		tmp = regCP_HQD_PQ_DOORBELL_CONTROL_DEFAULT;
 		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_DOORBELL_CONTROL,
 				DOORBELL_OFFSET, prop->doorbell_index);
 
@@ -3133,17 +3151,17 @@ static int gfx_v12_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	mqd->cp_hqd_pq_doorbell_control = tmp;
 
 	/* reset read and write pointers, similar to CP_RB0_WPTR/_RPTR */
-	mqd->cp_hqd_pq_rptr = RREG32_SOC15(GC, 0, regCP_HQD_PQ_RPTR);
+	mqd->cp_hqd_pq_rptr = regCP_HQD_PQ_RPTR_DEFAULT;
 
 	/* set the vmid for the queue */
 	mqd->cp_hqd_vmid = 0;
 
-	tmp = RREG32_SOC15(GC, 0, regCP_HQD_PERSISTENT_STATE);
+	tmp = regCP_HQD_PERSISTENT_STATE_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PERSISTENT_STATE, PRELOAD_SIZE, 0x55);
 	mqd->cp_hqd_persistent_state = tmp;
 
 	/* set MIN_IB_AVAIL_SIZE */
-	tmp = RREG32_SOC15(GC, 0, regCP_HQD_IB_CONTROL);
+	tmp = regCP_HQD_IB_CONTROL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_HQD_IB_CONTROL, MIN_IB_AVAIL_SIZE, 3);
 	mqd->cp_hqd_ib_control = tmp;
 
-- 
2.39.5



