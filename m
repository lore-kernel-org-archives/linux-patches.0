Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3011D54D;
	Tue, 14 May 2024 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685182; cv=none; b=Z+t1Ltyn8pbMtMm1oM5lnIVzNWIBarTEMwtfbmgWIPwBJvLVmE6s1XmYyS9EUx5NJt+NokwRQTSNmOBOebIZP8Coeh3p0boX3/XHURrB3UbiBT+q9sw6nDokQnre51aWxai1BspYhNf/PIe64a0IsHiNGPygya2WGxBEslKwIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685182; c=relaxed/simple;
	bh=MI8dpcWsv7srrMEA9nzg+9POV4y/2UfvDr2qOMPe2QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ+8m0GIIVV/AywL41OydBzkiDTAGBzDzHQ/Jt+eTmig90mGVOl8jTvESXz68VdjTIxmt6WWmm5zyl8Efaa7rpZK6fMmMBAPerwnryCT9zXM1dhijQK2/meUohWoikebgjjIhViGlHDez07atSKSgl+850rbKNwJGhhR1VxZ6tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozOEzlMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozOEzlMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57724C2BD10;
	Tue, 14 May 2024 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685181;
	bh=MI8dpcWsv7srrMEA9nzg+9POV4y/2UfvDr2qOMPe2QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozOEzlMrAhDBInq0qBPB8skx2NAY0BGhXEVZyQX3IVISylfMejvIOMS6RyeGVT6Vg
	 7MsUyux9//gIgo7fUCVl2jwIGI8x1owEz0ptBpCOWGnuoPBISl4QPe4TxJ4Lw/+LjJ
	 IT32qzG7LKM6NNetpTV9S8a3fiC9fZMIiR+ZjdJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	James Zhu <James.Zhu@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/301] drm/amdgpu: Fix VCN allocation in CPX partition
Date: Tue, 14 May 2024 12:16:59 +0200
Message-ID: <20240514101037.843810664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit f7e232de51bb1b45646e5b7dc4ebcf13510f2630 ]

VCN need not be shared in CPX mode always for all GFX 9.4.3 SOC SKUs. In
certain configs, VCN instance can be exclusively allocated to a
partition even under CPX mode.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index d0fc62784e821..0284c9198a04a 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -61,6 +61,11 @@ void aqua_vanjaram_doorbell_index_init(struct amdgpu_device *adev)
 	adev->doorbell_index.max_assignment = AMDGPU_DOORBELL_LAYOUT1_MAX_ASSIGNMENT << 1;
 }
 
+static bool aqua_vanjaram_xcp_vcn_shared(struct amdgpu_device *adev)
+{
+	return (adev->xcp_mgr->num_xcps > adev->vcn.num_vcn_inst);
+}
+
 static void aqua_vanjaram_set_xcp_id(struct amdgpu_device *adev,
 			     uint32_t inst_idx, struct amdgpu_ring *ring)
 {
@@ -86,7 +91,7 @@ static void aqua_vanjaram_set_xcp_id(struct amdgpu_device *adev,
 	case AMDGPU_RING_TYPE_VCN_ENC:
 	case AMDGPU_RING_TYPE_VCN_JPEG:
 		ip_blk = AMDGPU_XCP_VCN;
-		if (adev->xcp_mgr->mode == AMDGPU_CPX_PARTITION_MODE)
+		if (aqua_vanjaram_xcp_vcn_shared(adev))
 			inst_mask = 1 << (inst_idx * 2);
 		break;
 	default:
@@ -139,10 +144,12 @@ static int aqua_vanjaram_xcp_sched_list_update(
 
 		aqua_vanjaram_xcp_gpu_sched_update(adev, ring, ring->xcp_id);
 
-		/* VCN is shared by two partitions under CPX MODE */
+		/* VCN may be shared by two partitions under CPX MODE in certain
+		 * configs.
+		 */
 		if ((ring->funcs->type == AMDGPU_RING_TYPE_VCN_ENC ||
-			ring->funcs->type == AMDGPU_RING_TYPE_VCN_JPEG) &&
-			adev->xcp_mgr->mode == AMDGPU_CPX_PARTITION_MODE)
+		     ring->funcs->type == AMDGPU_RING_TYPE_VCN_JPEG) &&
+		    aqua_vanjaram_xcp_vcn_shared(adev))
 			aqua_vanjaram_xcp_gpu_sched_update(adev, ring, ring->xcp_id + 1);
 	}
 
-- 
2.43.0



