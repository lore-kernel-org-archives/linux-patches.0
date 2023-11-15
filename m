Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD6D3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFDQxlhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10AFC433C8;
	Wed, 15 Nov 2023 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077819;
	bh=JvUmh1bc8nUrH1AKsZ+Rxce85jgesCu02nklXhBR/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFDQxlhIG5wOjExjMxYFjhIGAAUnxxVKBWD3EQ6TgqElYmLiCBkMMEPMQP9ynUHSS
	 wnZrJcRRJzn6slnmUoVGcwtZF7sKex2nhsvrd+1byLXbJa0Z0wK65nDZKNHwyKgJdt
	 j2okFhFpfyxVy5i2QmdloNLgyj2WFdKG/fKBlo34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 516/603] media: mtk-jpegenc: Fix bug in JPEG encode quality selection
Date: Wed, 15 Nov 2023 14:17:41 -0500
Message-ID: <20231115191647.772944597@linuxfoundation.org>
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

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 0aeccc63f3bc4cfd49dc4893da1409402ee6b295 ]

The driver uses the upper-bound approach to decide the target JPEG
encode quality, but there's a logic bug that if the desired quality is
higher than what the driver can support, the driver falls back to using
the worst quality.

Fix the bug by assuming using the best quality in the beginning, and
with trivial refactor to avoid long lines.

Fixes: 45f13a57d813 ("media: platform: Add jpeg enc feature")
Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_enc_hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_enc_hw.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_enc_hw.c
index 2bbc48c7402ca..f8fa3b841ccfb 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_enc_hw.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_enc_hw.c
@@ -127,6 +127,7 @@ void mtk_jpeg_set_enc_params(struct mtk_jpeg_ctx *ctx,  void __iomem *base)
 	u32 img_stride;
 	u32 mem_stride;
 	u32 i, enc_quality;
+	u32 nr_enc_quality = ARRAY_SIZE(mtk_jpeg_enc_quality);
 
 	value = width << 16 | height;
 	writel(value, base + JPEG_ENC_IMG_SIZE);
@@ -157,8 +158,8 @@ void mtk_jpeg_set_enc_params(struct mtk_jpeg_ctx *ctx,  void __iomem *base)
 	writel(img_stride, base + JPEG_ENC_IMG_STRIDE);
 	writel(mem_stride, base + JPEG_ENC_STRIDE);
 
-	enc_quality = mtk_jpeg_enc_quality[0].hardware_value;
-	for (i = 0; i < ARRAY_SIZE(mtk_jpeg_enc_quality); i++) {
+	enc_quality = mtk_jpeg_enc_quality[nr_enc_quality - 1].hardware_value;
+	for (i = 0; i < nr_enc_quality; i++) {
 		if (ctx->enc_quality <= mtk_jpeg_enc_quality[i].quality_param) {
 			enc_quality = mtk_jpeg_enc_quality[i].hardware_value;
 			break;
-- 
2.42.0



