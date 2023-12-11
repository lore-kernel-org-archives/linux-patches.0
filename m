Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3E251C53;
	Mon, 11 Dec 2023 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHORUTjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA11C433C8;
	Mon, 11 Dec 2023 18:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319836;
	bh=1RhTyGqILMV7GCy5vMHgQiqrsVfRlnnTEOYMOKYv1ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHORUTjoCAfcPVQj8DZrM9SawK4ehrjnCQxcq//jV+UHle71qafNiTY/HeY3pPjFf
	 ZzvaUXHPRDzzJfxO7wQUBHbsHC1/OhWnW+HjwNeWXL/6ZS4uEQoPvreKawaA5vxEv3
	 F4uXDUaQ46m9XqKRlQi0K25VUtE0L433dTQpV9pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/244] drm/amdgpu: Restrict extended wait to PSP v13.0.6
Date: Mon, 11 Dec 2023 19:22:17 +0100
Message-ID: <20231211182056.970422299@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6fce23a4d8c5f93bf80b7f122449fbb97f1e40dd ]

Only PSPv13.0.6 SOCs take a longer time to reach steady state. Other
PSPv13 based SOCs don't need extended wait. Also, reduce PSPv13.0.6 wait
time.

Cc: stable@vger.kernel.org
Fixes: fc5988907156 ("drm/amdgpu: update retry times for psp vmbx wait")
Fixes: d8c1925ba8cd ("drm/amdgpu: update retry times for psp BL wait")
Link: https://lore.kernel.org/amd-gfx/34dd4c66-f7bf-44aa-af8f-c82889dd652c@amd.com/
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index 8e4372f24f850..fe1995ed13be7 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -60,7 +60,7 @@ MODULE_FIRMWARE("amdgpu/psp_14_0_0_ta.bin");
 #define GFX_CMD_USB_PD_USE_LFB 0x480
 
 /* Retry times for vmbx ready wait */
-#define PSP_VMBX_POLLING_LIMIT 20000
+#define PSP_VMBX_POLLING_LIMIT 3000
 
 /* VBIOS gfl defines */
 #define MBOX_READY_MASK 0x80000000
@@ -161,14 +161,18 @@ static int psp_v13_0_wait_for_vmbx_ready(struct psp_context *psp)
 static int psp_v13_0_wait_for_bootloader(struct psp_context *psp)
 {
 	struct amdgpu_device *adev = psp->adev;
-	int retry_loop, ret;
+	int retry_loop, retry_cnt, ret;
 
+	retry_cnt =
+		(adev->ip_versions[MP0_HWIP][0] == IP_VERSION(13, 0, 6)) ?
+			PSP_VMBX_POLLING_LIMIT :
+			10;
 	/* Wait for bootloader to signify that it is ready having bit 31 of
 	 * C2PMSG_35 set to 1. All other bits are expected to be cleared.
 	 * If there is an error in processing command, bits[7:0] will be set.
 	 * This is applicable for PSP v13.0.6 and newer.
 	 */
-	for (retry_loop = 0; retry_loop < PSP_VMBX_POLLING_LIMIT; retry_loop++) {
+	for (retry_loop = 0; retry_loop < retry_cnt; retry_loop++) {
 		ret = psp_wait_for(
 			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_35),
 			0x80000000, 0xffffffff, false);
-- 
2.42.0



