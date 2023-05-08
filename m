Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C51549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71542C433D2;
	Mon,  8 May 2023 09:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539951;
	bh=gSehkfD1EDJpF842xeAIolCDMdaaS9HL5V8LGdYRtNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAEtayGRQFg/ohIRPq8RTZHF8aNvGLG5/gSlz5q0dqrJbIBGkTg0mX9IVtUbUXyn1
	 oKBahewJnpsV0oeiMC7BH+eDyEFJAsAPp0qGcWblIhH+rNfMs5dWN6mB0sYM8LDVBh
	 SNXSXyBYACVijzDRY3yiVywaapZCOb+hPyl03RTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/611] media: amphion: decoder implement display delay enable
Date: Mon,  8 May 2023 11:40:15 +0200
Message-Id: <20230508094427.979436295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit ffa331d9bf9407655fc4c4d57dcc92ed2868e326 ]

amphion vpu support a low latency mode,
when V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE is enabled,
decoder can display frame immediately after it's decoded.
Only h264 is support yet.

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c       | 32 +++++++++++++++++++++
 drivers/media/platform/amphion/vpu_codec.h  |  3 +-
 drivers/media/platform/amphion/vpu_malone.c |  4 ++-
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index b27e6bed85f0f..4918547793dc1 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -139,7 +139,31 @@ static const struct vpu_format vdec_formats[] = {
 	{0, 0, 0, 0},
 };
 
+static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vpu_inst *inst = ctrl_to_inst(ctrl);
+	struct vdec_t *vdec = inst->priv;
+	int ret = 0;
+
+	vpu_inst_lock(inst);
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE:
+		vdec->params.display_delay_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY:
+		vdec->params.display_delay = ctrl->val;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	vpu_inst_unlock(inst);
+
+	return ret;
+}
+
 static const struct v4l2_ctrl_ops vdec_ctrl_ops = {
+	.s_ctrl = vdec_op_s_ctrl,
 	.g_volatile_ctrl = vpu_helper_g_volatile_ctrl,
 };
 
@@ -152,6 +176,14 @@ static int vdec_ctrl_init(struct vpu_inst *inst)
 	if (ret)
 		return ret;
 
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY,
+			  0, 0, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE,
+			  0, 1, 1, 0);
+
 	ctrl = v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
 				 V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 32, 1, 2);
 	if (ctrl)
diff --git a/drivers/media/platform/amphion/vpu_codec.h b/drivers/media/platform/amphion/vpu_codec.h
index 528a93f08ecd4..bac6d0d94f8a5 100644
--- a/drivers/media/platform/amphion/vpu_codec.h
+++ b/drivers/media/platform/amphion/vpu_codec.h
@@ -55,7 +55,8 @@ struct vpu_encode_params {
 struct vpu_decode_params {
 	u32 codec_format;
 	u32 output_format;
-	u32 b_dis_reorder;
+	u32 display_delay_enable;
+	u32 display_delay;
 	u32 b_non_frame;
 	u32 frame_count;
 	u32 end_flag;
diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index 9f2890730fd70..ae094cdc9bfc8 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -640,7 +640,9 @@ static int vpu_malone_set_params(struct vpu_shared_addr *shared,
 		hc->jpg[instance].jpg_mjpeg_interlaced = 0;
 	}
 
-	hc->codec_param[instance].disp_imm = params->b_dis_reorder ? 1 : 0;
+	hc->codec_param[instance].disp_imm = params->display_delay_enable ? 1 : 0;
+	if (malone_format != MALONE_FMT_AVC)
+		hc->codec_param[instance].disp_imm = 0;
 	hc->codec_param[instance].dbglog_enable = 0;
 	iface->dbglog_desc.level = 0;
 
-- 
2.39.2



