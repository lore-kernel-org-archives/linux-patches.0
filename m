Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308D34B44CB;
	Thu, 17 Sep 2026 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660465; cv=none; b=mNzxWpTIZcBTAqZ8PR4MjyxbA37Eyfm6Vvj9m0nv/S4IHsAunKXEz5hjpstOPaISO6oT6p+HU9XKj6y/o1MOusNeh8Dn6DxsyrMOgaPSIXoI5pGLAcKxUhwZkkYXB1Rq5LafpFMnIvAZzH4pfm5bpNOokIKanx98HefRGoAEHUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660465; c=relaxed/simple;
	bh=JZyQRSpft533/qlfNW22eVkgFYijS4eifpz0HFyy8qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU+9cWh33k+RXGRh7H+6i2Pkt3av1x7LQJyCCv7nQrobYiaoiE5AJM5xBu8D2GWkuX9dx9NKIbPcqRu3vQrSapeoFZMemXLDq6jJY7ANh1ttIK7IfopOMzdfovPcQegKduWYGaX7rM70Q6kxnSo4NBj2gW2+y7Sg+1q3FzPheSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUYHI3xZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUYHI3xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802DF1F000FF;
	Thu, 17 Sep 2026 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660464;
	bh=3CAWKjMsLV6Dyt4ly+xBVYmsQJutYnySmrkC/QlFqrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUYHI3xZ+C3YlqwlbstIEhaSSKIzQVAax5ozcoPth87V5VcvfNN5E5J0ORo/zCp79
	 Ce9YMyZBXOmZe0txRhsx3hU3sOHZ8sLSJCDTLqe3Z/evlFtSGEhNOX0MLonCp8ionI
	 WKM3tVr9Bp1L0dU1mUVyH9YGMU9GG29vK73j6pAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 601/733] media: verisilicon: rockchip: guard VPU981 AV1 divisor and tile buffer
Date: Thu, 17 Sep 2026 16:15:09 +0100
Message-ID: <20260917151407.444189268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit b84f6533a8ed2fd7b282fc7ab4b8efadc745a89c upstream.

rockchip_vpu981_av1_dec_set_tile_info() divides context_update_tile_id by
tile_info->tile_cols and writes one descriptor per tile into the tile_info
DMA buffer, which holds AV1_MAX_TILES entries; tile_cols and tile_rows
come from the bitstream. Guard the division against a zero tile_cols by
initialising the context-update values to zero and computing them only
when tile_cols is non-zero, and stop the descriptor writes once the
tile_info buffer is full. The tile geometry written to the hardware
registers is left unmodified; the per-dimension and total tile bounds are
enforced by the control validation.

Fixes: 727a400686a2 ("media: verisilicon: Add Rockchip AV1 decoder")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c |   32 ++++++++--
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -578,16 +578,30 @@ static void rockchip_vpu981_av1_dec_set_
 	const struct v4l2_av1_tile_info *tile_info = &ctrls->frame->tile_info;
 	const struct v4l2_ctrl_av1_tile_group_entry *group_entry =
 	    ctrls->tile_group_entry;
-	int context_update_y =
-	    tile_info->context_update_tile_id / tile_info->tile_cols;
-	int context_update_x =
-	    tile_info->context_update_tile_id % tile_info->tile_cols;
-	int context_update_tile_id =
-	    context_update_x * tile_info->tile_rows + context_update_y;
+	int context_update_y = 0;
+	int context_update_x = 0;
+	int context_update_tile_id = 0;
 	u8 *dst = av1_dec->tile_info.cpu;
+	u8 *dst_end = dst + av1_dec->tile_info.size;
 	struct hantro_dev *vpu = ctx->dev;
 	int tile0, tile1;
 
+	/*
+	 * tile_cols and tile_rows are bounded by the V4L2 control validation
+	 * (V4L2_AV1_MAX_TILE_{COLS,ROWS} and V4L2_AV1_MAX_TILE_COUNT). Guard
+	 * the divisor here, and keep the descriptor writes within the
+	 * AV1_MAX_TILES tile_info buffer below; the register values use the
+	 * unmodified tile geometry.
+	 */
+	if (tile_info->tile_cols) {
+		context_update_y =
+		    tile_info->context_update_tile_id / tile_info->tile_cols;
+		context_update_x =
+		    tile_info->context_update_tile_id % tile_info->tile_cols;
+		context_update_tile_id =
+		    context_update_x * tile_info->tile_rows + context_update_y;
+	}
+
 	memset(dst, 0, av1_dec->tile_info.size);
 
 	for (tile0 = 0; tile0 < tile_info->tile_cols; tile0++) {
@@ -598,6 +612,10 @@ static void rockchip_vpu981_av1_dec_set_
 			    tile_info->height_in_sbs_minus_1[tile1] + 1;
 			u32 x0 = tile_info->width_in_sbs_minus_1[tile0] + 1;
 
+			/* Stop once the tile_info descriptor buffer is full. */
+			if (dst + 16 > dst_end)
+				break;
+
 			/* tile size in SB units (width,height) */
 			*dst++ = x0;
 			*dst++ = 0;
@@ -622,6 +640,8 @@ static void rockchip_vpu981_av1_dec_set_
 			*dst++ = (end >> 16) & 255;
 			*dst++ = (end >> 24) & 255;
 		}
+		if (dst + 16 > dst_end)
+			break;
 	}
 
 	hantro_reg_write(vpu, &av1_multicore_expect_context_update, !!(context_update_x == 0));


