Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47F1A6192;
	Tue, 30 Jul 2024 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357095; cv=none; b=tWXL3/EqHKhsTvtJtaE3HwWAbnWsi6hjmpgrZmJtPNXpjlS98FXXhIhRAKVfygQ/GybmYijOCzc3QwbVR8iiynWIChv1uQK05DG98XT5M+EDhq4UD/clJi5bq+VIKYUZ92TWpVoIbzzZaHrRA3aXu4VB3v540fnQcB6wjr+7Mhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357095; c=relaxed/simple;
	bh=RgEOggoP/HO8civrs5ivWlzKnYQ6v9t2QZ273yjMBMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XywyM1inOanRqI4uPS/tclOgdqRrJQ6eNe2W4D7AZxn0iuE4fmY+bJv/vhtza4II0YHAUw+IkygmkiFTqlyk6Xlo7p+f3/ESLQ8EhuBVQz16Dw1kWWhpYsL2OZvCbW/UN93CncLL8BqeKhv1N6ES9jOgRYB2lRi7olNfTf/uLIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP3tdXGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP3tdXGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D56EC32782;
	Tue, 30 Jul 2024 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357095;
	bh=RgEOggoP/HO8civrs5ivWlzKnYQ6v9t2QZ273yjMBMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nP3tdXGtbu7SaCy2bxcip4/Gak+gPBNpRmH+3T/PVzi5pSoPXAtj63JJ/uQW2007J
	 wpPvUYxLF3qeazwj8Jm1rpkdKJU6fNZ2wMtUsEd5vjx9WEFN3WtUiYxsdJDTFK0OmL
	 H6fyODLXAoHoKTPtDwTQrjNR8AM8w04ePUkWtVNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/568] drm/mediatek: Fix destination alpha error in OVL
Date: Tue, 30 Jul 2024 17:45:24 +0200
Message-ID: <20240730151648.352656851@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 31c0fbf67c8c0bb38d7fb21d404ea3dbd619d99e ]

The formula of Coverage alpha blending is:
dst.a = dst.a * (0xff - src.a * SCA / 0xff) / 0xff
      + src.a * SCA / 0xff

dst.a: destination alpha
src.a: pixel alpha
SCA  : plane alpha

When SCA = 0xff, the formula becomes:
dst.a = dst.a * (0xff - src.a) + src.a

This patch is to set the destination alpha (background) to 0xff:
- When dst.a = 0    (before), dst.a = src.a
- When dst.a = 0xff (after) , dst.a = 0xff * (0xff - src.a) + src.a

According to the fomula above:
- When src.a = 0   , dst.a = 0
- When src.a = 0xff, dst.a = 0xff
This two cases are just still correct. But when src.a is
between 0 and 0xff, the difference starts to appear

Fixes: 616443ca577e ("drm/mediatek: Move cmdq_reg info from struct mtk_ddp_comp to sub driver private data")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-5-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 6c25fbc3db294..6f15069da8b02 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -72,6 +72,8 @@
 #define	OVL_CON_VIRT_FLIP	BIT(9)
 #define	OVL_CON_HORZ_FLIP	BIT(10)
 
+#define OVL_COLOR_ALPHA		GENMASK(31, 24)
+
 static const u32 mt8173_formats[] = {
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
@@ -274,7 +276,13 @@ void mtk_ovl_config(struct device *dev, unsigned int w,
 	if (w != 0 && h != 0)
 		mtk_ddp_write_relaxed(cmdq_pkt, h << 16 | w, &ovl->cmdq_reg, ovl->regs,
 				      DISP_REG_OVL_ROI_SIZE);
-	mtk_ddp_write_relaxed(cmdq_pkt, 0x0, &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_ROI_BGCLR);
+
+	/*
+	 * The background color must be opaque black (ARGB),
+	 * otherwise the alpha blending will have no effect
+	 */
+	mtk_ddp_write_relaxed(cmdq_pkt, OVL_COLOR_ALPHA, &ovl->cmdq_reg,
+			      ovl->regs, DISP_REG_OVL_ROI_BGCLR);
 
 	mtk_ddp_write(cmdq_pkt, 0x1, &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_RST);
 	mtk_ddp_write(cmdq_pkt, 0x0, &ovl->cmdq_reg, ovl->regs, DISP_REG_OVL_RST);
-- 
2.43.0



