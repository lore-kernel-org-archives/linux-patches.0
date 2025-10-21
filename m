Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6A41A3029;
	Tue, 21 Oct 2025 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077259; cv=none; b=kg02v09aebZ8C9u3ivJVnLdE7QAffgV0LgPQuDA1jx5EjT8lVLe9k7XqIDxCvkDsxE5QfsxsaxmwjrodAPa5F5G7uNBHjgTcsR3HD6UXh1Qahs27+79XzD91JG26c94pT4zFGSDLXau1YwvUJ/hTVt5KJ1IARfrdbFQCxWWL06k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077259; c=relaxed/simple;
	bh=wxaSUvvtJlQG0rwr6GwM7UtxgF02S8S2+ji4ytAd0uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sThQE/hhdnf3hOIdnYN5SUAdJFvixU34KgGvqLjFx4SVppmwhyZpZzBVguzVI/pJGYIv61lnVGSBnC4EAqU2qF9j9vNflZsbYZ8KoiQwVjwmImXEEDhlZDLQZfZRcSu/OvSPrUiJnbgMI8DYXPEeE35YAkAlkfgqlaDk7Jhtc4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRZ+lbzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRZ+lbzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E4C4CEF1;
	Tue, 21 Oct 2025 20:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077259;
	bh=wxaSUvvtJlQG0rwr6GwM7UtxgF02S8S2+ji4ytAd0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRZ+lbzhcBnrAxrNKTy5zVcXKMPOoimogbJO0CpJiY6jNyW6H1adkICtUnNACCpxH
	 0ESI8aj9tTk4NDD+nktXjKarZt/+Kasl3nvPMo6tftS4k4cUiOVAJsw8blEbpV+9z4
	 hiqye1BqPUFEDqaLnF1XUsrs3/GnjKf5tuVBw+Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 050/159] media: nxp: imx8-isi: m2m: Fix streaming cleanup on release
Date: Tue, 21 Oct 2025 21:50:27 +0200
Message-ID: <20251021195044.416923851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@nxp.com>

[ Upstream commit 178aa3360220231dd91e7dbc2eb984525886c9c1 ]

If streamon/streamoff calls are imbalanced, such as when exiting an
application with Ctrl+C when streaming, the m2m usage_count will never
reach zero and the ISI channel won't be freed. Besides from that, if the
input line width is more than 2K, it will trigger a WARN_ON():

[ 59.222120] ------------[ cut here ]------------
[ 59.226758] WARNING: drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c:631 at mxc_isi_channel_chain+0xa4/0x120, CPU#4: v4l2-ctl/654
[ 59.238569] Modules linked in: ap1302
[ 59.242231] CPU: 4 UID: 0 PID: 654 Comm: v4l2-ctl Not tainted 6.16.0-rc4-next-20250704-06511-gff0e002d480a-dirty #258 PREEMPT
[ 59.253597] Hardware name: NXP i.MX95 15X15 board (DT)
[ 59.258720] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 59.265669] pc : mxc_isi_channel_chain+0xa4/0x120
[ 59.270358] lr : mxc_isi_channel_chain+0x44/0x120
[ 59.275047] sp : ffff8000848c3b40
[ 59.278348] x29: ffff8000848c3b40 x28: ffff0000859b4c98 x27: ffff800081939f00
[ 59.285472] x26: 000000000000000a x25: ffff0000859b4cb8 x24: 0000000000000001
[ 59.292597] x23: ffff0000816f4760 x22: ffff0000816f4258 x21: ffff000084ceb780
[ 59.299720] x20: ffff000084342ff8 x19: ffff000084340000 x18: 0000000000000000
[ 59.306845] x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffffdb369e1c
[ 59.313969] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[ 59.321093] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[ 59.328217] x8 : ffff8000848c3d48 x7 : ffff800081930b30 x6 : ffff800081930b30
[ 59.335340] x5 : ffff0000859b6000 x4 : ffff80008193ae80 x3 : ffff800081022420
[ 59.342464] x2 : ffff0000852f6900 x1 : 0000000000000001 x0 : ffff000084341000
[ 59.349590] Call trace:
[ 59.352025]  mxc_isi_channel_chain+0xa4/0x120 (P)
[ 59.356722]  mxc_isi_m2m_streamon+0x160/0x20c
[ 59.361072]  v4l_streamon+0x24/0x30
[ 59.364556]  __video_do_ioctl+0x40c/0x4a0
[ 59.368560]  video_usercopy+0x2bc/0x690
[ 59.372382]  video_ioctl2+0x18/0x24
[ 59.375857]  v4l2_ioctl+0x40/0x60
[ 59.379168]  __arm64_sys_ioctl+0xac/0x104
[ 59.383172]  invoke_syscall+0x48/0x104
[ 59.386916]  el0_svc_common.constprop.0+0xc0/0xe0
[ 59.391613]  do_el0_svc+0x1c/0x28
[ 59.394915]  el0_svc+0x34/0xf4
[ 59.397966]  el0t_64_sync_handler+0xa0/0xe4
[ 59.402143]  el0t_64_sync+0x198/0x19c
[ 59.405801] ---[ end trace 0000000000000000 ]---

