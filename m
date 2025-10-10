Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745CB2F25FD;
	Fri, 10 Oct 2025 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102333; cv=none; b=TGJBCsS9dijRwhYPB3c86tfW2zvf+UTrV+l2y824THbGrVaDF6KnBPCU1gHjP35tW/IktDGQ9+Q1AyLVeLFJtFGJj71i69KAelbhBcCAVv/RVdm6spgHZsROvAXcMwbiScZDnevWtjYywXtgnc8jTT8KDwqPV4o9kptNNR+7m3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102333; c=relaxed/simple;
	bh=YrxyEoTgyWjhnD3IfHe9k7vMw/0OeZLfjiEnLzoJ+Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onHfO6Q1tSqeE9lhcFQHaHLZsBoyOJtxu548wembRwpa27mEK/YndV51EgW57pESNI4X5A5XCikWYIZKeqyn1BYvL34cuubzJuoCq966EhVZ0Ykfxf0M2nEDavmpzy4Ma5UENTqIk0+B4lRk/d0qzeDkxPbVgsw1Aqr9Y5hbOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHtTvFJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHtTvFJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0E1C4CEF1;
	Fri, 10 Oct 2025 13:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102333;
	bh=YrxyEoTgyWjhnD3IfHe9k7vMw/0OeZLfjiEnLzoJ+Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHtTvFJdYHkjdSKkDE+Tk1gZFBWHMZiYjm5aoezWKxRL3dsmEIKLSsDa5v0VHH5fQ
	 b9GXzUrzZLL0jsT4FgNC91vLno/Ef6cnKvC0hkmH40pWrMmo/6B0O7jb5f9mbn6oyK
	 xbO16E1wlPVZpfKOAhYeO9Sgm68WQoQhY/JIptbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.16 02/41] drm/amdgpu: Enable MES lr_compute_wa by default
Date: Fri, 10 Oct 2025 15:15:50 +0200
Message-ID: <20251010131333.511557363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1fb710793ce2619223adffaf981b1ff13cd48f17 upstream.

The MES set resources packet has an optional bit 'lr_compute_wa'
which can be used for preventing MES hangs on long compute jobs.

Set this bit by default.

Co-developed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c        |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c        |    5 +++++
 drivers/gpu/drm/amd/include/mes_v11_api_def.h |    3 ++-
 drivers/gpu/drm/amd/include/mes_v12_api_def.h |    3 ++-
 4 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -711,6 +711,12 @@ static int mes_v11_0_set_hw_resources(st
 	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
 	mes_set_hw_res_pkt.enable_level_process_quantum_check = 1;
 	mes_set_hw_res_pkt.oversubscription_timer = 50;
+	if ((mes->adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x7f)
+		mes_set_hw_res_pkt.enable_lr_compute_wa = 1;
+	else
+		dev_info_once(mes->adev->dev,
+			      "MES FW version must be >= 0x7f to enable LR compute workaround.\n");
+
 	if (amdgpu_mes_log_enable) {
 		mes_set_hw_res_pkt.enable_mes_event_int_logging = 1;
 		mes_set_hw_res_pkt.event_intr_history_gpu_mc_ptr =
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -738,6 +738,11 @@ static int mes_v12_0_set_hw_resources(st
 	mes_set_hw_res_pkt.use_different_vmid_compute = 1;
 	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
 	mes_set_hw_res_pkt.enable_level_process_quantum_check = 1;
+	if ((mes->adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x82)
+		mes_set_hw_res_pkt.enable_lr_compute_wa = 1;
+	else
+		dev_info_once(adev->dev,
+			      "MES FW version must be >= 0x82 to enable LR compute workaround.\n");
 
 	/*
 	 * Keep oversubscribe timer for sdma . When we have unmapped doorbell
--- a/drivers/gpu/drm/amd/include/mes_v11_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v11_api_def.h
@@ -238,7 +238,8 @@ union MESAPI_SET_HW_RESOURCES {
 				uint32_t enable_mes_sch_stb_log : 1;
 				uint32_t limit_single_process : 1;
 				uint32_t is_strix_tmz_wa_enabled  :1;
-				uint32_t reserved : 13;
+				uint32_t enable_lr_compute_wa : 1;
+				uint32_t reserved : 12;
 			};
 			uint32_t	uint32_t_all;
 		};
--- a/drivers/gpu/drm/amd/include/mes_v12_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v12_api_def.h
@@ -286,7 +286,8 @@ union MESAPI_SET_HW_RESOURCES {
 				uint32_t limit_single_process : 1;
 				uint32_t unmapped_doorbell_handling: 2;
 				uint32_t enable_mes_fence_int: 1;
-				uint32_t reserved : 10;
+				uint32_t enable_lr_compute_wa : 1;
+				uint32_t reserved : 9;
 			};
 			uint32_t uint32_all;
 		};


