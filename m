Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72601170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654A4C433C7;
	Mon, 11 Sep 2023 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441666;
	bh=vggEKoSu+wCo3xzjwC54SL8nRQNY2OZV+CCim3qGJWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyjR/+CZ6WIrhDqC3AaZrhByoysQEN/wTqhMvMjrhQSlXgauU3F92V8jlch2/6wfz
	 DLrPYJwwEq/6s5q/3aODH5zl4tRNcWTlkxvSOn0rcxP/1vlVP3upOY4/XPosTsNsU0
	 ziTj9l3CiGhSjJY+LBMTD3MFFHhBTi66onlmekMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 467/739] media: verisilicon: Fix TRY_FMT on encoder OUTPUT
Date: Mon, 11 Sep 2023 15:44:26 +0200
Message-ID: <20230911134704.191840942@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit b3b4c9d3cb3bf8725a3ded26f7042b1a37f25333 ]

Commit f100ce3bbd6a ("media: verisilicon: Fix crash when probing
encoder") removed vpu_fmt from hantro_try_fmt(), since it was
initialized from vpu_dst_fmt, which may not be initialized, when TRY_FMT
is called. It was replaced by fmt, which is found using the pixelformat.

For the encoder, this changed the fmt to contain the raw format instead
of the coded format. The format constraints as of fmt->frmsize are only
valid for the coded format and are 0 for the raw formats. Therefore, the
size of a encoder OUTPUT device is constrained to 0 and the
v4l2-compliance tests for G_FMT, TRY_FMT, and SET_FMT fail.

Bring back vpu_fmt to use the coded format on an encoder OUTPUT device,
but initialize it using the currently set pixelformat on dst_fmt, which
is the coded format on an encoder.

Fixes: f100ce3bbd6a ("media: verisilicon: Fix crash when probing encoder")
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_v4l2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index e871c078dd59e..b3ae037a50f61 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -297,6 +297,7 @@ static int hantro_try_fmt(const struct hantro_ctx *ctx,
 			  enum v4l2_buf_type type)
 {
 	const struct hantro_fmt *fmt;
+	const struct hantro_fmt *vpu_fmt;
 	bool capture = V4L2_TYPE_IS_CAPTURE(type);
 	bool coded;
 
@@ -316,19 +317,23 @@ static int hantro_try_fmt(const struct hantro_ctx *ctx,
 
 	if (coded) {
 		pix_mp->num_planes = 1;
-	} else if (!ctx->is_encoder) {
+		vpu_fmt = fmt;
+	} else if (ctx->is_encoder) {
+		vpu_fmt = hantro_find_format(ctx, ctx->dst_fmt.pixelformat);
+	} else {
 		/*
 		 * Width/height on the CAPTURE end of a decoder are ignored and
 		 * replaced by the OUTPUT ones.
 		 */
 		pix_mp->width = ctx->src_fmt.width;
 		pix_mp->height = ctx->src_fmt.height;
+		vpu_fmt = fmt;
 	}
 
 	pix_mp->field = V4L2_FIELD_NONE;
 
 	v4l2_apply_frmsize_constraints(&pix_mp->width, &pix_mp->height,
-				       &fmt->frmsize);
+				       &vpu_fmt->frmsize);
 
 	if (!coded) {
 		/* Fill remaining fields */
-- 
2.40.1



