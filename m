Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28FE4A340D;
	Sat, 28 Feb 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301306; cv=none; b=pYMTeUaSsS+GE9rVcDvdyyCaeQKYV/VUQX33ezIU7bwL2+ZUYeTMv4t9Va3O9YUqM1FJt1JDfZXTF7mYJwUzghUnURs89KbsYGPedx7Wt/9NLHRTXMFHbLMGl35ilRzB3eC5Zj9vs3gafb9axyc8vfKd7jeZnf4u3nBERHEWIqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301306; c=relaxed/simple;
	bh=CQIVdnlJyMptctFBerqJivMDLHUFVdKTfhlLmAJ14vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKZg78QsEQNK7MFD87pZ3BGJtjPsv1G17QJ6Vz31pvLxGje00XJrbPb/2O2P9+J1KBgt8W0gG1kNcZHkOcwtNoQrBEsE7WoPzMBLG/gB/GxbW407GiJSFlBg3sFnu3wrIBEH2adWcfkV6W+MDRp+8BF/XZlG32MuODfx/XUkwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sRmmJtgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRmmJtgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD94C116D0;
	Sat, 28 Feb 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301306;
	bh=CQIVdnlJyMptctFBerqJivMDLHUFVdKTfhlLmAJ14vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRmmJtglAhiPC85/FvZWQUR2hFzqKC5tQZRy/pvwPuS05Ul9tStC+2fegn0FI/Pqk
	 SnW6CFpx4gZFUkSbikrjqdLl/x9f4F9XTfAgu2GvO9HSExCjZ/rEKHaeNFKTZ2COCN
	 NMkk+x+i5UcSCosA+7hJDAGKo0m7cEn/SkpfCYodpGSJeBKJbjWKF3wn/2wmT4d9Xp
	 4ZpbGaXU9knEWu5zPoYM1hUJG8uP/QOlqDwjKt0ZFstITbpAnfnkTNW2/PQBxB6UcV
	 4Rk5pYVanidbyP6d8A+nP23xw/nYfXC3HzKbbCdhpyzvLfrVLMfnIVpeX7qlnB3oWd
	 RNjZaVM9skbvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 491/752] media: verisilicon: AV1: Fix tx mode bit setting
Date: Sat, 28 Feb 2026 12:43:22 -0500
Message-ID: <20260228174750.1542406-491-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit cb3f945c012ab152fd2323e0df34c2b640071738 ]

AV1 specification describes 3 possibles tx modes: 4x4 only, largest and
select. The hardware allows 5 possibles tx modes: 4x4 only, 8x8, 16x16,
32x32 and select. Since the both aren't exactly matching we need to add
a mapping function to set the correct mode on hardware.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Fixes: 727a400686a2c ("media: verisilicon: Add Rockchip AV1 decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c  | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
index f4f7cb45b1f1b..f52b8208e6b93 100644
--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -72,6 +72,14 @@
 		: AV1_DIV_ROUND_UP_POW2((_value_), (_n_)));		\
 })
 
+enum rockchip_av1_tx_mode {
+	ROCKCHIP_AV1_TX_MODE_ONLY_4X4	= 0,
+	ROCKCHIP_AV1_TX_MODE_8X8	= 1,
+	ROCKCHIP_AV1_TX_MODE_16x16	= 2,
+	ROCKCHIP_AV1_TX_MODE_32x32	= 3,
+	ROCKCHIP_AV1_TX_MODE_SELECT	= 4,
+};
+
 struct rockchip_av1_film_grain {
 	u8 scaling_lut_y[256];
 	u8 scaling_lut_cb[256];
@@ -1935,11 +1943,26 @@ static void rockchip_vpu981_av1_dec_set_reference_frames(struct hantro_ctx *ctx)
 	rockchip_vpu981_av1_dec_set_other_frames(ctx);
 }
 
+static int rockchip_vpu981_av1_get_hardware_tx_mode(enum v4l2_av1_tx_mode tx_mode)
+{
+	switch (tx_mode) {
+	case V4L2_AV1_TX_MODE_ONLY_4X4:
+		return ROCKCHIP_AV1_TX_MODE_ONLY_4X4;
+	case V4L2_AV1_TX_MODE_LARGEST:
+		return ROCKCHIP_AV1_TX_MODE_32x32;
+	case V4L2_AV1_TX_MODE_SELECT:
+		return ROCKCHIP_AV1_TX_MODE_SELECT;
+	}
+
+	return ROCKCHIP_AV1_TX_MODE_32x32;
+}
+
 static void rockchip_vpu981_av1_dec_set_parameters(struct hantro_ctx *ctx)
 {
 	struct hantro_dev *vpu = ctx->dev;
 	struct hantro_av1_dec_hw_ctx *av1_dec = &ctx->av1_dec;
 	struct hantro_av1_dec_ctrls *ctrls = &av1_dec->ctrls;
+	int tx_mode;
 
 	hantro_reg_write(vpu, &av1_skip_mode,
 			 !!(ctrls->frame->flags & V4L2_AV1_FRAME_FLAG_SKIP_MODE_PRESENT));
@@ -2005,7 +2028,9 @@ static void rockchip_vpu981_av1_dec_set_parameters(struct hantro_ctx *ctx)
 			 !!(ctrls->frame->flags & V4L2_AV1_FRAME_FLAG_ALLOW_HIGH_PRECISION_MV));
 	hantro_reg_write(vpu, &av1_comp_pred_mode,
 			 (ctrls->frame->flags & V4L2_AV1_FRAME_FLAG_REFERENCE_SELECT) ? 2 : 0);
-	hantro_reg_write(vpu, &av1_transform_mode, (ctrls->frame->tx_mode == 1) ? 3 : 4);
+
+	tx_mode = rockchip_vpu981_av1_get_hardware_tx_mode(ctrls->frame->tx_mode);
+	hantro_reg_write(vpu, &av1_transform_mode, tx_mode);
 	hantro_reg_write(vpu, &av1_max_cb_size,
 			 (ctrls->sequence->flags
 			  & V4L2_AV1_SEQUENCE_FLAG_USE_128X128_SUPERBLOCK) ? 7 : 6);
-- 
2.51.0

