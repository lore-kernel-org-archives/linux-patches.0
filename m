Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840C63AE1A8;
	Mon, 23 Mar 2026 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275260; cv=none; b=HVUb76iB3ClKWpj/oe7GDdQiVbcKKjLxh2SJ6R3raX9Bparlb/9742LPTKYALZFw1kT+/jomg8v3MxlEDWoy1rTF3TyILe2YxKW1goTvCUZ5jrTeeTfbkgrXNEOwxMAy8Bm7mkwNuTQvEW/Os6sf1hQCcVDqw6odyi7iZyoJFYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275260; c=relaxed/simple;
	bh=ckBfe14adKMfymIg3mR8C/AteE+/hXIKm2UolFpFBHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw8fGpIC7SZthINIrf45hcvfx4xb8xyc2McFx0zbDZw5KJuDJi5Gp82d9fDjX/HX66RNBaRqZKkXjHlqSKea+A4yRCnt6DTljCfqaQ8od6UGLlKRTprF10Xa1QX/iF2nOFKbkKV/zf0A0VGd3Urv9Z/PzO8sFPedJAbMKDBl2bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv4pXSmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv4pXSmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D04BC4CEF7;
	Mon, 23 Mar 2026 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275260;
	bh=ckBfe14adKMfymIg3mR8C/AteE+/hXIKm2UolFpFBHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iv4pXSmcC6aBnboDibY2L1LYYud3v3Caln5EHWrFiyCeCGlydpd/GjZrUDhm+0OG2
	 NMjr/t37fzYwAylpIl4KrW19GiZga3uPzy8SFPdVW/OuJIboNltbO2v/+OTI9LI/Oa
	 D59glV+WPRvffE7cEXxP9JUFHE2ISqZ0A/77DF8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/460] drm/msm/dsi: fix pclk rate calculation for bonded dsi
Date: Mon, 23 Mar 2026 14:40:28 +0100
Message-ID: <20260323134527.496006383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit e4eb11b34d6c84f398d8f08d7cb4d6c38e739dd2 ]

Recently, we round up new_hdisplay once at most, for bonded dsi, we
may need twice, since they are independent links, we should round up
each half separately. This also aligns with the hdisplay we program
later in dsi_timing_setup()

Example:
	full_hdisplay = 1904, dsc_bpp = 8, bpc = 8
	new_full_hdisplay = DIV_ROUND_UP(1904 * 8, 8 * 3) = 635

if we use half display
	new_half_hdisplay = DIV_ROUND_UP(952 * 8, 8 * 3) = 318
	new_full_display = 636

Fixes: 7c9e4a554d4a ("drm/msm/dsi: Reduce pclk rate for compression")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/709716/
Link: https://lore.kernel.org/r/20260306163255.215456-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index c85d0d5fc5800..0c360e7903295 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -534,13 +534,30 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
  *  FIXME: Reconsider this if/when CMD mode handling is rewritten to use
  *  transfer time and data overhead as a starting point of the calculations.
  */
-static unsigned long dsi_adjust_pclk_for_compression(const struct drm_display_mode *mode,
-		const struct drm_dsc_config *dsc)
+static unsigned long
+dsi_adjust_pclk_for_compression(const struct drm_display_mode *mode,
+				const struct drm_dsc_config *dsc,
+				bool is_bonded_dsi)
 {
-	int new_hdisplay = DIV_ROUND_UP(mode->hdisplay * drm_dsc_get_bpp_int(dsc),
-			dsc->bits_per_component * 3);
+	int hdisplay, new_hdisplay, new_htotal;
 
-	int new_htotal = mode->htotal - mode->hdisplay + new_hdisplay;
+	/*
+	 * For bonded DSI, split hdisplay across two links and round up each
+	 * half separately, passing the full hdisplay would only round up once.
+	 * This also aligns with the hdisplay we program later in
+	 * dsi_timing_setup()
+	 */
+	hdisplay = mode->hdisplay;
+	if (is_bonded_dsi)
+		hdisplay /= 2;
+
+	new_hdisplay = DIV_ROUND_UP(hdisplay * drm_dsc_get_bpp_int(dsc),
+				    dsc->bits_per_component * 3);
+
+	if (is_bonded_dsi)
+		new_hdisplay *= 2;
+
+	new_htotal = mode->htotal - mode->hdisplay + new_hdisplay;
 
 	return mult_frac(mode->clock * 1000u, new_htotal, mode->htotal);
 }
@@ -553,7 +570,7 @@ static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
 	pclk_rate = mode->clock * 1000u;
 
 	if (dsc)
-		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc);
+		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc, is_bonded_dsi);
 
 	/*
 	 * For bonded DSI mode, the current DRM mode has the complete width of the
-- 
2.51.0



