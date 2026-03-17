Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABF13EBF20;
	Tue, 17 Mar 2026 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765552; cv=none; b=j/Pov3m+vsGLjVLuB94Qw/DotCeisUF0sctQmqYc3NOXfTRqdxeWUpjDCdFyigm9FpFdsk0jWTJouXtUCF2AxsAx4bhHu4txQPzil5sCuTH7PP/oQQmfueG3s1oFvw41s/t/0lXQ/EDaMDn6kagje6MF8/JXmVUIpoMwCc4jERw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765552; c=relaxed/simple;
	bh=L0HX9Hl2Ts1QYjE6W5qEMnZoicXpPhsPJJsdFVVYiMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV+BsaFFDaFRVfqiGtJaHRp/8+Q9NpRumBEIV63nRlP1AHc8iSLQUb8+MyT4VEkONb6W46zxcEhIuAikkKdNfO18LdGe91tNn1DLdWT+us7EhJCha+KCeJMgNoSbTyRX6MqHNK8Cx8N1A6dPEm/VTkZJPuicSLNK5X66wpLAhQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2UA6G3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2UA6G3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239E3C4CEF7;
	Tue, 17 Mar 2026 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765552;
	bh=L0HX9Hl2Ts1QYjE6W5qEMnZoicXpPhsPJJsdFVVYiMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2UA6G3+TCluUbhFZnYvvrpOiHQn0+6FFEFqtfR1gluY8tONOi5qt87/N6SPPn3WR
	 BwwBn8EutOUlwQ4935iR/xQv2Y5rKySiWiTTXHIJhueeNKakk1i2JgYywCstc+aAEK
	 kaGZEI2ySn1jlsPCPGQCLu7bWe4yRtJaYIxviK+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 037/378] drm/msm/dsi: fix pclk rate calculation for bonded dsi
Date: Tue, 17 Mar 2026 17:29:54 +0100
Message-ID: <20260317163008.349274938@linuxfoundation.org>
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
index e8e83ee61eb09..db6da99375a18 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -584,13 +584,30 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
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
@@ -603,7 +620,7 @@ static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
 	pclk_rate = mode->clock * 1000u;
 
 	if (dsc)
-		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc);
+		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc, is_bonded_dsi);
 
 	/*
 	 * For bonded DSI mode, the current DRM mode has the complete width of the
-- 
2.51.0



