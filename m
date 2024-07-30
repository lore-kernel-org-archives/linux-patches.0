Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E28189900;
	Tue, 30 Jul 2024 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358249; cv=none; b=a/aH3TCvHaszP+reCYC/m6lcTrgKkEeh2RfAJVMpDAiLL328AvZN500WCqwwPZNC8Ye4fWM9mq/SLcXUWcdHjM+XM5VGbmE8Ads2wKWQI6RMhhGpSgAy6Am1kNOyULYVpUF3axMyxKcpLdF0ZzzHP9Bx6VSzZRjXpQmEYByUkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358249; c=relaxed/simple;
	bh=+M2qcTYhGU6HAVRIVow4FQB5AGY2oAr3EJDa2+CzQew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCnUmGZG4DTHF9DJG/1UUuWby0wMdo3cr7i90STe5AQNW0XbB/ynUZ2RUgVuc0S0eETNG1e6ZzuKxZjVi1F+ZpOFgyfcMyiCKa3yB4DqWhSzKbpDeZpbuVJEkXhp5Hasu28+cVcx3tvug6oVgt2tprRRGMmUTKpE6iLuViqpSBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovEsTYqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovEsTYqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2973BC4AF0A;
	Tue, 30 Jul 2024 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358249;
	bh=+M2qcTYhGU6HAVRIVow4FQB5AGY2oAr3EJDa2+CzQew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovEsTYqu4fv6mIIaKHu7Ay8jiTe3cvTVqjOFtbceMHD/dxxAZq2kxmhAt8OKO158r
	 K2sYM65a5TC9AOFuVE5yIhcvpHSIM5q3lB0dv4An3jxzuxM2IGSEo3nJ0ztZD167wp
	 xcgeyHuDyQ5wqHPdp9qsR6drifwprQT6Q6P7y3Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 326/809] drm/mediatek: Fix XRGB setting error in OVL
Date: Tue, 30 Jul 2024 17:43:22 +0200
Message-ID: <20240730151737.481144848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 765f284f1fe172573021056f7e337ee53f252969 ]

CONST_BLD must be enabled for XRGB formats although the alpha channel
can be ignored, or OVL will still read the value from memory.
This error only affects CRC generation.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-3-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index b552a02d7eae7..bd00e5e85deba 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -38,6 +38,7 @@
 #define DISP_REG_OVL_PITCH_MSB(n)		(0x0040 + 0x20 * (n))
 #define OVL_PITCH_MSB_2ND_SUBBUF			BIT(16)
 #define DISP_REG_OVL_PITCH(n)			(0x0044 + 0x20 * (n))
+#define OVL_CONST_BLEND					BIT(28)
 #define DISP_REG_OVL_RDMA_CTRL(n)		(0x00c0 + 0x20 * (n))
 #define DISP_REG_OVL_RDMA_GMC(n)		(0x00c8 + 0x20 * (n))
 #define DISP_REG_OVL_ADDR_MT2701		0x0040
@@ -407,6 +408,7 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	unsigned int fmt = pending->format;
 	unsigned int offset = (pending->y << 16) | pending->x;
 	unsigned int src_size = (pending->height << 16) | pending->width;
+	unsigned int ignore_pixel_alpha = 0;
 	unsigned int con;
 	bool is_afbc = pending->modifier != DRM_FORMAT_MOD_LINEAR;
 	union overlay_pitch {
@@ -428,6 +430,14 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	if (state->base.fb && state->base.fb->format->has_alpha)
 		con |= OVL_CON_AEN | OVL_CON_ALPHA;
 
+	/* CONST_BLD must be enabled for XRGB formats although the alpha channel
+	 * can be ignored, or OVL will still read the value from memory.
+	 * For RGB888 related formats, whether CONST_BLD is enabled or not won't
+	 * affect the result. Therefore we use !has_alpha as the condition.
+	 */
+	if (state->base.fb && !state->base.fb->format->has_alpha)
+		ignore_pixel_alpha = OVL_CONST_BLEND;
+
 	if (pending->rotation & DRM_MODE_REFLECT_Y) {
 		con |= OVL_CON_VIRT_FLIP;
 		addr += (pending->height - 1) * pending->pitch;
@@ -443,8 +453,8 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 
 	mtk_ddp_write_relaxed(cmdq_pkt, con, &ovl->cmdq_reg, ovl->regs,
 			      DISP_REG_OVL_CON(idx));
-	mtk_ddp_write_relaxed(cmdq_pkt, overlay_pitch.split_pitch.lsb, &ovl->cmdq_reg, ovl->regs,
-			      DISP_REG_OVL_PITCH(idx));
+	mtk_ddp_write_relaxed(cmdq_pkt, overlay_pitch.split_pitch.lsb | ignore_pixel_alpha,
+			      &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_PITCH(idx));
 	mtk_ddp_write_relaxed(cmdq_pkt, src_size, &ovl->cmdq_reg, ovl->regs,
 			      DISP_REG_OVL_SRC_SIZE(idx));
 	mtk_ddp_write_relaxed(cmdq_pkt, offset, &ovl->cmdq_reg, ovl->regs,
-- 
2.43.0



