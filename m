Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4C4DEC1D;
	Thu, 17 Sep 2026 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671139; cv=none; b=bcfHbi+f5yZl7B+nDFg8W6K/H8RQYAnq3ILNF2DtzOB9Ft8R3jeDMOyVEFY0QqwzqcfizqKqglvuaeeXE4KVR2df9Swms1TlTMk2k7OmslYCxa3flk1/Bu2YuiWD5zQqcqnfNyBovZUCQR9jAhf5kmpBlm0kUdmNQsoIeeTvzPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671139; c=relaxed/simple;
	bh=DbLIHLgvAcjSjg6LWQe9NGg1mC3xTD3/7F/TMqTR6kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJX7pexVVIkTgnKYw2+V8bO2L0kv7m7b9JV896hTrm8OS+EfeSNJs3LdaJXU9+bu1UXlWAPzIMNwQXfuwYPA/xGIHSIOQxCfEXMbfi6SSyN+6F0G+fp6rHeUTw7et+TurkHcP6UqVCZWqaK/TVTSwJ4sgCni/jTovDcu3MvhmvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFkAGNLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFkAGNLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1641F000FF;
	Thu, 17 Sep 2026 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671138;
	bh=2ZPV6ar+/NubENoKPr0DFqiDxGDjHhDYgsSMkYFcd0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFkAGNLj/LyYk+2P1PahogFT8l+jYaFtNLUTh2TOPPoCy+izRKOvcZjv63e+cQDbm
	 f1ETyy5uf9J0gyiVcGRMXSL9bhl2iHcLy8hRU3wqRjd93cCGlIVE86G9XTrSj7lEEu
	 5DNrq+WyZ2ibybiy6U+xJSzTV/TsSBKMVPvyxYRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0878/1102] media: verisilicon: rockchip: guard VPU981 AV1 divisor and tile buffer
Date: Thu, 17 Sep 2026 16:13:41 +0100
Message-ID: <20260917151602.608161833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


