Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664AC4DDB5B;
	Thu, 17 Sep 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661308; cv=none; b=i6b9I5dIxuokl0vEc50kePizpavfFvEicQnm29pJqEMa4owP72xvai/ZQTNKhOY9o/04P1ZyzOjjvRU9mYTB2yfuj7rxseSvww5ZBzERFylHOo/4VRevMfyFGpU8Q522d4qbcGAT7+U9Xhs5V3VmuLpF6+6X+769n8jvzE/xD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661308; c=relaxed/simple;
	bh=CW6R8XTO8YNeYv1sntybuEt2UIIAQ+S11+PKn5DKspQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/GtWQIz6G5LBMNLp1opt/8dxqQlkWSaCJy/AP0UdebpHv1ec4ZL48giSqLMbRo8h0t0eXfM9ZPUsz140f2MdOTb3PN9SXgcF5NRW27ZDFqCu84m1qnf0jByNoRAQIH4BeCN7LibZp85oPwbi0hQnfbwwPawTBJrVsuLgd6CTUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IpWS8+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IpWS8+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0181F0089B;
	Thu, 17 Sep 2026 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661306;
	bh=3YaJXf7QJwOzIqVb4HGki2Z4W04Nlyt7jJze5jOKucU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IpWS8+bLEB0PXqfTzoFYOeIsmABF6ofOtLvG8sK5WC9kq2BUXolr/gw2uDjgtJvo
	 8xUFsqqXpXp26hrrw/rnjnLm5yZVsXQEjG2ofbOvcoF9sgOjS5Q4H/RiUqZIVLiuGR
	 Z/pEWuAzNKGlB0pXMTn/8YZM1OW6MZGQn6uzqroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0151/1250] drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw
Date: Thu, 17 Sep 2026 15:59:06 +0100
Message-ID: <20260917151556.161549678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 161ca34be2070..dd7bc55470ac9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -838,7 +838,11 @@ static int psp_load_toc(struct psp_context *psp,
 	struct psp_gfx_cmd_resp *cmd = acquire_psp_cmd_buf(psp);
 
 	/* Copy toc to psp firmware private buffer */
-	psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	ret = psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	psp_prep_load_toc_cmd_buf(cmd, psp->fw_pri_mc_addr, psp->toc.size_bytes);
 
@@ -1165,8 +1169,11 @@ static int psp_rl_load(struct amdgpu_device *adev)
 
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
@@ -1389,8 +1396,12 @@ int psp_ta_load(struct psp_context *psp, struct ta_context *context)
 
 	cmd = acquire_psp_cmd_buf(psp);
 
-	psp_copy_fw(psp, context->bin_desc.start_addr,
-		    context->bin_desc.size_bytes);
+	ret = psp_copy_fw(psp, context->bin_desc.start_addr,
+			  context->bin_desc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	if (amdgpu_virt_xgmi_migrate_enabled(psp->adev) &&
 		context->mem_context.shared_bo)
@@ -4160,17 +4171,24 @@ static ssize_t psp_usbc_pd_fw_sysfs_write(struct device *dev,
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
index 237b624aa51ca..c3a5940e311aa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -605,7 +605,7 @@ int psp_get_fw_attestation_records_addr(struct psp_context *psp,
 int psp_update_fw_reservation(struct psp_context *psp);
 int psp_load_fw_list(struct psp_context *psp,
 		     struct amdgpu_firmware_info **ucode_list, int ucode_count);
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
 
 int psp_spatial_partition(struct psp_context *psp, int mode);
 int psp_memory_partition(struct psp_context *psp, int mode);
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 27d883fda5fa9..6f131f4b81134 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -217,7 +217,9 @@ static int psp_v11_0_bootloader_load_component(struct psp_context  	*psp,
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -263,7 +265,9 @@ static int psp_v11_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
index 4c6450d62299a..80ba57cce3916 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -87,7 +87,9 @@ static int psp_v12_0_bootloader_load_sysdrv(struct psp_context *psp)
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	ret = psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -123,7 +125,9 @@ static int psp_v12_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index af4a7d7c4abd8..8100930e47eb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -265,10 +265,9 @@ static int psp_v13_0_bootloader_load_component(struct psp_context  	*psp,
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
@@ -347,10 +346,9 @@ static int psp_v13_0_bootloader_load_sos(struct psp_context *psp)
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
index 5f39a2edcc956..3d5e26b3fa00a 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
@@ -105,10 +105,9 @@ static int psp_v13_0_4_bootloader_load_component(struct psp_context  	*psp,
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
@@ -168,10 +167,9 @@ static int psp_v13_0_4_bootloader_load_sos(struct psp_context *psp)
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
index 38dfc5c19f2a7..040a61aefa866 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -140,10 +140,9 @@ static int psp_v14_0_bootloader_load_component(struct psp_context  	*psp,
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
@@ -214,10 +213,9 @@ static int psp_v14_0_bootloader_load_sos(struct psp_context *psp)
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
index 833830bc3e2e3..409f097f4c524 100644
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



