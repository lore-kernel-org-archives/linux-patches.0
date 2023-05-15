Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB46FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353DAC433EF;
	Mon, 15 May 2023 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172321;
	bh=Ey9SXtDm4MHsmW8U53wHZ768rSca/8UKbYWuPhjr9AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCF6e1LwBIgjhEdyEM2PwpPR5QSGb9WCVq7MPD6siX5+QfLERkn5j/+fKWBKQ9Y4c
	 0/bU+K4KHWoerB/nja4CQcO2xtu/LO46BnyZ/wwd4T/NkyR7m01aABf7PIWqZabcW0
	 7mg8Ua+0nCJP+FcwN7oc77kdJVrqLlO9DKzO1SfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/381] media: venus: vdec: Make decoder return LAST flag for sufficient event
Date: Mon, 15 May 2023 18:26:07 +0200
Message-Id: <20230515161742.068836796@linuxfoundation.org>
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

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit a4ca67af8b831a781ac53060c5d5c3dccaf7676e ]

This makes the decoder to behaives equally for sufficient and
insufficient events. After this change the LAST buffer flag will be set
when the new resolution (in dynamic-resolution-change state) is smaller
then the old bitstream resolution.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 50248ad9f190 ("media: venus: dec: Fix handling of the start cmd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 42 ++++++++++++++++--------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index b6b5ae0a457bb..3adff10fce6a7 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -636,6 +636,7 @@ static int vdec_output_conf(struct venus_inst *inst)
 {
 	struct venus_core *core = inst->core;
 	struct hfi_enable en = { .enable = 1 };
+	struct hfi_buffer_requirements bufreq;
 	u32 width = inst->out_width;
 	u32 height = inst->out_height;
 	u32 out_fmt, out2_fmt;
@@ -711,6 +712,23 @@ static int vdec_output_conf(struct venus_inst *inst)
 	}
 
 	if (IS_V3(core) || IS_V4(core)) {
+		ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
+		if (ret)
+			return ret;
+
+		if (bufreq.size > inst->output_buf_size)
+			return -EINVAL;
+
+		if (inst->dpb_fmt) {
+			ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT2,
+						      &bufreq);
+			if (ret)
+				return ret;
+
+			if (bufreq.size > inst->output2_buf_size)
+				return -EINVAL;
+		}
+
 		if (inst->output2_buf_size) {
 			ret = venus_helper_set_bufsize(inst,
 						       inst->output2_buf_size,
@@ -1330,19 +1348,15 @@ static void vdec_event_change(struct venus_inst *inst,
 	dev_dbg(dev, VDBGM "event %s sufficient resources (%ux%u)\n",
 		sufficient ? "" : "not", ev_data->width, ev_data->height);
 
-	if (sufficient) {
-		hfi_session_continue(inst);
-	} else {
-		switch (inst->codec_state) {
-		case VENUS_DEC_STATE_INIT:
-			inst->codec_state = VENUS_DEC_STATE_CAPTURE_SETUP;
-			break;
-		case VENUS_DEC_STATE_DECODING:
-			inst->codec_state = VENUS_DEC_STATE_DRC;
-			break;
-		default:
-			break;
-		}
+	switch (inst->codec_state) {
+	case VENUS_DEC_STATE_INIT:
+		inst->codec_state = VENUS_DEC_STATE_CAPTURE_SETUP;
+		break;
+	case VENUS_DEC_STATE_DECODING:
+		inst->codec_state = VENUS_DEC_STATE_DRC;
+		break;
+	default:
+		break;
 	}
 
 	/*
@@ -1351,7 +1365,7 @@ static void vdec_event_change(struct venus_inst *inst,
 	 * itself doesn't mark the last decoder output buffer with HFI EOS flag.
 	 */
 
-	if (!sufficient && inst->codec_state == VENUS_DEC_STATE_DRC) {
+	if (inst->codec_state == VENUS_DEC_STATE_DRC) {
 		int ret;
 
 		inst->next_buf_last = true;
-- 
2.39.2



