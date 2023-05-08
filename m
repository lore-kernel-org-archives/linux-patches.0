Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9665168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA49C433D2;
	Mon,  8 May 2023 11:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544027;
	bh=4kSVwRMWSeZudJI9wCrpqLtJBze2gZkJ3I8sCofRyEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJPx82bswcnWFSkz9WHkrTgy1ue1epqfVAJ/2MKkFBRQfHwaAOz9KrB5vwAL74tGN
	 C77ZG8r0vtgFN/aZrEjjtfewVX1j3Fp0FaH7SX2ysXbW9z+j8xluut9/KVoN9gDrR8
	 eoSiQXv9Phb53UUDOzcK90jpYQ+TmzGd/6zFgw1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	"Nicolas F. R. A. Prado" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 277/694] media: mediatek: vcodec: Force capture queue format to MM21
Date: Mon,  8 May 2023 11:41:52 +0200
Message-Id: <20230508094441.254130761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 68c7df527657a9e962da7b5b9c0308557357d8dc ]

While the decoder can produce frames in both MM21 and MT21C formats, only
MM21 is currently supported by userspace tools (like gstreamer and libyuv).
In order to ensure userspace keeps working after the SCP firmware is
updated to support both MM21 and MT21C formats, force the MM21 format for
the capture queue.

This is meant as a stopgap solution while dynamic format switching between
MM21 and MT21C isn't implemented in the driver.

Fixes: 7501edef6b1f ("media: mediatek: vcodec: Different codec using different capture format")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: Nicolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nicolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/mtk_vcodec_dec.c | 24 +++----------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index 641f533c417fd..c99705681a03e 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -39,10 +39,9 @@ static bool mtk_vdec_get_cap_fmt(struct mtk_vcodec_ctx *ctx, int format_index)
 {
 	const struct mtk_vcodec_dec_pdata *dec_pdata = ctx->dev->vdec_pdata;
 	const struct mtk_video_fmt *fmt;
-	struct mtk_q_data *q_data;
 	int num_frame_count = 0, i;
-	bool ret = true;
 
+	fmt = &dec_pdata->vdec_formats[format_index];
 	for (i = 0; i < *dec_pdata->num_formats; i++) {
 		if (dec_pdata->vdec_formats[i].type != MTK_FMT_FRAME)
 			continue;
@@ -50,27 +49,10 @@ static bool mtk_vdec_get_cap_fmt(struct mtk_vcodec_ctx *ctx, int format_index)
 		num_frame_count++;
 	}
 
-	if (num_frame_count == 1)
+	if (num_frame_count == 1 || fmt->fourcc == V4L2_PIX_FMT_MM21)
 		return true;
 
-	fmt = &dec_pdata->vdec_formats[format_index];
-	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
-	switch (q_data->fmt->fourcc) {
-	case V4L2_PIX_FMT_VP8_FRAME:
-		if (fmt->fourcc == V4L2_PIX_FMT_MM21)
-			ret = true;
-		break;
-	case V4L2_PIX_FMT_H264_SLICE:
-	case V4L2_PIX_FMT_VP9_FRAME:
-		if (fmt->fourcc == V4L2_PIX_FMT_MM21)
-			ret = false;
-		break;
-	default:
-		ret = true;
-		break;
-	}
-
-	return ret;
+	return false;
 }
 
 static struct mtk_q_data *mtk_vdec_get_q_data(struct mtk_vcodec_ctx *ctx,
-- 
2.39.2



