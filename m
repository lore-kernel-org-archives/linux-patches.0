Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B272BB03;
	Thu, 11 Apr 2024 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831418; cv=none; b=DyHZw6jYCHBIkQxdP3IPdbmzQJc6YEr3e3dNk5wxTIFoNaPDHbC5Mkq1W7tdK1TIFle87N+DrTOab1Y/fm6GMnwMeLwLRTp7r7skW1yw3U8i+BGoZLOD9tp8sSH86/yz/g/HhcNNTS98M2dpR/7le9GBd4pM0yLGna8Srwn1EpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831418; c=relaxed/simple;
	bh=G3hwrpk+gj34cQYO4EeUWoqvwtzlyv8D9HAFt9lHzW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRPv9JDbzkM6bPv9Yk6bJTgn5YOfKkxW69rOg8ZJXR6FE8FZHBVv6zJX6LY9ifZFwRmFUh0Yo3vyXh5Ti59y15SsY206UNbr3/EBdu1YwWRfTPWVZUOBqHKiFBkB1hrRxq0X2VwMUEl8SHSOm3PapJ3kFhSss35fG38omWoS7R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDz5F0Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDz5F0Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F30C433F1;
	Thu, 11 Apr 2024 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831418;
	bh=G3hwrpk+gj34cQYO4EeUWoqvwtzlyv8D9HAFt9lHzW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDz5F0CvMvlIaC7Z6FaFM189agwqy7AEpNKykoTnwU/JxESeNbkLRHO5MrNSBkRcx
	 sdxi49137NiVgH3nyggYGdiA05RR/aWNRtShOoUI0pfJInXZPdA1ECes8i8bbM9mht
	 cEFyNjWthQsKyiexzWHkKJ0W8InbwRIseiJsb/9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/114] media: mediatek: vcodec: adding lock to protect decoder context list
Date: Thu, 11 Apr 2024 11:57:14 +0200
Message-ID: <20240411095420.122087847@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 6467cda18c9f9b5f2f9a0aa1e2861c653e41f382 ]

Add a lock for the ctx_list, to avoid accessing a NULL pointer
within the 'vpu_dec_ipi_handler' function when the ctx_list has
been deleted due to an unexpected behavior on the SCP IP block.

Hardware name: Google juniper sku16 board (DT)
pstate: 20400005 (nzCv daif +PAN -UAO -TCO BTYPE=--)
pc : vpu_dec_ipi_handler+0x58/0x1f8 [mtk_vcodec_dec]
lr : scp_ipi_handler+0xd0/0x194 [mtk_scp]
sp : ffffffc0131dbbd0
x29: ffffffc0131dbbd0 x28: 0000000000000000
x27: ffffff9bb277f348 x26: ffffff9bb242ad00
x25: ffffffd2d440d3b8 x24: ffffffd2a13ff1d4
x23: ffffff9bb7fe85a0 x22: ffffffc0133fbdb0
x21: 0000000000000010 x20: ffffff9b050ea328
x19: ffffffc0131dbc08 x18: 0000000000001000
x17: 0000000000000000 x16: ffffffd2d461c6e0
x15: 0000000000000242 x14: 000000000000018f
x13: 000000000000004d x12: 0000000000000000
x11: 0000000000000001 x10: fffffffffffffff0
x9 : ffffff9bb6e793a8 x8 : 0000000000000000
x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : fffffffffffffff0
x3 : 0000000000000020 x2 : ffffff9bb6e79080
x1 : 0000000000000010 x0 : ffffffc0131dbc08
Call trace:
vpu_dec_ipi_handler+0x58/0x1f8 [mtk_vcodec_dec (HASH:6c3f 2)]
scp_ipi_handler+0xd0/0x194 [mtk_scp (HASH:7046 3)]
mt8183_scp_irq_handler+0x44/0x88 [mtk_scp (HASH:7046 3)]
scp_irq_handler+0x48/0x90 [mtk_scp (HASH:7046 3)]
irq_thread_fn+0x38/0x94
irq_thread+0x100/0x1c0
kthread+0x140/0x1fc
ret_from_fork+0x10/0x30
Code: 54000088 f94ca50a eb14015f 54000060 (f9400108)
---[ end trace ace43ce36cbd5c93 ]---
Kernel panic - not syncing: Oops: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: 0x12c4000000 from 0xffffffc010000000
PHYS_OFFSET: 0xffffffe580000000
CPU features: 0x08240002,2188200c
Memory Limit: none

