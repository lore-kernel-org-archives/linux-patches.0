Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD22FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AED2C433EF;
	Mon, 15 May 2023 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172333;
	bh=XeZWahbMJT8ovNqGheTBRItFb5KlaSOAY2b5ATk/dEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEv3Vsr2D0I6xsgYxWP8YeTthiqHalBMffZXEbMiTt6Wk301W56PdcgJtlQhuHj2f
	 zpEmLNtzyRgBngWiKvNitZcAYwyVdXvamD6fR33edn7Q6DK4VBLq50OP7ytEQEagnJ
	 HaWqrdSlMQZbvcedXoIIke0EYcWeM+tNCGVvEIqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Krawczyk?= <mk@semihalf.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/381] media: venus: dec: Fix handling of the start cmd
Date: Mon, 15 May 2023 18:26:10 +0200
Message-Id: <20230515161742.211329282@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michał Krawczyk <mk@semihalf.com>

[ Upstream commit 50248ad9f190d527cbd578190ca769729518b703 ]

The decoder driver should clear the last_buffer_dequeued flag of the
capture queue upon receiving V4L2_DEC_CMD_START.

The last_buffer_dequeued flag is set upon receiving EOS (which always
happens upon receiving V4L2_DEC_CMD_STOP).

Without this patch, after issuing the V4L2_DEC_CMD_STOP and
V4L2_DEC_CMD_START, the vb2_dqbuf() function will always fail, even if
the buffers are completed by the hardware.

Fixes: beac82904a87 ("media: venus: make decoder compliant with stateful codec API")

Signed-off-by: Michał Krawczyk <mk@semihalf.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 766c292915272..c437a929a5451 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -495,6 +495,7 @@ static int
 vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 {
 	struct venus_inst *inst = to_inst(file);
+	struct vb2_queue *dst_vq;
 	struct hfi_frame_data fdata = {0};
 	int ret;
 
@@ -522,6 +523,13 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 			inst->codec_state = VENUS_DEC_STATE_DRAIN;
 			inst->drain_active = true;
 		}
+	} else if (cmd->cmd == V4L2_DEC_CMD_START &&
+		   inst->codec_state == VENUS_DEC_STATE_STOPPED) {
+		dst_vq = v4l2_m2m_get_vq(inst->fh.m2m_ctx,
+					 V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+		vb2_clear_last_buffer_dequeued(dst_vq);
+
+		inst->codec_state = VENUS_DEC_STATE_DECODING;
 	}
 
 unlock:
-- 
2.39.2



