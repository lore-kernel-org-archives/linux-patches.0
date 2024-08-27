Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFFE12B93;
	Tue, 27 Aug 2024 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771059; cv=none; b=IM4PBMXPho7nGU4QL5/J2fLsAehjVNVs74DhV256CjP1BXFGM0uQHGLKBu5gAAzkN6XHI6DCWSOHBsXocBXyhT1v6nZjvzD8+H+PuwmS2CJaG58jCgfvgr72Tfy24UmnxVeih95y6bIctZWkeez+RbG1N8RRtHzeoXBw2ELnzLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771059; c=relaxed/simple;
	bh=ZcLYtZ7y0ka4NOd2eJfYgYJhZsIOu8xrOERxVx7swDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klo8psOVfJ0Y9bBbEx8lB9GyzjdKZCtPpQceKHcSQ5ZsLvPV2aeedHkiiKTKwo8VqFIJbrzCJ+jKdKI8r9dI5Oj2Ge+YfN0IEZeNLp7uUT645VbXp5uC8HqZx4tNbHZvmSoqDmfqkS6SEl5ETuqiWCgo7xoC++mcyIA4Nt69msk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coAEMKBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coAEMKBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F50FC61055;
	Tue, 27 Aug 2024 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771058;
	bh=ZcLYtZ7y0ka4NOd2eJfYgYJhZsIOu8xrOERxVx7swDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coAEMKBNzFIn0Swxn7CD6pwrw1syPgrcQw18Ij0P1epzHXkIwLkIcj8zzuKccpDaT
	 /EvbOe/o4LWokG+PGCBg+BeOQWaOS7gK+w0t4FtKlz4LmvG1omcCQq1iVtU5xaoNqF
	 iIYofvkCQPloE+rdAd7I7kWgs5zGJhbHtzYdAJjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>
Subject: [PATCH 6.10 075/273] drm/amd/amdgpu: command submission parser for JPEG
Date: Tue, 27 Aug 2024 16:36:39 +0200
Message-ID: <20240827143836.269267067@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit 470516c2925493594a690bc4d05b1f4471d9f996 upstream.

Add JPEG IB command parser to ensure registers
in the command are within the JPEG IP block.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a7f670d5d8e77b092404ca8a35bb0f8f89ed3117)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c   |    3 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |   61 ++++++++++++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h |    7 +++
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c |    1 
 drivers/gpu/drm/amd/amdgpu/soc15d.h      |    6 +++
 5 files changed, 76 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1057,6 +1057,9 @@ static int amdgpu_cs_patch_ibs(struct am
 			r = amdgpu_ring_parse_cs(ring, p, job, ib);
 			if (r)
 				return r;
+
+			if (ib->sa_bo)
+				ib->gpu_addr =  amdgpu_sa_bo_gpu_addr(ib->sa_bo);
 		} else {
 			ib->ptr = (uint32_t *)kptr;
 			r = amdgpu_ring_patch_cs_in_place(ring, p, job, ib);
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -23,6 +23,7 @@
 
 #include "amdgpu.h"
 #include "amdgpu_jpeg.h"
+#include "amdgpu_cs.h"
 #include "soc15.h"
 #include "soc15d.h"
 #include "jpeg_v4_0_3.h"
@@ -773,7 +774,11 @@ void jpeg_v4_0_3_dec_ring_emit_ib(struct
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
+
+	if (ring->funcs->parse_cs)
+		amdgpu_ring_write(ring, 0);
+	else
+		amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
@@ -1063,6 +1068,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
+	.parse_cs = jpeg_v4_0_3_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
@@ -1227,3 +1233,56 @@ static void jpeg_v4_0_3_set_ras_funcs(st
 {
 	adev->jpeg.ras = &jpeg_v4_0_3_ras;
 }
+
+/**
+ * jpeg_v4_0_3_dec_ring_parse_cs - command submission parser
+ *
+ * @parser: Command submission parser context
+ * @job: the job to parse
+ * @ib: the IB to parse
+ *
+ * Parse the command stream, return -EINVAL for invalid packet,
+ * 0 otherwise
+ */
+int jpeg_v4_0_3_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+			     struct amdgpu_job *job,
+			     struct amdgpu_ib *ib)
+{
+	uint32_t i, reg, res, cond, type;
+	struct amdgpu_device *adev = parser->adev;
+
+	for (i = 0; i < ib->length_dw ; i += 2) {
+		reg  = CP_PACKETJ_GET_REG(ib->ptr[i]);
+		res  = CP_PACKETJ_GET_RES(ib->ptr[i]);
+		cond = CP_PACKETJ_GET_COND(ib->ptr[i]);
+		type = CP_PACKETJ_GET_TYPE(ib->ptr[i]);
+
+		if (res) /* only support 0 at the moment */
+			return -EINVAL;
+
+		switch (type) {
+		case PACKETJ_TYPE0:
+			if (cond != PACKETJ_CONDITION_CHECK0 || reg < JPEG_REG_RANGE_START || reg > JPEG_REG_RANGE_END) {
+				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+				return -EINVAL;
+			}
+			break;
+		case PACKETJ_TYPE3:
+			if (cond != PACKETJ_CONDITION_CHECK3 || reg < JPEG_REG_RANGE_START || reg > JPEG_REG_RANGE_END) {
+				dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+				return -EINVAL;
+			}
+			break;
+		case PACKETJ_TYPE6:
+			if (ib->ptr[i] == CP_PACKETJ_NOP)
+				continue;
+			dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+			return -EINVAL;
+		default:
+			dev_err(adev->dev, "Unknown packet type %d !\n", type);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
@@ -46,6 +46,9 @@
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 
+#define JPEG_REG_RANGE_START						0x4000
+#define JPEG_REG_RANGE_END						0x41c2
+
 extern const struct amdgpu_ip_block_version jpeg_v4_0_3_ip_block;
 
 void jpeg_v4_0_3_dec_ring_emit_ib(struct amdgpu_ring *ring,
@@ -62,5 +65,7 @@ void jpeg_v4_0_3_dec_ring_insert_end(str
 void jpeg_v4_0_3_dec_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg, uint32_t val);
 void jpeg_v4_0_3_dec_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t reg,
 					uint32_t val, uint32_t mask);
-
+int jpeg_v4_0_3_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+				  struct amdgpu_job *job,
+				  struct amdgpu_ib *ib);
 #endif /* __JPEG_V4_0_3_H__ */
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -523,6 +523,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v5_0_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_0_dec_ring_set_wptr,
+	.parse_cs = jpeg_v4_0_3_dec_ring_parse_cs,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 8 +
--- a/drivers/gpu/drm/amd/amdgpu/soc15d.h
+++ b/drivers/gpu/drm/amd/amdgpu/soc15d.h
@@ -76,6 +76,12 @@
 			 ((cond & 0xF) << 24) |				\
 			 ((type & 0xF) << 28))
 
+#define CP_PACKETJ_NOP		0x60000000
+#define CP_PACKETJ_GET_REG(x)  ((x) & 0x3FFFF)
+#define CP_PACKETJ_GET_RES(x)  (((x) >> 18) & 0x3F)
+#define CP_PACKETJ_GET_COND(x) (((x) >> 24) & 0xF)
+#define CP_PACKETJ_GET_TYPE(x) (((x) >> 28) & 0xF)
+
 /* Packet 3 types */
 #define	PACKET3_NOP					0x10
 #define	PACKET3_SET_BASE				0x11


