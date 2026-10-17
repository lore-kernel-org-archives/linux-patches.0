Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30E43C0601;
	Sat, 17 Oct 2026 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260513; cv=none; b=Okdh4xxpP2cd7j05nZxDtP+uNHqHqfp1JaluAE32O6KJDdyk71CZGdJzPt04/4eInzOJECoGhzeS5n0yBwPBQ8mxBeL8+qeGgjUYtCp9dvGiT9fx8sdk4/sC9+V36OTHYJ5SUSX/1hMIi/XeAwse5evjuspo0p0iWu+u1mHIBtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260513; c=relaxed/simple;
	bh=eVgxrzVqlvb9PaDVOmpHEE3wyL7i3IhCjpYHnxX05ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjbGXRJcO/HSPGF7P3aUOCp2eZFbwiDcev00n5WvuktmgF4aQ+OBcRFE5QJqGDqxkW+tyQD5x9YxV/Ct56HShjRlSY+luTxJvpAXh6tiiaYly/hXKYuunmR0g6OUXP0eB/bO8YWGZ//DMI8NEs9efW3vMG6FryciGAIMsZnbK+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtlL582t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtlL582t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A46A1F000C4;
	Sat, 17 Oct 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260511;
	bh=OcbYioROIztfz9tqBLUcrYURlDFBW0XzDPzkMEwVFkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtlL582t32xRXFlZEZL2zS1YHGAXAomIHAcXRSNfDSkQtBnl2/ohCbWwrGj1H9Lpv
	 ekjqdRd1g69hRGlcE06gf+gJTw8MzihjWe7z2nT9592Sai4c3GeUcS0s/96hvjoDda
	 T9+YGNkfPgCoK6+HLvRNDt4YgD+GxImSx2TFpagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1542/1674] drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw
Date: Sat, 17 Oct 2026 18:03:34 +0200
Message-ID: <20261017160510.691411486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c    |  8 ++++--
 7 files changed, 56 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 91eebf85596b7..e678fd5a0a60c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -759,7 +759,11 @@ static int psp_load_toc(struct psp_context *psp,
 	struct psp_gfx_cmd_resp *cmd = acquire_psp_cmd_buf(psp);
 
 	/* Copy toc to psp firmware private buffer */
-	psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	ret = psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	psp_prep_load_toc_cmd_buf(cmd, psp->fw_pri_mc_addr, psp->toc.size_bytes);
 
@@ -994,8 +998,11 @@ static int psp_rl_load(struct amdgpu_device *adev)
 
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
@@ -1188,8 +1195,12 @@ int psp_ta_load(struct psp_context *psp, struct ta_context *context)
 
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
 
@@ -3576,17 +3587,24 @@ static ssize_t psp_usbc_pd_fw_sysfs_write(struct device *dev,
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
index 3e67ed63e6385..2431bfb598678 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -528,7 +528,7 @@ int psp_get_fw_attestation_records_addr(struct psp_context *psp,
 
 int psp_load_fw_list(struct psp_context *psp,
 		     struct amdgpu_firmware_info **ucode_list, int ucode_count);
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
 
 int psp_spatial_partition(struct psp_context *psp, int mode);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 8f84fe40abbbb..7f6c45539eb86 100644
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
index fe1995ed13be7..a1ad01056efbf 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -215,10 +215,9 @@ static int psp_v13_0_bootloader_load_component(struct psp_context  	*psp,
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
@@ -284,10 +283,9 @@ static int psp_v13_0_bootloader_load_sos(struct psp_context *psp)
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
index d5ba58eba3e2b..28a2f2ca62460 100644
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



