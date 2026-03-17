Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A53EC2EA;
	Tue, 17 Mar 2026 16:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765653; cv=none; b=uqUeyrexgx2UxfuvwtGUtHs+5ChYs6dQRPnKpcWYnX/Ut3p1eIz4t1LJKUO4FB8gwcRCGovsKzTHWMtMNy3cgeq8KJU58pP6gDBDqZE+NnKCW8xjxikqWLSjc8PEmyQ45mKM1ntApPzvAyGlr3zJxdcElK/PegpRoKmnJPwvIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765653; c=relaxed/simple;
	bh=awptZf2DjQrr/BoNyDTb0D7VH2+zWv0Uc34RLHuz020=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjTHHfpRUtboCJd6r8SW+fUckI020WM0dYkcyuRd0CVCX/hSMF5wnsnDTKG6ofamE8SQQKxTOoCeIIAlKixOg7Dywx6WgiqQkUwoSs6Jlo/Sg9H/U/e5FRDAZmh+6iCY2hRiQ7aF1mcNcaCRFmeGU4z4foqk6C7YyXGR1CC5J5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imustr4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imustr4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE418C2BC86;
	Tue, 17 Mar 2026 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765653;
	bh=awptZf2DjQrr/BoNyDTb0D7VH2+zWv0Uc34RLHuz020=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imustr4GL5/0mFVjwMAA/6XRFl1ODeoz5ZUHsxp/96UGjMcmXCxNOFN4QZZYYobbg
	 jUyAAtext9PLvU1bqQpXSsEf5zumGeG3Ijd1Go4/xZCuI6AfWLZMLPn9NuGSii0yli
	 3Ek0MQhU/KLMkgmDjG1dQui64yRjB8BcPoosrypg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 028/378] drm/msm/dsi: fix hdisplay calculation when programming dsi registers
Date: Tue, 17 Mar 2026 17:29:45 +0100
Message-ID: <20260317163008.013706115@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit ac47870fd795549f03d57e0879fc730c79119f4b ]

Recently, the hdisplay calculation is working for 3:1 compressed ratio
only. If we have a video panel with DSC BPP = 8, and BPC = 10, we still
use the default bits_per_pclk = 24, then we get the wrong hdisplay. We
can draw the conclusion by cross-comparing the calculation with the
calculation in dsi_adjust_pclk_for_compression().

Since CMD mode does not use this, we can remove
!(msm_host->mode_flags & MIPI_DSI_MODE_VIDEO) safely.

Fixes: efcbd6f9cdeb ("drm/msm/dsi: Enable widebus for DSI")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/704822/
Link: https://lore.kernel.org/r/20260214105145.105308-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index e0de545d40775..e8e83ee61eb09 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -993,7 +993,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 	if (msm_host->dsc) {
 		struct drm_dsc_config *dsc = msm_host->dsc;
-		u32 bytes_per_pclk;
+		u32 bits_per_pclk;
 
 		/* update dsc params with timing params */
 		if (!dsc || !mode->hdisplay || !mode->vdisplay) {
@@ -1015,7 +1015,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 		/*
 		 * DPU sends 3 bytes per pclk cycle to DSI. If widebus is
-		 * enabled, bus width is extended to 6 bytes.
+		 * enabled, MDP always sends out 48-bit compressed data per
+		 * pclk and on average, DSI consumes an amount of compressed
+		 * data equivalent to the uncompressed pixel depth per pclk.
 		 *
 		 * Calculate the number of pclks needed to transmit one line of
 		 * the compressed data.
@@ -1027,12 +1029,12 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 * unused anyway.
 		 */
 		h_total -= hdisplay;
-		if (wide_bus_enabled && !(msm_host->mode_flags & MIPI_DSI_MODE_VIDEO))
-			bytes_per_pclk = 6;
+		if (wide_bus_enabled)
+			bits_per_pclk = mipi_dsi_pixel_format_to_bpp(msm_host->format);
 		else
-			bytes_per_pclk = 3;
+			bits_per_pclk = 24;
 
-		hdisplay = DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_host->dsc), bytes_per_pclk);
+		hdisplay = DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_host->dsc) * 8, bits_per_pclk);
 
 		h_total += hdisplay;
 		ha_end = ha_start + hdisplay;
-- 
2.51.0



