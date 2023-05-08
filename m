Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD80168D2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EF1C433D2;
	Mon,  8 May 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541819;
	bh=sfmBdob86OOT7D8yZ6MQW+q1TSZdbATFPgSpbVp8eUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wu5teedF3pp/70cZ6CyS+P+4c0y09zb0W02cxt7PgD+zrkbJQWIIPyAdwCieJqU36
	 pwY7kmLSSU19Kpj7dUL7tKQKj3EQgEoobaBQEyE0oTC/HhnZICC4ruhZgB/MMgUemk
	 Gov+l2qWOM/gNEWh+3hsD/H40064/owTlv0W0+6E=
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
Subject: [PATCH 6.2 235/663] media: mediatek: vcodec: Make MM21 the default capture format
Date: Mon,  8 May 2023 11:41:01 +0200
Message-Id: <20230508094435.909891294@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit 6d020d81b91af80a977061e82de25cafa4456af5 ]

Given that only the MM21 capture format is supported by userspace tools
(like gstreamer and libyuv), make it the default capture format.

This allows us to force the MM21 format even when a MM21 and MT21C capable
firmware is available (which is needed while dynamic format switching isn't
implemented in the driver), without causing the following regressions on
v4l2-compliance:

        fail: v4l2-test-formats.cpp(478): pixelformat 3132544d (MT21) for buftype 9 not reported by ENUM_FMT
    test VIDIOC_G_FMT: FAIL
        fail: v4l2-test-formats.cpp(478): pixelformat 3132544d (MT21) for buftype 9 not reported by ENUM_FMT
    test VIDIOC_TRY_FMT: FAIL
        fail: v4l2-test-formats.cpp(478): pixelformat 3132544d (MT21) for buftype 9 not reported by ENUM_FMT
    test VIDIOC_S_FMT: FAIL

Fixes: 7501edef6b1f ("media: mediatek: vcodec: Different codec using different capture format")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: Nicolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nicolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
index ffbcee04dc26f..ab8f642d1e5b0 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
@@ -390,14 +390,14 @@ static void mtk_vcodec_get_supported_formats(struct mtk_vcodec_ctx *ctx)
 	if (num_formats)
 		return;
 
-	if (ctx->dev->dec_capability & MTK_VDEC_FORMAT_MM21) {
-		mtk_vcodec_add_formats(V4L2_PIX_FMT_MM21, ctx);
-		cap_format_count++;
-	}
 	if (ctx->dev->dec_capability & MTK_VDEC_FORMAT_MT21C) {
 		mtk_vcodec_add_formats(V4L2_PIX_FMT_MT21C, ctx);
 		cap_format_count++;
 	}
+	if (ctx->dev->dec_capability & MTK_VDEC_FORMAT_MM21) {
+		mtk_vcodec_add_formats(V4L2_PIX_FMT_MM21, ctx);
+		cap_format_count++;
+	}
 	if (ctx->dev->dec_capability & MTK_VDEC_FORMAT_H264_SLICE) {
 		mtk_vcodec_add_formats(V4L2_PIX_FMT_H264_SLICE, ctx);
 		out_format_count++;
-- 
2.39.2



