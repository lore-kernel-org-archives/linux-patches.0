Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133E1433BB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYZrQPOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB8FC433C8;
	Wed, 15 Nov 2023 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077050;
	bh=tFikCpqX94NMS/1hwNP3H6Ux1uIbpSOj+tXMz2m78qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYZrQPODqgvKc5+GJQBD5RnaqnYibZf+u0YyK7Jax7qeaZmPs4uOtZh8cQfvbQLxu
	 YKFz+jrdtOIValuxKnIvC55BGf13pD486QAD7pHOEttHpwTj1SIzR581iybItVnzDi
	 fdlwcHlLZx3dh0rdt0OEr88XAiJRhtegtLudBCUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 487/550] media: imx-jpeg: notify source chagne event when the first picture parsed
Date: Wed, 15 Nov 2023 14:17:51 -0500
Message-ID: <20231115191634.621867054@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit b833b178498dafa2156cfb6f4d3ce4581c21f1e5 ]

After gstreamer rework the dynamic resolution change handling, gstreamer
stop doing capture buffer allocation based on guesses and wait for the
source change event when available. It requires driver always notify
source change event in the initialization, even if the size parsed is
equal to the size set on capture queue. otherwise, the pipeline will be
stalled.

Currently driver may not notify source change event if the parsed format
and size are equal to those previously established, but it may stall the
gstreamer pipeline.

The link of gstreamer patch is
https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/4437

Fixes: b4e1fb8643da ("media: imx-jpeg: Support dynamic resolution change")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 7 ++++++-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 9ef0cb20f63be..c376ce1cabac4 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1348,7 +1348,8 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 	q_data_cap = mxc_jpeg_get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (mxc_jpeg_compare_format(q_data_cap->fmt, jpeg_src_buf->fmt))
 		jpeg_src_buf->fmt = q_data_cap->fmt;
-	if (q_data_cap->fmt != jpeg_src_buf->fmt ||
+	if (ctx->need_initial_source_change_evt ||
+	    q_data_cap->fmt != jpeg_src_buf->fmt ||
 	    q_data_cap->w != jpeg_src_buf->w ||
 	    q_data_cap->h != jpeg_src_buf->h) {
 		dev_dbg(dev, "Detected jpeg res=(%dx%d)->(%dx%d), pixfmt=%c%c%c%c\n",
@@ -1392,6 +1393,7 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 		mxc_jpeg_sizeimage(q_data_cap);
 		notify_src_chg(ctx);
 		ctx->source_change = 1;
+		ctx->need_initial_source_change_evt = false;
 		if (vb2_is_streaming(v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx)))
 			mxc_jpeg_set_last_buffer(ctx);
 	}
@@ -1611,6 +1613,9 @@ static int mxc_jpeg_queue_setup(struct vb2_queue *q,
 	for (i = 0; i < *nplanes; i++)
 		sizes[i] = mxc_jpeg_get_plane_size(q_data, i);
 
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->need_initial_source_change_evt = true;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index d80e94cc9d992..dc4afeeff5b65 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -99,6 +99,7 @@ struct mxc_jpeg_ctx {
 	enum mxc_jpeg_enc_state		enc_state;
 	int				slot;
 	unsigned int			source_change;
+	bool				need_initial_source_change_evt;
 	bool				header_parsed;
 	struct v4l2_ctrl_handler	ctrl_handler;
 	u8				jpeg_quality;
-- 
2.42.0



