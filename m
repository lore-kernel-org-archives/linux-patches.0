Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BDB13B79F;
	Mon, 16 Sep 2024 12:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488416; cv=none; b=GD4xIKsQOwHCfBbW/duR6Bb3ACZYqCQ3zPEWRx1+AQdaKOg3Z1okmYGhX9MMGxtQHRTB3VX+aUr0lUiQBgyE4u1Dnty8Ph5zyQ1s+tCGEUSOOeg0H/MbHIsQDo6SOMLKGImbMPLnltt4QqPeag2o1dUW6W/lh4AFjbM4z+qeIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488416; c=relaxed/simple;
	bh=/FpLk9csAFh4tfrieAUD5T4xXtYYSgMwJaUPbjOuXI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBJrqfQUwSrbHFcT7OSNq8Zq79U5kfkr9gKn9VWovWPRJkLMFe3Zgv9bL/rLSmMC8UFMeC3SNUY+VYPj0LCxDlSs9ZE1+3QECxFo3VHlCi6efgx1IdG/n4k3lh1G0vw9xjKmBOXizKgN/mia2PWBbOqo2/HCATF02oPIOap4MF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r72MTV3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r72MTV3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777B4C4CEC4;
	Mon, 16 Sep 2024 12:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488415;
	bh=/FpLk9csAFh4tfrieAUD5T4xXtYYSgMwJaUPbjOuXI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r72MTV3iabl+l46Und0UskF+hOT1DmF5T2yUfpfuW0Upe2Ze9oI7rSl1N1WNFKL8h
	 dbpGr02br5gq/uwMRj3VZ9cpMGSsFZpDyBpvmcejzXLcAebeBFE/bDRNFGDW9HNzAy
	 3xaCXwukHwh4bpLHrmgVpJ+5b1wY9mfHbN2LjRPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>
Subject: [PATCH 6.10 106/121] drm/amd/amdgpu: apply command submission parser for JPEG v1
Date: Mon, 16 Sep 2024 13:44:40 +0200
Message-ID: <20240916114232.608007796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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


