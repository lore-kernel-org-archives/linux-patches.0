Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9536199222;
	Thu,  6 Jun 2024 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683688; cv=none; b=AbD9YqrHFTKv1ShVHa11x5smvJUSSuHQVakamdCfTelqpWC4+4yLg7m25qu1/KEIeQ5Clw2M18qUXt9Iw6tKj51AXXZcj641tPQNj/UfY8S2umJsWdPGAGPZvsLBRd/ZVrynGM3xmxxNRVIeVFbysteHuzSUexdWg8fpiYIE88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683688; c=relaxed/simple;
	bh=RBaMvAkkvJKQNqLccAl61MOu07v0xDyYG22t+VR+rto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+TbBNCfJHvy8Gq/r+D8Yqozwb8zHuK8Zjj3+8VrS23YJH8svobURK0QnAGo5gxm89JYP1/5zqRgtcudfEvmVz3t90aFD3MwjLontJk+KGqKhHj/QqhpevZO4kost+VaOUasrE3y85Y+1dmElccow6zIH2Q+6ySMGmlYgDpvoNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1I2qGkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1I2qGkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A310C2BD10;
	Thu,  6 Jun 2024 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683687;
	bh=RBaMvAkkvJKQNqLccAl61MOu07v0xDyYG22t+VR+rto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1I2qGkJqNPaYdU2gCgvwWdRVB6Y5OMZ7oohBgp5rvcfZlS1kfPado6Db9UL15uC7
	 YBGaA3oPSUBGdd8axXFboQewYdYduKO5f6ocisaJIzUm9pWakbKASXsw7LuoJ7v3qe
	 1rw6GRccJTBv60c5oMBVwKoEO7jQ3ZQHhq3gx0Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 594/744] media: mediatek: vcodec: fix possible unbalanced PM counter
Date: Thu,  6 Jun 2024 16:04:26 +0200
Message-ID: <20240606131751.527772509@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit c28d4921a1e3ce0a0374b7e9d68593be8802c42a ]

It is possible that mtk_vcodec_enc_pw_on fails, and in that scenario
the PM counter is not incremented, and subsequent call to
mtk_vcodec_enc_pw_off decrements the counter, leading to a PM imbalance.
Fix by bailing out of venc_if_encode in the case when mtk_vcodec_enc_pw_on
fails.

Fixes: 4e855a6efa54 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c     | 4 +++-
 .../platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h     | 2 +-
 drivers/media/platform/mediatek/vcodec/encoder/venc_drv_if.c | 5 ++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c
index a22b7dfc656e1..1a2b14a3e219c 100644
--- a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c
@@ -58,13 +58,15 @@ int mtk_vcodec_init_enc_clk(struct mtk_vcodec_enc_dev *mtkdev)
 	return 0;
 }
 
-void mtk_vcodec_enc_pw_on(struct mtk_vcodec_pm *pm)
+int mtk_vcodec_enc_pw_on(struct mtk_vcodec_pm *pm)
 {
 	int ret;
 
 	ret = pm_runtime_resume_and_get(pm->dev);
 	if (ret)
 		dev_err(pm->dev, "pm_runtime_resume_and_get fail: %d", ret);
+
+	return ret;
 }
 
 void mtk_vcodec_enc_pw_off(struct mtk_vcodec_pm *pm)
diff --git a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h
index 157ea08ba9e36..2e28f25e36cc4 100644
--- a/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h
+++ b/drivers/media/platform/mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h
@@ -10,7 +10,7 @@
 #include "mtk_vcodec_enc_drv.h"
 
 int mtk_vcodec_init_enc_clk(struct mtk_vcodec_enc_dev *dev);
-void mtk_vcodec_enc_pw_on(struct mtk_vcodec_pm *pm);
+int mtk_vcodec_enc_pw_on(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_enc_pw_off(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm);
 void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm);
diff --git a/drivers/media/platform/mediatek/vcodec/encoder/venc_drv_if.c b/drivers/media/platform/mediatek/vcodec/encoder/venc_drv_if.c
index c402a686f3cb2..e83747b8d69ab 100644
--- a/drivers/media/platform/mediatek/vcodec/encoder/venc_drv_if.c
+++ b/drivers/media/platform/mediatek/vcodec/encoder/venc_drv_if.c
@@ -64,7 +64,9 @@ int venc_if_encode(struct mtk_vcodec_enc_ctx *ctx,
 	ctx->dev->curr_ctx = ctx;
 	spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
 
-	mtk_vcodec_enc_pw_on(&ctx->dev->pm);
+	ret = mtk_vcodec_enc_pw_on(&ctx->dev->pm);
+	if (ret)
+		goto venc_if_encode_pw_on_err;
 	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
 	ret = ctx->enc_if->encode(ctx->drv_handle, opt, frm_buf,
 				  bs_buf, result);
@@ -75,6 +77,7 @@ int venc_if_encode(struct mtk_vcodec_enc_ctx *ctx,
 	ctx->dev->curr_ctx = NULL;
 	spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
 
+venc_if_encode_pw_on_err:
 	mtk_venc_unlock(ctx);
 	return ret;
 }
-- 
2.43.0