Address this issue by moving the streaming preparation and cleanup to
the vb2 .prepare_streaming() and .unprepare_streaming() operations. This
also simplifies the driver by allowing direct usage of the
v4l2_m2m_ioctl_streamon() and v4l2_m2m_ioctl_streamoff() helpers.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250821135123.29462-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Co-developed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ added bypass parameter to mxc_isi_channel_chain() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c |  226 ++++++++-------------
 1 file changed, 93 insertions(+), 133 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
@@ -43,7 +43,6 @@ struct mxc_isi_m2m_ctx_queue_data {
 	struct v4l2_pix_format_mplane format;
 	const struct mxc_isi_format_info *info;
 	u32 sequence;
-	bool streaming;
 };
 
 struct mxc_isi_m2m_ctx {
@@ -236,6 +235,66 @@ static void mxc_isi_m2m_vb2_buffer_queue
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
+static int mxc_isi_m2m_vb2_prepare_streaming(struct vb2_queue *q)
+{
+	struct mxc_isi_m2m_ctx *ctx = vb2_get_drv_priv(q);
+	const struct v4l2_pix_format_mplane *out_pix = &ctx->queues.out.format;
+	const struct v4l2_pix_format_mplane *cap_pix = &ctx->queues.cap.format;
+	const struct mxc_isi_format_info *cap_info = ctx->queues.cap.info;
+	const struct mxc_isi_format_info *out_info = ctx->queues.out.info;
+	struct mxc_isi_m2m *m2m = ctx->m2m;
+	bool bypass;
+	int ret;
+
+	guard(mutex)(&m2m->lock);
+
+	if (m2m->usage_count == INT_MAX)
+		return -EOVERFLOW;
+
+	bypass = cap_pix->width == out_pix->width &&
+		 cap_pix->height == out_pix->height &&
+		 cap_info->encoding == out_info->encoding;
+
+	/*
+	 * Acquire the pipe and initialize the channel with the first user of
+	 * the M2M device.
+	 */
+	if (m2m->usage_count == 0) {
+		ret = mxc_isi_channel_acquire(m2m->pipe,
+					      &mxc_isi_m2m_frame_write_done,
+					      bypass);
+		if (ret)
+			return ret;
+
+		mxc_isi_channel_get(m2m->pipe);
+	}
+
+	m2m->usage_count++;
+
+	/*
+	 * Allocate resources for the channel, counting how many users require
+	 * buffer chaining.
+	 */
+	if (!ctx->chained && out_pix->width > MXC_ISI_MAX_WIDTH_UNCHAINED) {
+		ret = mxc_isi_channel_chain(m2m->pipe, bypass);
+		if (ret)
+			goto err_deinit;
+
+		m2m->chained_count++;
+		ctx->chained = true;
+	}
+
+	return 0;
+
+err_deinit:
+	if (--m2m->usage_count == 0) {
+		mxc_isi_channel_put(m2m->pipe);
+		mxc_isi_channel_release(m2m->pipe);
+	}
+
+	return ret;
+}
+
 static int mxc_isi_m2m_vb2_start_streaming(struct vb2_queue *q,
 					   unsigned int count)
 {
@@ -265,13 +324,44 @@ static void mxc_isi_m2m_vb2_stop_streami
 	}
 }
 
