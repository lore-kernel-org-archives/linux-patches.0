Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445236BCED;
	Tue,  6 Jan 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722190; cv=none; b=fiEmLnxs1huuorCsI0tM6JL3wZB8SdmutmMb91ZY4S+wDohZvwV7a3iQyTOoS+uay10Lm8ft9Jbi5S6ntjgHOqSbxs1mTnOq8teWDohPZ7Gzc9LNV/FxCVWO0hHm8aGpIWq7cCX4Pw4mtY1ZiWMrxk+t/ikfcegpy7t3ikHb910=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722190; c=relaxed/simple;
	bh=RrjkorEmFF7E9YLezQC+3xsUvi5oTaaOBAdQdSFB/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WheOdpys09FdrQlaUliE+DxfwupU8SH1dUTmENdguY4VOt+JvHufacFRGdGEqvtDML0ui2U/OwjrF9oL+FQglUfV67SFE2k250xD2QY4mKdzXtvn0e1SiCXOxrJL7Q9FgTyXGReAWG5YWyuMutOSoc5Tuhyt2OaEqXEuLVZh8ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9FpbQ+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9FpbQ+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9800CC116C6;
	Tue,  6 Jan 2026 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722190;
	bh=RrjkorEmFF7E9YLezQC+3xsUvi5oTaaOBAdQdSFB/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9FpbQ+DqaUHGCrzE99VPKTmnBYrfjyc5PHhaSxydLsY7tdmC6L9lrxPtoSe2cGUs
	 KyRhwUjaXpBiRDoMrdkUHsHRJTTT83RvibOuNs/G4DicfaBeDyrjzZhqh+F/n5nGt/
	 IhC0GE1OQPLSEjIgrxXq84nC/oP7xfMfngwCqlcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 190/312] media: mediatek: vcodec: Use spinlock for context list protection lock
Date: Tue,  6 Jan 2026 18:04:24 +0100
Message-ID: <20260106170554.703516205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit a5844227e0f030d2af2d85d4aed10c5eca6ca176 upstream.

Previously a mutex was added to protect the encoder and decoder context
lists from unexpected changes originating from the SCP IP block, causing
the context pointer to go invalid, resulting in a NULL pointer
dereference in the IPI handler.

Turns out on the MT8173, the VPU IPI handler is called from hard IRQ
context. This causes a big warning from the scheduler. This was first
reported downstream on the ChromeOS kernels, but is also reproducible
on mainline using Fluster with the FFmpeg v4l2m2m decoders. Even though
the actual capture format is not supported, the affected code paths
are triggered.

Since this lock just protects the context list and operations on it are
very fast, it should be OK to switch to a spinlock.

Fixes: 6467cda18c9f ("media: mediatek: vcodec: adding lock to protect decoder context list")
Fixes: afaaf3a0f647 ("media: mediatek: vcodec: adding lock to protect encoder context list")
Cc: Yunfei Dong <yunfei.dong@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c   |   10 +++++---
 drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c |   12 +++++-----
 drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h |    2 -
 drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c        |    5 ++--
 drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c |   12 +++++-----
 drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.h |    2 -
 drivers/media/platform/mediatek/vcodec/encoder/venc_vpu_if.c        |    5 ++--
 7 files changed, 28 insertions(+), 20 deletions(-)

