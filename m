Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ED83A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdWqO6NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0101C433CB;
	Wed, 15 Nov 2023 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077803;
	bh=clrNvGQ0OkDzN57eFDbZo8t88mli2y7vRj2urczHEEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdWqO6NGEpZEsVa3AGaPyZEsi6pQsRDxwxNVUg0seS4/WWj1C3dUr2u/ntHDE+O0L
	 YygwJjpe+6HNc8E6coBAKjXgWepZOPCUoeAmSSEaN9UqbAUPu25iRgUKyL11VaES4B
	 mueC4XIr1budfVfWnPOA1GGDnoHFSkoeUOKQSizo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 529/603] media: mediatek: vcodec: using encoder device to alloc/free encoder memory
Date: Wed, 15 Nov 2023 14:17:54 -0500
Message-ID: <20231115191648.530171138@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit 56c0ac05a31a0bf525fddc300ea997356ad8146f ]

Need to use encoder device to allocate/free encoder memory when calling
mtk_vcodec_mem_alloc/mtk_vcodec_mem_free, or leading to below crash log
when test encoder with decoder device.

pc : dma_alloc_attrs+0x44/0xf4
lr : mtk_vcodec_mem_alloc+0x50/0xa4 [mtk_vcodec_common]
sp : ffffffc0209f3990
x29: ffffffc0209f39a0 x28: ffffff8024102a18 x27: 0000000000000000
x26: 0000000000000000 x25: ffffffc00c06e2d8 x24: 0000000000000001
x23: 0000000000000cc0 x22: 0000000000000010 x21: 0000000000000800
x20: ffffff8024102a18 x19: 0000000000000000 x18: 0000000000000000
x17: 0000000000000009 x16: ffffffe389736a98 x15: 0000000000000078
x14: ffffffe389704434 x13: 0000000000000007 x12: ffffffe38a2b2560
x11: 0000000000000800 x10: 0000000000000004 x9 : ffffffe331f07484
x8 : 5400e9aef2395000 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000001 x4 : 0000000000000000 x3 : 0000000000000cc0
x2 : ffffff8024102a18 x1 : 0000000000000800 x0 : 0000000000000010
Call trace:
 dma_alloc_attrs+0x44/0xf4
 mtk_vcodec_mem_alloc+0x50/0xa4 [mtk_vcodec_common 2819d3d601f3cd06c1f2213ac1b9995134441421]
 h264_enc_set_param+0x27c/0x378 [mtk_vcodec_enc 772cc3d26c254e8cf54079451ef8d930d2eb4404]
 venc_if_set_param+0x4c/0x7c [mtk_vcodec_enc 772cc3d26c254e8cf54079451ef8d930d2eb4404]
 vb2ops_venc_start_streaming+0x1bc/0x328 [mtk_vcodec_enc 772cc3d26c254e8cf54079451ef8d930d2eb4404]
 vb2_start_streaming+0x64/0x12c
 vb2_core_streamon+0x114/0x158
 vb2_streamon+0x38/0x60
 v4l2_m2m_streamon+0x48/0x88
 v4l2_m2m_ioctl_streamon+0x20/0x2c
 v4l_streamon+0x2c/0x38
 __video_do_ioctl+0x2c4/0x3dc
 video_usercopy+0x404/0x934
 video_ioctl2+0x20/0x2c
 v4l2_ioctl+0x54/0x64
 v4l2_compat_ioctl32+0x90/0xa34
 __arm64_compat_sys_ioctl+0x128/0x13c
 invoke_syscall+0x4c/0x108
 el0_svc_common+0x98/0x104
 do_el0_svc_compat+0x28/0x34
 el0_svc_compat+0x2c/0x74
 el0t_32_sync_handler+0xa8/0xcc
 el0t_32_sync+0x194/0x198
Code: aa0003f6 aa0203f4 aa0103f5 f900

