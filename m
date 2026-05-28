Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03E3335566;
	Thu, 28 May 2026 20:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999075; cv=none; b=iE/OkkAmCiO7j1NS9l1FheVkCWyeyGqGAlMzFMuXDpsfrTxU6QEo0As9BuZ+LSFdTt5CfEjGcX96uIBDXDVjV6Bs2rUELy/haLMWrEcv95aVdAOajL+W3Xk2ukP9EETek3ohvOcTJcgh3K4hLf3IWdzInkFRZIAKbogakG/dVCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999075; c=relaxed/simple;
	bh=Jik+Uyg2KulaFjKuL2LZ298i1oCIhOnzRRIGy8A1H4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K85zfIC2kdwuR/i/fyShKqKVGZAroR84jbRFyDgvL8I61xHT3YD/S13ypPHp2BtdIBpSyEF16L1PejFL8kID5Iy7JBwKbJQbYsibk7t2Do7zTjajyTq8LHqncc0KKbV/OTH8E2g26GO+xW5oEdxFb3usDiDGLEY6KWJuZHXPtEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GZT2+Mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GZT2+Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B4E1F000E9;
	Thu, 28 May 2026 20:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999073;
	bh=gdxTFr/jOn6k8GNTLpTgt1WYiGfX4JXE3xDMWbiw1Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GZT2+MrltcTl8/8YMm86FYXSZEKsOv2stzpZuyF9eyFYBVOfxpDMnIaEFTwP7ycj
	 1pCSZmSBKSv7UFCLwyrGBbH1IuyO8EnpcAMCGvhIKC67NVG8cVjDJ3f4MtxbJMSbQz
	 hZiEDIf0Dw7VPCVtRwMPjSgFYKIs65vpFVG4oGA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 400/461] drm/amdgpu/vce1: Fix VCE 1 firmware size and offsets
Date: Thu, 28 May 2026 21:48:49 +0200
Message-ID: <20260528194659.051286688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 3e5a1d5bb2ff061e64c7992f8e5404dfd4c2d0f3 ]

The VCPU BO contains the actual FW at an offset, but
it was not calculated into the VCPU BO size.
Subtract this from the FW size to make sure there is
no out of bounds access.

Make sure the stack and data offsets are aligned to
the 32K TLB size.

Check that the FW microcode actually fits in the
space that is reserved for it.

Fixes: d4a640d4b9f3 ("drm/amdgpu/vce1: Implement VCE1 IP block (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c16fe59f622a080fc457a57b3e8f14c780699449)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v1_0.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
index 0b69773b71848..d63ff64943d58 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
@@ -42,9 +42,10 @@
 #include "oss/oss_1_0_d.h"
 #include "oss/oss_1_0_sh_mask.h"
 
+#define VCE_V1_0_ALIGNMENT	(32 * 1024)
 #define VCE_V1_0_FW_SIZE	(256 * 1024)
 #define VCE_V1_0_STACK_SIZE	(64 * 1024)
-#define VCE_V1_0_DATA_SIZE	(7808 * (AMDGPU_MAX_VCE_HANDLES + 1))
+#define VCE_V1_0_DATA_SIZE	(ALIGN(7808 * (AMDGPU_MAX_VCE_HANDLES + 1), VCE_V1_0_ALIGNMENT))
 #define VCE_STATUS_VCPU_REPORT_FW_LOADED_MASK	0x02
 
 #define VCE_V1_0_GART_PAGE_START \
@@ -194,17 +195,22 @@ static int vce_v1_0_load_fw_signature(struct amdgpu_device *adev)
 {
 	const struct common_firmware_header *hdr;
 	struct vce_v1_0_fw_signature *sign;
-	unsigned int ucode_offset;
+	u32 ucode_offset;
+	u32 ucode_size;
 	uint32_t chip_id;
 	u32 *cpu_addr;
 	int i;
 
 	hdr = (const struct common_firmware_header *)adev->vce.fw->data;
 	ucode_offset = le32_to_cpu(hdr->ucode_array_offset_bytes);
+	ucode_size = hdr->ucode_size_bytes - sizeof(struct vce_v1_0_fw_signature *);
 	cpu_addr = adev->vce.cpu_addr;
 
 	sign = (void *)adev->vce.fw->data + ucode_offset;
 
+	if (ucode_size > VCE_V1_0_FW_SIZE - AMDGPU_VCE_FIRMWARE_OFFSET)
+		return -EINVAL;
+
 	switch (adev->asic_type) {
 	case CHIP_TAHITI:
 		chip_id = 0x01000014;
@@ -236,7 +242,7 @@ static int vce_v1_0_load_fw_signature(struct amdgpu_device *adev)
 	cpu_addr[4] = cpu_to_le32(le32_to_cpu(sign->length) + 64);
 
 	memset_io(&cpu_addr[5], 0, 44);
-	memcpy_toio(&cpu_addr[16], &sign[1], hdr->ucode_size_bytes - sizeof(*sign));
+	memcpy_toio(&cpu_addr[16], &sign[1], ucode_size);
 
 	cpu_addr += (le32_to_cpu(sign->length) + 64) / 4;
 	memcpy_toio(&cpu_addr[0], &sign->val[i].sigval[0], 16);
@@ -317,17 +323,22 @@ static int vce_v1_0_mc_resume(struct amdgpu_device *adev)
 	WREG32(mmVCE_VCPU_SCRATCH7, AMDGPU_MAX_VCE_HANDLES);
 
 	offset =  adev->vce.gpu_addr + AMDGPU_VCE_FIRMWARE_OFFSET;
-	size = VCE_V1_0_FW_SIZE;
+	size = VCE_V1_0_FW_SIZE - AMDGPU_VCE_FIRMWARE_OFFSET;
 	WREG32(mmVCE_VCPU_CACHE_OFFSET0, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE0, size);
 
 	offset += size;
 	size = VCE_V1_0_STACK_SIZE;
+	WARN_ON(!IS_ALIGNED(offset, VCE_V1_0_ALIGNMENT));
+	WARN_ON(!IS_ALIGNED(size, VCE_V1_0_ALIGNMENT));
 	WREG32(mmVCE_VCPU_CACHE_OFFSET1, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE1, size);
 
 	offset += size;
 	size = VCE_V1_0_DATA_SIZE;
+	WARN_ON(!IS_ALIGNED(offset, VCE_V1_0_ALIGNMENT));
+	WARN_ON(!IS_ALIGNED(size, VCE_V1_0_ALIGNMENT));
+	WARN_ON((offset + size - adev->vce.gpu_addr) > amdgpu_bo_size(adev->vce.vcpu_bo));
 	WREG32(mmVCE_VCPU_CACHE_OFFSET2, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE2, size);
 
-- 
2.53.0