--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
@@ -47,30 +47,32 @@ static void mtk_vcodec_vpu_reset_dec_han
 {
 	struct mtk_vcodec_dec_dev *dev = priv;
 	struct mtk_vcodec_dec_ctx *ctx;
+	unsigned long flags;
 
 	dev_err(&dev->plat_dev->dev, "Watchdog timeout!!");
 
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_for_each_entry(ctx, &dev->ctx_list, list) {
 		ctx->state = MTK_STATE_ABORT;
 		mtk_v4l2_vdec_dbg(0, ctx, "[%d] Change to state MTK_STATE_ABORT", ctx->id);
 	}
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 }
 
 static void mtk_vcodec_vpu_reset_enc_handler(void *priv)
 {
 	struct mtk_vcodec_enc_dev *dev = priv;
 	struct mtk_vcodec_enc_ctx *ctx;
+	unsigned long flags;
 
 	dev_err(&dev->plat_dev->dev, "Watchdog timeout!!");
 
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_for_each_entry(ctx, &dev->ctx_list, list) {
 		ctx->state = MTK_STATE_ABORT;
 		mtk_v4l2_vdec_dbg(0, ctx, "[%d] Change to state MTK_STATE_ABORT", ctx->id);
 	}
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 }
 
 static const struct mtk_vcodec_fw_ops mtk_vcodec_vpu_msg = {
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -198,6 +198,7 @@ static int fops_vcodec_open(struct file
 	struct mtk_vcodec_dec_ctx *ctx = NULL;
 	int ret = 0, i, hw_count;
 	struct vb2_queue *src_vq;
+	unsigned long flags;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -267,9 +268,9 @@ static int fops_vcodec_open(struct file
 
 	ctx->dev->vdec_pdata->init_vdec_params(ctx);
 
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_add(&ctx->list, &dev->ctx_list);
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 	mtk_vcodec_dbgfs_create(ctx);
 
 	mutex_unlock(&dev->dev_mutex);
@@ -294,6 +295,7 @@ static int fops_vcodec_release(struct fi
 {
 	struct mtk_vcodec_dec_dev *dev = video_drvdata(file);
 	struct mtk_vcodec_dec_ctx *ctx = file_to_dec_ctx(file);
+	unsigned long flags;
 
 	mtk_v4l2_vdec_dbg(0, ctx, "[%d] decoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
@@ -312,9 +314,9 @@ static int fops_vcodec_release(struct fi
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
 
 	mtk_vcodec_dbgfs_remove(dev, ctx->id);
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_del_init(&ctx->list);
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 	return 0;
@@ -407,7 +409,7 @@ static int mtk_vcodec_probe(struct platf
 	for (i = 0; i < MTK_VDEC_HW_MAX; i++)
 		mutex_init(&dev->dec_mutex[i]);
 	mutex_init(&dev->dev_mutex);
-	mutex_init(&dev->dev_ctx_lock);
+	spin_lock_init(&dev->dev_ctx_lock);
 	spin_lock_init(&dev->irqlock);
 
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h
@@ -285,7 +285,7 @@ struct mtk_vcodec_dec_dev {
 	/* decoder hardware mutex lock */
 	struct mutex dec_mutex[MTK_VDEC_HW_MAX];
 	struct mutex dev_mutex;
-	struct mutex dev_ctx_lock;
+	spinlock_t dev_ctx_lock;
 	struct workqueue_struct *decode_workqueue;
 
 	spinlock_t irqlock;
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
@@ -75,16 +75,17 @@ static void handle_get_param_msg_ack(con
 static bool vpu_dec_check_ap_inst(struct mtk_vcodec_dec_dev *dec_dev, struct vdec_vpu_inst *vpu)
 {
 	struct mtk_vcodec_dec_ctx *ctx;
+	unsigned long flags;
 	int ret = false;
 
-	mutex_lock(&dec_dev->dev_ctx_lock);
+	spin_lock_irqsave(&dec_dev->dev_ctx_lock, flags);
 	list_for_each_entry(ctx, &dec_dev->ctx_list, list) {
 		if (!IS_ERR_OR_NULL(ctx) && ctx->vpu_inst == vpu) {
 			ret = true;
 			break;
 		}
 	}
-	mutex_unlock(&dec_dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dec_dev->dev_ctx_lock, flags);
 
 	return ret;
 }
--- a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c
@@ -117,6 +117,7 @@ static int fops_vcodec_open(struct file
 	struct mtk_vcodec_enc_ctx *ctx = NULL;
 	int ret = 0;
 	struct vb2_queue *src_vq;
+	unsigned long flags;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -176,9 +177,9 @@ static int fops_vcodec_open(struct file
 	mtk_v4l2_venc_dbg(2, ctx, "Create instance [%d]@%p m2m_ctx=%p ",
 			  ctx->id, ctx, ctx->m2m_ctx);
 
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_add(&ctx->list, &dev->ctx_list);
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 
 	mutex_unlock(&dev->dev_mutex);
 	mtk_v4l2_venc_dbg(0, ctx, "%s encoder [%d]", dev_name(&dev->plat_dev->dev),
@@ -203,6 +204,7 @@ static int fops_vcodec_release(struct fi
 {
 	struct mtk_vcodec_enc_dev *dev = video_drvdata(file);
 	struct mtk_vcodec_enc_ctx *ctx = file_to_enc_ctx(file);
+	unsigned long flags;
 
 	mtk_v4l2_venc_dbg(1, ctx, "[%d] encoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
@@ -213,9 +215,9 @@ static int fops_vcodec_release(struct fi
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
 
-	mutex_lock(&dev->dev_ctx_lock);
+	spin_lock_irqsave(&dev->dev_ctx_lock, flags);
 	list_del_init(&ctx->list);
-	mutex_unlock(&dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&dev->dev_ctx_lock, flags);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 	return 0;
@@ -297,7 +299,7 @@ static int mtk_vcodec_probe(struct platf
 
 	mutex_init(&dev->enc_mutex);
 	mutex_init(&dev->dev_mutex);
-	mutex_init(&dev->dev_ctx_lock);
+	spin_lock_init(&dev->dev_ctx_lock);
 	spin_lock_init(&dev->irqlock);
 
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
--- a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.h
+++ b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_drv.h
@@ -206,7 +206,7 @@ struct mtk_vcodec_enc_dev {
 	/* encoder hardware mutex lock */
 	struct mutex enc_mutex;
 	struct mutex dev_mutex;
-	struct mutex dev_ctx_lock;
+	spinlock_t dev_ctx_lock;
 	struct workqueue_struct *encode_workqueue;
 
 	int enc_irq;
--- a/drivers/media/platform/mediatek/vcodec/encoder/venc_vpu_if.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/venc_vpu_if.c
@@ -45,16 +45,17 @@ static void handle_enc_encode_msg(struct
 static bool vpu_enc_check_ap_inst(struct mtk_vcodec_enc_dev *enc_dev, struct venc_vpu_inst *vpu)
 {
 	struct mtk_vcodec_enc_ctx *ctx;
+	unsigned long flags;
 	int ret = false;
 
-	mutex_lock(&enc_dev->dev_ctx_lock);
+	spin_lock_irqsave(&enc_dev->dev_ctx_lock, flags);
 	list_for_each_entry(ctx, &enc_dev->ctx_list, list) {
 		if (!IS_ERR_OR_NULL(ctx) && ctx->vpu_inst == vpu) {
 			ret = true;
 			break;
 		}
 	}
-	mutex_unlock(&enc_dev->dev_ctx_lock);
+	spin_unlock_irqrestore(&enc_dev->dev_ctx_lock, flags);
 
 	return ret;
 }


