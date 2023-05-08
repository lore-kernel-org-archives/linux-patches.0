Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1775154A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55455C433EF;
	Mon,  8 May 2023 10:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540049;
	bh=w/t2A4zVFzPFuF4F1zTVMPbkwgl6BgQv6xF64kcS2w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySVbZ9mx5AlVjbB7piVG0T80Mtz7yp9pxpwd6vxzXscD0GOYMv0BYTeGx9iUhYIGF
	 tWZZKmLMqiowEYzj4aroEMJIiZ7wyrY29faqMn4ChZw9SxgSr5jTXsQNOe6tfxJ2d7
	 71EEfqrTuuBMYU3T5jOfMFMRoVFAU8Sq0FwJjgTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/611] media: mediatek: vcodec: Use 4K frame size when supported by stateful decoder
Date: Mon,  8 May 2023 11:41:05 +0200
Message-Id: <20230508094429.656786987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit e25528e1dbe52784ac250071653104a8adc848e2 ]

After commit b018be06f3c7 ("media: mediatek: vcodec: Read max resolution
from dec_capability"), the stateful video decoder driver never really
sets its output frame size to 4K.

Parse the decoder capability reported by the firmware, and update the
output frame size in mtk_init_vdec_params to enable 4K frame size when
available.

Fixes: b018be06f3c7 ("media: mediatek: vcodec: Read max resolution from dec_capability")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/mtk_vcodec_dec_stateful.c        | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateful.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateful.c
index 035c86e7809fd..29991551cf614 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateful.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateful.c
@@ -11,7 +11,7 @@
 #include "mtk_vcodec_dec_pm.h"
 #include "vdec_drv_if.h"
 
-static const struct mtk_video_fmt mtk_video_formats[] = {
+static struct mtk_video_fmt mtk_video_formats[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_H264,
 		.type = MTK_FMT_DEC,
@@ -580,6 +580,16 @@ static int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
 
 static void mtk_init_vdec_params(struct mtk_vcodec_ctx *ctx)
 {
+	unsigned int i;
+
+	if (!(ctx->dev->dec_capability & VCODEC_CAPABILITY_4K_DISABLED)) {
+		for (i = 0; i < num_supported_formats; i++) {
+			mtk_video_formats[i].frmsize.max_width =
+				VCODEC_DEC_4K_CODED_WIDTH;
+			mtk_video_formats[i].frmsize.max_height =
+				VCODEC_DEC_4K_CODED_HEIGHT;
+		}
+	}
 }
 
 static struct vb2_ops mtk_vdec_frame_vb2_ops = {
-- 
2.39.2



