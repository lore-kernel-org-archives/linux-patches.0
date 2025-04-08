Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCB72690DB;
	Tue,  8 Apr 2025 11:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113124; cv=none; b=gEQDbkTVXJEu86L6uUkw0Ds7Ro9Fa5XbeKHEN0e6BMbFn+iJxwxFMfrxUL/jOEo0mHtnql5TmV8g2RemZAEVaSp6WPzd+gUw7jh3Mlh9RfWquMWMdj+qSdkAzP8Fkns9ulQgcIlKAxVXngUg9MiN3umAT2Kqd8ATVq5pwPcOUBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113124; c=relaxed/simple;
	bh=xn6NZmAjeh8dnIKS9Cz9YLAJ9J+XT7FaW7dB2Tuce+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSRXx1+JZSzMun80zaWA72PiMgMykHNJ3ZO9hOVLLlgjVAewLHANKXuj4RsCTMeRZxX/G48jiVl69nJlNQdebyVsP/Zql4YdfeLg6B03YUQgwhGjAsu5dco6XCv4x7vRnP1JvIRcgs1ZxO/ljjrh80HhlJItHEBts4Xwxhcnrf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIm4Exgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIm4Exgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CC4C4CEE7;
	Tue,  8 Apr 2025 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113123;
	bh=xn6NZmAjeh8dnIKS9Cz9YLAJ9J+XT7FaW7dB2Tuce+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIm4ExgspxwDxqXXyq/A2joEgRXNVt6OMaWSkUiZiei4dw+3dXmP0Q/wiLcKa56Ck
	 ilu/5aVNWLi91PtQfdn7OyObgsYGphoTXZEzr3hWh7gWQkpbpu+3x0u9xwJHbpypHh
	 M6KDvA+leekVdaAk+mD/WcPaeJcPaLdmhwoou9tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/268] drm/msm/dsi: Use existing per-interface slice count in DSC timing
Date: Tue,  8 Apr 2025 12:47:33 +0200
Message-ID: <20250408104829.639657788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 14ad809ceb66d0874cbe4bd5ca9edf0de8d9ad96 ]

When configuring the timing of DSI hosts (interfaces) in
dsi_timing_setup() all values written to registers are taking
bonded-mode into account by dividing the original mode width by 2
(half the data is sent over each of the two DSI hosts), but the full
width instead of the interface width is passed as hdisplay parameter to
dsi_update_dsc_timing().

Currently only msm_dsc_get_slices_per_intf() is called within
dsi_update_dsc_timing() with the `hdisplay` argument which clearly
documents that it wants the width of a single interface (which, again,
in bonded DSI mode is half the total width of the mode) resulting in all
subsequent values to be completely off.

However, as soon as we start to pass the halved hdisplay
into dsi_update_dsc_timing() we might as well discard
msm_dsc_get_slices_per_intf() since the value it calculates is already
available in dsc->slice_count which is per-interface by the current
design of MSM DPU/DSI implementations and their use of the DRM DSC
helpers.

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/637648/
Link: https://lore.kernel.org/r/20250217-drm-msm-initial-dualpipe-dsc-fixes-v3-1-913100d6103f@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c   |  8 ++++----
 drivers/gpu/drm/msm/msm_dsc_helper.h | 11 -----------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index f920329fe2e09..f90ccdfbb2fc7 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -825,7 +825,7 @@ static void dsi_ctrl_enable(struct msm_dsi_host *msm_host,
 		dsi_write(msm_host, REG_DSI_CPHY_MODE_CTRL, BIT(0));
 }
 
-static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mode, u32 hdisplay)
+static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mode)
 {
 	struct drm_dsc_config *dsc = msm_host->dsc;
 	u32 reg, reg_ctrl, reg_ctrl2;
@@ -837,7 +837,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	/* first calculate dsc parameters and then program
 	 * compress mode registers
 	 */
-	slice_per_intf = msm_dsc_get_slices_per_intf(dsc, hdisplay);
+	slice_per_intf = dsc->slice_count;
 
 	total_bytes_per_intf = dsc->slice_chunk_size * slice_per_intf;
 	bytes_per_pkt = dsc->slice_chunk_size; /* * slice_per_pkt; */
@@ -948,7 +948,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 	if (msm_host->mode_flags & MIPI_DSI_MODE_VIDEO) {
 		if (msm_host->dsc)
-			dsi_update_dsc_timing(msm_host, false, mode->hdisplay);
+			dsi_update_dsc_timing(msm_host, false);
 
 		dsi_write(msm_host, REG_DSI_ACTIVE_H,
 			DSI_ACTIVE_H_START(ha_start) |
@@ -969,7 +969,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 			DSI_ACTIVE_VSYNC_VPOS_END(vs_end));
 	} else {		/* command mode */
 		if (msm_host->dsc)
-			dsi_update_dsc_timing(msm_host, true, mode->hdisplay);
+			dsi_update_dsc_timing(msm_host, true);
 
 		/* image data and 1 byte write_memory_start cmd */
 		if (!msm_host->dsc)
diff --git a/drivers/gpu/drm/msm/msm_dsc_helper.h b/drivers/gpu/drm/msm/msm_dsc_helper.h
index b9049fe1e2790..63f95523b2cbb 100644
--- a/drivers/gpu/drm/msm/msm_dsc_helper.h
+++ b/drivers/gpu/drm/msm/msm_dsc_helper.h
@@ -12,17 +12,6 @@
 #include <linux/math.h>
 #include <drm/display/drm_dsc_helper.h>
 
-/**
- * msm_dsc_get_slices_per_intf() - calculate number of slices per interface
- * @dsc: Pointer to drm dsc config struct
- * @intf_width: interface width in pixels
- * Returns: Integer representing the number of slices for the given interface
- */
-static inline u32 msm_dsc_get_slices_per_intf(const struct drm_dsc_config *dsc, u32 intf_width)
-{
-	return DIV_ROUND_UP(intf_width, dsc->slice_width);
-}
-
 /**
  * msm_dsc_get_bytes_per_line() - calculate bytes per line
  * @dsc: Pointer to drm dsc config struct
-- 
2.39.5



