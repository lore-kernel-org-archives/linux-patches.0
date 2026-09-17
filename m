Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F9E4E0B7D;
	Thu, 17 Sep 2026 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671291; cv=none; b=HlBDgeO9PdorcCazVZiSrh92rhAPAJ4a6aUgp/PIM2K7FStCFISnIBOdF+40Tw+JVdpOV0SBMP5hoLX/xipvva0Ct5/rzfYz168EVSkOXzwkml9FHufNZKs03SZKQrG+633z9gdcbMRJTdo1AoLkLy90+Sa3Abb7/GuBClxxraM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671291; c=relaxed/simple;
	bh=qv21KY5Jw6zxa+0rjuGWxpiKEIkVfp+Ppsy+8gI1uak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APqlpbXeFg/1Y4ZrD6UMejg7Z2lp0crHAnOjSendfuZ4s1iENc60gGuv7NoRBg8Khf8FsZQIMoMCi/qU6VSpL/aHQURRiMNFSaJQZ8qlQpGuRvepa1mYVadL3NIEvmnCcgcg1XLvgRInc0gacGyBH17U3Wu8WwLOZ+hY7DTtWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Me2fh4Tg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Me2fh4Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453CB1F000FF;
	Thu, 17 Sep 2026 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671288;
	bh=A+SxN+vABnha3wqBSINmcMY7lWNr9vDLxwAa39gbPkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Me2fh4TgGIPgkewyxGZi5r+mCt0p/usqXgWvl63kyHtiawwfBVFrW4WjXO7WcgR3G
	 m+NckEwNDzVoGxhNsR5Mm+hH2ucPgZOezxRa0446sWaVlTfYz1OqgNIa8JwEI28OQd
	 5p2pY+xHy4F6KD5/nlk4Btg1nE3w0ZIwUkAwQQf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0879/1102] media: verisilicon: rockchip: reject AV1 frames exceeding the tile capacity
Date: Thu, 17 Sep 2026 16:13:42 +0100
Message-ID: <20260917151602.633853858@linuxfoundation.org>
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

commit 367db8b23c26a913d76ed70457bbcd781c422b49 upstream.

rockchip_vpu981_av1_dec_set_tile_info() indexes the tile group entry
array by tile1 * tile_cols + tile0, reading up to tile_cols * tile_rows
entries, lays out one descriptor per tile in the AV1_MAX_TILES tile_info
buffer, and programs the real tile_cols / tile_rows into the hardware.

The tile group entry control is a dynamic array sized to the number of
entries userspace submitted, independent of tile_cols / tile_rows, so a
frame that claims more tiles than entries reads past the array. A frame
that claims more than AV1_MAX_TILES tiles also leaves the hardware
programmed for more tiles than the descriptor buffer holds.

Reject both in prepare_run(): tile_cols * tile_rows must not exceed the
submitted entry count or AV1_MAX_TILES. The entry count is read via
v4l2_ctrl_find() (ctrl->elems). This mirrors the bound the mediatek AV1
decoder already enforces.

Fixes: 727a400686a2 ("media: verisilicon: Add Rockchip AV1 decoder")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c |   25 ++++++++--
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -431,20 +431,39 @@ static int rockchip_vpu981_av1_dec_prepa
 {
 	struct hantro_av1_dec_hw_ctx *av1_dec = &ctx->av1_dec;
 	struct hantro_av1_dec_ctrls *ctrls = &av1_dec->ctrls;
+	const struct v4l2_av1_tile_info *tile_info;
+	struct v4l2_ctrl *tge;
+	u32 num_tiles;
 
 	ctrls->sequence = hantro_get_ctrl(ctx, V4L2_CID_STATELESS_AV1_SEQUENCE);
 	if (WARN_ON(!ctrls->sequence))
 		return -EINVAL;
 
-	ctrls->tile_group_entry =
-	    hantro_get_ctrl(ctx, V4L2_CID_STATELESS_AV1_TILE_GROUP_ENTRY);
-	if (WARN_ON(!ctrls->tile_group_entry))
+	tge = v4l2_ctrl_find(&ctx->ctrl_handler,
+			     V4L2_CID_STATELESS_AV1_TILE_GROUP_ENTRY);
+	if (WARN_ON(!tge))
 		return -EINVAL;
+	ctrls->tile_group_entry = tge->p_cur.p;
 
 	ctrls->frame = hantro_get_ctrl(ctx, V4L2_CID_STATELESS_AV1_FRAME);
 	if (WARN_ON(!ctrls->frame))
 		return -EINVAL;
 
+	/*
+	 * rockchip_vpu981_av1_dec_set_tile_info() indexes the tile group
+	 * entry array by tile1 * tile_cols + tile0, so it reads up to
+	 * tile_cols * tile_rows entries, and lays out one descriptor per tile
+	 * in the AV1_MAX_TILES tile_info buffer while programming the real
+	 * tile geometry into the hardware. Reject a frame that claims more
+	 * tiles than userspace submitted, or more than the hardware tile
+	 * buffer holds, so the read stays in bounds and the programmed
+	 * geometry matches the descriptors written.
+	 */
+	tile_info = &ctrls->frame->tile_info;
+	num_tiles = (u32)tile_info->tile_cols * tile_info->tile_rows;
+	if (num_tiles > tge->elems || num_tiles > AV1_MAX_TILES)
+		return -EINVAL;
+
 	ctrls->film_grain =
 	    hantro_get_ctrl(ctx, V4L2_CID_STATELESS_AV1_FILM_GRAIN);
 


