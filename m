Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A278F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD374C433C7;
	Sun, 16 Jul 2023 20:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538789;
	bh=rhu/ApJ2l+uClfHnn+bAgVtOU6+dPXY2VjGaUWCfjyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZjGb7FrRn6qH1JvEKXWxUDqh9D8vF7munf8XMGS4uqNbPewQknEVD+r4vylGsqsQ
	 E9wzN6/NfGmBodhNz0Mb9yZnYCBAO3FjVSfomn50C/cbUNn6wwPboof2dZduRhWBcX
	 YDQwJSByHztItfyKmHBLtKpE5JIoRTdMg7l7mWAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 577/800] media: mediatek: vcodec: using decoder status instead of core work count
Date: Sun, 16 Jul 2023 21:47:10 +0200
Message-ID: <20230716195002.485449226@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 2864e304faec04c2674328aad0e820a9cd84cdec ]

Adding the definition of decoder status to separate different decoder
period for core hardware.

core_work_cnt is the number of core work queued to work queue, the control
is very complex, leading to some unreasonable test result.

Using parameter status to indicate whether queue core work to work queue.

Fixes: 2e0ef56d81cb ("media: mediatek: vcodec: making sure queue_work successfully")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/vdec_msg_queue.c | 33 ++++++++-----------
 .../platform/mediatek/vcodec/vdec_msg_queue.h | 16 +++++++--
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
index f3073d1e7f420..03f8d7cd8eddc 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
@@ -71,7 +71,6 @@ static void vdec_msg_queue_dec(struct vdec_msg_queue *msg_queue, int hardware_in
 int vdec_msg_queue_qbuf(struct vdec_msg_queue_ctx *msg_ctx, struct vdec_lat_buf *buf)
 {
 	struct list_head *head;
-	int status;
 
 	head = vdec_get_buf_list(msg_ctx->hardware_index, buf);
 	if (!head) {
@@ -87,12 +86,9 @@ int vdec_msg_queue_qbuf(struct vdec_msg_queue_ctx *msg_ctx, struct vdec_lat_buf
 	if (msg_ctx->hardware_index != MTK_VDEC_CORE) {
 		wake_up_all(&msg_ctx->ready_to_use);
 	} else {
-		if (buf->ctx->msg_queue.core_work_cnt <
-			atomic_read(&buf->ctx->msg_queue.core_list_cnt)) {
-			status = queue_work(buf->ctx->dev->core_workqueue,
-					    &buf->ctx->msg_queue.core_work);
-			if (status)
-				buf->ctx->msg_queue.core_work_cnt++;
+		if (!(buf->ctx->msg_queue.status & CONTEXT_LIST_QUEUED)) {
+			queue_work(buf->ctx->dev->core_workqueue, &buf->ctx->msg_queue.core_work);
+			buf->ctx->msg_queue.status |= CONTEXT_LIST_QUEUED;
 		}
 	}
 
@@ -261,7 +257,10 @@ static void vdec_msg_queue_core_work(struct work_struct *work)
 		container_of(msg_queue, struct mtk_vcodec_ctx, msg_queue);
 	struct mtk_vcodec_dev *dev = ctx->dev;
 	struct vdec_lat_buf *lat_buf;
-	int status;
+
+	spin_lock(&ctx->dev->msg_queue_core_ctx.ready_lock);
+	ctx->msg_queue.status &= ~CONTEXT_LIST_QUEUED;
+	spin_unlock(&ctx->dev->msg_queue_core_ctx.ready_lock);
 
 	lat_buf = vdec_msg_queue_dqbuf(&dev->msg_queue_core_ctx);
 	if (!lat_buf)
@@ -278,17 +277,13 @@ static void vdec_msg_queue_core_work(struct work_struct *work)
 	vdec_msg_queue_qbuf(&ctx->msg_queue.lat_ctx, lat_buf);
 
 	wake_up_all(&ctx->msg_queue.core_dec_done);
-	spin_lock(&dev->msg_queue_core_ctx.ready_lock);
-	lat_buf->ctx->msg_queue.core_work_cnt--;
-
-	if (lat_buf->ctx->msg_queue.core_work_cnt <
-		atomic_read(&lat_buf->ctx->msg_queue.core_list_cnt)) {
-		status = queue_work(lat_buf->ctx->dev->core_workqueue,
-				    &lat_buf->ctx->msg_queue.core_work);
-		if (status)
-			lat_buf->ctx->msg_queue.core_work_cnt++;
+	if (!(ctx->msg_queue.status & CONTEXT_LIST_QUEUED) &&
+	    atomic_read(&msg_queue->core_list_cnt)) {
+		spin_lock(&ctx->dev->msg_queue_core_ctx.ready_lock);
+		ctx->msg_queue.status |= CONTEXT_LIST_QUEUED;
+		spin_unlock(&ctx->dev->msg_queue_core_ctx.ready_lock);
+		queue_work(ctx->dev->core_workqueue, &msg_queue->core_work);
 	}
-	spin_unlock(&dev->msg_queue_core_ctx.ready_lock);
 }
 
 int vdec_msg_queue_init(struct vdec_msg_queue *msg_queue,
@@ -303,13 +298,13 @@ int vdec_msg_queue_init(struct vdec_msg_queue *msg_queue,
 		return 0;
 
 	msg_queue->ctx = ctx;
-	msg_queue->core_work_cnt = 0;
 	vdec_msg_queue_init_ctx(&msg_queue->lat_ctx, MTK_VDEC_LAT0);
 	INIT_WORK(&msg_queue->core_work, vdec_msg_queue_core_work);
 
 	atomic_set(&msg_queue->lat_list_cnt, 0);
 	atomic_set(&msg_queue->core_list_cnt, 0);
 	init_waitqueue_head(&msg_queue->core_dec_done);
+	msg_queue->status = CONTEXT_LIST_EMPTY;
 
 	msg_queue->wdma_addr.size =
 		vde_msg_queue_get_trans_size(ctx->picinfo.buf_w,
diff --git a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.h b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.h
index a5d44bc97c16b..8f82d14847726 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.h
+++ b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.h
@@ -21,6 +21,18 @@ struct mtk_vcodec_ctx;
 struct mtk_vcodec_dev;
 typedef int (*core_decode_cb_t)(struct vdec_lat_buf *lat_buf);
 
+/**
+ * enum core_ctx_status - Context decode status for core hardwre.
+ * @CONTEXT_LIST_EMPTY: No buffer queued on core hardware(must always be 0)
+ * @CONTEXT_LIST_QUEUED: Buffer queued to core work list
+ * @CONTEXT_LIST_DEC_DONE: context decode done
+ */
+enum core_ctx_status {
+	CONTEXT_LIST_EMPTY = 0,
+	CONTEXT_LIST_QUEUED,
+	CONTEXT_LIST_DEC_DONE,
+};
+
 /**
  * struct vdec_msg_queue_ctx - represents a queue for buffers ready to be processed
  * @ready_to_use: ready used queue used to signalize when get a job queue
@@ -77,7 +89,7 @@ struct vdec_lat_buf {
  * @lat_list_cnt: used to record each instance lat list count
  * @core_list_cnt: used to record each instance core list count
  * @core_dec_done: core work queue decode done event
- * @core_work_cnt: the number of core work in work queue
+ * @status: current context decode status for core hardware
  */
 struct vdec_msg_queue {
 	struct vdec_lat_buf lat_buf[NUM_BUFFER_COUNT];
@@ -93,7 +105,7 @@ struct vdec_msg_queue {
 	atomic_t lat_list_cnt;
 	atomic_t core_list_cnt;
 	wait_queue_head_t core_dec_done;
-	int core_work_cnt;
+	int status;
 };
 
 /**
-- 
2.39.2



