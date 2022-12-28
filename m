Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B031863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C4FC433D2;
	Wed, 28 Dec 2022 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242325;
	bh=6WPVI2RzqdiPWNz6u8FMFbRCToeTpaZF137s1wsRmk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQEPkDlVKwWFh0p0y/Tay/buZDnN/k3v4dJ+IpiyzwqdalzDhJlrRGauQ5F0rPvra
	 2Lr//AimxZYah4C76B3u2BvVczw2ukipPSO8cAcRQtwQ2Ojh8/JjQb9HIxP+u+/Qjb
	 7aRm263j2iqSk8Z/0JrdiE5t9eOTEL9mV3LeAl9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0397/1073] media: mediatek: vcodec: Fix getting NULL pointer for dst buffer
Date: Wed, 28 Dec 2022 15:33:05 +0100
Message-Id: <20221228144338.801201091@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit d879f770e4d1d5f0d9b692d3a2702f23ee441dbb ]

The driver may can't get v4l2 buffer when lat or core decode timeout,
will lead to crash when call v4l2_m2m_buf_done to set dst buffer
(NULL pointer) done.

Fixes: 7b182b8d9c85 ("media: mediatek: vcodec: Refactor get and put capture buffer flow")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/mtk_vcodec_dec_stateless.c        | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
index c45bd2599bb2..e86809052a9f 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
@@ -138,10 +138,13 @@ static void mtk_vdec_stateless_cap_to_disp(struct mtk_vcodec_ctx *ctx, int error
 		state = VB2_BUF_STATE_DONE;
 
 	vb2_dst = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-	v4l2_m2m_buf_done(vb2_dst, state);
-
-	mtk_v4l2_debug(2, "free frame buffer id:%d to done list",
-		       vb2_dst->vb2_buf.index);
+	if (vb2_dst) {
+		v4l2_m2m_buf_done(vb2_dst, state);
+		mtk_v4l2_debug(2, "free frame buffer id:%d to done list",
+			       vb2_dst->vb2_buf.index);
+	} else {
+		mtk_v4l2_err("dst buffer is NULL");
+	}
 
 	if (src_buf_req)
 		v4l2_ctrl_request_complete(src_buf_req, &ctx->ctrl_hdl);
-- 
2.35.1



