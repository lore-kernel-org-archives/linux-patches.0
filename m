Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B923A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cyYkP18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870B4C433C7;
	Wed, 15 Nov 2023 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077766;
	bh=hTHKwv/Wv2da/DNYhUHCrH9tQinB5jAYONtZlWlxSds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cyYkP18N2AG2hhsPljoJ+s8d2kDKyVos5wtk4Sh/VlSBADQe8JWXh1/BYvn/Yg5b
	 DC2YnUR5le92lutUDOivi9/7weMigMG38uQJY6ijU8Aq+6g9/gAkoZQYL+2edpgP/X
	 UdywwGUJ8gmAKFakkX8POyTgZbxDVrZ1wXeyLM3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/603] media: imx-jpeg: initiate a drain of the capture queue in dynamic resolution change
Date: Wed, 15 Nov 2023 14:17:32 -0500
Message-ID: <20231115191647.243226328@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 1c2786632e20c8f0fd4004fae3b3490276e5e5da ]

The last buffer from before the change must be marked,
with the V4L2_BUF_FLAG_LAST flag,
similarly to the Drain sequence above.

Meanwhile if V4L2_DEC_CMD_STOP is sent before
the source change triggered,
we need to restore the is_draing flag after
the draining in dynamic resolution change.

Fixes: b4e1fb8643da ("media: imx-jpeg: Support dynamic resolution change")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 27 ++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index b7a720198ce57..e74b0ed8ec5ba 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1322,6 +1322,20 @@ static bool mxc_jpeg_compare_format(const struct mxc_jpeg_fmt *fmt1,
 	return false;
 }
 
+static void mxc_jpeg_set_last_buffer(struct mxc_jpeg_ctx *ctx)
+{
+	struct vb2_v4l2_buffer *next_dst_buf;
+
+	next_dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	if (!next_dst_buf) {
+		ctx->fh.m2m_ctx->is_draining = true;
+		ctx->fh.m2m_ctx->next_buf_last = true;
+		return;
+	}
+
+	v4l2_m2m_last_buffer_done(ctx->fh.m2m_ctx, next_dst_buf);
+}
+
 static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 				   struct mxc_jpeg_src_buf *jpeg_src_buf)
 {
@@ -1378,6 +1392,8 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 		mxc_jpeg_sizeimage(q_data_cap);
 		notify_src_chg(ctx);
 		ctx->source_change = 1;
+		if (vb2_is_streaming(v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx)))
+			mxc_jpeg_set_last_buffer(ctx);
 	}
 
 	return ctx->source_change ? true : false;
@@ -1638,8 +1654,13 @@ static void mxc_jpeg_stop_streaming(struct vb2_queue *q)
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 	}
 
-	if (V4L2_TYPE_IS_OUTPUT(q->type) || !ctx->source_change)
-		v4l2_m2m_update_stop_streaming_state(ctx->fh.m2m_ctx, q);
+	v4l2_m2m_update_stop_streaming_state(ctx->fh.m2m_ctx, q);
+	/* if V4L2_DEC_CMD_STOP is sent before the source change triggered,
+	 * restore the is_draining flag
+	 */
+	if (V4L2_TYPE_IS_CAPTURE(q->type) && ctx->source_change && ctx->fh.m2m_ctx->last_src_buf)
+		ctx->fh.m2m_ctx->is_draining = true;
+
 	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
 	    v4l2_m2m_has_stopped(ctx->fh.m2m_ctx)) {
 		notify_eos(ctx);
@@ -1916,7 +1937,7 @@ static int mxc_jpeg_buf_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	for (i = 0; i < q_data->fmt->mem_planes; i++) {
 		sizeimage = mxc_jpeg_get_plane_size(q_data, i);
-		if (vb2_plane_size(vb, i) < sizeimage) {
+		if (!ctx->source_change && vb2_plane_size(vb, i) < sizeimage) {
 			dev_err(dev, "plane %d too small (%lu < %lu)",
 				i, vb2_plane_size(vb, i), sizeimage);
 			return -EINVAL;
-- 
2.42.0



