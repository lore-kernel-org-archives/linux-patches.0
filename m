Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E998F6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD79C433D2;
	Tue, 10 Jan 2023 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374666;
	bh=p4dt/o+VKh4m5q/5yUy2pks5GSDjSqYgTOIINbJLB90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdJWINTO85eL75I/zARoIts8O+HKVsMMoLuShUwaNpp5+LLnKlY/Pn2HDB1B1p72E
	 HDXM732h8x8BxR3X+I9oa7B+MZaWHLgOsr0zJq69w8QZpzwbuKOAsr3yHHHRlv10B5
	 LLH2Y3aeb3ePwo2NibklGk602uA9di6FX7jeTs3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ian Ray <ian.ray@ge.com>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/159] drm/imx: ipuv3-plane: Fix overlay plane width
Date: Tue, 10 Jan 2023 19:04:00 +0100
Message-Id: <20230110180021.227656377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 92d43bd3bc9728c1fb114d7011d46f5ea9489e28 ]

ipu_src_rect_width() was introduced to support odd screen resolutions
such as 1366x768 by internally rounding up primary plane width to a
multiple of 8 and compensating with reduced horizontal blanking.
This also caused overlay plane width to be rounded up, which was not
intended. Fix overlay plane width by limiting the rounding up to the
primary plane.

drm_rect_width(&new_state->src) >> 16 is the same value as
drm_rect_width(dst) because there is no plane scaling support.

Fixes: 94dfec48fca7 ("drm/imx: Add 8 pixel alignment fix")
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20221108141420.176696-1-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108141420.176696-1-p.zabel@pengutronix.de
Tested-by: Ian Ray <ian.ray@ge.com>
(cherry picked from commit 4333472f8d7befe62359fecb1083cd57a6e07bfc)
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-plane.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index dba4f7d81d69..80142d9a4a55 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -614,6 +614,11 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
+	if (ipu_plane->dp_flow == IPU_DP_FLOW_SYNC_BG)
+		width = ipu_src_rect_width(new_state);
+	else
+		width = drm_rect_width(&new_state->src) >> 16;
+
 	eba = drm_plane_state_to_eba(new_state, 0);
 
 	/*
@@ -622,8 +627,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 	 */
 	if (ipu_state->use_pre) {
 		axi_id = ipu_chan_assign_axi_id(ipu_plane->dma);
-		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id,
-					  ipu_src_rect_width(new_state),
+		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id, width,
 					  drm_rect_height(&new_state->src) >> 16,
 					  fb->pitches[0], fb->format->format,
 					  fb->modifier, &eba);
@@ -678,9 +682,8 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
-	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, ALIGN(drm_rect_width(dst), 8));
+	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, width);
 
-	width = ipu_src_rect_width(new_state);
 	height = drm_rect_height(&new_state->src) >> 16;
 	info = drm_format_info(fb->format->format);
 	ipu_calculate_bursts(width, info->cpp[0], fb->pitches[0],
@@ -744,8 +747,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		ipu_cpmem_set_burstsize(ipu_plane->ipu_ch, 16);
 
 		ipu_cpmem_zero(ipu_plane->alpha_ch);
-		ipu_cpmem_set_resolution(ipu_plane->alpha_ch,
-					 ipu_src_rect_width(new_state),
+		ipu_cpmem_set_resolution(ipu_plane->alpha_ch, width,
 					 drm_rect_height(&new_state->src) >> 16);
 		ipu_cpmem_set_format_passthrough(ipu_plane->alpha_ch, 8);
 		ipu_cpmem_set_high_priority(ipu_plane->alpha_ch);
-- 
2.35.1