'Fixes: 01abf5fbb081c ("media: mediatek: vcodec: separate struct 'mtk_vcodec_ctx'")'
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/common/mtk_vcodec_util.c  | 56 +++++++++++++------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_util.c b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_util.c
index 908602031fd0e..9ce34a3b5ee67 100644
--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_util.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_util.c
@@ -47,20 +47,32 @@ EXPORT_SYMBOL(mtk_vcodec_write_vdecsys);
 
 int mtk_vcodec_mem_alloc(void *priv, struct mtk_vcodec_mem *mem)
 {
+	enum mtk_instance_type inst_type = *((unsigned int *)priv);
+	struct platform_device *plat_dev;
 	unsigned long size = mem->size;
-	struct mtk_vcodec_dec_ctx *ctx = priv;
-	struct device *dev = &ctx->dev->plat_dev->dev;
+	int id;
 
-	mem->va = dma_alloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
+	if (inst_type == MTK_INST_ENCODER) {
+		struct mtk_vcodec_enc_ctx *enc_ctx = priv;
+
+		plat_dev = enc_ctx->dev->plat_dev;
+		id = enc_ctx->id;
+	} else {
+		struct mtk_vcodec_dec_ctx *dec_ctx = priv;
+
+		plat_dev = dec_ctx->dev->plat_dev;
+		id = dec_ctx->id;
+	}
+
+	mem->va = dma_alloc_coherent(&plat_dev->dev, size, &mem->dma_addr, GFP_KERNEL);
 	if (!mem->va) {
-		mtk_v4l2_vdec_err(ctx, "%s dma_alloc size=%ld failed!", dev_name(dev), size);
+		mtk_v4l2_err(plat_dev, "%s dma_alloc size=%ld failed!",
+			     dev_name(&plat_dev->dev), size);
 		return -ENOMEM;
 	}
 
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]  - va      = %p", ctx->id, mem->va);
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]  - dma     = 0x%lx", ctx->id,
-			  (unsigned long)mem->dma_addr);
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]    size = 0x%lx", ctx->id, size);
+	mtk_v4l2_debug(plat_dev, 3, "[%d] - va = %p dma = 0x%lx size = 0x%lx", id, mem->va,
+		       (unsigned long)mem->dma_addr, size);
 
 	return 0;
 }
@@ -68,21 +80,33 @@ EXPORT_SYMBOL(mtk_vcodec_mem_alloc);
 
 void mtk_vcodec_mem_free(void *priv, struct mtk_vcodec_mem *mem)
 {
+	enum mtk_instance_type inst_type = *((unsigned int *)priv);
+	struct platform_device *plat_dev;
 	unsigned long size = mem->size;
-	struct mtk_vcodec_dec_ctx *ctx = priv;
-	struct device *dev = &ctx->dev->plat_dev->dev;
+	int id;
+
+	if (inst_type == MTK_INST_ENCODER) {
+		struct mtk_vcodec_enc_ctx *enc_ctx = priv;
+
+		plat_dev = enc_ctx->dev->plat_dev;
+		id = enc_ctx->id;
+	} else {
+		struct mtk_vcodec_dec_ctx *dec_ctx = priv;
+
+		plat_dev = dec_ctx->dev->plat_dev;
+		id = dec_ctx->id;
+	}
 
 	if (!mem->va) {
-		mtk_v4l2_vdec_err(ctx, "%s dma_free size=%ld failed!", dev_name(dev), size);
+		mtk_v4l2_err(plat_dev, "%s dma_free size=%ld failed!",
+			     dev_name(&plat_dev->dev), size);
 		return;
 	}
 
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]  - va      = %p", ctx->id, mem->va);
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]  - dma     = 0x%lx", ctx->id,
-			  (unsigned long)mem->dma_addr);
-	mtk_v4l2_vdec_dbg(3, ctx, "[%d]    size = 0x%lx", ctx->id, size);
+	mtk_v4l2_debug(plat_dev, 3, "[%d] - va = %p dma = 0x%lx size = 0x%lx", id, mem->va,
+		       (unsigned long)mem->dma_addr, size);
 
-	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
+	dma_free_coherent(&plat_dev->dev, size, mem->va, mem->dma_addr);
 	mem->va = NULL;
 	mem->dma_addr = 0;
 	mem->size = 0;
-- 
2.42.0



