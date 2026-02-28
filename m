Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872939B94A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302549; cv=none; b=s4IxfIz1MI3Vi5icmL43uBC9lobdvuucNdeZNI78tqF43jkGl5tGl2JJR1LYtv8QlFF6PWX5mvFUgT0dUnuh988U91Juj02PQl3sEDL94FwlOG0ob0V23jGEpQ1J6dji+cZTklWjkt5bNVJ4fgyx3j1gfZPpu6ZGr9BHTaaPjag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302549; c=relaxed/simple;
	bh=8MKpMoh6szpQpjMx8N8LUXQMKszwyvIKivWzVKr5Ht8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRAKHtI0dnN01vmk3b6JmIZVgXENxaxnBqEBYGn9R+nNesz1ge2upvinXG9WKquSINZnLHEUliYja8Be9MhzOHGube21Izx/G52VL4qbA2RKhLt/GgVBVDXBbpFK2n15zWaeZFBJT2n0yet4BtHB1oH5EjgvB55tQjUHAlB0RY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFub6/DF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFub6/DF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF4C19423;
	Sat, 28 Feb 2026 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302549;
	bh=8MKpMoh6szpQpjMx8N8LUXQMKszwyvIKivWzVKr5Ht8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFub6/DFSoXI7MZWl7uuyxqFJMSnv5xI9WwpsvPqQh3tz3e0mj/lAqt/cEFETFIxz
	 eV5Qonp0kRcNDLbLSookOWubh/ZqUCYMulB/IdkOWJjUfL2CJI/0sXdi63fgXm72Zw
	 5EBA2THaiwCc3FW6GoJarLN0N5QmWwoMt4XgDt3WkLFMSqOMJVwL5eYERbXhKq+F3I
	 hU4Nj6QW8vfMyLvKQ02QCLh4/i23QMdNoi1+tC1yCDvYqHmhEnb+XibuTitcu3qC6Y
	 mKt+6Ayo4W4Kaj9IBMjKmmGXwjiZUeqNZ3bKd12Ds2KaZrTHVc5UhsEkoN623BhFuz
	 8/G2t/cV9FGBg==
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
Subject: [PATCH 5.15 052/164] drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init
Date: Sat, 28 Feb 2026 13:13:11 -0500
Message-ID: <20260228181505.1600663-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index c405075a572c1..02ae3e7a8a552 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -1859,7 +1859,8 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 	struct mmsch_v2_0_cmd_end end = { {0} };
 	struct mmsch_v2_0_init_header *header;
 	uint32_t *init_table = adev->virt.mm_table.cpu_addr;
-	uint8_t i = 0;
+
+	/* This path only programs VCN instance 0. */
 
 	header = (struct mmsch_v2_0_init_header *)init_table;
 	direct_wt.cmd_header.command_type = MMSCH_COMMAND__DIRECT_REG_WRITE;
@@ -1878,94 +1879,94 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		size = AMDGPU_GPU_PAGE_ALIGN(adev->vcn.fw->size + 4);
 
 		MMSCH_V2_0_INSERT_DIRECT_RD_MOD_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_STATUS),
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_STATUS),
 			0xFFFFFFFF, 0x00000004);
 
 		/* mc resume*/
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
 			tmp = AMDGPU_UCODE_ID_VCN;
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_LOW),
 				adev->firmware.ucode[tmp].tmr_mc_addr_lo);
 			MMSCH_V2_0_INSERT_DIRECT_WT(
-				SOC15_REG_OFFSET(UVD, i,
+				SOC15_REG_OFFSET(UVD, 0,
 					mmUVD_LMI_VCPU_CACHE_64BIT_BAR_HIGH),
 				adev->firmware.ucode[tmp].tmr_mc_addr_hi);
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
@@ -1976,7 +1977,7 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_NO_UPDATE, 1);
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_RPTR_WR_EN, 1);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_RBC_RB_CNTL), tmp);
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_RBC_RB_CNTL), tmp);
 
 		/* add end packet */
 		tmp = sizeof(struct mmsch_v2_0_cmd_end);
-- 
2.51.0

