Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F59114BFA2;
	Sun,  7 Sep 2025 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276394; cv=none; b=LVfNdgFheSpJOA21AnvOVpSvjDwja2pShaBDmqZwBzV8bIcwQjFlDh7GzImJNx0W9S8qmW48xjdQVKoc7UALpvqOp+lmsrEuEKgVf0QuYyTnNVauovlaXwOR4ziODrzNdDZiL9sbx91uT/qNYLOBsT93bLnIWqi8C9+5BCSY9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276394; c=relaxed/simple;
	bh=tCv1a8HSlahMMNwB+ZfFKY/hfvYAWIr24jRX1iT5xec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltN/yWYqYURgOdLCVi6hslYnc7vDOCNbkPTLKTp7YF+CG4u73Yz6OFdP/3+xeI8FqSm+AfqgWfUGFwxf/eVkihcVAjIg2ZurUEfrVVP//T2qIulp2mJUl5xXcrc1joCec+Iv3Z8q1rg9nitJ1hl2JPW2ToA2vhMTGePybAvE6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpiGmhi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpiGmhi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF81BC4CEF9;
	Sun,  7 Sep 2025 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276394;
	bh=tCv1a8HSlahMMNwB+ZfFKY/hfvYAWIr24jRX1iT5xec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpiGmhi5MGZcsJNB40afrT7/OqibOIXz9A4y+TPSQujo7s+nvqnArrnT1103UJDjo
	 HzVk57qwiTgFQCXFvrjiTg1Lrzpz6IcufTkp7bQ2i5U0n7LKMhOt9I7gOzoTqguhX/
	 +NDWnaS3spCSaMUK+uOk891Ej4Ob+NtJOI4HJNIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/104] drm/amdgpu: Skip TMR allocation if not required
Date: Sun,  7 Sep 2025 21:58:48 +0200
Message-ID: <20250907195610.028956886@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 5b03127d4745d6848f208463390e6a76d489eb03 ]

On ASICs with PSPv13.0.6, TMR is reserved at boot time. There is no need
to allocate TMR region by driver. However, it's still required to send
SETUP_TMR command to PSP.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 467e00b30dfe ("drm/amd/amdgpu: Fix missing error return on kzalloc failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 34 +++++++++++++++++++------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 459a5af3a99ac..cbee5c6cdb369 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -697,8 +697,13 @@ static void psp_prep_tmr_cmd_buf(struct psp_context *psp,
 				 uint64_t tmr_mc, struct amdgpu_bo *tmr_bo)
 {
 	struct amdgpu_device *adev = psp->adev;
-	uint32_t size = amdgpu_bo_size(tmr_bo);
-	uint64_t tmr_pa = amdgpu_gmc_vram_pa(adev, tmr_bo);
+	uint32_t size = 0;
+	uint64_t tmr_pa = 0;
+
+	if (tmr_bo) {
+		size = amdgpu_bo_size(tmr_bo);
+		tmr_pa = amdgpu_gmc_vram_pa(adev, tmr_bo);
+	}
 
 	if (amdgpu_sriov_vf(psp->adev))
 		cmd->cmd_id = GFX_CMD_ID_SETUP_VMR;
@@ -743,6 +748,16 @@ static int psp_load_toc(struct psp_context *psp,
 	return ret;
 }
 
+static bool psp_boottime_tmr(struct psp_context *psp)
+{
+	switch (psp->adev->ip_versions[MP0_HWIP][0]) {
+	case IP_VERSION(13, 0, 6):
+		return true;
+	default:
+		return false;
+	}
+}
+
 /* Set up Trusted Memory Region */
 static int psp_tmr_init(struct psp_context *psp)
 {
@@ -810,8 +825,9 @@ static int psp_tmr_load(struct psp_context *psp)
 	cmd = acquire_psp_cmd_buf(psp);
 
 	psp_prep_tmr_cmd_buf(psp, cmd, psp->tmr_mc_addr, psp->tmr_bo);
-	DRM_INFO("reserve 0x%lx from 0x%llx for PSP TMR\n",
-		 amdgpu_bo_size(psp->tmr_bo), psp->tmr_mc_addr);
+	if (psp->tmr_bo)
+		DRM_INFO("reserve 0x%lx from 0x%llx for PSP TMR\n",
+			 amdgpu_bo_size(psp->tmr_bo), psp->tmr_mc_addr);
 
 	ret = psp_cmd_submit_buf(psp, NULL, cmd,
 				 psp->fence_buf_mc_addr);
@@ -2098,10 +2114,12 @@ static int psp_hw_start(struct psp_context *psp)
 	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
 		goto skip_pin_bo;
 
-	ret = psp_tmr_init(psp);
-	if (ret) {
-		DRM_ERROR("PSP tmr init failed!\n");
-		return ret;
+	if (!psp_boottime_tmr(psp)) {
+		ret = psp_tmr_init(psp);
+		if (ret) {
+			DRM_ERROR("PSP tmr init failed!\n");
+			return ret;
+		}
 	}
 
 skip_pin_bo:
-- 
2.51.0



