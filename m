Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E23114B080;
	Mon, 24 Feb 2025 14:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409075; cv=none; b=s24NFUTEn8TRsQ5zezsVOnGEOK147e5ReRbSQFyzG1RRGpEEGXnuFLYNHeLuHxrMyrA9fEQ4RDes9Ut7NQhbMlUZrj8qLYuDDNhri9wdhR84qQLTMv77M+4I6z2uWqNBP7gDnK14zGhFeZOLiUp2PtLag3avL6dJ2A0zAoyJ/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409075; c=relaxed/simple;
	bh=rQiKx+I+rRitL7NXRQihAxDoVKaLefB+dSoYRB4B2dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7p150aN6lBZlzI88Oug5j49RGTEz4yHXOBUttCBn684PON9NmNLLWFedKyz9ZGc6EyKUCRRhqU65DHW4nJQLN/hB4PfvOP5iDpbrywfQsIUyKvs/ugXF9ekwr0UqUSGErTAQV3XRfoTcmYw2ccX6Zgs3Q9Bsdr74yFVSsd6Fmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8+hrOvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8+hrOvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C83C4CED6;
	Mon, 24 Feb 2025 14:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409075;
	bh=rQiKx+I+rRitL7NXRQihAxDoVKaLefB+dSoYRB4B2dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8+hrOvXjsTtH+cvid9y9luf2jSTmoCoJ/9biSkiNzaEmpI+XOGXvGE+M7yUTdoeP
	 17JYTWpeSWnouvyeo9hZpAfBdDD0LorYlVQFcSjZADwddukx+RvTW0PManq3dSc8Ob
	 Gn5D2ZTSqmga7+Pg6Ei7L6P7Py2AfE87h5zoLnqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dale Whinham <daleyo@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.13 088/138] drm/msm/dp: account for widebus and yuv420 during mode validation
Date: Mon, 24 Feb 2025 15:35:18 +0100
Message-ID: <20250224142607.933773425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

commit df9cf852ca3099feb8fed781bdd5d3863af001c8 upstream.

Widebus allows the DP controller to operate in 2 pixel per clock mode.
The mode validation logic validates the mode->clock against the max
DP pixel clock. However the max DP pixel clock limit assumes widebus
is already enabled. Adjust the mode validation logic to only compare
the adjusted pixel clock which accounts for widebus against the max DP
pixel clock. Also fix the mode validation logic for YUV420 modes as in
that case as well, only half the pixel clock is needed.

Cc: stable@vger.kernel.org
Fixes: 757a2f36ab09 ("drm/msm/dp: enable widebus feature for display port")
Fixes: 6db6e5606576 ("drm/msm/dp: change clock related programming for YUV420 over DP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dale Whinham <daleyo@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/635789/
Link: https://lore.kernel.org/r/20250206-dp-widebus-fix-v2-1-cb89a0313286@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |   11 ++++++-----
 drivers/gpu/drm/msm/dp/dp_drm.c     |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -937,16 +937,17 @@ enum drm_mode_status msm_dp_bridge_mode_
 		return -EINVAL;
 	}
 
-	if (mode->clock > DP_MAX_PIXEL_CLK_KHZ)
-		return MODE_CLOCK_HIGH;
-
 	msm_dp_display = container_of(dp, struct msm_dp_display_private, msm_dp_display);
 	link_info = &msm_dp_display->panel->link_info;
 
-	if (drm_mode_is_420_only(&dp->connector->display_info, mode) &&
-	    msm_dp_display->panel->vsc_sdp_supported)
+	if ((drm_mode_is_420_only(&dp->connector->display_info, mode) &&
+	     msm_dp_display->panel->vsc_sdp_supported) ||
+	     msm_dp_wide_bus_available(dp))
 		mode_pclk_khz /= 2;
 
+	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
+		return MODE_CLOCK_HIGH;
+
 	mode_bpp = dp->connector->display_info.bpc * num_components;
 	if (!mode_bpp)
 		mode_bpp = default_bpp;
--- a/drivers/gpu/drm/msm/dp/dp_drm.c
+++ b/drivers/gpu/drm/msm/dp/dp_drm.c
@@ -257,7 +257,10 @@ static enum drm_mode_status msm_edp_brid
 		return -EINVAL;
 	}
 
-	if (mode->clock > DP_MAX_PIXEL_CLK_KHZ)
+	if (msm_dp_wide_bus_available(dp))
+		mode_pclk_khz /= 2;
+
+	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
 		return MODE_CLOCK_HIGH;
 
 	/*


