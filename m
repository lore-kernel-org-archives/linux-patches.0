Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED2171A4;
	Sat,  3 Feb 2024 04:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933890; cv=none; b=Nlr1l5+fvQksm8NobRVELTdhk2mqHNKkLvS/L9Y/fD59kgPM3Eu7YJpmkDRo1p9Ay9vhY1+XxQJEfd9YNy3LEBNiJGNf4iA0pRT2Jpc6GNUEsMApF0RlsQtQZ3OMTz4xRvfBm/4a6OoFtcyGnnVOUFf7HgGOQeY9Iqe947GBRyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933890; c=relaxed/simple;
	bh=/uSxWQmsUyM0IhDhjjjhjeEMMAeX8ETVPPo1m4VufyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJYHcATnQy7MJhZqOuzI+2kDO373VXI3a7bxXh1e1D5PPrkKXT8QV61VGOMd9AMce8ShwSp2YDlpwj2uoJJiP5mXNwwW9IC6jUrlXIKYyUvQSExqLEUAaT4LykAebXVnKeb5zKQVhLoTfXETtLq5sB8cfTk8CcqCipES6jksJmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgCtg30p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgCtg30p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAC1C433F1;
	Sat,  3 Feb 2024 04:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933890;
	bh=/uSxWQmsUyM0IhDhjjjhjeEMMAeX8ETVPPo1m4VufyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgCtg30pI03FAXqB074beyJ+/LJT+BmzIee62cntmCqp6/ZHzs3dHE76+2nNgbWsP
	 WutrovqZlPGHyk5/Ztyn3XAjppfcuuVGa3LpO7S7P+tHmboL6eOD1jozr9NkiOo6MR
	 mPdFMj1QJqRhokOdcu74IjbTd3FnbGs3h0bsd+k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>
Subject: [PATCH 6.7 235/353] drm/amdgpu: apply the RV2 system aperture fix to RN/CZN as well
Date: Fri,  2 Feb 2024 20:05:53 -0800
Message-ID: <20240203035411.111216579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 16783d8ef08448815e149e40c82fc1e1fc41ddbf ]

These chips needs the same fix.  This was previously not seen
on then since the AGP aperture expanded the system aperture,
but this showed up again when AGP was disabled.

Reviewed-and-tested-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c          | 4 +++-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c          | 4 +++-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c           | 4 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 8 ++++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
index 53a2ba5fcf4b..22175da0e16a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
@@ -102,7 +102,9 @@ static void gfxhub_v1_0_init_system_aperture_regs(struct amdgpu_device *adev)
 		WREG32_SOC15_RLC(GC, 0, mmMC_VM_SYSTEM_APERTURE_LOW_ADDR,
 			min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18);
 
-		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+		if (adev->apu_flags & (AMD_APU_IS_RAVEN2 |
+				       AMD_APU_IS_RENOIR |
+				       AMD_APU_IS_GREEN_SARDINE))
 		       /*
 			* Raven2 has a HW issue that it is unable to use the
 			* vram which is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR.
diff --git a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
index 55423ff1bb49..95d06da544e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
@@ -139,7 +139,9 @@ gfxhub_v1_2_xcc_init_system_aperture_regs(struct amdgpu_device *adev,
 			WREG32_SOC15_RLC(GC, GET_INST(GC, i), regMC_VM_SYSTEM_APERTURE_LOW_ADDR,
 				min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18);
 
-			if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			if (adev->apu_flags & (AMD_APU_IS_RAVEN2 |
+					       AMD_APU_IS_RENOIR |
+					       AMD_APU_IS_GREEN_SARDINE))
 			       /*
 				* Raven2 has a HW issue that it is unable to use the
 				* vram which is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR.
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index 843219a91736..e3ddd22aa172 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -96,7 +96,9 @@ static void mmhub_v1_0_init_system_aperture_regs(struct amdgpu_device *adev)
 	WREG32_SOC15(MMHUB, 0, mmMC_VM_SYSTEM_APERTURE_LOW_ADDR,
 		     min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18);
 
-	if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+	if (adev->apu_flags & (AMD_APU_IS_RAVEN2 |
+			       AMD_APU_IS_RENOIR |
+			       AMD_APU_IS_GREEN_SARDINE))
 		/*
 		 * Raven2 has a HW issue that it is unable to use the vram which
 		 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6f7d7f79ef89..affc628004ff 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1257,7 +1257,9 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 	/* AGP aperture is disabled */
 	if (agp_bot > agp_top) {
 		logical_addr_low = adev->gmc.fb_start >> 18;
-		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+		if (adev->apu_flags & (AMD_APU_IS_RAVEN2 |
+				       AMD_APU_IS_RENOIR |
+				       AMD_APU_IS_GREEN_SARDINE))
 			/*
 			 * Raven2 has a HW issue that it is unable to use the vram which
 			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
@@ -1269,7 +1271,9 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 			logical_addr_high = adev->gmc.fb_end >> 18;
 	} else {
 		logical_addr_low = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
-		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+		if (adev->apu_flags & (AMD_APU_IS_RAVEN2 |
+				       AMD_APU_IS_RENOIR |
+				       AMD_APU_IS_GREEN_SARDINE))
 			/*
 			 * Raven2 has a HW issue that it is unable to use the vram which
 			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
-- 
2.43.0



