Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89A383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302103; cv=none; b=df2IhEXt2t+NSzi+77U+l7RjciEA6BzlG50FFMqSEKTQp84LmSAS6cy5OyZvb72NF64wZBYKSBGJij+wNnrYSAvZ6UPpwDc9MGRmNJ5AjZbFWcDb8Y3+duLdJE3j7MW3KB9BkAPM3FQ1CzvWWgvr0TbnckkNQayGvRmWSWxbf8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302103; c=relaxed/simple;
	bh=dmAOFaG2M/ICerrfsTeIRMy3v8jJFqHz+F/QmZj6O98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C1I/jfSv8ubED+7R2yVObQtSxbGTcYSl+bf8JV6BjeJsxaR4GYkJ9Ch6Do91FVkwlzAaIqI3n41dfqd6CvTMEt4M+GwKDg+jUoghRirMlyw6RJALz1zOz/PqKS3Jh2r0cc1XHvTha7SgLkRovYXNwnyezc8FhPxKT6AIF9001Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIBdFCT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIBdFCT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E183DC19424;
	Sat, 28 Feb 2026 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302102;
	bh=dmAOFaG2M/ICerrfsTeIRMy3v8jJFqHz+F/QmZj6O98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIBdFCT4FASwcKLf5eiDFQyH1YmVIgll/A3QNEObvex50fjfcYjQFNtw60bQVHigu
	 /wMau+Vy2ZlQMIzBNsdGKFAtYYfjxy4tD56K1m6lDNpaUnzWMsnOqQGBEJcl7smsHU
	 LJgzEMl9kuZwTU4MuMgOVKBVlhH/R2GAoB8QQbRp1kRRYIe+4Q+41i93Qxu+L+IDdv
	 9zLMjjHWEinebNawWQ67tYRN2haCZLGSVZoKOCZcjtRy0sWL8Qsf8EnSw3xZex/jIE
	 p7mupQO3CmLzog2dj7npdtZYxVpBlwooi1XQS3PMT9kB5mr0RTkq5/RKhXE7WmU5gi
	 l+F6rq8SH4Tmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	darlington Opara <darlington.opara@amd.com>,
	Jinage Zhao <jiange.zhao@amd.com>,
	Monk Liu <Monk.Liu@amd.com>,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/283] drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init
Date: Sat, 28 Feb 2026 13:03:51 -0500
Message-ID: <20260228180709.1583486-89-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit af26fa751c2eef66916acbf0d3c3e9159da56186 ]

vcn_v2_0_start_sriov() declares a local variable "i" initialized to zero
and uses it only as the instance index in SOC15_REG_OFFSET(UVD, i, ...).
The value is never changed and all other fields are taken from
adev->vcn.inst[0], so this path only ever programs VCN instance 0.

This triggered a Smatch:
warn: iterator 'i' not incremented

Replace the dummy iterator with an explicit instance index of 0 in
SOC15_REG_OFFSET() calls.

Fixes: dd26858a9cd8 ("drm/amdgpu: implement initialization part on VCN2.0 for SRIOV")
Reported by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: darlington Opara <darlington.opara@amd.com>
Cc: Jinage Zhao <jiange.zhao@amd.com>
Cc: Monk Liu <Monk.Liu@amd.com>
Cc: Emily Deng <Emily.Deng@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c | 45 ++++++++++++++-------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 18794394c5a05..2505951ad06a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -1862,7 +1862,8 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 	struct mmsch_v2_0_cmd_end end = { {0} };
 	struct mmsch_v2_0_init_header *header;
 	uint32_t *init_table = adev->virt.mm_table.cpu_addr;
-	uint8_t i = 0;
+
+	/* This path only programs VCN instance 0. */
 
 	header = (struct mmsch_v2_0_init_header *)init_table;
 	direct_wt.cmd_header.command_type = MMSCH_COMMAND__DIRECT_REG_WRITE;
@@ -1881,93 +1882,93 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		size = AMDGPU_GPU_PAGE_ALIGN(adev->vcn.fw->size + 4);
 
 		MMSCH_V2_0_INSERT_DIRECT_RD_MOD_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_STATUS),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_STATUS),
 			0xFFFFFFFF, 0x00000004);
 
 		/* mc resume*/
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_LOW),
 				adev->firmware.ucode[AMDGPU_UCODE_ID_VCN].tmr_mc_addr_lo);
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_HIGH),
 				adev->firmware.ucode[AMDGPU_UCODE_ID_VCN].tmr_mc_addr_hi);
 			offset = 0;
 		} else {
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_LOW),
 				lower_32_bits(adev->vcn.inst->gpu_addr));
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_HIGH),
 				upper_32_bits(adev->vcn.inst->gpu_addr));
 			offset = size;
 		}
 
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_OFFSET0),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_OFFSET0),
 			0);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_SIZE0),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_SIZE0),
 			size);
 
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_VCPU_CACHE1_64BIT_BAR_LOW),
 			lower_32_bits(adev->vcn.inst->gpu_addr + offset));
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_VCPU_CACHE1_64BIT_BAR_HIGH),
 			upper_32_bits(adev->vcn.inst->gpu_addr + offset));
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_OFFSET1),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_OFFSET1),
 			0);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_SIZE1),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_SIZE1),
 			AMDGPU_VCN_STACK_SIZE);
 
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_VCPU_CACHE2_64BIT_BAR_LOW),
 			lower_32_bits(adev->vcn.inst->gpu_addr + offset +
 				AMDGPU_VCN_STACK_SIZE));
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_VCPU_CACHE2_64BIT_BAR_HIGH),
 			upper_32_bits(adev->vcn.inst->gpu_addr + offset +
 				AMDGPU_VCN_STACK_SIZE));
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_OFFSET2),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_OFFSET2),
 			0);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_VCPU_CACHE_SIZE2),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_VCPU_CACHE_SIZE2),
 			AMDGPU_VCN_CONTEXT_SIZE);
 
 		for (r = 0; r < adev->vcn.num_enc_rings; ++r) {
 			ring = &adev->vcn.inst->ring_enc[r];
 			ring->wptr = 0;
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i, mmUVD_RB_BASE_LO),
+				SOC15_REG_OFFSET(UVD, 0, mmUVD_RB_BASE_LO),
 				lower_32_bits(ring->gpu_addr));
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i, mmUVD_RB_BASE_HI),
+				SOC15_REG_OFFSET(UVD, 0, mmUVD_RB_BASE_HI),
 				upper_32_bits(ring->gpu_addr));
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i, mmUVD_RB_SIZE),
+				SOC15_REG_OFFSET(UVD, 0, mmUVD_RB_SIZE),
 				ring->ring_size / 4);
 		}
 
 		ring = &adev->vcn.inst->ring_dec;
 		ring->wptr = 0;
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_RBC_RB_64BIT_BAR_LOW),
 			lower_32_bits(ring->gpu_addr));
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i,
+			SOC15_REG_OFFSET(UVD, 0,
 				mmUVD_LMI_RBC_RB_64BIT_BAR_HIGH),
 			upper_32_bits(ring->gpu_addr));
 		/* force RBC into idle state */
@@ -1978,7 +1979,7 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_NO_UPDATE, 1);
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_RPTR_WR_EN, 1);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_RBC_RB_CNTL), tmp);
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_RBC_RB_CNTL), tmp);
 
 		/* add end packet */
 		tmp = sizeof(struct mmsch_v2_0_cmd_end);
-- 
2.51.0

