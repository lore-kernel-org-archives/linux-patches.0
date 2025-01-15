Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A0A1DB15D;
	Wed, 15 Jan 2025 11:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938897; cv=none; b=tkR2nwATOO71eNMcOdvjn4VymwcfSuDDAs5fXyrE/tH8Q7IEDMpVtA+HHlm3x3R4PWtucGdSngzavKpsv89dwfC+sQSLBIkG8+fZMUOpus/lrwEF+Ceu6Q/LzehbmDBReq7moCHZmbYW+p/W4kQ7nR3PmBP0IgVj2RWEO8KTkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938897; c=relaxed/simple;
	bh=jKWWm4CwYvk74fn+Gdetk6gPkA9p31tOiHSMDtyUQ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCk29Pvlx+RrfDLUbow/B5/cF2v5Zd6/77zaN/zWsd0Wz61AV6kLHr0XxHu5+ZxHfEwgeXRy2w4G+b6SUBKp0vBuzKGmBE06+uODAn/7hE2WP3mNvvZqYjOXyhXaPecPqXeu7uNu36Mq3jD5vA5Tx2W6KWNpyOcPelm8MAriD5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlUEmvwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlUEmvwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8966AC4CEE4;
	Wed, 15 Jan 2025 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938897;
	bh=jKWWm4CwYvk74fn+Gdetk6gPkA9p31tOiHSMDtyUQ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlUEmvwDjWWcor0SQ6lTzSWDK76HBSIZYNvSkOlrBHW7AdsPRudbf6W6/iQUHpqp9
	 6PclaHLgqY0WzmlxfEV6FIQceo64/GYRqZiVW6mU/aDCv89GT3Aw4oiw2rhPCea30s
	 Kkfj9lzsiLZkFZR/zmzS6MVrXae+sjGiMf2llvyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/129] drm/mediatek: Only touch DISP_REG_OVL_PITCH_MSB if AFBC is supported
Date: Wed, 15 Jan 2025 11:38:24 +0100
Message-ID: <20250115103559.495112493@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit f8d9b91739e1fb436447c437a346a36deb676a36 ]

Touching DISP_REG_OVL_PITCH_MSB leads to video overlay on MT2701, MT7623N
and probably other older SoCs being broken.

Move setting up AFBC layer configuration into a separate function only
being called on hardware which actually supports AFBC which restores the
behavior as it was before commit c410fa9b07c3 ("drm/mediatek: Add AFBC
support to Mediatek DRM driver") on non-AFBC hardware.

Fixes: c410fa9b07c3 ("drm/mediatek: Add AFBC support to Mediatek DRM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/c7fbd3c3e633c0b7dd6d1cd78ccbdded31e1ca0f.1734397800.git.daniel@makrotopia.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 57 +++++++++++++------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 6f15069da8b0..ce0f441e3f13 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -403,6 +403,29 @@ static unsigned int ovl_fmt_convert(struct mtk_disp_ovl *ovl, unsigned int fmt)
 	}
 }
 
+static void mtk_ovl_afbc_layer_config(struct mtk_disp_ovl *ovl,
+				      unsigned int idx,
+				      struct mtk_plane_pending_state *pending,
+				      struct cmdq_pkt *cmdq_pkt)
+{
+	unsigned int pitch_msb = pending->pitch >> 16;
+	unsigned int hdr_pitch = pending->hdr_pitch;
+	unsigned int hdr_addr = pending->hdr_addr;
+
+	if (pending->modifier != DRM_FORMAT_MOD_LINEAR) {
+		mtk_ddp_write_relaxed(cmdq_pkt, hdr_addr, &ovl->cmdq_reg, ovl->regs,
+				      DISP_REG_OVL_HDR_ADDR(ovl, idx));
+		mtk_ddp_write_relaxed(cmdq_pkt,
+				      OVL_PITCH_MSB_2ND_SUBBUF | pitch_msb,
+				      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH_MSB(idx));
+		mtk_ddp_write_relaxed(cmdq_pkt, hdr_pitch, &ovl->cmdq_reg, ovl->regs,
+				      DISP_REG_OVL_HDR_PITCH(ovl, idx));
+	} else {
+		mtk_ddp_write_relaxed(cmdq_pkt, pitch_msb,
+				      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH_MSB(idx));
+	}
+}
+
 void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 			  struct mtk_plane_state *state,
 			  struct cmdq_pkt *cmdq_pkt)