Fixes: 655b86e52eac ("media: mediatek: vcodec: Fix possible invalid memory access for decoder")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c      | 4 ++--
 .../platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c    | 5 +++++
 .../platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h    | 2 ++
 drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c | 2 ++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
index 0849ffb0dcd45..831ec3d48b274 100644
--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
@@ -50,12 +50,12 @@ static void mtk_vcodec_vpu_reset_dec_handler(void *priv)
 
 	dev_err(&dev->plat_dev->dev, "Watchdog timeout!!");
 
-	mutex_lock(&dev->dev_mutex);
+	mutex_lock(&dev->dev_ctx_lock);
 	list_for_each_entry(ctx, &dev->ctx_list, list) {
 		ctx->state = MTK_STATE_ABORT;
 		mtk_v4l2_vdec_dbg(0, ctx, "[%d] Change to state MTK_STATE_ABORT", ctx->id);
 	}
-	mutex_unlock(&dev->dev_mutex);
+	mutex_unlock(&dev->dev_ctx_lock);
 }
 
 static void mtk_vcodec_vpu_reset_enc_handler(void *priv)
diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
index 0a89ce452ac32..20c0b1acf6186 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -268,7 +268,9 @@ static int fops_vcodec_open(struct file *file)
 
 	ctx->dev->vdec_pdata->init_vdec_params(ctx);
 
+	mutex_lock(&dev->dev_ctx_lock);
 	list_add(&ctx->list, &dev->ctx_list);
+	mutex_unlock(&dev->dev_ctx_lock);
 	mtk_vcodec_dbgfs_create(ctx);
 
 	mutex_unlock(&dev->dev_mutex);
@@ -311,7 +313,9 @@ static int fops_vcodec_release(struct file *file)
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
 
 	mtk_vcodec_dbgfs_remove(dev, ctx->id);
+	mutex_lock(&dev->dev_ctx_lock);
 	list_del_init(&ctx->list);
+	mutex_unlock(&dev->dev_ctx_lock);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 	return 0;
@@ -378,6 +382,7 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	for (i = 0; i < MTK_VDEC_HW_MAX; i++)
 		mutex_init(&dev->dec_mutex[i]);
 	mutex_init(&dev->dev_mutex);
+	mutex_init(&dev->dev_ctx_lock);
 	spin_lock_init(&dev->irqlock);
 
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h
index 7e36b2c69b7d1..b3a59af7c8ac5 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h
@@ -231,6 +231,7 @@ struct mtk_vcodec_dec_ctx {
  *
  * @dec_mutex: decoder hardware lock
  * @dev_mutex: video_device lock
+ * @dev_ctx_lock: the lock of context list
  * @decode_workqueue: decode work queue
  *
  * @irqlock: protect data access by irq handler and work thread
@@ -270,6 +271,7 @@ struct mtk_vcodec_dec_dev {
 	/* decoder hardware mutex lock */
 	struct mutex dec_mutex[MTK_VDEC_HW_MAX];
 	struct mutex dev_mutex;
+	struct mutex dev_ctx_lock;
 	struct workqueue_struct *decode_workqueue;
 
 	spinlock_t irqlock;
diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
index 82e57ae983d55..da6be556727bb 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
@@ -77,12 +77,14 @@ static bool vpu_dec_check_ap_inst(struct mtk_vcodec_dec_dev *dec_dev, struct vde
 	struct mtk_vcodec_dec_ctx *ctx;
 	int ret = false;
 
+	mutex_lock(&dec_dev->dev_ctx_lock);
 	list_for_each_entry(ctx, &dec_dev->ctx_list, list) {
 		if (!IS_ERR_OR_NULL(ctx) && ctx->vpu_inst == vpu) {
 			ret = true;
 			break;
 		}
 	}
+	mutex_unlock(&dec_dev->dev_ctx_lock);
 
 	return ret;
 }
-- 
2.43.0



