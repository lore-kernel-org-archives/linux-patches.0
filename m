Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F71334252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301748; cv=none; b=H5ZULGVtZZ3/T3YVRcmr2iBaSws4LVhC2WH6Uu1HfjU0sZvFii4bv5jHcOpIagJwU/dMs0T40eaf1seR+g1CzTYy/GGUzKtuyqSnZqBqkeUGleB1BVIrH2CUHDIJpzagRCmPFlvG/D+jWm7uRNjmhzl53rHeeEve1WshgtV8Kug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301748; c=relaxed/simple;
	bh=HGhVyo6TaSMqZJa3nQ1CbE/cS53V0HYejrw7ZzWugOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTqaKSWRbYq+bP5fWw6+cN7oDbXUoAz2aXPp6qpu3vYiys5x8tZDq9hEjtusnQlXxYVxnYAv52aTtOcRkv723vaJ8xRDq32XH15nmassveC85VxpajFAMW0yeTo/CWW2f9eoUqisKGTsHItpMLQIiJBt0G581q5VAkOdjyUZSt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsTOsy4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsTOsy4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D2C116D0;
	Sat, 28 Feb 2026 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301748;
	bh=HGhVyo6TaSMqZJa3nQ1CbE/cS53V0HYejrw7ZzWugOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsTOsy4gW+YXSNHs1ghZ7jvRnGCb7RxONHpUqj5jLvveO/ALQIokl1Ts3M+IqcjmC
	 LqqZVDdHzFdQafSuChQzWH31DUtRkb4elxQCF8a7XnY/Tt6pvbIccFVJERcN+bryD8
	 3+lkTrPEQ9uSHINRbEKE3ozZm+b4ThqOMhpe2Wgulm8tIrx5eCVYFZmNnzuDisr1QG
	 JsEt4Pz5DfjTzg2sK/jZxpeMh+rdstvarTEKyyzPYHmLKSA8v07W7Jh1NwwMK7OOk+
	 vDaZPzX6IxVnavG2Q5aNYtVAxZESjPESqTeIhg4rztMCrM+ODI/n+pjlabWsInTp1t
	 GIZVaWe3WrQ5Q==
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
Subject: [PATCH 6.12 150/385] drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init
Date: Sat, 28 Feb 2026 12:56:12 -0500
Message-ID: <20260228180011.1568201-150-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index f085fdaafae00..9479bf9ea30fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -1913,7 +1913,8 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 	struct mmsch_v2_0_cmd_end end = { {0} };
 	struct mmsch_v2_0_init_header *header;
 	uint32_t *init_table = adev->virt.mm_table.cpu_addr;
-	uint8_t i = 0;
+
+	/* This path only programs VCN instance 0. */
 
 	header = (struct mmsch_v2_0_init_header *)init_table;
 	direct_wt.cmd_header.command_type = MMSCH_COMMAND__DIRECT_REG_WRITE;
@@ -1932,93 +1933,93 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		size = AMDGPU_GPU_PAGE_ALIGN(adev->vcn.fw[0]->size + 4);
 
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
@@ -2029,7 +2030,7 @@ static int vcn_v2_0_start_sriov(struct amdgpu_device *adev)
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_NO_UPDATE, 1);
 		tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_RPTR_WR_EN, 1);
 		MMSCH_V2_0_INSERT_DIRECT_WT(
-			SOC15_REG_OFFSET(UVD, i, mmUVD_RBC_RB_CNTL), tmp);
+			SOC15_REG_OFFSET(UVD, 0, mmUVD_RBC_RB_CNTL), tmp);
 
 		/* add end packet */
 		tmp = sizeof(struct mmsch_v2_0_cmd_end);
-- 
2.51.0