@@ -410,24 +433,12 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
 	struct mtk_plane_pending_state *pending = &state->pending;
 	unsigned int addr = pending->addr;
-	unsigned int hdr_addr = pending->hdr_addr;
-	unsigned int pitch = pending->pitch;
-	unsigned int hdr_pitch = pending->hdr_pitch;
+	unsigned int pitch_lsb = pending->pitch & GENMASK(15, 0);
 	unsigned int fmt = pending->format;
 	unsigned int offset = (pending->y << 16) | pending->x;
 	unsigned int src_size = (pending->height << 16) | pending->width;
 	unsigned int ignore_pixel_alpha = 0;
 	unsigned int con;
-	bool is_afbc = pending->modifier != DRM_FORMAT_MOD_LINEAR;
-	union overlay_pitch {
-		struct split_pitch {
-			u16 lsb;
-			u16 msb;
-		} split_pitch;
-		u32 pitch;
-	} overlay_pitch;
-
-	overlay_pitch.pitch = pitch;
 
 	if (!pending->enable) {
 		mtk_ovl_layer_off(dev, idx, cmdq_pkt);
@@ -457,11 +468,12 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	}
 
 	if (ovl->data->supports_afbc)
-		mtk_ovl_set_afbc(ovl, cmdq_pkt, idx, is_afbc);
+		mtk_ovl_set_afbc(ovl, cmdq_pkt, idx,
+				 pending->modifier != DRM_FORMAT_MOD_LINEAR);
 
 	mtk_ddp_write_relaxed(cmdq_pkt, con, &ovl->cmdq_reg, ovl->regs,
 			      DISP_REG_OVL_CON(idx));
-	mtk_ddp_write_relaxed(cmdq_pkt, overlay_pitch.split_pitch.lsb | ignore_pixel_alpha,
+	mtk_ddp_write_relaxed(cmdq_pkt, pitch_lsb | ignore_pixel_alpha,
 			      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH(idx));
 	mtk_ddp_write_relaxed(cmdq_pkt, src_size, &ovl->cmdq_reg, ovl->regs,
 			      DISP_REG_OVL_SRC_SIZE(idx));
@@ -470,19 +482,8 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	mtk_ddp_write_relaxed(cmdq_pkt, addr, &ovl->cmdq_reg, ovl->regs,
 			      DISP_REG_OVL_ADDR(ovl, idx));
 
-	if (is_afbc) {
-		mtk_ddp_write_relaxed(cmdq_pkt, hdr_addr, &ovl->cmdq_reg, ovl->regs,
-				      DISP_REG_OVL_HDR_ADDR(ovl, idx));
-		mtk_ddp_write_relaxed(cmdq_pkt,
-				      OVL_PITCH_MSB_2ND_SUBBUF | overlay_pitch.split_pitch.msb,
-				      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH_MSB(idx));
-		mtk_ddp_write_relaxed(cmdq_pkt, hdr_pitch, &ovl->cmdq_reg, ovl->regs,
-				      DISP_REG_OVL_HDR_PITCH(ovl, idx));
-	} else {
-		mtk_ddp_write_relaxed(cmdq_pkt,
-				      overlay_pitch.split_pitch.msb,
-				      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH_MSB(idx));
-	}
+	if (ovl->data->supports_afbc)
+		mtk_ovl_afbc_layer_config(ovl, idx, pending, cmdq_pkt);
 
 	mtk_ovl_set_bit_depth(dev, idx, fmt, cmdq_pkt);
 	mtk_ovl_layer_on(dev, idx, cmdq_pkt);
-- 
2.39.5



