Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2ED2472A2;
	Mon, 23 Jun 2025 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686127; cv=none; b=fC0HNEVYgDcRI+Auxt17rEVLQzdGkv+BBsWVFx/gTQPhcipE/fd518ZsNzUvSIeqYRMHzSP4+rRkRyCJMzO9W30gDnh9MBYA/jYKJwMHQOJ5tJPhtyIgGVU9tu9YBsDcD7rkarg/F9kdDM3h5RsHVCqZBvwtnmlWboXfUsdV8iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686127; c=relaxed/simple;
	bh=eMsDe9FnF3YlqsyhCZUpzlW31T1j+i54axV+gWK5yKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIEUNZ5gSOODyWuqd56PWXknUMPc7Gwmz7dvjQmA3T4bNvgkNqUg1plSa9RoCtwkgov5bCUnjyA3mm6vpJd07yhoCFNEuzetrjx0HzOVLZLeQYDFl9/GTRSyK3/hWB351Eo5TvPY6/vqBQD4fielR0c+gWcFbKdoyJZTAJ2ZkWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqrC8xLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqrC8xLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D566EC4CEEA;
	Mon, 23 Jun 2025 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686127;
	bh=eMsDe9FnF3YlqsyhCZUpzlW31T1j+i54axV+gWK5yKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqrC8xLavj6a6cBHA7gwYyjpcx8bf5bwpjc8D38EuanWPn85AYsQQVBAMul0ouK90
	 H30KqV/8aCqIeHKKjoQHVGTtWEp8MNrYjSL3TyCjERmtSR4uPwVrYaA3q3N0e2p9GF
	 BgLIOr/JXNitkh1TgWwysEYtDYc9ACZVyT9WqY9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Kevin Gao <kevin.gao3@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 282/592] drm/amd/display: Correct SSC enable detection for DCN351
Date: Mon, 23 Jun 2025 15:04:00 +0200
Message-ID: <20250623130707.055764256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Gao <kevin.gao3@amd.com>

[ Upstream commit d01a7306e1bec9c02268793f58144e3e42695bf0 ]

[Why]
Due to very small clock register delta between DCN35 and DCN351, clock
spread is being checked on the wrong register for DCN351, causing the
display driver to believe that DPREFCLK downspread to be disabled when
in some stacks it is enabled. This causes the clock values for audio to
be incorrect.

[How]
Both DCN351 and DCN35 use the same clk_mgr, so we modify the DCN35
function that checks for SSC enable to read CLK6 instead of CLK5 when
using DCN351. This allows us to read for DPREFCLK downspread correctly
so the clock can properly compensate when setting values.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Kevin Gao <kevin.gao3@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c | 1 +
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  | 8 +++++++-
 drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h  | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c
index 6a6ae618650b6..4607eff07253c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c
@@ -65,6 +65,7 @@
 #define mmCLK1_CLK5_ALLOW_DS 0x16EB1
 
 #define mmCLK5_spll_field_8 0x1B04B
+#define mmCLK6_spll_field_8 0x1B24B
 #define mmDENTIST_DISPCLK_CNTL 0x0124
 #define regDENTIST_DISPCLK_CNTL 0x0064
 #define regDENTIST_DISPCLK_CNTL_BASE_IDX 1
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 142de8938d7c3..bb1ac12a2b095 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -90,6 +90,7 @@
 #define mmCLK1_CLK5_ALLOW_DS 0x16EB1
 
 #define mmCLK5_spll_field_8 0x1B24B
+#define mmCLK6_spll_field_8 0x1B24B
 #define mmDENTIST_DISPCLK_CNTL 0x0124
 #define regDENTIST_DISPCLK_CNTL 0x0064
 #define regDENTIST_DISPCLK_CNTL_BASE_IDX 1
@@ -116,6 +117,7 @@
 #define DENTIST_DISPCLK_CNTL__DENTIST_DPPCLK_WDIVIDER_MASK 0x7F000000L
 
 #define CLK5_spll_field_8__spll_ssc_en_MASK 0x00002000L
+#define CLK6_spll_field_8__spll_ssc_en_MASK 0x00002000L
 
 #define SMU_VER_THRESHOLD 0x5D4A00 //93.74.0
 #undef FN
@@ -596,7 +598,11 @@ static bool dcn35_is_spll_ssc_enabled(struct clk_mgr *clk_mgr_base)
 
 	uint32_t ssc_enable;
 
-	ssc_enable = REG_READ(CLK5_spll_field_8) & CLK5_spll_field_8__spll_ssc_en_MASK;
+	if (clk_mgr_base->ctx->dce_version == DCN_VERSION_3_51) {
+		ssc_enable = REG_READ(CLK6_spll_field_8) & CLK6_spll_field_8__spll_ssc_en_MASK;
+	} else {
+		ssc_enable = REG_READ(CLK5_spll_field_8) & CLK5_spll_field_8__spll_ssc_en_MASK;
+	}
 
 	return ssc_enable != 0;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
index 221645c023b50..bac8febad69a5 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
@@ -199,6 +199,7 @@ enum dentist_divider_range {
 	CLK_SR_DCN35(CLK1_CLK4_ALLOW_DS), \
 	CLK_SR_DCN35(CLK1_CLK5_ALLOW_DS), \
 	CLK_SR_DCN35(CLK5_spll_field_8), \
+	CLK_SR_DCN35(CLK6_spll_field_8), \
 	SR(DENTIST_DISPCLK_CNTL), \
 
 #define CLK_COMMON_MASK_SH_LIST_DCN32(mask_sh) \
@@ -307,7 +308,7 @@ struct clk_mgr_registers {
 	uint32_t CLK1_CLK4_ALLOW_DS;
 	uint32_t CLK1_CLK5_ALLOW_DS;
 	uint32_t CLK5_spll_field_8;
-
+	uint32_t CLK6_spll_field_8;
 };
 
 struct clk_mgr_shift {
-- 
2.39.5



