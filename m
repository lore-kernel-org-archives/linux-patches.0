Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53F81D04BE;
	Wed,  2 Oct 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878676; cv=none; b=ky32cU2gydSLl2rgup3nHk8hx9NaWUwIaG89ILKUgBbyJ/wnxluIOTzSjpzSiE+RNJIIjqG/8wxNr/CpECL0aRI8RwMqVCGn6+UF7CNQyf5RxemuB/17INe43p+9LSfZbGZYQsn0Bditpj4UOijSPTYQfUAvufMzHqVKDsaZv5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878676; c=relaxed/simple;
	bh=0G8U+Mu2Z2h92jB3UMyyqIaw4GLPzzOtJqyGomq+YyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVwbDARnncLkj0FkfZp70Oz1DMKv/t+z+Y3259f3C+W342IMz/dN3fn+luUpp0H6pMXJJ90Aya7ALsM9xcQOAZIYvdejPiytn7YGzBSmaCIILUBGeaSBk6mvYubXFBgzHda1XddwZgTT5A13Shsy0cic7f4/d/+XmhpFs1kqIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VU0o0Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VU0o0Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F397C4CEC2;
	Wed,  2 Oct 2024 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878675;
	bh=0G8U+Mu2Z2h92jB3UMyyqIaw4GLPzzOtJqyGomq+YyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VU0o0Vn6/zKndyV1vMPen8gDDzGEZ7LFnSg7l8WNhJfq53KstE7Hqp3hdUSgiCWR
	 UyYkabr08LZbHt3D+fmw/wwvQ1Tp0PU3aye5/uWL7XJtDYE/+O3WeqpEIx8seT8TSw
	 54JacOR6bb71aeX82+X4ZthLnlalxtPcAVWWvrRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Martin Tsai <martin.tsai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 494/634] drm/amd/display: Clean up dsc blocks in accelerated mode
Date: Wed,  2 Oct 2024 14:59:54 +0200
Message-ID: <20241002125830.598855756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tsai <martin.tsai@amd.com>

commit 3766a840e093d30e1a2522f650d8a6ac892a8719 upstream.

[WHY]
DSC on eDP could be enabled during VBIOS post. The enabled
DSC may not be disabled when enter to OS, once the system was
in second screen only mode before entering to S4. In this
case, OS will not send setTimings to reset eDP path again.

The enabled DSC HW will make a new stream without DSC cannot
output normally if it reused this pipe with enabled DSC.

[HOW]
In accelerated mode, to clean up DSC blocks if eDP is on link
but not active when we are not in fast boot and seamless boot.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Martin Tsai <martin.tsai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |   50 ++++++++++++++
 1 file changed, 50 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -57,6 +57,7 @@
 #include "panel_cntl.h"
 #include "dc_state_priv.h"
 #include "dpcd_defs.h"
+#include "dsc.h"
 /* include DCE11 register header files */
 #include "dce/dce_11_0_d.h"
 #include "dce/dce_11_0_sh_mask.h"
@@ -1768,6 +1769,48 @@ static void get_edp_links_with_sink(
 	}
 }
 
+static void clean_up_dsc_blocks(struct dc *dc)
+{
+	struct display_stream_compressor *dsc = NULL;
+	struct timing_generator *tg = NULL;
+	struct stream_encoder *se = NULL;
+	struct dccg *dccg = dc->res_pool->dccg;
+	struct pg_cntl *pg_cntl = dc->res_pool->pg_cntl;
+	int i;
+
+	if (dc->ctx->dce_version != DCN_VERSION_3_5 &&
+		dc->ctx->dce_version != DCN_VERSION_3_51)
+		return;
+
+	for (i = 0; i < dc->res_pool->res_cap->num_dsc; i++) {
+		struct dcn_dsc_state s  = {0};
+
+		dsc = dc->res_pool->dscs[i];
+		dsc->funcs->dsc_read_state(dsc, &s);
+		if (s.dsc_fw_en) {
+			/* disable DSC in OPTC */
+			if (i < dc->res_pool->timing_generator_count) {
+				tg = dc->res_pool->timing_generators[i];
+				tg->funcs->set_dsc_config(tg, OPTC_DSC_DISABLED, 0, 0);
+			}
+			/* disable DSC in stream encoder */
+			if (i < dc->res_pool->stream_enc_count) {
+				se = dc->res_pool->stream_enc[i];
+				se->funcs->dp_set_dsc_config(se, OPTC_DSC_DISABLED, 0, 0);
+				se->funcs->dp_set_dsc_pps_info_packet(se, false, NULL, true);
+			}
+			/* disable DSC block */
+			if (dccg->funcs->set_ref_dscclk)
+				dccg->funcs->set_ref_dscclk(dccg, dsc->inst);
+			dsc->funcs->dsc_disable(dsc);
+
+			/* power down DSC */
+			if (pg_cntl != NULL)
+				pg_cntl->funcs->dsc_pg_control(pg_cntl, dsc->inst, false);
+		}
+	}
+}
+
 /*
  * When ASIC goes from VBIOS/VGA mode to driver/accelerated mode we need:
  *  1. Power down all DC HW blocks
@@ -1852,6 +1895,13 @@ void dce110_enable_accelerated_mode(stru
 		clk_mgr_exit_optimized_pwr_state(dc, dc->clk_mgr);
 
 		power_down_all_hw_blocks(dc);
+
+		/* DSC could be enabled on eDP during VBIOS post.
+		 * To clean up dsc blocks if eDP is in link but not active.
+		 */
+		if (edp_link_with_sink && (edp_stream_num == 0))
+			clean_up_dsc_blocks(dc);
+
 		disable_vga_and_power_gate_all_controllers(dc);
 		if (edp_link_with_sink && !keep_edp_vdd_on)
 			dc->hwss.edp_power_control(edp_link_with_sink, false);