+static void mxc_isi_m2m_vb2_unprepare_streaming(struct vb2_queue *q)
+{
+	struct mxc_isi_m2m_ctx *ctx = vb2_get_drv_priv(q);
+	struct mxc_isi_m2m *m2m = ctx->m2m;
+
+	guard(mutex)(&m2m->lock);
+
+	/*
+	 * If the last context is this one, reset it to make sure the device
+	 * will be reconfigured when streaming is restarted.
+	 */
+	if (m2m->last_ctx == ctx)
+		m2m->last_ctx = NULL;
+
+	/* Free the channel resources if this is the last chained context. */
+	if (ctx->chained && --m2m->chained_count == 0)
+		mxc_isi_channel_unchain(m2m->pipe);
+	ctx->chained = false;
+
+	/* Turn off the light with the last user. */
+	if (--m2m->usage_count == 0) {
+		mxc_isi_channel_disable(m2m->pipe);
+		mxc_isi_channel_put(m2m->pipe);
+		mxc_isi_channel_release(m2m->pipe);
+	}
+
+	WARN_ON(m2m->usage_count < 0);
+}
+
 static const struct vb2_ops mxc_isi_m2m_vb2_qops = {
 	.queue_setup		= mxc_isi_m2m_vb2_queue_setup,
 	.buf_init		= mxc_isi_m2m_vb2_buffer_init,
 	.buf_prepare		= mxc_isi_m2m_vb2_buffer_prepare,
 	.buf_queue		= mxc_isi_m2m_vb2_buffer_queue,
+	.prepare_streaming	= mxc_isi_m2m_vb2_prepare_streaming,
 	.start_streaming	= mxc_isi_m2m_vb2_start_streaming,
 	.stop_streaming		= mxc_isi_m2m_vb2_stop_streaming,
+	.unprepare_streaming	= mxc_isi_m2m_vb2_unprepare_streaming,
 };
 
 static int mxc_isi_m2m_queue_init(void *priv, struct vb2_queue *src_vq,
@@ -481,136 +571,6 @@ static int mxc_isi_m2m_s_fmt_vid(struct
 	return 0;
 }
 
-static int mxc_isi_m2m_streamon(struct file *file, void *fh,
-				enum v4l2_buf_type type)
-{
-	struct mxc_isi_m2m_ctx *ctx = to_isi_m2m_ctx(fh);
-	struct mxc_isi_m2m_ctx_queue_data *q = mxc_isi_m2m_ctx_qdata(ctx, type);
-	const struct v4l2_pix_format_mplane *out_pix = &ctx->queues.out.format;
-	const struct v4l2_pix_format_mplane *cap_pix = &ctx->queues.cap.format;
-	const struct mxc_isi_format_info *cap_info = ctx->queues.cap.info;
-	const struct mxc_isi_format_info *out_info = ctx->queues.out.info;
-	struct mxc_isi_m2m *m2m = ctx->m2m;
-	bool bypass;
-	int ret;
-
-	if (q->streaming)
-		return 0;
-
-	mutex_lock(&m2m->lock);
-
-	if (m2m->usage_count == INT_MAX) {
-		ret = -EOVERFLOW;
-		goto unlock;
-	}
-
-	bypass = cap_pix->width == out_pix->width &&
-		 cap_pix->height == out_pix->height &&
-		 cap_info->encoding == out_info->encoding;
-
-	/*
-	 * Acquire the pipe and initialize the channel with the first user of
-	 * the M2M device.
-	 */
-	if (m2m->usage_count == 0) {
-		ret = mxc_isi_channel_acquire(m2m->pipe,
-					      &mxc_isi_m2m_frame_write_done,
-					      bypass);
-		if (ret)
-			goto unlock;
-
-		mxc_isi_channel_get(m2m->pipe);
-	}
-
-	m2m->usage_count++;
-
-	/*
-	 * Allocate resources for the channel, counting how many users require
-	 * buffer chaining.
-	 */
-	if (!ctx->chained && out_pix->width > MXC_ISI_MAX_WIDTH_UNCHAINED) {
-		ret = mxc_isi_channel_chain(m2m->pipe, bypass);
-		if (ret)
-			goto deinit;
-
-		m2m->chained_count++;
-		ctx->chained = true;
-	}
-
-	/*
-	 * Drop the lock to start the stream, as the .device_run() operation
-	 * needs to acquire it.
-	 */
-	mutex_unlock(&m2m->lock);
-	ret = v4l2_m2m_ioctl_streamon(file, fh, type);
-	if (ret) {
-		/* Reacquire the lock for the cleanup path. */
-		mutex_lock(&m2m->lock);
-		goto unchain;
-	}
-
-	q->streaming = true;
-
-	return 0;
-
-unchain:
-	if (ctx->chained && --m2m->chained_count == 0)
-		mxc_isi_channel_unchain(m2m->pipe);
-	ctx->chained = false;
-
-deinit:
-	if (--m2m->usage_count == 0) {
-		mxc_isi_channel_put(m2m->pipe);
-		mxc_isi_channel_release(m2m->pipe);
-	}
-
-unlock:
-	mutex_unlock(&m2m->lock);
-	return ret;
-}
-
-static int mxc_isi_m2m_streamoff(struct file *file, void *fh,
-				 enum v4l2_buf_type type)
-{
-	struct mxc_isi_m2m_ctx *ctx = to_isi_m2m_ctx(fh);
-	struct mxc_isi_m2m_ctx_queue_data *q = mxc_isi_m2m_ctx_qdata(ctx, type);
-	struct mxc_isi_m2m *m2m = ctx->m2m;
-
-	v4l2_m2m_ioctl_streamoff(file, fh, type);
-
-	if (!q->streaming)
-		return 0;
-
-	mutex_lock(&m2m->lock);
-
-	/*
-	 * If the last context is this one, reset it to make sure the device
-	 * will be reconfigured when streaming is restarted.
-	 */
-	if (m2m->last_ctx == ctx)
-		m2m->last_ctx = NULL;
-
-	/* Free the channel resources if this is the last chained context. */
-	if (ctx->chained && --m2m->chained_count == 0)
-		mxc_isi_channel_unchain(m2m->pipe);
-	ctx->chained = false;
-
-	/* Turn off the light with the last user. */
-	if (--m2m->usage_count == 0) {
-		mxc_isi_channel_disable(m2m->pipe);
-		mxc_isi_channel_put(m2m->pipe);
-		mxc_isi_channel_release(m2m->pipe);
-	}
-
-	WARN_ON(m2m->usage_count < 0);
-
-	mutex_unlock(&m2m->lock);
-
-	q->streaming = false;
-
-	return 0;
-}
-
 static const struct v4l2_ioctl_ops mxc_isi_m2m_ioctl_ops = {
 	.vidioc_querycap		= mxc_isi_m2m_querycap,
 
@@ -631,8 +591,8 @@ static const struct v4l2_ioctl_ops mxc_i
 	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
 	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
 
-	.vidioc_streamon		= mxc_isi_m2m_streamon,
-	.vidioc_streamoff		= mxc_isi_m2m_streamoff,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,


