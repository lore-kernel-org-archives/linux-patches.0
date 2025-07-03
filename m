Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199582EF66C;
	Thu,  3 Jul 2025 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555994; cv=none; b=WVn8J1NxZrkkQALWb0kiUgMkkCoXNVFca4vkT6wevJDID5fBQNQ1BQ8AnKHJFL0URuIkaJBAYCdA6ggwhMckGK2SpGRCc5jRjAMa7TqMnGSgCOGQs2a010jJ4pW1+MIbgBc9SNNCSIeP7WExQXLABMLcmuNBHjEWDPgYUIrMYzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555994; c=relaxed/simple;
	bh=8+i3+Mmm4t4gEeuMaamNaCb9cHGj3e60Ey/M0icLsw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFquZ1Vej+xj4AQXZnEXccGva83vYT0OIvutxnjs9oOxKYOUIL+j8ZmECFGRaIHCT1FGmvr6IXvHJo3MQAOtEk0SOJFyO2nBEcQjWZy4WeM5G2KsaiBABaAdY74/jUEtYUCa300HW0SzDxjxsbZSm63aJULWpHM5wv8B2HBE80E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AivTGyPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AivTGyPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F8FC4CEE3;
	Thu,  3 Jul 2025 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555993;
	bh=8+i3+Mmm4t4gEeuMaamNaCb9cHGj3e60Ey/M0icLsw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AivTGyPE8V0yUuQz7BJaQnvXNXaG11cf8WZcoxc321orkYESuXEZj+O1gu2Uc5XVM
	 3pVgv2Cyp2KwVXlt6hiFPspcELp11uh/IyCGDKCjR7SC6ctIu+A4Ml5nNKHSfD7spi
	 VuaZfJn76Y+WuAIRtHBdug4axRSC9l460O3UUN5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/132] media: imx-jpeg: Add a timeout mechanism for each frame
Date: Thu,  3 Jul 2025 16:42:11 +0200
Message-ID: <20250703143941.079058802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit cfed9632ca8e8bdf0128745ae2400b72c4292886 ]

Add a timeout mechanism for each frame.
If the frame can't be decoded or encoded,
driver can cancel it to avoid hang.

Fixes: 2db16c6ed72ce ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 46e9c092f850 ("media: imx-jpeg: Move mxc_jpeg_free_slot_data() ahead")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 55 ++++++++++++++++---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  1 +
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index c3655ab4511b4..5e897dda0ac63 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -330,6 +330,10 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-3)");
 
+static unsigned int hw_timeout = 2000;
+module_param(hw_timeout, int, 0644);
+MODULE_PARM_DESC(hw_timeout, "MXC JPEG hw timeout, the number of milliseconds");
+
 static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q, u32 precision);
 static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q);
 
@@ -569,6 +573,26 @@ static void mxc_jpeg_check_and_set_last_buffer(struct mxc_jpeg_ctx *ctx,
 	}
 }
 
+static void mxc_jpeg_job_finish(struct mxc_jpeg_ctx *ctx, enum vb2_buffer_state state, bool reset)
+{
+	struct mxc_jpeg_dev *jpeg = ctx->mxc_jpeg;
+	void __iomem *reg = jpeg->base_reg;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	mxc_jpeg_check_and_set_last_buffer(ctx, src_buf, dst_buf);
+	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	v4l2_m2m_buf_done(src_buf, state);
+	v4l2_m2m_buf_done(dst_buf, state);
+
+	mxc_jpeg_disable_irq(reg, ctx->slot);
+	ctx->mxc_jpeg->slot_data[ctx->slot].used = false;
+	if (reset)
+		mxc_jpeg_sw_reset(reg);
+}
+
 static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 {
 	struct mxc_jpeg_dev *jpeg = priv;
@@ -601,6 +625,9 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 		goto job_unlock;
 	}
 
+	if (!jpeg->slot_data[slot].used)
+		goto job_unlock;
+
 	dec_ret = readl(reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
 	writel(dec_ret, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS)); /* w1c */
 
@@ -665,14 +692,9 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 	buf_state = VB2_BUF_STATE_DONE;
 
 buffers_done:
-	mxc_jpeg_disable_irq(reg, ctx->slot);
-	jpeg->slot_data[slot].used = false; /* unused, but don't free */
-	mxc_jpeg_check_and_set_last_buffer(ctx, src_buf, dst_buf);
-	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	v4l2_m2m_buf_done(src_buf, buf_state);
-	v4l2_m2m_buf_done(dst_buf, buf_state);
+	mxc_jpeg_job_finish(ctx, buf_state, false);
 	spin_unlock(&jpeg->hw_lock);
+	cancel_delayed_work(&ctx->task_timer);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 	return IRQ_HANDLED;
 job_unlock:
@@ -1003,6 +1025,23 @@ static int mxc_jpeg_job_ready(void *priv)
 	return ctx->source_change ? 0 : 1;
 }
 
+static void mxc_jpeg_device_run_timeout(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mxc_jpeg_ctx *ctx = container_of(dwork, struct mxc_jpeg_ctx, task_timer);
+	struct mxc_jpeg_dev *jpeg = ctx->mxc_jpeg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->mxc_jpeg->hw_lock, flags);
+	if (ctx->slot < MXC_MAX_SLOTS && ctx->mxc_jpeg->slot_data[ctx->slot].used) {
+		dev_warn(jpeg->dev, "%s timeout, cancel it\n",
+			 ctx->mxc_jpeg->mode == MXC_JPEG_DECODE ? "decode" : "encode");
+		mxc_jpeg_job_finish(ctx, VB2_BUF_STATE_ERROR, true);
+		v4l2_m2m_job_finish(ctx->mxc_jpeg->m2m_dev, ctx->fh.m2m_ctx);
+	}
+	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
+}
+
 static void mxc_jpeg_device_run(void *priv)
 {
 	struct mxc_jpeg_ctx *ctx = priv;
@@ -1088,6 +1127,7 @@ static void mxc_jpeg_device_run(void *priv)
 					 &src_buf->vb2_buf, &dst_buf->vb2_buf);
 		mxc_jpeg_dec_mode_go(dev, reg);
 	}
+	schedule_delayed_work(&ctx->task_timer, msecs_to_jiffies(hw_timeout));
 end:
 	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
 }
@@ -1681,6 +1721,7 @@ static int mxc_jpeg_open(struct file *file)
 	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
 	mxc_jpeg_set_default_params(ctx);
 	ctx->slot = MXC_MAX_SLOTS; /* slot not allocated yet */
+	INIT_DELAYED_WORK(&ctx->task_timer, mxc_jpeg_device_run_timeout);
 
 	if (mxc_jpeg->mode == MXC_JPEG_DECODE)
 		dev_dbg(dev, "Opened JPEG decoder instance %p\n", ctx);
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index d742b638ddc93..a0dad86e40eab 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -97,6 +97,7 @@ struct mxc_jpeg_ctx {
 	bool				header_parsed;
 	struct v4l2_ctrl_handler	ctrl_handler;
 	u8				jpeg_quality;
+	struct delayed_work		task_timer;
 };
 
 struct mxc_jpeg_slot_data {
-- 
2.39.5



