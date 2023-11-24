Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4350D33CCA;
	Fri, 24 Nov 2023 19:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ8ko4bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08D1C433C7;
	Fri, 24 Nov 2023 19:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853716;
	bh=2tPE7EuTvrCSTedV27OI27SElzjGeMwmHzx4k9TdAEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ8ko4bFK5uXXmmwfe/lvGvN9ptzpR2fDm1sE7jznCyqiLO45+UMpJ7Gczpur6hk8
	 XAGmNkz1tl6BL2LB1ctCGWV1WN0sIeSh+OdyvcYkglzWgQNzNlslgAigCHlbCV0hX+
	 v4wln0nn8dM1N8ydxyCo2/kkx8eEEPPkds0daiPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Lewis Huang <lewis.huang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 292/297] drm/amd/display: Change the DMCUB mailbox memory location from FB to inbox
Date: Fri, 24 Nov 2023 17:55:34 +0000
Message-ID: <20231124172010.331959498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lewis Huang <lewis.huang@amd.com>

commit 5911d02cac70d7fb52009fbd37423e63f8f6f9bc upstream.

[WHY]
Flush command sent to DMCUB spends more time for execution on
a dGPU than on an APU. This causes cursor lag when using high
refresh rate mouses.

[HOW]
1. Change the DMCUB mailbox memory location from FB to inbox.
2. Only change windows memory to inbox.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Lewis Huang <lewis.huang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   13 ++++----
 drivers/gpu/drm/amd/display/dmub/dmub_srv.h       |   22 +++++++++------
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c   |   32 ++++++++++++++++------
 3 files changed, 45 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1911,7 +1911,7 @@ static int dm_dmub_sw_init(struct amdgpu
 	struct dmub_srv_create_params create_params;
 	struct dmub_srv_region_params region_params;
 	struct dmub_srv_region_info region_info;
-	struct dmub_srv_fb_params fb_params;
+	struct dmub_srv_memory_params memory_params;
 	struct dmub_srv_fb_info *fb_info;
 	struct dmub_srv *dmub_srv;
 	const struct dmcub_firmware_header_v1_0 *hdr;
@@ -2021,6 +2021,7 @@ static int dm_dmub_sw_init(struct amdgpu
 		adev->dm.dmub_fw->data +
 		le32_to_cpu(hdr->header.ucode_array_offset_bytes) +
 		PSP_HEADER_BYTES;
+	region_params.is_mailbox_in_inbox = false;
 
 	status = dmub_srv_calc_region_info(dmub_srv, &region_params,
 					   &region_info);
@@ -2042,10 +2043,10 @@ static int dm_dmub_sw_init(struct amdgpu
 		return r;
 
 	/* Rebase the regions on the framebuffer address. */
-	memset(&fb_params, 0, sizeof(fb_params));
-	fb_params.cpu_addr = adev->dm.dmub_bo_cpu_addr;
-	fb_params.gpu_addr = adev->dm.dmub_bo_gpu_addr;
-	fb_params.region_info = &region_info;
+	memset(&memory_params, 0, sizeof(memory_params));
+	memory_params.cpu_fb_addr = adev->dm.dmub_bo_cpu_addr;
+	memory_params.gpu_fb_addr = adev->dm.dmub_bo_gpu_addr;
+	memory_params.region_info = &region_info;
 
 	adev->dm.dmub_fb_info =
 		kzalloc(sizeof(*adev->dm.dmub_fb_info), GFP_KERNEL);
@@ -2057,7 +2058,7 @@ static int dm_dmub_sw_init(struct amdgpu
 		return -ENOMEM;
 	}
 
-	status = dmub_srv_calc_fb_info(dmub_srv, &fb_params, fb_info);
+	status = dmub_srv_calc_mem_info(dmub_srv, &memory_params, fb_info);
 	if (status != DMUB_STATUS_OK) {
 		DRM_ERROR("Error calculating DMUB FB info: %d\n", status);
 		return -EINVAL;
--- a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
@@ -166,6 +166,7 @@ struct dmub_srv_region_params {
 	uint32_t vbios_size;
 	const uint8_t *fw_inst_const;
 	const uint8_t *fw_bss_data;
+	bool is_mailbox_in_inbox;
 };
 
 /**
@@ -185,20 +186,25 @@ struct dmub_srv_region_params {
  */
 struct dmub_srv_region_info {
 	uint32_t fb_size;
+	uint32_t inbox_size;
 	uint8_t num_regions;
 	struct dmub_region regions[DMUB_WINDOW_TOTAL];
 };
 
 /**
- * struct dmub_srv_fb_params - parameters used for driver fb setup
+ * struct dmub_srv_memory_params - parameters used for driver fb setup
  * @region_info: region info calculated by dmub service
- * @cpu_addr: base cpu address for the framebuffer
- * @gpu_addr: base gpu virtual address for the framebuffer
+ * @cpu_fb_addr: base cpu address for the framebuffer
+ * @cpu_inbox_addr: base cpu address for the gart
+ * @gpu_fb_addr: base gpu virtual address for the framebuffer
+ * @gpu_inbox_addr: base gpu virtual address for the gart
  */
-struct dmub_srv_fb_params {
+struct dmub_srv_memory_params {
 	const struct dmub_srv_region_info *region_info;
-	void *cpu_addr;
-	uint64_t gpu_addr;
+	void *cpu_fb_addr;
+	void *cpu_inbox_addr;
+	uint64_t gpu_fb_addr;
+	uint64_t gpu_inbox_addr;
 };
 
 /**
@@ -496,8 +502,8 @@ dmub_srv_calc_region_info(struct dmub_sr
  *   DMUB_STATUS_OK - success
  *   DMUB_STATUS_INVALID - unspecified error
  */
-enum dmub_status dmub_srv_calc_fb_info(struct dmub_srv *dmub,
-				       const struct dmub_srv_fb_params *params,
+enum dmub_status dmub_srv_calc_mem_info(struct dmub_srv *dmub,
+				       const struct dmub_srv_memory_params *params,
 				       struct dmub_srv_fb_info *out);
 
 /**
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -318,7 +318,7 @@ dmub_srv_calc_region_info(struct dmub_sr
 	uint32_t fw_state_size = DMUB_FW_STATE_SIZE;
 	uint32_t trace_buffer_size = DMUB_TRACE_BUFFER_SIZE;
 	uint32_t scratch_mem_size = DMUB_SCRATCH_MEM_SIZE;
-
+	uint32_t previous_top = 0;
 	if (!dmub->sw_init)
 		return DMUB_STATUS_INVALID;
 
@@ -343,8 +343,15 @@ dmub_srv_calc_region_info(struct dmub_sr
 	bios->base = dmub_align(stack->top, 256);
 	bios->top = bios->base + params->vbios_size;
 
-	mail->base = dmub_align(bios->top, 256);
-	mail->top = mail->base + DMUB_MAILBOX_SIZE;
+	if (params->is_mailbox_in_inbox) {
+		mail->base = 0;
+		mail->top = mail->base + DMUB_MAILBOX_SIZE;
+		previous_top = bios->top;
+	} else {
+		mail->base = dmub_align(bios->top, 256);
+		mail->top = mail->base + DMUB_MAILBOX_SIZE;
+		previous_top = mail->top;
+	}
 
 	fw_info = dmub_get_fw_meta_info(params);
 
@@ -363,7 +370,7 @@ dmub_srv_calc_region_info(struct dmub_sr
 			dmub->fw_version = fw_info->fw_version;
 	}
 
-	trace_buff->base = dmub_align(mail->top, 256);
+	trace_buff->base = dmub_align(previous_top, 256);
 	trace_buff->top = trace_buff->base + dmub_align(trace_buffer_size, 64);
 
 	fw_state->base = dmub_align(trace_buff->top, 256);
@@ -374,11 +381,14 @@ dmub_srv_calc_region_info(struct dmub_sr
 
 	out->fb_size = dmub_align(scratch_mem->top, 4096);
 
+	if (params->is_mailbox_in_inbox)
+		out->inbox_size = dmub_align(mail->top, 4096);
+
 	return DMUB_STATUS_OK;
 }
 
-enum dmub_status dmub_srv_calc_fb_info(struct dmub_srv *dmub,
-				       const struct dmub_srv_fb_params *params,
+enum dmub_status dmub_srv_calc_mem_info(struct dmub_srv *dmub,
+				       const struct dmub_srv_memory_params *params,
 				       struct dmub_srv_fb_info *out)
 {
 	uint8_t *cpu_base;
@@ -393,8 +403,8 @@ enum dmub_status dmub_srv_calc_fb_info(s
 	if (params->region_info->num_regions != DMUB_NUM_WINDOWS)
 		return DMUB_STATUS_INVALID;
 
-	cpu_base = (uint8_t *)params->cpu_addr;
-	gpu_base = params->gpu_addr;
+	cpu_base = (uint8_t *)params->cpu_fb_addr;
+	gpu_base = params->gpu_fb_addr;
 
 	for (i = 0; i < DMUB_NUM_WINDOWS; ++i) {
 		const struct dmub_region *reg =
@@ -402,6 +412,12 @@ enum dmub_status dmub_srv_calc_fb_info(s
 
 		out->fb[i].cpu_addr = cpu_base + reg->base;
 		out->fb[i].gpu_addr = gpu_base + reg->base;
+
+		if (i == DMUB_WINDOW_4_MAILBOX && params->cpu_inbox_addr != 0) {
+			out->fb[i].cpu_addr = (uint8_t *)params->cpu_inbox_addr + reg->base;
+			out->fb[i].gpu_addr = params->gpu_inbox_addr + reg->base;
+		}
+
 		out->fb[i].size = reg->top - reg->base;
 	}
 


