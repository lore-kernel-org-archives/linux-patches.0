Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285E778F32;
	Tue, 27 May 2025 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365316; cv=none; b=RrDXVtD2YMj3AOGbf8Ljn8n+hUljPDxyd5K2pePyzlE6FCwqITB6FQiN0sVTIDvg3MbCrr+ta8cBCl1FAKaStBLDeAzOICqRRfbSarHPecgIyWIkCoZhS1I4EdqYrlDyCl05bsRftXyNxY95qNb9nMEoql5th9C3h+8D1cwypqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365316; c=relaxed/simple;
	bh=+wQ6Opj6oJvZJ1txc+AD8H0PlhCCr7RiZn0ynRKafxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDBTAwXwpOy+ckrHVEUShCZBV32VXNTl+VXYll6Pw5kJOb8xMcmD3tne1VXuJ7kcfz+Oknnoqj/o3/sBr9YkVcFJHVZkXgk2a2Ivp8B2mSZ7lWe+6cZ4LWisEVAdGuIya7qEXoZFK1Twwso8nqXIUFw32e3fmFvLEvDFTwVY9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBgzpyzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBgzpyzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31C2C4CEE9;
	Tue, 27 May 2025 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365316;
	bh=+wQ6Opj6oJvZJ1txc+AD8H0PlhCCr7RiZn0ynRKafxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBgzpyzhZqGs24WKjx1nqll7cImueeYiWCxLLi1Jjc0aYL1Y/6CrhtICOVf28Pf5J
	 EW/TJnKiZaUklRwWJNDfcsRW3fThBQWv8sv5FTRf5+bAIutLmRAnJK8vWT3z9E0j6H
	 tZgZriaZX2dkTO/C89Ydc5Z98BqBDeHUCNH7TJG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	George Shen <george.shen@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/626] drm/amd/display: Read LTTPR ALPM caps during link cap retrieval
Date: Tue, 27 May 2025 18:23:49 +0200
Message-ID: <20250527162458.675766324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

[ Upstream commit de84d580126eb2214937df755cfec5ef0901479e ]

[Why]
The latest DP spec requires the DP TX to read DPCD F0000h through F0009h
when detecting LTTPR capabilities for the first time.

[How]
Update LTTPR cap retrieval to read up to F0009h (two more bytes than the
previous F0007h), and store the LTTPR ALPM capabilities.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h         | 12 ++++++++++++
 .../display/dc/link/protocols/link_dp_capability.c   |  6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 41bd95e9177a4..223c3d55544b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -959,6 +959,14 @@ union dp_128b_132b_supported_lttpr_link_rates {
 	uint8_t raw;
 };
 
+union dp_alpm_lttpr_cap {
+	struct {
+		uint8_t AUX_LESS_ALPM_SUPPORTED	:1;
+		uint8_t RESERVED				:7;
+	} bits;
+	uint8_t raw;
+};
+
 union dp_sink_video_fallback_formats {
 	struct {
 		uint8_t dp_1024x768_60Hz_24bpp_support	:1;
@@ -1103,6 +1111,7 @@ struct dc_lttpr_caps {
 	uint8_t max_ext_timeout;
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
+	union dp_alpm_lttpr_cap alpm;
 	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
 };
 
@@ -1352,6 +1361,9 @@ struct dp_trace {
 #ifndef DPCD_MAX_UNCOMPRESSED_PIXEL_RATE_CAP
 #define DPCD_MAX_UNCOMPRESSED_PIXEL_RATE_CAP    0x221c
 #endif
+#ifndef DP_LTTPR_ALPM_CAPABILITIES
+#define DP_LTTPR_ALPM_CAPABILITIES              0xF0009
+#endif
 #ifndef DP_REPEATER_CONFIGURATION_AND_STATUS_SIZE
 #define DP_REPEATER_CONFIGURATION_AND_STATUS_SIZE	0x50
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index d9a1e1a599674..842636c7922b4 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1495,7 +1495,7 @@ static bool dpcd_read_sink_ext_caps(struct dc_link *link)
 
 enum dc_status dp_retrieve_lttpr_cap(struct dc_link *link)
 {
-	uint8_t lttpr_dpcd_data[8] = {0};
+	uint8_t lttpr_dpcd_data[10] = {0};
 	enum dc_status status;
 	bool is_lttpr_present;
 
@@ -1545,6 +1545,10 @@ enum dc_status dp_retrieve_lttpr_cap(struct dc_link *link)
 			lttpr_dpcd_data[DP_PHY_REPEATER_128B132B_RATES -
 							DP_LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV];
 
+	link->dpcd_caps.lttpr_caps.alpm.raw =
+			lttpr_dpcd_data[DP_LTTPR_ALPM_CAPABILITIES -
+							DP_LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV];
+
 	/* If this chip cap is set, at least one retimer must exist in the chain
 	 * Override count to 1 if we receive a known bad count (0 or an invalid value) */
 	if ((link->chip_caps & EXT_DISPLAY_PATH_CAPS__DP_FIXED_VS_EN) &&
-- 
2.39.5



