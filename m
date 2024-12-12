Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CB23A580;
	Thu, 12 Dec 2024 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022079; cv=none; b=GCbIEDrnPDupNEM5Is/b9y8mP+PulGvihyMqx1QJA36U2ER5fuGi+lpXM+21ZqEYLyL3o+PWeQU9uCeLCEhYLAcXXMXRTgMpUFxMxjGT6h/fVRpBMqy6EX9JzRiLqQD9a1p4cirdwFjPu31gdoQJmY9Q8u6gDJp33RBlnGhcP3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022079; c=relaxed/simple;
	bh=9VeHxGTA1FucJ6GeQ79HRarRJenh3hXsh64+a9NCek8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piKsouScpC5fJndkNDdB+uk3pllAifqA7hNrC1Hk7MOS3qhPOhBshT6a8RyozjCRmoTQFodbkPMaUos03DIVv5oTr70wB0mIjXfdVO0zSWIriZ2Nwtaoyo/iqEMazFv00kNH5Kq6Ii3VyGo/3ByYxsG9w5cCAHB36R5zWvdrdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRtnY3YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRtnY3YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C7AC4CECE;
	Thu, 12 Dec 2024 16:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022079;
	bh=9VeHxGTA1FucJ6GeQ79HRarRJenh3hXsh64+a9NCek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRtnY3YOOAUXPYiI2NQlhOV2dJE2WOhlx7U4QpGp7GhiYVMt/9aCMn60CLn08b7Xw
	 keD0/s7LcsO2UoKNm0F47f+XmIvxyKZBg4NP+k7cKOdYgDn9H/hU7wWNccl8SriNwU
	 bTpCo3zjS9umrsfvWuPN32WAO3aQoPaH/UC920t8=
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
Subject: [PATCH 5.15 141/565] media: venus: provide ctx queue lock for ioctl synchronization
Date: Thu, 12 Dec 2024 15:55:36 +0100
Message-ID: <20241212144317.055195867@linuxfoundation.org>
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
index cf9d2dd265f7d..b83e4cb214d39 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -381,6 +381,7 @@ enum venus_inst_modes {
  * @sequence_out:	a sequence counter for output queue
  * @m2m_dev:	a reference to m2m device structure
  * @m2m_ctx:	a reference to m2m context structure
+ * @ctx_q_lock:	a lock to serialize video device ioctl calls
  * @state:	current state of the instance
  * @done:	a completion for sync HFI operation
  * @error:	an error returned during last HFI sync operation
@@ -448,6 +449,7 @@ struct venus_inst {
 	u32 sequence_out;
 	struct v4l2_m2m_dev *m2m_dev;
 	struct v4l2_m2m_ctx *m2m_ctx;
+	struct mutex ctx_q_lock;
 	unsigned int state;
 	struct completion done;
 	unsigned int error;
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index fef414f624069..3cb8a284fc68f 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1537,6 +1537,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 0;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->ctx_q_lock;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1551,6 +1552,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 0;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->ctx_q_lock;
 	return vb2_queue_init(dst_vq);
 }
 
@@ -1569,6 +1571,7 @@ static int vdec_open(struct file *file)
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
 	mutex_init(&inst->lock);
+	mutex_init(&inst->ctx_q_lock);
 
 	inst->core = core;
 	inst->session_type = VIDC_SESSION_TYPE_DEC;
@@ -1643,6 +1646,7 @@ static int vdec_close(struct file *file)
 	ida_destroy(&inst->dpb_ids);
 	hfi_session_destroy(inst);
 	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index ae47535168d12..4a439b4908ea7 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1355,6 +1355,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->ctx_q_lock;
 	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
 		src_vq->bidirectional = 1;
 	ret = vb2_queue_init(src_vq);
@@ -1371,6 +1372,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 1;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->ctx_q_lock;
 	return vb2_queue_init(dst_vq);
 }
 
@@ -1403,6 +1405,7 @@ static int venc_open(struct file *file)
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
 	mutex_init(&inst->lock);
+	mutex_init(&inst->ctx_q_lock);
 
 	inst->core = core;
 	inst->session_type = VIDC_SESSION_TYPE_ENC;
@@ -1471,6 +1474,7 @@ static int venc_close(struct file *file)
 	venc_ctrl_deinit(inst);
 	hfi_session_destroy(inst);
 	mutex_destroy(&inst->lock);
+	mutex_destroy(&inst->ctx_q_lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
-- 
2.43.0



