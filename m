Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1F748A;
	Thu, 12 Dec 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017231; cv=none; b=dodeuq6PcGvGuJZ26aO9MuRTsnzbupOMx9S4OzHHVOepsPCZjMaxt7YENjdYV+giPtMeGEWXxOPs0zikLjsOmGRL4JnaG/mKluWejMulJsYhifOKKdxbtqiQqjMOtI1SoSDjQ25rXEscgq6zZDn0p0O6ES9kJHAEtBEiXjrmSjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017231; c=relaxed/simple;
	bh=CHzgizdCw/HTmYV8T4Mbd3CMLyUhUjZuMgfBSvNOKz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQj6R6xBC1yjNnZ4PSsDWfga52M17oZvKuuGV7TC9WCQNnaMkTHXTbyo4v3X1fRbTEmEkln9Eaqb7rw2tpSEyr6vN5zbWvobPo0vDiNNYtOdtPjFaQYulDtnhx7BbonAwUHm3n68XcipmR36PMi3/WCuqd7Uck3dABzPQ1TNu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyWR1A4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyWR1A4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B9BC4CECE;
	Thu, 12 Dec 2024 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017231;
	bh=CHzgizdCw/HTmYV8T4Mbd3CMLyUhUjZuMgfBSvNOKz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyWR1A4ZtWSlfiP0iU72uSwyOSfJtbUqX73L7n/xvJqkcxQ5fqGk90jWVBpLmvcX/
	 ZP7wP5WFpPeHzyeXl62rTAMW35o4rNOD3pdDnhgCmaYFFLhNkQg42SoD8eLBO9rIDu
	 5qrUTSrGyV649GPCMFpY0IKc437Xg1HLQHH+Y0lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/466] drm/amdgpu/vcn: reset fw_shared when VCPU buffers corrupted on vcn v4.0.3
Date: Thu, 12 Dec 2024 15:59:47 +0100
Message-ID: <20241212144323.269802013@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 928cd772e18ffbd7723cb2361db4a8ccf2222235 ]

It is not necessarily corrupted. When there is RAS fatal error, device
memory access is blocked. Hence vcpu bo cannot be saved to system memory
as in a regular suspend sequence before going for reset. In other full
device reset cases, that gets saved and restored during resume.

v2: Remove redundant code like vcn_v4_0 did
v2: Refine commit message
v3: Drop the volatile
v3: Refine commit message

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 30 ++++++++++++++++++-------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 0fda703363004..6fca2915ea8fd 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -116,6 +116,20 @@ static int vcn_v4_0_3_early_init(void *handle)
 	return amdgpu_vcn_early_init(adev);
 }
 
+static int vcn_v4_0_3_fw_shared_init(struct amdgpu_device *adev, int inst_idx)
+{
+	struct amdgpu_vcn4_fw_shared *fw_shared;
+
+	fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
+	fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
+	fw_shared->sq.is_enabled = 1;
+
+	if (amdgpu_vcnfw_log)
+		amdgpu_vcn_fwlog_init(&adev->vcn.inst[inst_idx]);
+
+	return 0;
+}
+
 /**
  * vcn_v4_0_3_sw_init - sw init for VCN block
  *
@@ -148,8 +162,6 @@ static int vcn_v4_0_3_sw_init(void *handle)
 		return r;
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
-		volatile struct amdgpu_vcn4_fw_shared *fw_shared;
-
 		vcn_inst = GET_INST(VCN, i);
 
 		ring = &adev->vcn.inst[i].ring_enc[0];
@@ -172,12 +184,7 @@ static int vcn_v4_0_3_sw_init(void *handle)
 		if (r)
 			return r;
 
-		fw_shared = adev->vcn.inst[i].fw_shared.cpu_addr;
-		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
-		fw_shared->sq.is_enabled = true;
-
-		if (amdgpu_vcnfw_log)
-			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
+		vcn_v4_0_3_fw_shared_init(adev, i);
 	}
 
 	if (amdgpu_sriov_vf(adev)) {
@@ -273,6 +280,8 @@ static int vcn_v4_0_3_hw_init(void *handle)
 		}
 	} else {
 		for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
+			struct amdgpu_vcn4_fw_shared *fw_shared;
+
 			vcn_inst = GET_INST(VCN, i);
 			ring = &adev->vcn.inst[i].ring_enc[0];
 
@@ -296,6 +305,11 @@ static int vcn_v4_0_3_hw_init(void *handle)
 					regVCN_RB1_DB_CTRL);
 			}
 
+			/* Re-init fw_shared when RAS fatal error occurred */
+			fw_shared = adev->vcn.inst[i].fw_shared.cpu_addr;
+			if (!fw_shared->sq.is_enabled)
+				vcn_v4_0_3_fw_shared_init(adev, i);
+
 			r = amdgpu_ring_test_helper(ring);
 			if (r)
 				return r;
-- 
2.43.0



