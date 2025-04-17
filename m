Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF2F256C7A;
	Thu, 17 Apr 2025 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914343; cv=none; b=AF3HbuvPuriNaSQeDLbJgYVcBo8P/EGYL3CR5J++cpmnUDdy7p0AkOBCiiRstZnBTfYE8abjZSw+BY8ZSmhgnRLnqR8QowLOIGnIt5N3dpFAfR4W1NcipNVrHhzP61zCiGbB8sDtES6TrolJrqjHcS3gtMDX49Hfptx9VY06n2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914343; c=relaxed/simple;
	bh=RQtp9l+WHFSpbHY4vRBHqM1plfi2otgoXUQYAb4ts9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcOF835TuYQ9Zha8qeJAyvB9pfgRXUJDgYNKNM+EmLAa/a7JGFAspF1tzCTcsP6a/wVp2pZPlFhsOG/LhXoT62+pe0fThVqTRJPYSjGKTl492HE2FuMBnYzvymt2/w/AgPCzVr5EEqKXz4uXqGDfxphgO8hVLuyHzf1l4qZzkWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p11sYs2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p11sYs2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DEEC4CEE4;
	Thu, 17 Apr 2025 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914343;
	bh=RQtp9l+WHFSpbHY4vRBHqM1plfi2otgoXUQYAb4ts9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p11sYs2hdjvziMLi8Uw0wdU2zwykPWrFax1Ev0b98kKu+FQ33rl0iwbRcN4JIs4b+
	 5nD7krGnaLadlIz53vSRBajGK8OKhzQX3yDgo5Y3mlZNsAS2i5OgbMxcmXvvdJbaW0
	 QkSUkzYkMg4Er3+MfECxwtd/v6wOE1HhueWg+qso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 143/414] drm/amd/display: Update FIXED_VS Link Rate Toggle Workaround Usage
Date: Thu, 17 Apr 2025 19:48:21 +0200
Message-ID: <20250417175117.180252774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 7c6518c1c73199a230b5fc55ddfed3e5b9dc3290 ]

[WHY]
Previously the 128b/132b LTTPR support DPCD field was used to decide if
FIXED_VS training sequence required a rate toggle before initiating LT.

When running DP2.1 4.9.x.x compliance tests, emulated LTTPRs can report
no-128b/132b support which is then forwarded by the FIXED_VS retimer.
As a result this test exposes the rate toggle again, erroneously causing
failures as certain compliance sinks don't expect this behaviour.

[HOW]
Add new DPCD register defines/reads to read LTTPR IEEE OUI and device ID.

Decide whether to perform the rate toggle based on the LTTPR's IEEE OUI
which guarantees that we only perform the toggle on affected retimers.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h         |  8 ++++++++
 .../display/dc/link/protocols/link_dp_capability.c   | 12 ++++++++++--
 .../protocols/link_dp_training_fixed_vs_pe_retimer.c |  3 ++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 8dd6eb044829a..aecaf06ba9990 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -1104,6 +1104,8 @@ struct dc_lttpr_caps {
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
 	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t lttpr_ieee_oui[3];
+	uint8_t lttpr_device_id[6];
 };
 
 struct dc_dongle_dfp_cap_ext {
@@ -1363,6 +1365,12 @@ struct dp_trace {
 #ifndef DP_BRANCH_VENDOR_SPECIFIC_START
 #define DP_BRANCH_VENDOR_SPECIFIC_START     0x50C
 #endif
+#ifndef DP_LTTPR_IEEE_OUI
+#define DP_LTTPR_IEEE_OUI 0xF003D
+#endif
+#ifndef DP_LTTPR_DEVICE_ID
+#define DP_LTTPR_DEVICE_ID 0xF0040
+#endif
 /** USB4 DPCD BW Allocation Registers Chapter 10.7 **/
 #ifndef DP_TUNNELING_CAPABILITIES
 #define DP_TUNNELING_CAPABILITIES			0xE000D /* 1.4a */
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 9dabaf682171d..d5d1f5ffd4fd8 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1568,10 +1568,18 @@ enum dc_status dp_retrieve_lttpr_cap(struct dc_link *link)
 	/* Attempt to train in LTTPR transparent mode if repeater count exceeds 8. */
 	is_lttpr_present = dp_is_lttpr_present(link);
 
-	if (is_lttpr_present)
+	DC_LOG_DC("is_lttpr_present = %d\n", is_lttpr_present);
+
+	if (is_lttpr_present) {
 		CONN_DATA_DETECT(link, lttpr_dpcd_data, sizeof(lttpr_dpcd_data), "LTTPR Caps: ");
 
-	DC_LOG_DC("is_lttpr_present = %d\n", is_lttpr_present);
+		core_link_read_dpcd(link, DP_LTTPR_IEEE_OUI, link->dpcd_caps.lttpr_caps.lttpr_ieee_oui, sizeof(link->dpcd_caps.lttpr_caps.lttpr_ieee_oui));
+		CONN_DATA_DETECT(link, link->dpcd_caps.lttpr_caps.lttpr_ieee_oui, sizeof(link->dpcd_caps.lttpr_caps.lttpr_ieee_oui), "LTTPR IEEE OUI: ");
+
+		core_link_read_dpcd(link, DP_LTTPR_DEVICE_ID, link->dpcd_caps.lttpr_caps.lttpr_device_id, sizeof(link->dpcd_caps.lttpr_caps.lttpr_device_id));
+		CONN_DATA_DETECT(link, link->dpcd_caps.lttpr_caps.lttpr_device_id, sizeof(link->dpcd_caps.lttpr_caps.lttpr_device_id), "LTTPR Device ID: ");
+	}
+
 	return status;
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
index ccf8096dde290..ce174ce5579c0 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
@@ -270,7 +270,8 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 
 	rate = get_dpcd_link_rate(&lt_settings->link_settings);
 
-	if (!link->dpcd_caps.lttpr_caps.main_link_channel_coding.bits.DP_128b_132b_SUPPORTED) {
+	// Only perform toggle if FIXED_VS LTTPR reports no IEEE OUI
+	if (memcmp("\x0,\x0,\x0", &link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
 		/* Vendor specific: Toggle link rate */
 		toggle_rate = (rate == 0x6) ? 0xA : 0x6;
 
-- 
2.39.5



