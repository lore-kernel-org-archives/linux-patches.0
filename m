Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026528ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2089FC433EF;
	Mon, 12 Dec 2022 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852809;
	bh=83ndlwg9IoSxuyPFXnTOhVN1N/G3Mew6oEjsWoD86lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOfJksHZDvjx9WJnqllQsF3uNxmqOSBPzf1lSGGJ/3NTqsyNDr9TPYBKrhfQSjDqX
	 36SZhkqkfh2tpSpfM2Hd4LukZbeMTyNw1BaGUuYrlt8mrkPp8h6GjrzVp548CtCSmr
	 lrOPsNr8SwwKpNYfw+eThJ/HkqjAwYQcv2Y8EEN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.0 157/157] drm/amdgpu/vcn: update vcn4 fw shared data structure
Date: Mon, 12 Dec 2022 14:18:25 +0100
Message-Id: <20221212130941.616646357@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruijing Dong <ruijing.dong@amd.com>

commit 167be8522821fd38636410103e1c154b589cb1d9 upstream.

update VF_RB_SETUP_FLAG, add SMU_DPM_INTERFACE_FLAG,
and corresponding change in VCN4.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Hand modified large dependency of commit aa44beb5f0155 ("drm/amdgpu/vcn: Add sriov VCN v4_0 unified queue support")
  This no longer updates VF_RB_SETUP_FLAG, but just adds SMU_DPM_INTERFACE_FLAG. ]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |    7 +++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   |    4 ++++
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -161,6 +161,7 @@
 #define AMDGPU_VCN_SW_RING_FLAG		(1 << 9)
 #define AMDGPU_VCN_FW_LOGGING_FLAG	(1 << 10)
 #define AMDGPU_VCN_SMU_VERSION_INFO_FLAG (1 << 11)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG (1 << 11)
 
 #define AMDGPU_VCN_IB_FLAG_DECODE_BUFFER	0x00000001
 #define AMDGPU_VCN_CMD_FLAG_MSG_BUFFER		0x00000001
@@ -170,6 +171,9 @@
 #define VCN_CODEC_DISABLE_MASK_HEVC (1 << 2)
 #define VCN_CODEC_DISABLE_MASK_H264 (1 << 3)
 
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU (0)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_APU (1)
+
 enum fw_queue_mode {
 	FW_QUEUE_RING_RESET = 1,
 	FW_QUEUE_DPG_HOLD_OFF = 2,
@@ -323,6 +327,9 @@ struct amdgpu_vcn4_fw_shared {
 	struct amdgpu_fw_shared_unified_queue_struct sq;
 	uint8_t pad1[8];
 	struct amdgpu_fw_shared_fw_logging fw_log;
+	uint8_t pad2[20];
+	uint32_t pad3[13];
+	struct amdgpu_fw_shared_smu_interface_info smu_dpm_interface;
 };
 
 struct amdgpu_vcn_fwlog {
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -132,6 +132,10 @@ static int vcn_v4_0_sw_init(void *handle
 		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
 		fw_shared->sq.is_enabled = 1;
 
+		fw_shared->present_flag_0 |= cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
+		fw_shared->smu_dpm_interface.smu_interface_type = (adev->flags & AMD_IS_APU) ?
+			AMDGPU_VCN_SMU_DPM_INTERFACE_APU : AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
+
 		if (amdgpu_vcnfw_log)
 			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
 	}


