Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75C5306483;
	Fri,  9 Jan 2026 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961759; cv=none; b=BcudIuP2qic7OFxcNf2BvlC8uxSak3rwp9mk6M4dsxmWRvytLiKjxqY1mrVijb4zpsb9AX+spcfod3w/OcrTrEXOfF3ANYAp2Tu7jG9Pj6WaANtyQWh9LsXyp8lQc/GfdVwEOo4b9YJEi840J+mDhnFmfbeorE/NJYFaLmaHavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961759; c=relaxed/simple;
	bh=ul5qDvwMd7iM30Rc8JjZBQGByi1+9DbDWvRaRvfLcjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpTntWX9uXI96QtbMy2uoxzWmqlP1hbapxAB8NZTRV8C31DXoL1tQvrTWkU6q0ZHUtkgC94CgnQYoUxD5gt+EGxe4HAPkLkqWolDHjGXq4MoIgQ7oiDjIz7ob0nmlasjidkZWMljASakpbFjVagMy4V1GJ12krsEyZQQnpw/Afc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghm6uzP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghm6uzP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EDEC4CEF1;
	Fri,  9 Jan 2026 12:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961759;
	bh=ul5qDvwMd7iM30Rc8JjZBQGByi1+9DbDWvRaRvfLcjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghm6uzP1lcHjF63SrHxfhn7Dc4b6/gICf8k8swGZpqHRAdB4/fdPOF2fzozPKPP/g
	 K8ljBP2qXAVbL6h7lh/mMfpKqBruO5reaudryciHUxEqfMUh2hoM92dp/skLVypu5f
	 0YGd5z3sROBejZFRNVUg1i1ysF0fq4o4Vrd1CTwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jay Liu <jay.liu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/634] drm/mediatek: Fix CCORR mtk_ctm_s31_32_to_s1_n function issue
Date: Fri,  9 Jan 2026 12:36:44 +0100
Message-ID: <20260109112122.188158830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3a53ebc4e1724..2d090bdf5a009 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ccorr.c
@@ -85,27 +85,6 @@ void mtk_ccorr_stop(struct device *dev)
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
@@ -124,7 +103,7 @@ void mtk_ccorr_ctm_set(struct device *dev, struct drm_crtc_state *state)
 	input = ctm->matrix;
 
 	for (i = 0; i < ARRAY_SIZE(coeffs); i++)
-		coeffs[i] = mtk_ctm_s31_32_to_s1_n(input[i], matrix_bits);
+		coeffs[i] = drm_color_ctm_s31_32_to_qm_n(input[i], 2, matrix_bits);
 
 	mtk_ddp_write(cmdq_pkt, coeffs[0] << 16 | coeffs[1],
 		      &ccorr->cmdq_reg, ccorr->regs, DISP_CCORR_COEF_0);
-- 
2.51.0



