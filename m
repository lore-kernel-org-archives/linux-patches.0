Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D9157E6A;
	Mon, 29 Jan 2024 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548294; cv=none; b=pc4oaRzv3cjrLVgUl33HJkr72O9MDaUZVOkudIVsoeqFXpCA/upNEYJkRHV6ds1oLF7U9ydbQpyJ7BxZQY+g+mcaHZTx1+zO/hIlSlnHDNALZertLjLa5wueN6LrzNeb+DOe0QRSEADI2G1xaHa2bd4+M/E8INfey51JTmzwiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548294; c=relaxed/simple;
	bh=jDCUVccF1iV0M7lBuUHA6loaBrn6Qjekmqj8+Ab7J9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ap5v8v8UUsEFkrkVQ+bozSPBpzYTYfLpRFVkoDhd3AInzRwtfxO+TcD9SbeXGTwBiRqoWtiqi5TXR3yhsBpJmw/BWydz/0spC0y6TjPJuLb90Cb1DfhnpSzdIlEu8lqMpAGexAoFlIojYV4m9kqk6jLO/1yh1bPl6a417QDU++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmTV1kNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmTV1kNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F516C43390;
	Mon, 29 Jan 2024 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548294;
	bh=jDCUVccF1iV0M7lBuUHA6loaBrn6Qjekmqj8+Ab7J9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmTV1kNjunQoWto7utt+Ua0f66blCG0hepH+BjivWc+OeMSN+kmc+/ShOPpeRFr7I
	 JgdizTu1qq2q/+Q5rdqdfo300pCwH88WV/hpWPSp+FemKDjNM0zj33JQCcq4QgMsrR
	 r2hI1zcdN/comaidf9yn+ZF/tPmLrynrWenrBGNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 303/346] drm/amdgpu: Enable tunneling on high-priority compute queues
Date: Mon, 29 Jan 2024 09:05:34 -0800
Message-ID: <20240129170025.354073776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Friedrich Vock <friedrich.vock@gmx.de>

[ Upstream commit 91963397c49aa2907aeafa52d929555dcbc9cd07 ]

This improves latency if the GPU is already busy with other work.
This is useful for VR compositors that submit highly latency-sensitive
compositing work on high-priority compute queues while the GPU is busy
rendering the next frame.

Userspace merge request:
https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/26462

v2: bump driver version (Alex)

Reviewed-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 03ff6d7238b7 ("drm/amdgpu/gfx10: set UNORD_DISPATCH in compute MQDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h      |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c  |  3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 10 ++++++----
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c   |  3 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c   |  3 ++-
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 9d92ca157677..50f57d4dfd8f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -757,6 +757,7 @@ struct amdgpu_mqd_prop {
 	uint64_t eop_gpu_addr;
 	uint32_t hqd_pipe_priority;
 	uint32_t hqd_queue_priority;
+	bool allow_tunneling;
 	bool hqd_active;
 };
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index c0e8e030b96f..a7ad77ed09ca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -115,9 +115,10 @@
  *   3.54.0 - Add AMDGPU_CTX_QUERY2_FLAGS_RESET_IN_PROGRESS support
  * - 3.55.0 - Add AMDGPU_INFO_GPUVM_FAULT query
  * - 3.56.0 - Update IB start address and size alignment for decode and encode
+ * - 3.57.0 - Compute tunneling on GFX10+
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	56
+#define KMS_DRIVER_MINOR	57
 #define KMS_DRIVER_PATCHLEVEL	0
 
 /*
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 6a80d3ec887e..45424ebf9681 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -642,6 +642,10 @@ static void amdgpu_ring_to_mqd_prop(struct amdgpu_ring *ring,
 				    struct amdgpu_mqd_prop *prop)
 {
 	struct amdgpu_device *adev = ring->adev;
+	bool is_high_prio_compute = ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE &&
+				    amdgpu_gfx_is_high_priority_compute_queue(adev, ring);
+	bool is_high_prio_gfx = ring->funcs->type == AMDGPU_RING_TYPE_GFX &&
+				amdgpu_gfx_is_high_priority_graphics_queue(adev, ring);
 
 	memset(prop, 0, sizeof(*prop));
 
@@ -659,10 +663,8 @@ static void amdgpu_ring_to_mqd_prop(struct amdgpu_ring *ring,
 	 */
 	prop->hqd_active = ring->funcs->type == AMDGPU_RING_TYPE_KIQ;
 
-	if ((ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE &&
-	     amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) ||
-	    (ring->funcs->type == AMDGPU_RING_TYPE_GFX &&
-	     amdgpu_gfx_is_high_priority_graphics_queue(adev, ring))) {
+	prop->allow_tunneling = is_high_prio_compute;
+	if (is_high_prio_compute || is_high_prio_gfx) {
 		prop->hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
 		prop->hqd_queue_priority = AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 67c198ea8211..d63cab294883 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6590,7 +6590,8 @@ static int gfx_v10_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, ENDIAN_SWAP, 1);
 #endif
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 0);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH, 0);
+	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH,
+			    prop->allow_tunneling);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
 	mqd->cp_hqd_pq_control = tmp;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index cddf3737e8a3..4824a4c04d35 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3839,7 +3839,8 @@ static int gfx_v11_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, RPTR_BLOCK_SIZE,
 			    (order_base_2(AMDGPU_GPU_PAGE_SIZE / 4) - 1));
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 0);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH, 0);
+	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH,
+			    prop->allow_tunneling);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
 	mqd->cp_hqd_pq_control = tmp;
-- 
2.43.0



