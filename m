Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00754142903;
	Mon, 16 Sep 2024 12:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488741; cv=none; b=JzUG2/1UReupN9IK9THLdPCkonGZn5mz3XJvmKqvCU33GnGXJk1O60T2ZS/CL/a52aReYiNiTITsNBRAyhRuUI4mPo5yA7jYS5aN/iVCbdoKDbJIlogQzetV/tiMCA+0zpzDgBZ3c1EBcvN5vrM4IIqfyLxKWCAg3cqALvpb9o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488741; c=relaxed/simple;
	bh=sCS/tDuK8kMCSF9284n951rYFqiJL3CUa+EU/wT5Dd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBhTyJTOekNVpp2YgFOOgndVZMGG6nJf6pLgxZ7hGhwyrIdPJvWVyP8X4PQWmoq1XetcjDbveG60lWm6ypVSqGpN5wirVKNP1psdKF/pzOVA5yTo6m95ICTm8eEPa8v1GNEVymNVSslrxw8ewx2ZLBvdcC1NZKG2dTp+PwSYvFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju5Hb0bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju5Hb0bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA70C4CEC4;
	Mon, 16 Sep 2024 12:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488740;
	bh=sCS/tDuK8kMCSF9284n951rYFqiJL3CUa+EU/wT5Dd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju5Hb0bfpBLUeNQk+8usEmnrgbh1uzHAllxpivNM9bTMscb6/5qAkzwNuSNWMkUOA
	 9Ks93sFVqOA3hKeGnCQ62gD0m+N0FKCFaRzBdS0jXqwbaE3T+7fH/VXQBCkQa34n8a
	 YwpyKO6s8GN1VhRLz0UMASD/zamMkjYIFTpt3VN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>
Subject: [PATCH 6.6 83/91] drm/amd/amdgpu: apply command submission parser for JPEG v1
Date: Mon, 16 Sep 2024 13:44:59 +0200
Message-ID: <20240916114227.189409750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit 8409fb50ce48d66cf9dc5391f03f05c56c430605 upstream.

Similar to jpeg_v2_dec_ring_parse_cs() but it has different
register ranges and a few other registers access.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3d5adbdf1d01708777f2eda375227cbf7a98b9fe)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c |   76 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h |   11 ++++
 2 files changed, 86 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
@@ -23,6 +23,7 @@
 
 #include "amdgpu.h"
 #include "amdgpu_jpeg.h"
+#include "amdgpu_cs.h"
 #include "soc15.h"
 #include "soc15d.h"
 #include "vcn_v1_0.h"
@@ -34,6 +35,9 @@
 static void jpeg_v1_0_set_dec_ring_funcs(struct amdgpu_device *adev);
 static void jpeg_v1_0_set_irq_funcs(struct amdgpu_device *adev);
 static void jpeg_v1_0_ring_begin_use(struct amdgpu_ring *ring);
