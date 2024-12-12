Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CFD22332E;
	Thu, 12 Dec 2024 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018482; cv=none; b=OgVSqLLXx3ytU/FRAgvTllxJmORNqeUpWgHUWfZMi3egDQdoYJ6DPPqmAkdlt341/iYlQP62Cegrj62RW/ybFEWywYQAGWQYgcEAJOqeJfoyi0fl4dDWpN5jcbTqGLPNtf80X1ogJvx8OG/fNlqHHQkWFwweO0MseQatPKfyv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018482; c=relaxed/simple;
	bh=NbZm2f+WMPKWACUbUhtV3aSugUpW71G6IF6jfvB1NKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNwKbAhGmhUmt5zSZHF7Ldy88851wIBACYLQEkcDDO1q+V4I2SYx8fqx5IAqOTh6d3SqU0okBkhAyE5rE+e+kEA26qTdEwEN5nkh1v7MsCvWeyH3ZOKSTZ4khVgp77/z2VYzJY16K8j8lejDQaUywNmQKoCuFoAswmqkVP1ZdPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuj/QabS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuj/QabS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8A6C4CEDE;
	Thu, 12 Dec 2024 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018482;
	bh=NbZm2f+WMPKWACUbUhtV3aSugUpW71G6IF6jfvB1NKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuj/QabSHTG+HMsQnW8C+cyK1BovspEtgNP7tZowsmJNMZkXb52NRu4jP9qSh9+5U
	 KgYNWsAShBa7df7PkrKYAUTAAYmoUaDtTOSR8WheGi8GZS4mTj/eAB7EosGHi0wKp+
	 IN+MqErz6DBXEdynWizKrGmnGyYH+JmsyYGyCpb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/356] drm/amdgpu/vcn: reset fw_shared when VCPU buffers corrupted on vcn v4.0.3
Date: Thu, 12 Dec 2024 16:00:25 +0100
Message-ID: <20241212144256.650315097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f85d18cd74eca..e80c4f5b4f402 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -77,6 +77,20 @@ static int vcn_v4_0_3_early_init(void *handle)
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
@@ -107,8 +121,6 @@ static int vcn_v4_0_3_sw_init(void *handle)
 		return r;
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
-		volatile struct amdgpu_vcn4_fw_shared *fw_shared;
-
 		vcn_inst = GET_INST(VCN, i);
 
 		ring = &adev->vcn.inst[i].ring_enc[0];
@@ -131,12 +143,7 @@ static int vcn_v4_0_3_sw_init(void *handle)
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
@@ -221,6 +228,8 @@ static int vcn_v4_0_3_hw_init(void *handle)
 		}
 	} else {
 		for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
+			struct amdgpu_vcn4_fw_shared *fw_shared;
+
 			vcn_inst = GET_INST(VCN, i);
 			ring = &adev->vcn.inst[i].ring_enc[0];
 
@@ -244,6 +253,11 @@ static int vcn_v4_0_3_hw_init(void *handle)
 					regVCN_RB1_DB_CTRL);
 			}
 
+			/* Re-init fw_shared when RAS fatal error occurred */
+			fw_shared = adev->vcn.inst[i].fw_shared.cpu_addr;
+			if (!fw_shared->sq.is_enabled)
+				vcn_v4_0_3_fw_shared_init(adev, i);
+
 			r = amdgpu_ring_test_helper(ring);
 			if (r)
 				goto done;
-- 
2.43.0



