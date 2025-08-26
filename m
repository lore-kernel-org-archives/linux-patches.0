Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA631CA74;
	Tue, 26 Aug 2025 11:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208628; cv=none; b=Kg3Wiy9MiRaNhUpbTL6y6huuX6G+zqITOyXXrAkYIBXkf1XJaqI9Yhjq9senOduq0y2y51YoRrpCXYZJ6Od/oXKY13TGHZLRRHhmTavE/xUTI35AQUy5EMJ2dTjf2Iu0XktyQn4qIb7a7BXGT8gjfEClpdANej17xWdwEKH+8+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208628; c=relaxed/simple;
	bh=qWLEXQ4w/HNTxxQIjMgSUpUf2Jqh+6svBDMksjax+vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgWxrU5pw0d5eni6CEpiiCK9pXQ1fOFLvp6QsPsoKLTxBj3iEEV6MvsU7EOBV8JsXsT4at/Bv89I5F+xZ63+mp5cVSOsm/zVog0soO1oy2vQAcXsEt/+pDMFOdCr80AoX8cfCaw9YQb8izCJ9WHXJKpGWR2unOZaqTghrArbRMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPxphfiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPxphfiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFFFC4CEF1;
	Tue, 26 Aug 2025 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208628;
	bh=qWLEXQ4w/HNTxxQIjMgSUpUf2Jqh+6svBDMksjax+vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPxphfiCHG5w8q5NZzlC3QPemhcAW5t0kn2a2a5uP/vtKp16GglNLiJYV9LNHMC4f
	 qHRTSs9/VlwIPJ3Qa9IsPR3ksIEVDhwhQn4q6sXsPkZkmuJQzgDkZTLC/7ePtjCfhQ
	 TwCn8fX8LrnEF2OnvN/RGohZ47Sf/gZBeQuhAbSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.12 185/322] drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.
Date: Tue, 26 Aug 2025 13:10:00 +0200
Message-ID: <20250826110920.433076855@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 297a4833a68aac3316eb808b4123eb016ef242d7 upstream.

On DCE 6, DP audio was not working. However, it worked when an
HDMI monitor was also plugged in.

Looking at dce_aud_wall_dto_setup it seems that the main
difference is that we use DTO1 when only DP is plugged in.

When programming DTO1, it uses audio_dto_source_clock_in_khz
which is set from get_dp_ref_freq_khz

The dce60_get_dp_ref_freq_khz implementation looks incorrect,
because DENTIST_DISPCLK_CNTL seems to be always zero on DCE 6,
so it isn't usable.
I compared dce60_get_dp_ref_freq_khz to the legacy display code,
specifically dce_v6_0_audio_set_dto, and it turns out that in
case of DCE 6, it needs to use the display clock. With that,
DP audio started working on Pitcairn, Oland and Cape Verde.

However, it still didn't work on Tahiti. Despite having the
same DCE version, Tahiti seems to have a different audio device.
After some trial and error I realized that it works with the
default display clock as reported by the VBIOS, not the current
display clock.

The patch was tested on all four SI GPUs:

* Pitcairn (DCE 6.0)
* Oland (DCE 6.4)
* Cape Verde (DCE 6.0)
* Tahiti (DCE 6.0 but different)

The testing was done on Samsung Odyssey G7 LS28BG700EPXEN on
each of the above GPUs, at the following settings:

* 4K 60 Hz
* 1080p 60 Hz
* 1080p 144 Hz

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 645cc7863da5de700547d236697dffd6760cf051)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c |   21 +++--------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
@@ -83,22 +83,13 @@ static const struct state_dependent_cloc
 static int dce60_get_dp_ref_freq_khz(struct clk_mgr *clk_mgr_base)
 {
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
-	int dprefclk_wdivider;
-	int dp_ref_clk_khz;
-	int target_div;
+	struct dc_context *ctx = clk_mgr_base->ctx;
+	int dp_ref_clk_khz = 0;
 
-	/* DCE6 has no DPREFCLK_CNTL to read DP Reference Clock source */
-
-	/* Read the mmDENTIST_DISPCLK_CNTL to get the currently
-	 * programmed DID DENTIST_DPREFCLK_WDIVIDER*/
-	REG_GET(DENTIST_DISPCLK_CNTL, DENTIST_DPREFCLK_WDIVIDER, &dprefclk_wdivider);
-
-	/* Convert DENTIST_DPREFCLK_WDIVIDERto actual divider*/
-	target_div = dentist_get_divider_from_did(dprefclk_wdivider);
-
-	/* Calculate the current DFS clock, in kHz.*/
-	dp_ref_clk_khz = (DENTIST_DIVIDER_RANGE_SCALE_FACTOR
-		* clk_mgr->base.dentist_vco_freq_khz) / target_div;
+	if (ASIC_REV_IS_TAHITI_P(ctx->asic_id.hw_internal_rev))
+		dp_ref_clk_khz = ctx->dc_bios->fw_info.default_display_engine_pll_frequency;
+	else
+		dp_ref_clk_khz = clk_mgr_base->clks.dispclk_khz;
 
 	return dce_adjust_dp_ref_freq_for_ss(clk_mgr, dp_ref_clk_khz);
 }


