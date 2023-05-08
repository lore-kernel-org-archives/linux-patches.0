Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD24623A4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B186EC433D2;
	Mon,  8 May 2023 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541908;
	bh=VXDgDRPaXFJnjVtytghjh/juy7EXzf6f2L6oSo/T/Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0c78YcyUeTNS9rH8WStPzZEb3UgYHdYwslajx528NynbvSIgziFFwc1Lbw5gnX99
	 BsdYhSvCLAAELemebvRYOG5FYp12sPINbEUraTAewbHL04o20MfkVdPmrknsFueWfm
	 gN9XO2gj3pN6Tzzzwo6M+EVVJrWOzpIp56CmuYws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 265/663] media: venus: dec: Fix capture formats enumeration order
Date: Mon,  8 May 2023 11:41:31 +0200
Message-Id: <20230508094436.844786773@linuxfoundation.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit a9d45ec74c8e68aaafe90191928eddbf79f4644f ]

Commit 9593126dae3e ("media: venus: Add a handling of QC08C compressed
format") and commit cef92b14e653 ("media: venus: Add a handling of QC10C
compressed format") added support for the QC08C and QC10C compressed
formats respectively.

But these also caused a regression, because the new formats where added
at the beginning of the vdec_formats[] array and the vdec_inst_init()
function sets the default format output and capture using fixed indexes
of that array:

static void vdec_inst_init(struct venus_inst *inst)
{
...
	inst->fmt_out = &vdec_formats[8];
	inst->fmt_cap = &vdec_formats[0];
...
}

Since now V4L2_PIX_FMT_NV12 is not the first entry in the array anymore,
the default capture format is not set to that as it was done before.

Both commits changed the first index to keep inst->fmt_out default format
set to V4L2_PIX_FMT_H264, but did not update the latter to keep .fmt_out
default format set to V4L2_PIX_FMT_NV12.

Rather than updating the index to the current V4L2_PIX_FMT_NV12 position,
let's reorder the entries so that this format is the first entry again.

This would also make VIDIOC_ENUM_FMT report the V4L2_PIX_FMT_NV12 format
with an index 0 as it did before the QC08C and QC10C formats were added.

Fixes: 9593126dae3e ("media: venus: Add a handling of QC08C compressed format")
Fixes: cef92b14e653 ("media: venus: Add a handling of QC10C compressed format")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 9d26587716bf6..1a52c2ea2da5b 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -31,15 +31,15 @@
  */
 static const struct venus_format vdec_formats[] = {
 	{
-		.pixfmt = V4L2_PIX_FMT_QC08C,
+		.pixfmt = V4L2_PIX_FMT_NV12,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 	}, {
-		.pixfmt = V4L2_PIX_FMT_QC10C,
+		.pixfmt = V4L2_PIX_FMT_QC08C,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
-	},{
-		.pixfmt = V4L2_PIX_FMT_NV12,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_QC10C,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 	}, {
-- 
2.39.2



