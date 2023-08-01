Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C741FB51
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDE7C433C7;
	Tue,  1 Aug 2023 09:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882947;
	bh=OlkPUUoPvyzP/UhIh3ntP/0/LFv8iRdzIJnuWSoOlwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouHI1NjCxgVollqYXgLbtkvOrtDR4jhQ4pFrlyWGyRxHhUuaH6JoAh8sI8Ws+MoaQ
	 YHjrhefI5JbjZ0WJiBTHw85n6SFC1fugDN1S3NS2LznzZIrnB9L7Mw6SoU3w+U1mNk
	 at3lTim5eHYduI1CSKVItMKK1tNzTIQ7L2NHcWeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 032/239] drm/amd/display: Convert Delaying Aux-I Disable To Monitor Patch
Date: Tue,  1 Aug 2023 11:18:16 +0200
Message-ID: <20230801091926.774751277@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 9fa8cc0c444562fa19e20ca20f1c70e15b9d8c13 ]

[WHY]
32ms delay was added to resolve issue with a specific sink, however this same
delay also introduces erroneous link training failures with certain sink
devices.

[HOW]
Only apply the 32ms delay for offending devices instead of globally.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5a096b73c8fe ("drm/amd/display: Keep disable aux-i delay as 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h             |  1 -
 drivers/gpu/drm/amd/display/dc/dc_types.h       |  1 +
 .../link_dp_training_fixed_vs_pe_retimer.c      | 17 +++++++++++------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 4d93ca9c627b0..07d86b961c798 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -855,7 +855,6 @@ struct dc_debug_options {
 	bool force_usr_allow;
 	/* uses value at boot and disables switch */
 	bool disable_dtb_ref_clk_switch;
-	uint32_t fixed_vs_aux_delay_config_wa;
 	bool extended_blank_optimization;
 	union aux_wake_wa_options aux_wake_wa;
 	uint32_t mst_start_top_delay;
diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 45ab48fe5d004..139a77acd5d02 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -196,6 +196,7 @@ struct dc_panel_patch {
 	unsigned int disable_fams;
 	unsigned int skip_avmute;
 	unsigned int mst_start_top_delay;
+	unsigned int delay_disable_aux_intercept_ms;
 };
 
 struct dc_edid_caps {
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
index 5731c4b61f9f0..fb6c938c6dab1 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
@@ -233,7 +233,8 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence_legacy(
 			link->dpcd_caps.lttpr_caps.phy_repeater_cnt);
 	const uint8_t vendor_lttpr_write_data_intercept_en[4] = {0x1, 0x55, 0x63, 0x0};
 	const uint8_t vendor_lttpr_write_data_intercept_dis[4] = {0x1, 0x55, 0x63, 0x68};
-	uint32_t pre_disable_intercept_delay_ms = link->dc->debug.fixed_vs_aux_delay_config_wa;
+	uint32_t pre_disable_intercept_delay_ms =
+			link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
 	uint8_t vendor_lttpr_write_data_vs[4] = {0x1, 0x51, 0x63, 0x0};
 	uint8_t vendor_lttpr_write_data_pe[4] = {0x1, 0x52, 0x63, 0x0};
 	uint32_t vendor_lttpr_write_address = 0xF004F;
@@ -259,7 +260,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence_legacy(
 
 		/* Certain display and cable configuration require extra delay */
 		if (offset > 2)
-			pre_disable_intercept_delay_ms = link->dc->debug.fixed_vs_aux_delay_config_wa * 2;
+			pre_disable_intercept_delay_ms = pre_disable_intercept_delay_ms * 2;
 	}
 
 	/* Vendor specific: Reset lane settings */
@@ -380,7 +381,8 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence_legacy(
 						0);
 				/* Vendor specific: Disable intercept */
 				for (i = 0; i < max_vendor_dpcd_retries; i++) {
-					msleep(pre_disable_intercept_delay_ms);
+					if (pre_disable_intercept_delay_ms != 0)
+						msleep(pre_disable_intercept_delay_ms);
 					dpcd_status = core_link_write_dpcd(
 							link,
 							vendor_lttpr_write_address,
@@ -591,9 +593,11 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 	const uint8_t vendor_lttpr_write_data_adicora_eq1[4] = {0x1, 0x55, 0x63, 0x2E};
 	const uint8_t vendor_lttpr_write_data_adicora_eq2[4] = {0x1, 0x55, 0x63, 0x01};
 	const uint8_t vendor_lttpr_write_data_adicora_eq3[4] = {0x1, 0x55, 0x63, 0x68};
-	uint32_t pre_disable_intercept_delay_ms = link->dc->debug.fixed_vs_aux_delay_config_wa;
 	uint8_t vendor_lttpr_write_data_vs[4] = {0x1, 0x51, 0x63, 0x0};
 	uint8_t vendor_lttpr_write_data_pe[4] = {0x1, 0x52, 0x63, 0x0};
+	uint32_t pre_disable_intercept_delay_ms =
+			link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
+
 
 	uint32_t vendor_lttpr_write_address = 0xF004F;
 	enum link_training_result status = LINK_TRAINING_SUCCESS;
@@ -618,7 +622,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 
 		/* Certain display and cable configuration require extra delay */
 		if (offset > 2)
-			pre_disable_intercept_delay_ms = link->dc->debug.fixed_vs_aux_delay_config_wa * 2;
+			pre_disable_intercept_delay_ms = pre_disable_intercept_delay_ms * 2;
 	}
 
 	/* Vendor specific: Reset lane settings */
@@ -739,7 +743,8 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 						0);
 				/* Vendor specific: Disable intercept */
 				for (i = 0; i < max_vendor_dpcd_retries; i++) {
-					msleep(pre_disable_intercept_delay_ms);
+					if (pre_disable_intercept_delay_ms != 0)
+						msleep(pre_disable_intercept_delay_ms);
 					dpcd_status = core_link_write_dpcd(
 							link,
 							vendor_lttpr_write_address,
-- 
2.39.2



