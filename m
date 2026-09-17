Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198CF4DD3A6;
	Thu, 17 Sep 2026 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660468; cv=none; b=J5xQWlb5/lZW8Hu5ozY1ysUucD+N89E5C2CSHoks2Ws1p+Zohz89A1ffUCKR29DNo0qhPoqrKOF527gRfPy/9iQsnPqp01bewwTDEQZGXOrFcbPLbO3V/17kV7f6deQFIJVTQ0puMN7gB7fem48TvEJ/V9/tfGs75N84oVAfwNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660468; c=relaxed/simple;
	bh=szaly7wkU8wPijjq3+PIlEQhP29ZM/3jebmDeIXT2gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4c7QDp/D6vaUw6qTHwStQN10o9KYN90dMK83TbnUAlJPO7otbYfpglGECue7sxy/JB2TpNWelJe9Qj5GAl5r9hRUyGBo4qvcFXYRSJm9OScaj3Re3a2Wx5cm4vksIX1yt+BdSaRzCkGX5SbgPZPA+JnqXl47SPvZFQATR8M42s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oC840fC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oC840fC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732B71F000FF;
	Thu, 17 Sep 2026 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660467;
	bh=tCIslNcjQfXBofxhUW6quS4gaxJDY2n9BKSJP7fO4YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oC840fC1Kcrf4OPvOkm5a59FroqJSABIUlMeWVteOePbkRfZ28+8BwhZYQPzmDrT7
	 4rOf26ZuccwIPkUN8hHxgnF52DE+tYe47wiCvUTd9uoMpUcIX3U1wOBoLzd4I4ew0s
	 Mt9TQqajojYm9b942+OvLX+zylyd0YE6vQuORv5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 602/733] media: verisilicon: rockchip: reject AV1 frames exceeding the tile capacity
Date: Thu, 17 Sep 2026 16:15:10 +0100
Message-ID: <20260917151407.472722506@linuxfoundation.org>
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
 


