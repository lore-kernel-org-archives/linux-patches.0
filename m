Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E423EA70;
	Thu, 12 Dec 2024 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019121; cv=none; b=D8npEMj4BdVL8fBIuCNSJjGPTAWL7QxTOu3MOS43lDxCkCOtbY4ks7vtR+a1tvKmInkcn9vLlIVOALc8SHpRG6adNi+xIEOctOEPwH3B3R0U7PPc1IeruuDFkQ/A0xx+LrXWc5EYD1WdmfETtAzUAzn4+1abpFXHww6ODG7tJfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019121; c=relaxed/simple;
	bh=FD05iF48vnhJ5dWTvSPgwIAylB9JWvqwsIvabOCyaG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLZz1tVeoDAh3fKPizgy/cG2HgMddp6/uA3xXGVIeSeWbpdJMML2Y1toC8jjfcdBs1X7ElmF8GoL1w8oG4uv3nnWZ/+tIg7P6k1RwEo2p3kOdDT9HkzpYYo4nHTndXsiOqzu8Kcy8Uy9hVvwilVIlU0lm9Y1Dp1JgaspDE/rsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P87RlrEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P87RlrEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20447C4CECE;
	Thu, 12 Dec 2024 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019120;
	bh=FD05iF48vnhJ5dWTvSPgwIAylB9JWvqwsIvabOCyaG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P87RlrEoLJlY/byBXYG7adcmtFI969B+FY7VD6PmMBli7/d3pHECNvG+uttpkKZt8
	 NQNws4UPx4Hjugk1BHL/BnXY+P43/T9/SdX9jekfQpILr5DuzRSdrKpyS0aB4WWy2t
	 dJ6hPOO0O7P2MzkdS0m9KFO4WR1QVlwPZPNhnSh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/772] media: venus: provide ctx queue lock for ioctl synchronization
Date: Thu, 12 Dec 2024 15:51:07 +0100
Message-ID: <20241212144354.963917887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 34318b808ef20cdddd4e187ea2df0455936cf61b ]

Video device has to provide a lock so that __video_do_ioctl()
can serialize IOCTL calls. Introduce a dedicated venus_inst
mutex for the purpose of vb2 operations synchronization.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.h | 2 ++
 drivers/media/platform/qcom/venus/vdec.c | 4 ++++
 drivers/media/platform/qcom/venus/venc.c | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index d147154c01ea5..83a97288319ba 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -390,6 +390,7 @@ enum venus_inst_modes {
  * @sequence_out:	a sequence counter for output queue
  * @m2m_dev:	a reference to m2m device structure
  * @m2m_ctx:	a reference to m2m context structure
+ * @ctx_q_lock:	a lock to serialize video device ioctl calls
  * @state:	current state of the instance
  * @done:	a completion for sync HFI operation
  * @error:	an error returned during last HFI sync operation
@@ -461,6 +462,7 @@ struct venus_inst {
 	u32 sequence_out;
 	struct v4l2_m2m_dev *m2m_dev;
 	struct v4l2_m2m_ctx *m2m_ctx;
+	struct mutex ctx_q_lock;
 	unsigned int state;
 	struct completion done;
 	unsigned int error;
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 7ea976efc0242..3b51d603605ee 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1604,6 +1604,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 0;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->ctx_q_lock;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1618,6 +1619,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 0;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->ctx_q_lock;
 	return vb2_queue_init(dst_vq);
 }
 
@@ -1636,6 +1638,7 @@ static int vdec_open(struct file *file)
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
 	mutex_init(&inst->lock);
+	mutex_init(&inst->ctx_q_lock);
 
 	inst->core = core;
 	inst->session_type = VIDC_SESSION_TYPE_DEC;
@@ -1712,6 +1715,7 @@ static int vdec_close(struct file *file)
 	ida_destroy(&inst->dpb_ids);
 	hfi_session_destroy(inst);
 	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index f4921dbe6b7ec..abd25720b96bc 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1370,6 +1370,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->ctx_q_lock;
 	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
 		src_vq->bidirectional = 1;
 	ret = vb2_queue_init(src_vq);
@@ -1386,6 +1387,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 1;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->ctx_q_lock;
 	return vb2_queue_init(dst_vq);
 }
 
@@ -1418,6 +1420,7 @@ static int venc_open(struct file *file)
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
 	mutex_init(&inst->lock);
+	mutex_init(&inst->ctx_q_lock);
 
 	inst->core = core;
 	inst->session_type = VIDC_SESSION_TYPE_ENC;
@@ -1487,6 +1490,7 @@ static int venc_close(struct file *file)
 	venc_ctrl_deinit(inst);
 	hfi_session_destroy(inst);
 	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
-- 
2.43.0



