Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BBEFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C792C433D2;
	Mon, 15 May 2023 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170585;
	bh=/BZDfdZh+7pjby76Bk5kvnrPm/wW7RJBSV9FyR+uujE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uC1NFWER4TLQ9tmm8vCnIJKmEnVZjsLRFRbbDVLoL1mvJTb1nVEw5j0zVxKti/Ei
	 cQsEEep3CX9TAPBy6fIwDJ4mQPu07WwoHb2asFkJzoT50zwW8hNbc2TumiuLtjy965
	 f8/x8ETTQXTzyisjarY9BPJ1NzsqT7KG52nvwJQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Graham Sider <Graham.Sider@amd.com>,
	Jack Xiao <Jack.Xiao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 176/239] drm/amdgpu: remove deprecated MES version vars
Date: Mon, 15 May 2023 18:27:19 +0200
Message-Id: <20230515161726.944845799@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Graham Sider <Graham.Sider@amd.com>

commit 6040517e4a29d3828160c571681eec9ffe10043f upstream.

MES scheduler and kiq versions are stored in mes.sched_version and
mes.kiq_version, respectively, which are read from a register after
their queues are initialized. Remove mes.ucode_fw_version and
mes.data_fw_version which tried to read this versioning info from the
firmware headers (which don't contain this information).

Signed-off-by: Graham Sider <Graham.Sider@amd.com>
Reviewed-by: Jack Xiao <Jack.Xiao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h |    2 --
 drivers/gpu/drm/amd/amdgpu/mes_v10_1.c  |    4 ----
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c  |    4 ----
 3 files changed, 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -91,14 +91,12 @@ struct amdgpu_mes {
 	struct amdgpu_bo		*ucode_fw_obj[AMDGPU_MAX_MES_PIPES];
 	uint64_t			ucode_fw_gpu_addr[AMDGPU_MAX_MES_PIPES];
 	uint32_t			*ucode_fw_ptr[AMDGPU_MAX_MES_PIPES];
-	uint32_t                        ucode_fw_version[AMDGPU_MAX_MES_PIPES];
 	uint64_t                        uc_start_addr[AMDGPU_MAX_MES_PIPES];
 
 	/* mes ucode data */
 	struct amdgpu_bo		*data_fw_obj[AMDGPU_MAX_MES_PIPES];
 	uint64_t			data_fw_gpu_addr[AMDGPU_MAX_MES_PIPES];
 	uint32_t			*data_fw_ptr[AMDGPU_MAX_MES_PIPES];
-	uint32_t                        data_fw_version[AMDGPU_MAX_MES_PIPES];
 	uint64_t                        data_start_addr[AMDGPU_MAX_MES_PIPES];
 
 	/* eop gpu obj */
--- a/drivers/gpu/drm/amd/amdgpu/mes_v10_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v10_1.c
@@ -415,10 +415,6 @@ static int mes_v10_1_init_microcode(stru
 
 	mes_hdr = (const struct mes_firmware_header_v1_0 *)
 		adev->mes.fw[pipe]->data;
-	adev->mes.ucode_fw_version[pipe] =
-		le32_to_cpu(mes_hdr->mes_ucode_version);
-	adev->mes.ucode_fw_version[pipe] =
-		le32_to_cpu(mes_hdr->mes_ucode_data_version);
 	adev->mes.uc_start_addr[pipe] =
 		le32_to_cpu(mes_hdr->mes_uc_start_addr_lo) |
 		((uint64_t)(le32_to_cpu(mes_hdr->mes_uc_start_addr_hi)) << 32);
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -484,10 +484,6 @@ static int mes_v11_0_init_microcode(stru
 
 	mes_hdr = (const struct mes_firmware_header_v1_0 *)
 		adev->mes.fw[pipe]->data;
-	adev->mes.ucode_fw_version[pipe] =
-		le32_to_cpu(mes_hdr->mes_ucode_version);
-	adev->mes.ucode_fw_version[pipe] =
-		le32_to_cpu(mes_hdr->mes_ucode_data_version);
 	adev->mes.uc_start_addr[pipe] =
 		le32_to_cpu(mes_hdr->mes_uc_start_addr_lo) |
 		((uint64_t)(le32_to_cpu(mes_hdr->mes_uc_start_addr_hi)) << 32);


