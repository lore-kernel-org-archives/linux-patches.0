Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB44422A7E4;
	Thu, 12 Dec 2024 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022075; cv=none; b=ds5R/i5k5gfxWlJh4mtHLOHApB2n8teSzusAoyb+0caYhHeMkcgSer8Ivws1xGYFHXYSFD1b6W1ozmIqzMy4E3J9LxPZmhFCPOEHaNIt3zjxtZlPEdIGRIqOiX4NN2TTMiDBGXJe/QQkeUqu37GdMbxy6N7OjZIFm5pJ7hfqlGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022075; c=relaxed/simple;
	bh=viBTxaL9O+/m9oKG143gxEJ1lkmYZkRvNZ1Ae3GJOgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFbqBeSBkugct6H9nE8hzBoLexjoztY2ao2FP7LsZ8EfolayKpY7Fk0xCVeZiBhpZok7L8zIbbX6kGXXNMBExePRejVBd5qUqz37v+TVghNVDI7aj2g2qq8jTne6tjVDGqMVId/NjHVayGwl95lOA08pEy4u0DIkaqeIkK7WqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czm52eZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czm52eZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A510C4CECE;
	Thu, 12 Dec 2024 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022075;
	bh=viBTxaL9O+/m9oKG143gxEJ1lkmYZkRvNZ1Ae3GJOgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czm52eZzBZTbVwUx0PRCyFUbSOlEXApw8qRh74pxJvxpQS2Mpoi55OUYIy3w1cse4
	 RySAxDxW7WSwEBUGgsp4AhSUANS8nlj+1LvViET3WGXNToQdNlE+g8i814/szNtiC6
	 /4qtMvaKDmNWzcBzBw8lWebcTyItENdIhhIhscMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/565] venus: venc: add handling for VIDIOC_ENCODER_CMD
Date: Thu, 12 Dec 2024 15:55:35 +0100
Message-ID: <20241212144317.014033018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

[ Upstream commit 7493db46e4c4aa5126dd32f8eae12a4cdcf7a401 ]

Add handling for below commands in encoder:
1. V4L2_ENC_CMD_STOP
2. V4L2_ENC_CMD_START

Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.h |  9 ++++
 drivers/media/platform/qcom/venus/venc.c | 68 ++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 6869f0d06b774..cf9d2dd265f7d 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -310,6 +310,14 @@ enum venus_dec_state {
 	VENUS_DEC_STATE_DRC		= 7,
 };
 
+enum venus_enc_state {
+	VENUS_ENC_STATE_DEINIT		= 0,
+	VENUS_ENC_STATE_INIT		= 1,
+	VENUS_ENC_STATE_ENCODING	= 2,
+	VENUS_ENC_STATE_STOPPED		= 3,
+	VENUS_ENC_STATE_DRAIN		= 4,
+};
+
 struct venus_ts_metadata {
 	bool used;
 	u64 ts_ns;
@@ -415,6 +423,7 @@ struct venus_inst {
 	u8 quantization;
 	u8 xfer_func;
 	enum venus_dec_state codec_state;
+	enum venus_enc_state enc_state;
 	wait_queue_head_t reconf_wait;
 	unsigned int subscriptions;
 	int buf_count;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 52a7366d7a5fc..ae47535168d12 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -522,6 +522,51 @@ static int venc_subscribe_event(struct v4l2_fh *fh,
 	}
 }
 
+static int
+venc_encoder_cmd(struct file *file, void *fh, struct v4l2_encoder_cmd *cmd)
+{
+	struct venus_inst *inst = to_inst(file);
+	struct hfi_frame_data fdata = {0};
+	int ret = 0;
+
+	ret = v4l2_m2m_ioctl_try_encoder_cmd(file, fh, cmd);
+	if (ret)
+		return ret;
+
+	mutex_lock(&inst->lock);
+
+	if (cmd->cmd == V4L2_ENC_CMD_STOP &&
+	    inst->enc_state == VENUS_ENC_STATE_ENCODING) {
+		/*
+		 * Implement V4L2_ENC_CMD_STOP by enqueue an empty buffer on
+		 * encoder input to signal EOS.
+		 */
+		if (!(inst->streamon_out && inst->streamon_cap))
+			goto unlock;
+
+		fdata.buffer_type = HFI_BUFFER_INPUT;
+		fdata.flags |= HFI_BUFFERFLAG_EOS;
+		fdata.device_addr = 0xdeadb000;
+
+		ret = hfi_session_process_buf(inst, &fdata);
+
+		inst->enc_state = VENUS_ENC_STATE_DRAIN;
+	} else if (cmd->cmd == V4L2_ENC_CMD_START) {
+		if (inst->enc_state == VENUS_ENC_STATE_DRAIN) {
+			ret = -EBUSY;
+			goto unlock;
+		}
+		if (inst->enc_state == VENUS_ENC_STATE_STOPPED) {
+			vb2_clear_last_buffer_dequeued(&inst->fh.m2m_ctx->cap_q_ctx.q);
+			inst->enc_state = VENUS_ENC_STATE_ENCODING;
+		}
+	}
+
+unlock:
+	mutex_unlock(&inst->lock);
+	return ret;
+}
+
 static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_querycap = venc_querycap,
 	.vidioc_enum_fmt_vid_cap = venc_enum_fmt,
@@ -550,6 +595,7 @@ static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_subscribe_event = venc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_try_encoder_cmd = v4l2_m2m_ioctl_try_encoder_cmd,
+	.vidioc_encoder_cmd = venc_encoder_cmd,
 };
 
 static int venc_pm_get(struct venus_inst *inst)
@@ -1182,6 +1228,8 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret)
 		goto error;
 
+	inst->enc_state = VENUS_ENC_STATE_ENCODING;
+
 	mutex_unlock(&inst->lock);
 
 	return 0;
@@ -1201,10 +1249,21 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 static void venc_vb2_buf_queue(struct vb2_buffer *vb)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	venc_pm_get_put(inst);
 
 	mutex_lock(&inst->lock);
+
+	if (inst->enc_state == VENUS_ENC_STATE_STOPPED) {
+		vbuf->sequence = inst->sequence_cap++;
+		vbuf->field = V4L2_FIELD_NONE;
+		vb2_set_plane_payload(vb, 0, 0);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
+		mutex_unlock(&inst->lock);
+		return;
+	}
+
 	venus_helper_vb2_buf_queue(vb);
 	mutex_unlock(&inst->lock);
 }
@@ -1246,6 +1305,10 @@ static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
+		if ((vbuf->flags & V4L2_BUF_FLAG_LAST) &&
+		    inst->enc_state == VENUS_ENC_STATE_DRAIN) {
+			inst->enc_state = VENUS_ENC_STATE_STOPPED;
+		}
 	} else {
 		vbuf->sequence = inst->sequence_out++;
 	}
@@ -1346,6 +1409,9 @@ static int venc_open(struct file *file)
 	inst->clk_data.core_id = VIDC_CORE_ID_DEFAULT;
 	inst->core_acquired = false;
 
+	if (inst->enc_state == VENUS_ENC_STATE_DEINIT)
+		inst->enc_state = VENUS_ENC_STATE_INIT;
+
 	venus_helper_init_instance(inst);
 
 	ret = venc_ctrl_init(inst);
@@ -1408,6 +1474,8 @@ static int venc_close(struct file *file)
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
+	inst->enc_state = VENUS_ENC_STATE_DEINIT;
+
 	venc_pm_put(inst, false);
 
 	kfree(inst);
-- 
2.43.0



