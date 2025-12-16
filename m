Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF05D361DB3;
	Tue, 16 Dec 2025 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887731; cv=none; b=ZISjFu6syzd766W0PqFLougZuDMXiPw8LnFkQKcjJj0yAG7iqhxA+glzRrwQcz+c5mubiBbj7qDGfCqUpxzXLusHS9U2cMhbnVoAvbAVUZLzDDoou9hLqlRv3KRzAVJjpRz8Z7wSCsrR3UI0Hoyzw0fFGBtRdeKgXIL9ar5g9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887731; c=relaxed/simple;
	bh=bMseVb0J5jWHBZxG3lktL5AWHbWky0f6ER9LXZzsydk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtK6CGj/pv8JKa1ikykxzi4OUWMe8HKil40Qah2Cz4Y/DAIMf4Naa0rpXZ4NPwGzK1MeJZcBIDcgd00A+m1eYuV0lZn1BkCMmgCH7Hc4JMq5M0XoPpYt9raTbXOZPxIHpfC2fbWAVADDiUUxsy8Xu6FR1y6VzWl6nCbnwPINbns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5LhwlTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5LhwlTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C14BC4CEF1;
	Tue, 16 Dec 2025 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887730;
	bh=bMseVb0J5jWHBZxG3lktL5AWHbWky0f6ER9LXZzsydk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5LhwlTHOkGanTrv4AvuqxyPCVhxQUzGz/LPseDiHGjtmW7eH/Oh7kQ6q2g5fZL1q
	 LgIgELL7kQCp/DqeezjQgWMnxA3VgJSlNpGXFSU5PWMQTcm/sMr++UHlAJ+2nCIJWc
	 yVeplT7G+lAFEs5e3fyuibsPT6JR/8ziJswfbz9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jay Liu <jay.liu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/614] drm/mediatek: Fix CCORR mtk_ctm_s31_32_to_s1_n function issue
Date: Tue, 16 Dec 2025 12:11:28 +0100
Message-ID: <20251216111412.994565211@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Liu <jay.liu@mediatek.com>

[ Upstream commit 20ac36b71c53b8c36c6903b5ca87c75226700a97 ]

if matrixbit is 11,
The range of color matrix is from 0 to (BIT(12) - 1).
Values from 0 to (BIT(11) - 1) represent positive numbers,
values from BIT(11) to (BIT(12) - 1) represent negative numbers.
For example, -1 need converted to 8191.
so convert S31.32 to HW Q2.11 format by drm_color_ctm_s31_32_to_qm_n,
and set int_bits to 2.

Fixes: 738ed4156fba ("drm/mediatek: Add matrix_bits private data for ccorr")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jay Liu <jay.liu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250921055416.25588-2-jay.liu@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ccorr.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c b/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
index 10d60d2c2a568..6d7bf4afa78d3 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
@@ -80,27 +80,6 @@ void mtk_ccorr_stop(struct device *dev)
 	writel_relaxed(0x0, ccorr->regs + DISP_CCORR_EN);
 }
 
-/* Converts a DRM S31.32 value to the HW S1.n format. */
-static u16 mtk_ctm_s31_32_to_s1_n(u64 in, u32 n)
-{
-	u16 r;
-
-	/* Sign bit. */
-	r = in & BIT_ULL(63) ? BIT(n + 1) : 0;
-
-	if ((in & GENMASK_ULL(62, 33)) > 0) {
-		/* identity value 0x100000000 -> 0x400(mt8183), */
-		/* identity value 0x100000000 -> 0x800(mt8192), */
-		/* if bigger this, set it to max 0x7ff. */
-		r |= GENMASK(n, 0);
-	} else {
-		/* take the n+1 most important bits. */
-		r |= (in >> (32 - n)) & GENMASK(n, 0);
-	}
-
-	return r;
-}
-
 void mtk_ccorr_ctm_set(struct device *dev, struct drm_crtc_state *state)
 {
 	struct mtk_disp_ccorr *ccorr = dev_get_drvdata(dev);
@@ -119,7 +98,7 @@ void mtk_ccorr_ctm_set(struct device *dev, struct drm_crtc_state *state)
 	input = ctm->matrix;
 
 	for (i = 0; i < ARRAY_SIZE(coeffs); i++)
-		coeffs[i] = mtk_ctm_s31_32_to_s1_n(input[i], matrix_bits);
+		coeffs[i] = drm_color_ctm_s31_32_to_qm_n(input[i], 2, matrix_bits);
 
 	mtk_ddp_write(cmdq_pkt, coeffs[0] << 16 | coeffs[1],
 		      &ccorr->cmdq_reg, ccorr->regs, DISP_CCORR_COEF_0);
-- 
2.51.0



