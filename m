Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFDF9CA7B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KTFnlaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D98C433B6;
	Mon,  9 Oct 2023 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856975;
	bh=HnbnyoEZa5cRxypu0Otitc1Ztu+E6INKEEXhK+61JT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KTFnlaQbx92SLyDwA5IjAWZzlWgBOz5K2quvvh4/4MESQrLCUlEwV/S8ZeZaDTd2
	 Pd4XTQOiTKXIyKWet31wT50zgzfdmBA8l9MfsNqJtfOyt8xX8VhoocKOXyPV6Ew15S
	 4nw3G6XsUG7yumx1bqhFlF3+tWscvVz3F0EUstpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Umio Yasuno <coelacanth_dream@protonmail.com>
Subject: [PATCH 6.5 053/163] drm/amd: Fix logic error in sienna_cichlid_update_pcie_parameters()
Date: Mon,  9 Oct 2023 15:00:17 +0200
Message-ID: <20231009130125.499425583@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 2a1fe39a5be785e962e387146aed34fa9a829f3f upstream.

While aligning SMU11 with SMU13 implementation an assumption was made that
`dpm_context->dpm_tables.pcie_table` was populated in dpm table initialization
like in SMU13 but it isn't.

So restore some of the original logic and instead just check for
amdgpu_device_pcie_dynamic_switching_supported() to decide whether to hardcode
values; erring on the side of performance.

Cc: stable@vger.kernel.org # 6.1+
Reported-and-tested-by: Umio Yasuno <coelacanth_dream@protonmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1447#note_2101382
Fixes: e701156ccc6c ("drm/amd: Align SMU11 SMU_MSG_OverridePcieParameters implementation with SMU13")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |   41 ++++++++--------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2081,36 +2081,41 @@ static int sienna_cichlid_display_disabl
 	return ret;
 }
 
+#define MAX(a, b)	((a) > (b) ? (a) : (b))
+
 static int sienna_cichlid_update_pcie_parameters(struct smu_context *smu,
 					 uint32_t pcie_gen_cap,
 					 uint32_t pcie_width_cap)
 {
 	struct smu_11_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	struct smu_11_0_pcie_table *pcie_table = &dpm_context->dpm_tables.pcie_table;
-	u32 smu_pcie_arg;
+	uint8_t *table_member1, *table_member2;
+	uint32_t min_gen_speed, max_gen_speed;
+	uint32_t min_lane_width, max_lane_width;
+	uint32_t smu_pcie_arg;
 	int ret, i;
 
-	/* PCIE gen speed and lane width override */
-	if (!amdgpu_device_pcie_dynamic_switching_supported()) {
-		if (pcie_table->pcie_gen[NUM_LINK_LEVELS - 1] < pcie_gen_cap)
-			pcie_gen_cap = pcie_table->pcie_gen[NUM_LINK_LEVELS - 1];
+	GET_PPTABLE_MEMBER(PcieGenSpeed, &table_member1);
+	GET_PPTABLE_MEMBER(PcieLaneCount, &table_member2);
 
-		if (pcie_table->pcie_lane[NUM_LINK_LEVELS - 1] < pcie_width_cap)
-			pcie_width_cap = pcie_table->pcie_lane[NUM_LINK_LEVELS - 1];
+	min_gen_speed = MAX(0, table_member1[0]);
+	max_gen_speed = MIN(pcie_gen_cap, table_member1[1]);
+	min_gen_speed = min_gen_speed > max_gen_speed ?
+			max_gen_speed : min_gen_speed;
+	min_lane_width = MAX(1, table_member2[0]);
+	max_lane_width = MIN(pcie_width_cap, table_member2[1]);
+	min_lane_width = min_lane_width > max_lane_width ?
+			 max_lane_width : min_lane_width;
 
-		/* Force all levels to use the same settings */
-		for (i = 0; i < NUM_LINK_LEVELS; i++) {
-			pcie_table->pcie_gen[i] = pcie_gen_cap;
-			pcie_table->pcie_lane[i] = pcie_width_cap;
-		}
+	if (!amdgpu_device_pcie_dynamic_switching_supported()) {
+		pcie_table->pcie_gen[0] = max_gen_speed;
+		pcie_table->pcie_lane[0] = max_lane_width;
 	} else {
-		for (i = 0; i < NUM_LINK_LEVELS; i++) {
-			if (pcie_table->pcie_gen[i] > pcie_gen_cap)
-				pcie_table->pcie_gen[i] = pcie_gen_cap;
-			if (pcie_table->pcie_lane[i] > pcie_width_cap)
-				pcie_table->pcie_lane[i] = pcie_width_cap;
-		}
+		pcie_table->pcie_gen[0] = min_gen_speed;
+		pcie_table->pcie_lane[0] = min_lane_width;
 	}
+	pcie_table->pcie_gen[1] = max_gen_speed;
+	pcie_table->pcie_lane[1] = max_lane_width;
 
 	for (i = 0; i < NUM_LINK_LEVELS; i++) {
 		smu_pcie_arg = (i << 16 |


