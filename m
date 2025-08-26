Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E421917ED;
	Tue, 26 Aug 2025 13:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215139; cv=none; b=qSisUEMMmYEKC3Jdz++j4Anjq9wnnK2uEToDTvVXo167SNm5ducQ47EDedDUHkwPLi8OR9jkNScuqNuiZ6BrmX1SE9FJFTqJV/tD+dwxpx9/CjLxulkMGznr5upF+WCt2xTraMOzYtP6gaEkypuIzU11k80TvYNJLW6xlBQx+Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215139; c=relaxed/simple;
	bh=lqXn9C9dv5lpdDgTgMKQIcU+te/3c1+/QdbQTUIPXu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1frnn3HWFExzDxunH1E562TRQGVp9bm6cK51MwsJz4wLuSxvaZEt70gP2Yq4/dEp3+Fs+JfKPuvd9EGqWtB4MBcDDOmJMixqKukLaXa+8sOzSqR9Y/5UnYwWfknCNSHFZDSrreUm6W6uNEyHHHHWNWEbj86r/rEPi7Eavc5YGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNwM797G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNwM797G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A36FC4CEF1;
	Tue, 26 Aug 2025 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215139;
	bh=lqXn9C9dv5lpdDgTgMKQIcU+te/3c1+/QdbQTUIPXu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNwM797G6tdQeiOqbZx0WHa5lY/AeKT2AgDr/3b11fY2eJqml+F22qXcMCrzFLVN0
	 XuKwhIsO2n1nmAOlksSEhQaP6225Cv/D2EIOXrvhQjLJDR2X7xmRH+x83jQ5BlKTNV
	 k/OlzqRBaGMHyHkiE/sDjtdPapzJ+t+nKqJpJAkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.1 402/482] drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.
Date: Tue, 26 Aug 2025 13:10:55 +0200
Message-ID: <20250826110940.759358244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


