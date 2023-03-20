Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F51C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD95C433EF;
	Mon, 20 Mar 2023 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326003;
	bh=QvcSXIXmzvexRS2Gq4ddVraMPszs0S4VB18ZYyuUotU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YG5Lp8MlqSEKqduDRet14IxIoF0wXFceBYGr5lLpsFrE4sK6GG8Ojo2ENxLT2Vflh
	 cEQpuHqv0LlQsbhes80hZQ5iei5pmTy8k//IWPxNmBqyzTKeyaPkwolRo4U95U/6ai
	 tmiTz36+xBs7x4wdeWZrciZ7IWk9D6mU2BX6Km7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatio Zhang <Hongkun.Zhang@amd.com>,
	longlyao <Longlong.Yao@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 114/211] drm/amdgpu: fix ttm_bo calltrace warning in psp_hw_fini
Date: Mon, 20 Mar 2023 15:54:09 +0100
Message-Id: <20230320145518.088107355@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatio Zhang <Hongkun.Zhang@amd.com>

[ Upstream commit 23f4a2d29ba57bf88095f817de5809d427fcbe7e ]

The call trace occurs when the amdgpu is removed after
the mode1 reset. During mode1 reset, from suspend to resume,
there is no need to reinitialize the ta firmware buffer
which caused the bo pin_count increase redundantly.

[  489.885525] Call Trace:
[  489.885525]  <TASK>
[  489.885526]  amdttm_bo_put+0x34/0x50 [amdttm]
[  489.885529]  amdgpu_bo_free_kernel+0xe8/0x130 [amdgpu]
[  489.885620]  psp_free_shared_bufs+0xb7/0x150 [amdgpu]
[  489.885720]  psp_hw_fini+0xce/0x170 [amdgpu]
[  489.885815]  amdgpu_device_fini_hw+0x2ff/0x413 [amdgpu]
[  489.885960]  ? blocking_notifier_chain_unregister+0x56/0xb0
[  489.885962]  amdgpu_driver_unload_kms+0x51/0x60 [amdgpu]
[  489.886049]  amdgpu_pci_remove+0x5a/0x140 [amdgpu]
[  489.886132]  ? __pm_runtime_resume+0x60/0x90
[  489.886134]  pci_device_remove+0x3e/0xb0
[  489.886135]  __device_release_driver+0x1ab/0x2a0
[  489.886137]  driver_detach+0xf3/0x140
[  489.886138]  bus_remove_driver+0x6c/0xf0
[  489.886140]  driver_unregister+0x31/0x60
[  489.886141]  pci_unregister_driver+0x40/0x90
[  489.886142]  amdgpu_exit+0x15/0x451 [amdgpu]

Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Signed-off-by: longlyao <Longlong.Yao@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index ba092072308fa..1b4105110f398 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1685,7 +1685,7 @@ static int psp_hdcp_initialize(struct psp_context *psp)
 	psp->hdcp_context.context.mem_context.shared_mem_size = PSP_HDCP_SHARED_MEM_SIZE;
 	psp->hdcp_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->hdcp_context.context.initialized) {
+	if (!psp->hdcp_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->hdcp_context.context.mem_context);
 		if (ret)
 			return ret;
@@ -1752,7 +1752,7 @@ static int psp_dtm_initialize(struct psp_context *psp)
 	psp->dtm_context.context.mem_context.shared_mem_size = PSP_DTM_SHARED_MEM_SIZE;
 	psp->dtm_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->dtm_context.context.initialized) {
+	if (!psp->dtm_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->dtm_context.context.mem_context);
 		if (ret)
 			return ret;
@@ -1820,7 +1820,7 @@ static int psp_rap_initialize(struct psp_context *psp)
 	psp->rap_context.context.mem_context.shared_mem_size = PSP_RAP_SHARED_MEM_SIZE;
 	psp->rap_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->rap_context.context.initialized) {
+	if (!psp->rap_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->rap_context.context.mem_context);
 		if (ret)
 			return ret;
-- 
2.39.2



