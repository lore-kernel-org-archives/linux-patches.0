Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F581C68B9;
	Tue, 27 Aug 2024 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770050; cv=none; b=SdWZieLkbxNJP3bapPJakoh3tFRtsU8Zg5CzMymBXrE4ql/qiLeJkax+zv034gvdvOEsmIba6UK1twOWq2tRxkoNg7vXZWouu9RhX0LhxG6vwd7HPQzJxaZ9GuZOx4ni+8RG5RHDhQk/iqkv8N93ukQ84J3mu6hgSmGOhjX+GXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770050; c=relaxed/simple;
	bh=S43R8YPu0yhvk/222N8GSbJEVa6eLxbZxxmkrwWh5fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl1u4JpWJD9sIuZnNhgJ+VBHFehGPcmAnkSqKJhPkmGSGhwwlW9Rx4kGfmyzb4NkSlHLEZt4T4Vq64HOjvgDavGHuqwKLIkYoI/MvQbAMym87OUocseNiopPtGr9SND5mPn2sRBWbjfrYktEgMXkzF1tdOxIEqovcWkziGM4vkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZAN9Qv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZAN9Qv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE4C61045;
	Tue, 27 Aug 2024 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770049;
	bh=S43R8YPu0yhvk/222N8GSbJEVa6eLxbZxxmkrwWh5fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZAN9Qv11/nOQZtxA9d+UbXsevEnWyW88BOaXKfuqT+OBgdqEAdbv7eoznX3Stm+K
	 enUz9hZ7cLR6z4VLAvYgH0jQDQC1U/1NsdcFvfh1wcHhuVAxlTobj7Pe8EaY8Pm6uP
	 F9HxusNodGZgMfqXjbuKJDmzOhVwLIUDJUHyJm5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	ZhenGuo Yin <zhenguo.yin@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/341] drm/amdgpu: access RLC_SPM_MC_CNTL through MMIO in SRIOV runtime
Date: Tue, 27 Aug 2024 16:35:16 +0200
Message-ID: <20240827143846.643302658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: ZhenGuo Yin <zhenguo.yin@amd.com>

[ Upstream commit 9f05cfc78c6880e06940ea78fbc43f6392710f17 ]

Register RLC_SPM_MC_CNTL is not blocked by L1 policy, VF can
directly access it through MMIO during SRIOV runtime.

v2: use SOC15 interface to access registers

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 13 +++----------
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 13 +++----------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 3560a3f2c848e..cd594b92c6129 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -7892,22 +7892,15 @@ static int gfx_v10_0_update_gfx_clock_gating(struct amdgpu_device *adev,
 static void gfx_v10_0_update_spm_vmid_internal(struct amdgpu_device *adev,
 					       unsigned int vmid)
 {
-	u32 reg, data;
+	u32 data;
 
 	/* not for *_SOC15 */
-	reg = SOC15_REG_OFFSET(GC, 0, mmRLC_SPM_MC_CNTL);
-	if (amdgpu_sriov_is_pp_one_vf(adev))
-		data = RREG32_NO_KIQ(reg);
-	else
-		data = RREG32_SOC15(GC, 0, mmRLC_SPM_MC_CNTL);
+	data = RREG32_SOC15_NO_KIQ(GC, 0, mmRLC_SPM_MC_CNTL);
 
 	data &= ~RLC_SPM_MC_CNTL__RLC_SPM_VMID_MASK;
 	data |= (vmid & RLC_SPM_MC_CNTL__RLC_SPM_VMID_MASK) << RLC_SPM_MC_CNTL__RLC_SPM_VMID__SHIFT;
 
-	if (amdgpu_sriov_is_pp_one_vf(adev))
-		WREG32_SOC15_NO_KIQ(GC, 0, mmRLC_SPM_MC_CNTL, data);
-	else
-		WREG32_SOC15(GC, 0, mmRLC_SPM_MC_CNTL, data);
+	WREG32_SOC15_NO_KIQ(GC, 0, mmRLC_SPM_MC_CNTL, data);
 }
 
 static void gfx_v10_0_update_spm_vmid(struct amdgpu_device *adev, unsigned int vmid)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index daab4c7a073ac..c81e98f0d17ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4961,23 +4961,16 @@ static int gfx_v11_0_update_gfx_clock_gating(struct amdgpu_device *adev,
 
 static void gfx_v11_0_update_spm_vmid(struct amdgpu_device *adev, unsigned vmid)
 {
-	u32 reg, data;
+	u32 data;
 
 	amdgpu_gfx_off_ctrl(adev, false);
 
-	reg = SOC15_REG_OFFSET(GC, 0, regRLC_SPM_MC_CNTL);
-	if (amdgpu_sriov_is_pp_one_vf(adev))
-		data = RREG32_NO_KIQ(reg);
-	else
-		data = RREG32(reg);
+	data = RREG32_SOC15_NO_KIQ(GC, 0, regRLC_SPM_MC_CNTL);
 
 	data &= ~RLC_SPM_MC_CNTL__RLC_SPM_VMID_MASK;
 	data |= (vmid & RLC_SPM_MC_CNTL__RLC_SPM_VMID_MASK) << RLC_SPM_MC_CNTL__RLC_SPM_VMID__SHIFT;
 
-	if (amdgpu_sriov_is_pp_one_vf(adev))
-		WREG32_SOC15_NO_KIQ(GC, 0, regRLC_SPM_MC_CNTL, data);
-	else
-		WREG32_SOC15(GC, 0, regRLC_SPM_MC_CNTL, data);
+	WREG32_SOC15_NO_KIQ(GC, 0, regRLC_SPM_MC_CNTL, data);
 
 	amdgpu_gfx_off_ctrl(adev, true);
 }
-- 
2.43.0



