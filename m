Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF134B7A27;
	Thu, 17 Sep 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667470; cv=none; b=VNA2QUXlaN5yvk80CV9dhzHV2XXR0y2OgUEmLvsbIQL+OPcfx73580oHAq4hTcs6GOpnNLu9SUGYTATHS4yCqyoFTg6fu5QyVnQUlO0ZhRWm8/YUXMlefrxYHNbUsx8q4hd+k7CQFZFDYpdKQrw0ItXDzl3VHdESC/dXI5ZF+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667470; c=relaxed/simple;
	bh=seKs4UoYfxQtJIwLYYSV3d3ASr6VSEc6AXGbp1Az7Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A62dWfYqxRMxvdvxWTeNVVC7KLXDub2N86W3khYI9+wf5Ri1nSLUs4HYuIQ4cRTbn4ctzMA2QGCbYRDNdU1HMjYsfAqwK1pLeyNjmw+iMv6EmkUDSOFg+2lhywPzZm04xpKuLUhBgoChJbqmO8jT9yO0J6h+GNeTAHEebxZvp+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CIygtPd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CIygtPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580981F000FF;
	Thu, 17 Sep 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667467;
	bh=7bQCIOc1xElaHoFCaJYs3JQgKoPO3hP/B93KW2TZqvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CIygtPdO2EqQEMVRRHjwtrffVSY2p5Feg8VaWtO7CgMxryBC0pX12svAxErRD4ZN
	 ZoF1LF9rhiriM5yQbGLrPTALsi5EFWzuWZVTCoQLVTZ2av0WEKOEIbeERhnV3ijbKB
	 zHd4D2su4y5wjcSmIoTLHzIC6mQX8HhHA+RmITrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0104/1102] drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw
Date: Thu, 17 Sep 2026 16:00:47 +0100
Message-ID: <20260917151542.109930751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit d1f9f5839bd785a3a06335a01d53282e80f8e5fa ]

Change psp_copy_fw from void to int: return -ENODEV when drm_dev_enter
fails, and -EINVAL when the image size is zero or larger than the
1 MiB PSP private buffer.

Replace open-coded memset/memcpy into fw_pri_buf with psp_copy_fw.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  | 32 ++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h  |  2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c   |  8 ++++--
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c   |  8 ++++--
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c   | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c   | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c    |  8 ++++--
 8 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index b964b1a2f9b50..435376c7f5e28 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -806,7 +806,11 @@ static int psp_load_toc(struct psp_context *psp,
 	struct psp_gfx_cmd_resp *cmd = acquire_psp_cmd_buf(psp);
 
 	/* Copy toc to psp firmware private buffer */
-	psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	ret = psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	psp_prep_load_toc_cmd_buf(cmd, psp->fw_pri_mc_addr, psp->toc.size_bytes);
 
@@ -1032,8 +1036,11 @@ static int psp_rl_load(struct amdgpu_device *adev)
 
 	cmd = acquire_psp_cmd_buf(psp);
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-	memcpy(psp->fw_pri_buf, psp->rl.start_addr, psp->rl.size_bytes);
+	ret = psp_copy_fw(psp, psp->rl.start_addr, psp->rl.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	cmd->cmd_id = GFX_CMD_ID_LOAD_IP_FW;
 	cmd->cmd.cmd_load_ip_fw.fw_phy_addr_lo = lower_32_bits(psp->fw_pri_mc_addr);
@@ -1231,8 +1238,12 @@ int psp_ta_load(struct psp_context *psp, struct ta_context *context)
 
 	cmd = acquire_psp_cmd_buf(psp);
 
-	psp_copy_fw(psp, context->bin_desc.start_addr,
-		    context->bin_desc.size_bytes);
+	ret = psp_copy_fw(psp, context->bin_desc.start_addr,
+			  context->bin_desc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	psp_prep_ta_load_cmd_buf(cmd, psp->fw_pri_mc_addr, context);
 
@@ -3843,17 +3854,24 @@ static ssize_t psp_usbc_pd_fw_sysfs_write(struct device *dev,
 	return count;
 }
 
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size)
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size)
 {
 	int idx;
 
 	if (!drm_dev_enter(adev_to_drm(psp->adev), &idx))
-		return;
+		return -ENODEV;
+
+	if (!bin_size || bin_size > PSP_1_MEG) {
+		dev_err(psp->adev->dev, "PSP firmware is invalid\n");
+		drm_dev_exit(idx);
+		return -EINVAL;
+	}
 
 	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
 	memcpy(psp->fw_pri_buf, start_addr, bin_size);
 
 	drm_dev_exit(idx);
+	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index e8abbbcb43266..a36896ff8dc33 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -549,7 +549,7 @@ int psp_get_fw_attestation_records_addr(struct psp_context *psp,
 
 int psp_load_fw_list(struct psp_context *psp,
 		     struct amdgpu_firmware_info **ucode_list, int ucode_count);
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
 
 int psp_spatial_partition(struct psp_context *psp, int mode);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index e77a467af7ac3..b903fc7ee961d 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -193,7 +193,9 @@ static int psp_v11_0_bootloader_load_component(struct psp_context  	*psp,
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -239,7 +241,9 @@ static int psp_v11_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
index fcd708eae75cc..14e6cd44cc012 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -90,7 +90,9 @@ static int psp_v12_0_bootloader_load_sysdrv(struct psp_context *psp)
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	ret = psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -129,7 +131,9 @@ static int psp_v12_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index 124f74e862d7f..bcfe0f7859c3a 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -238,10 +238,9 @@ static int psp_v13_0_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
@@ -315,10 +314,9 @@ static int psp_v13_0_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
index eaa5512a21dac..35e6f2dc6cdf9 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
@@ -107,10 +107,9 @@ static int psp_v13_0_4_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
@@ -170,10 +169,9 @@ static int psp_v13_0_4_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
index 89f6c06946c51..d65dd7b129a5d 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -130,10 +130,9 @@ static int psp_v14_0_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_36,
@@ -204,10 +203,9 @@ static int psp_v14_0_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
index f6b75e3e47ffb..b0c1046c355da 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
@@ -96,7 +96,9 @@ static int psp_v3_1_bootloader_load_sysdrv(struct psp_context *psp)
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	ret = psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -135,7 +137,9 @@ static int psp_v3_1_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
-- 
2.53.0



