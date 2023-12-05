Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65F86FAF;
	Tue,  5 Dec 2023 03:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/pkPxfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBC5C433C8;
	Tue,  5 Dec 2023 03:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746713;
	bh=6uP7XktiQJXY5JqILQXJEIPv4l5g0kdnK9+B53VcHCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/pkPxfAQGzqu0Vo9oMwjJvW1C55H3UEfY7k7vX3BPtTq9nhOngkRE8n35JrXgcIf
	 XtyH/IxlFqRU77iWmnOwLdCmPEJkuLPKTtZ7ZIDp+kdBASNzXmvu58rMh+BUaba1Tc
	 hkj2nROUXq03YGVA8XtObWKuCy7EFgj2J/54y95Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Koo <anthony.koo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sherry Wang <yao.wang1@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/134] drm/amd/display: refactor ILR to make it work
Date: Tue,  5 Dec 2023 12:16:39 +0900
Message-ID: <20231205031543.500288223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Sherry Wang <yao.wang1@amd.com>

[ Upstream commit 6ec876472ff7edeaf2a07bf6afbff74d7f1dfa35 ]

[Why]
Current ILR toggle is on/off as a part of panel
config for new function, which breaks original
ILR logic

[How]
Refactor ILR and take panel config into account

Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sherry Wang <yao.wang1@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d9e865826c20 ("drm/amd/display: Simplify brightness initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/link_detection.c  |  6 ++++++
 .../dc/link/protocols/link_dp_capability.c    | 14 ++++---------
 .../link/protocols/link_edp_panel_control.c   | 21 +++++++++++++++++--
 .../link/protocols/link_edp_panel_control.h   |  2 ++
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_detection.c b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
index e682d27e098f8..b3d3e46c466b3 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1166,6 +1166,12 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			dm_helpers_init_panel_settings(dc_ctx, &link->panel_config, sink);
 			// Override dc_panel_config if system has specific settings
 			dm_helpers_override_panel_settings(dc_ctx, &link->panel_config);
+
+			//sink only can use supported link rate table, we are foreced to enable it
+			if (link->reported_link_cap.link_rate == LINK_RATE_UNKNOWN)
+				link->panel_config.ilr.optimize_edp_link_rate = true;
+			if (edp_is_ilr_optimization_enabled(link))
+				link->reported_link_cap.link_rate = get_max_link_rate_from_ilr_table(link);
 		}
 
 	} else {
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 237e0ff955f3c..db87aa7b5c90f 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -707,8 +707,7 @@ bool edp_decide_link_settings(struct dc_link *link,
 	 * edp_supported_link_rates_count is only valid for eDP v1.4 or higher.
 	 * Per VESA eDP spec, "The DPCD revision for eDP v1.4 is 13h"
 	 */
-	if (link->dpcd_caps.dpcd_rev.raw < DPCD_REV_13 ||
-			link->dpcd_caps.edp_supported_link_rates_count == 0) {
+	if (!edp_is_ilr_optimization_enabled(link)) {
 		*link_setting = link->verified_link_cap;
 		return true;
 	}
@@ -772,8 +771,7 @@ bool decide_edp_link_settings_with_dsc(struct dc_link *link,
 	 * edp_supported_link_rates_count is only valid for eDP v1.4 or higher.
 	 * Per VESA eDP spec, "The DPCD revision for eDP v1.4 is 13h"
 	 */
-	if ((link->dpcd_caps.dpcd_rev.raw < DPCD_REV_13 ||
-			link->dpcd_caps.edp_supported_link_rates_count == 0)) {
+	if (!edp_is_ilr_optimization_enabled(link)) {
 		/* for DSC enabled case, we search for minimum lane count */
 		memset(&initial_link_setting, 0, sizeof(initial_link_setting));
 		initial_link_setting.lane_count = LANE_COUNT_ONE;
@@ -1938,9 +1936,7 @@ void detect_edp_sink_caps(struct dc_link *link)
 	 * edp_supported_link_rates_count is only valid for eDP v1.4 or higher.
 	 * Per VESA eDP spec, "The DPCD revision for eDP v1.4 is 13h"
 	 */
-	if (link->dpcd_caps.dpcd_rev.raw >= DPCD_REV_13 &&
-			(link->panel_config.ilr.optimize_edp_link_rate ||
-			link->reported_link_cap.link_rate == LINK_RATE_UNKNOWN)) {
+	if (link->dpcd_caps.dpcd_rev.raw >= DPCD_REV_13) {
 		// Read DPCD 00010h - 0001Fh 16 bytes at one shot
 		core_link_read_dpcd(link, DP_SUPPORTED_LINK_RATES,
 							supported_link_rates, sizeof(supported_link_rates));
@@ -1958,12 +1954,10 @@ void detect_edp_sink_caps(struct dc_link *link)
 				link_rate = linkRateInKHzToLinkRateMultiplier(link_rate_in_khz);
 				link->dpcd_caps.edp_supported_link_rates[link->dpcd_caps.edp_supported_link_rates_count] = link_rate;
 				link->dpcd_caps.edp_supported_link_rates_count++;
-
-				if (link->reported_link_cap.link_rate < link_rate)
-					link->reported_link_cap.link_rate = link_rate;
 			}
 		}
 	}
+
 	core_link_read_dpcd(link, DP_EDP_BACKLIGHT_ADJUSTMENT_CAP,
 						&backlight_adj_cap, sizeof(backlight_adj_cap));
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index 24b47fa82f93c..e1708c296b7df 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -300,6 +300,24 @@ bool set_cached_brightness_aux(struct dc_link *link)
 		return set_default_brightness_aux(link);
 	return false;
 }
+bool edp_is_ilr_optimization_enabled(struct dc_link *link)
+{
+	if (link->dpcd_caps.edp_supported_link_rates_count == 0 || !link->panel_config.ilr.optimize_edp_link_rate)
+		return false;
+	return true;
+}
+
+enum dc_link_rate get_max_link_rate_from_ilr_table(struct dc_link *link)
+{
+	enum dc_link_rate link_rate = link->reported_link_cap.link_rate;
+
+	for (int i = 0; i < link->dpcd_caps.edp_supported_link_rates_count; i++) {
+		if (link_rate < link->dpcd_caps.edp_supported_link_rates[i])
+			link_rate = link->dpcd_caps.edp_supported_link_rates[i];
+	}
+
+	return link_rate;
+}
 
 bool edp_is_ilr_optimization_required(struct dc_link *link,
 		struct dc_crtc_timing *crtc_timing)
@@ -312,8 +330,7 @@ bool edp_is_ilr_optimization_required(struct dc_link *link,
 
 	ASSERT(link || crtc_timing); // invalid input
 
-	if (link->dpcd_caps.edp_supported_link_rates_count == 0 ||
-			!link->panel_config.ilr.optimize_edp_link_rate)
+	if (!edp_is_ilr_optimization_enabled(link))
 		return false;
 
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.h b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.h
index 20f91de852e30..ebf7deb63d136 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.h
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.h
@@ -64,6 +64,8 @@ bool edp_get_replay_state(const struct dc_link *link, uint64_t *state);
 bool edp_wait_for_t12(struct dc_link *link);
 bool edp_is_ilr_optimization_required(struct dc_link *link,
        struct dc_crtc_timing *crtc_timing);
+bool edp_is_ilr_optimization_enabled(struct dc_link *link);
+enum dc_link_rate get_max_link_rate_from_ilr_table(struct dc_link *link);
 bool edp_backlight_enable_aux(struct dc_link *link, bool enable);
 void edp_add_delay_for_T9(struct dc_link *link);
 bool edp_receiver_ready_T9(struct dc_link *link);
-- 
2.42.0



