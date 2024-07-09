Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850A313A25F;
	Tue,  9 Jul 2024 11:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523953; cv=none; b=eWlRaSu0vEgm+Ub1aRQpcVuqEokqDlMOTVqSIQ7bNKcK0TVENqWNmd66e7P0KO5avsiEcKZo46wy942Z7NXMbeSp5P+KtaObwKjE9UMWITyyYNy/+hLSEHOodksCGDJNfmuXgel05GCybwqC5lPKdVRuiweIiMOIhRRb3gYbA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523953; c=relaxed/simple;
	bh=o4VXzIwxUoBF+pQoQg//WdULplXyGy1E3Ibs32rHBME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK0LCQXtMk2cl9RldMKilGhDr8yGbfhmhz2M9KuYq67HtGhB+jQfYqcQ7y5F8Du+uNHv3QHjTXje2M9fiA8xbInMdwq6sbhrC4V7OoQaAiEEoehR32TCbesrzxYulrRi7AkBTxuoWUUGO1HOh865sMgzai63/bs0sKBSSmcvGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQOu4+4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQOu4+4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3EBC3277B;
	Tue,  9 Jul 2024 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523953;
	bh=o4VXzIwxUoBF+pQoQg//WdULplXyGy1E3Ibs32rHBME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQOu4+4gdC/Sob+zKnskyij2b04FUexKOrfovS4j/vrRTFYtwfNvajkmFNGksImmH
	 RpkZv/4AIVILtT6Nh7xTHB2Y8l/gu2IJ9AI/y1xJ+xFecKpT/ybVClHZtXswrqSKkQ
	 rauM1DiYxtndB9zSuKdOkJz1HVlpYaFZq/r3Z+GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 023/197] media: mediatek: vcodec: Only free buffer VA that is not NULL
Date: Tue,  9 Jul 2024 13:07:57 +0200
Message-ID: <20240709110709.813501146@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit eb005c801ec70ff4307727bd3bd6e8280169ef32 ]

In the MediaTek vcodec driver, while mtk_vcodec_mem_free() is mostly
called only when the buffer to free exists, there are some instances
that didn't do the check and triggered warnings in practice.

We believe those checks were forgotten unintentionally. Add the checks
back to fix the warnings.

Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vcodec/decoder/vdec/vdec_av1_req_lat_if.c | 22 +++++++++++++------
 .../vcodec/encoder/venc/venc_h264_if.c        |  5 +++--
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
index 2b6a5adbc4199..b0e2e59f61b5d 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
@@ -1023,18 +1023,26 @@ static void vdec_av1_slice_free_working_buffer(struct vdec_av1_slice_instance *i
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(instance->mv); i++)
-		mtk_vcodec_mem_free(ctx, &instance->mv[i]);
+		if (instance->mv[i].va)
+			mtk_vcodec_mem_free(ctx, &instance->mv[i]);
 
 	for (i = 0; i < ARRAY_SIZE(instance->seg); i++)
-		mtk_vcodec_mem_free(ctx, &instance->seg[i]);
+		if (instance->seg[i].va)
+			mtk_vcodec_mem_free(ctx, &instance->seg[i]);
 
 	for (i = 0; i < ARRAY_SIZE(instance->cdf); i++)
-		mtk_vcodec_mem_free(ctx, &instance->cdf[i]);
+		if (instance->cdf[i].va)
+			mtk_vcodec_mem_free(ctx, &instance->cdf[i]);
+
 
-	mtk_vcodec_mem_free(ctx, &instance->tile);
-	mtk_vcodec_mem_free(ctx, &instance->cdf_temp);
-	mtk_vcodec_mem_free(ctx, &instance->cdf_table);
-	mtk_vcodec_mem_free(ctx, &instance->iq_table);
+	if (instance->tile.va)
+		mtk_vcodec_mem_free(ctx, &instance->tile);
+	if (instance->cdf_temp.va)
+		mtk_vcodec_mem_free(ctx, &instance->cdf_temp);
+	if (instance->cdf_table.va)
+		mtk_vcodec_mem_free(ctx, &instance->cdf_table);
+	if (instance->iq_table.va)
+		mtk_vcodec_mem_free(ctx, &instance->iq_table);
 
 	instance->level = AV1_RES_NONE;
 }
diff --git a/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c b/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c
index a68dac72c4e42..f8145998fcaf7 100644
--- a/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/venc/venc_h264_if.c
@@ -301,11 +301,12 @@ static void h264_enc_free_work_buf(struct venc_h264_inst *inst)
 	 * other buffers need to be freed by AP.
 	 */
 	for (i = 0; i < VENC_H264_VPU_WORK_BUF_MAX; i++) {
-		if (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME)
+		if (i != VENC_H264_VPU_WORK_BUF_SKIP_FRAME && inst->work_bufs[i].va)
 			mtk_vcodec_mem_free(inst->ctx, &inst->work_bufs[i]);
 	}
 
-	mtk_vcodec_mem_free(inst->ctx, &inst->pps_buf);
+	if (inst->pps_buf.va)
+		mtk_vcodec_mem_free(inst->ctx, &inst->pps_buf);
 }
 
 static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst, bool is_34bit)
-- 
2.43.0



