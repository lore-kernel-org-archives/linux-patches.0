Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B061875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72234C433D2;
	Wed, 28 Dec 2022 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242847;
	bh=f5v4dRBPbTX41wrvjczmE97GmaFBbIs5KlTm4XalbDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5OGkxvP2rfKnYjezpLC/JmO3p7F2bdZLgEtfbbgey8zb+Gi/6dofVXRQuUXxDKnp
	 5wVX3SuDgW/A8tQTdmMeGvPC13RSiaw4Fo9ZgXP3xt6gKfoX3vxEfJuVLM9iKz5zdW
	 si9UGXJEjUGNhjsqxCCbhoERYZnKGzoliDfzuUxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0414/1146] media: mediatek: vcodec: Fix h264 set lat buffer error
Date: Wed, 28 Dec 2022 15:32:33 +0100
Message-Id: <20221228144341.413337698@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 23d677bd9cdd10323e6d290578bbb0a408f43499 ]

Will set lat buffer to lat_list two times when lat decode timeout for
inner racing mode.

If core thread can't get frame buffer, need to return error value.

Fixes: 59fba9eed5a7 ("media: mediatek: vcodec: support stateless H.264 decoding for mt8192")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vcodec/vdec/vdec_h264_req_multi_if.c      | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
index 18e048755d11..955b2d0c8f53 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
@@ -471,14 +471,19 @@ static int vdec_h264_slice_core_decode(struct vdec_lat_buf *lat_buf)
 	       sizeof(share_info->h264_slice_params));
 
 	fb = ctx->dev->vdec_pdata->get_cap_buffer(ctx);
-	y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
-	vdec_fb_va = (unsigned long)fb;
+	if (!fb) {
+		err = -EBUSY;
+		mtk_vcodec_err(inst, "fb buffer is NULL");
+		goto vdec_dec_end;
+	}
 
+	vdec_fb_va = (unsigned long)fb;
+	y_fb_dma = (u64)fb->base_y.dma_addr;
 	if (ctx->q_data[MTK_Q_DATA_DST].fmt->num_planes == 1)
 		c_fb_dma =
 			y_fb_dma + inst->ctx->picinfo.buf_w * inst->ctx->picinfo.buf_h;
 	else
-		c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
+		c_fb_dma = (u64)fb->base_c.dma_addr;
 
 	mtk_vcodec_debug(inst, "[h264-core] y/c addr = 0x%llx 0x%llx", y_fb_dma,
 			 c_fb_dma);
@@ -656,7 +661,7 @@ static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	err = vpu_dec_start(vpu, data, 2);
 	if (err) {
 		mtk_vcodec_debug(inst, "lat decode err: %d", err);
-		goto err_scp_decode;
+		goto err_free_fb_out;
 	}
 
 	share_info->trans_end = inst->ctx->msg_queue.wdma_addr.dma_addr +
@@ -673,12 +678,17 @@ static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	/* wait decoder done interrupt */
 	timeout = mtk_vcodec_wait_for_done_ctx(inst->ctx, MTK_INST_IRQ_RECEIVED,
 					       WAIT_INTR_TIMEOUT_MS, MTK_VDEC_LAT0);
+	if (timeout)
+		mtk_vcodec_err(inst, "lat decode timeout: pic_%d", inst->slice_dec_num);
 	inst->vsi->dec.timeout = !!timeout;
 
 	err = vpu_dec_end(vpu);
-	if (err == SLICE_HEADER_FULL || timeout || err == TRANS_BUFFER_FULL) {
-		err = -EINVAL;
-		goto err_scp_decode;
+	if (err == SLICE_HEADER_FULL || err == TRANS_BUFFER_FULL) {
+		if (!IS_VDEC_INNER_RACING(inst->ctx->dev->dec_capability))
+			vdec_msg_queue_qbuf(&inst->ctx->msg_queue.lat_ctx, lat_buf);
+		inst->slice_dec_num++;
+		mtk_vcodec_err(inst, "lat dec fail: pic_%d err:%d", inst->slice_dec_num, err);
+		return -EINVAL;
 	}
 
 	share_info->trans_end = inst->ctx->msg_queue.wdma_addr.dma_addr +
@@ -695,10 +705,6 @@ static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 
 	inst->slice_dec_num++;
 	return 0;
-
-err_scp_decode:
-	if (!IS_VDEC_INNER_RACING(inst->ctx->dev->dec_capability))
-		vdec_msg_queue_qbuf(&inst->ctx->msg_queue.lat_ctx, lat_buf);
 err_free_fb_out:
 	vdec_msg_queue_qbuf(&inst->ctx->msg_queue.lat_ctx, lat_buf);
 	mtk_vcodec_err(inst, "slice dec number: %d err: %d", inst->slice_dec_num, err);
-- 
2.35.1