+static int jpeg_v1_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+				     struct amdgpu_job *job,
+				     struct amdgpu_ib *ib);
 
 static void jpeg_v1_0_decode_ring_patch_wreg(struct amdgpu_ring *ring, uint32_t *ptr, uint32_t reg_offset, uint32_t val)
 {
@@ -300,7 +304,10 @@ static void jpeg_v1_0_decode_ring_emit_i
 
 	amdgpu_ring_write(ring,
 		PACKETJ(SOC15_REG_OFFSET(JPEG, 0, mmUVD_LMI_JRBC_IB_VMID), 0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	if (ring->funcs->parse_cs)
+		amdgpu_ring_write(ring, 0);
+	else
+		amdgpu_ring_write(ring, (vmid | (vmid << 4)));
 
 	amdgpu_ring_write(ring,
 		PACKETJ(SOC15_REG_OFFSET(JPEG, 0, mmUVD_LMI_JPEG_VMID), 0, 0, PACKETJ_TYPE0));
@@ -554,6 +561,7 @@ static const struct amdgpu_ring_funcs jp
 	.get_rptr = jpeg_v1_0_decode_ring_get_rptr,
 	.get_wptr = jpeg_v1_0_decode_ring_get_wptr,
 	.set_wptr = jpeg_v1_0_decode_ring_set_wptr,
+	.parse_cs = jpeg_v1_dec_ring_parse_cs,
 	.emit_frame_size =
 		6 + 6 + /* hdp invalidate / flush */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +
@@ -612,3 +620,69 @@ static void jpeg_v1_0_ring_begin_use(str
 
 	vcn_v1_0_set_pg_for_begin_use(ring, set_clocks);
 }
+
+/**
+ * jpeg_v1_dec_ring_parse_cs - command submission parser
+ *
+ * @parser: Command submission parser context
+ * @job: the job to parse
+ * @ib: the IB to parse
+ *
+ * Parse the command stream, return -EINVAL for invalid packet,
+ * 0 otherwise
+ */
+static int jpeg_v1_dec_ring_parse_cs(struct amdgpu_cs_parser *parser,
+				     struct amdgpu_job *job,
+				     struct amdgpu_ib *ib)
+{
+	u32 i, reg, res, cond, type;
+	int ret = 0;
+	struct amdgpu_device *adev = parser->adev;
+
+	for (i = 0; i < ib->length_dw ; i += 2) {
+		reg  = CP_PACKETJ_GET_REG(ib->ptr[i]);
+		res  = CP_PACKETJ_GET_RES(ib->ptr[i]);
+		cond = CP_PACKETJ_GET_COND(ib->ptr[i]);
+		type = CP_PACKETJ_GET_TYPE(ib->ptr[i]);
+
+		if (res || cond != PACKETJ_CONDITION_CHECK0) /* only allow 0 for now */
+			return -EINVAL;
+
+		if (reg >= JPEG_V1_REG_RANGE_START && reg <= JPEG_V1_REG_RANGE_END)
+			continue;
+
+		switch (type) {
+		case PACKETJ_TYPE0:
+			if (reg != JPEG_V1_LMI_JPEG_WRITE_64BIT_BAR_HIGH &&
+			    reg != JPEG_V1_LMI_JPEG_WRITE_64BIT_BAR_LOW &&
+			    reg != JPEG_V1_LMI_JPEG_READ_64BIT_BAR_HIGH &&
+			    reg != JPEG_V1_LMI_JPEG_READ_64BIT_BAR_LOW &&
+			    reg != JPEG_V1_REG_CTX_INDEX &&
+			    reg != JPEG_V1_REG_CTX_DATA) {
+				ret = -EINVAL;
+			}
+			break;
+		case PACKETJ_TYPE1:
+			if (reg != JPEG_V1_REG_CTX_DATA)
+				ret = -EINVAL;
+			break;
+		case PACKETJ_TYPE3:
+			if (reg != JPEG_V1_REG_SOFT_RESET)
+				ret = -EINVAL;
+			break;
+		case PACKETJ_TYPE6:
+			if (ib->ptr[i] != CP_PACKETJ_NOP)
+				ret = -EINVAL;
+			break;
+		default:
+			ret = -EINVAL;
+		}
+
+		if (ret) {
+			dev_err(adev->dev, "Invalid packet [0x%08x]!\n", ib->ptr[i]);
+			break;
+		}
+	}
+
+	return ret;
+}
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h
@@ -29,4 +29,15 @@ int jpeg_v1_0_sw_init(void *handle);
 void jpeg_v1_0_sw_fini(void *handle);
 void jpeg_v1_0_start(struct amdgpu_device *adev, int mode);
 
+#define JPEG_V1_REG_RANGE_START	0x8000
+#define JPEG_V1_REG_RANGE_END	0x803f
+
+#define JPEG_V1_LMI_JPEG_WRITE_64BIT_BAR_HIGH	0x8238
+#define JPEG_V1_LMI_JPEG_WRITE_64BIT_BAR_LOW	0x8239
+#define JPEG_V1_LMI_JPEG_READ_64BIT_BAR_HIGH	0x825a
+#define JPEG_V1_LMI_JPEG_READ_64BIT_BAR_LOW	0x825b
+#define JPEG_V1_REG_CTX_INDEX			0x8328
+#define JPEG_V1_REG_CTX_DATA			0x8329
+#define JPEG_V1_REG_SOFT_RESET			0x83a0
+
 #endif /*__JPEG_V1_0_H__*/


