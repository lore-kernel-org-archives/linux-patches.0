Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD91C3A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSw3QYoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EFBC433C8;
	Wed, 15 Nov 2023 19:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077771;
	bh=oF5TE4kTv5qriQGwsKG+4GK2fGCx30DBLxloLAkmV6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSw3QYoHtlOIBWvVpP9A2KNdYBp/9wbkeFzhG2SjYMRTfjN3YgY+7niVFEtLH1sll
	 dyf54isMrONq35nAeJaX0arOXqvibOz6mWsDFKVxPDBxQ0yEgERrmgPPVpYivrr2m1
	 LqAjAyp9DwPO9JbckwHoufs82VsPIhUShcqENIlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 509/603] media: verisilicon: Do not enable G2 postproc downscale if source is narrower than destination
Date: Wed, 15 Nov 2023 14:17:34 -0500
Message-ID: <20231115191647.363366205@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 6e481d52d363218a3e6feb31694da74b38b30fad ]

In case of encoded input VP9 data width that is not multiple of macroblock
size, which is 16 (e.g. 1080x1920 frames, where 1080 is multiple of 8), the
width is padded to be a multiple of macroblock size (for 1080x1920 frames,
that is 1088x1920).

The hantro_postproc_g2_enable() checks whether the encoded data width is
equal to decoded frame width, and if not, enables down-scale mode. For a
frame where input is 1080x1920 and output is 1088x1920, this is incorrect
as no down-scale happens, the frame is only padded. Enabling the down-scale
mode in this case results in corrupted frames.

Fix this by adjusting the check to test whether encoded data width is
greater than decoded frame width, and only in that case enable the
down-scale mode.

To generate input test data to trigger this bug, use e.g.:
$ gst-launch-1.0 videotestsrc ! video/x-raw,width=272,height=256,format=I420 ! \
                 vp9enc ! matroskamux ! filesink location=/tmp/test.vp9
To trigger the bug upon decoding (note that the NV12 must be forced, as
that assures the output data would pass the G2 postproc):
$ gst-launch-1.0 filesrc location=/tmp/test.vp9 ! matroskademux ! vp9parse ! \
                 v4l2slvp9dec ! video/x-raw,format=NV12 ! videoconvert ! fbdevsink

Fixes: 79c987de8b35 ("media: hantro: Use post processor scaling capacities")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_postproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/hantro_postproc.c b/drivers/media/platform/verisilicon/hantro_postproc.c
index 0224ff68ab3fc..64d6fb852ae9b 100644
--- a/drivers/media/platform/verisilicon/hantro_postproc.c
+++ b/drivers/media/platform/verisilicon/hantro_postproc.c
@@ -107,7 +107,7 @@ static void hantro_postproc_g1_enable(struct hantro_ctx *ctx)
 
 static int down_scale_factor(struct hantro_ctx *ctx)
 {
-	if (ctx->src_fmt.width == ctx->dst_fmt.width)
+	if (ctx->src_fmt.width <= ctx->dst_fmt.width)
 		return 0;
 
 	return DIV_ROUND_CLOSEST(ctx->src_fmt.width, ctx->dst_fmt.width);
-- 
2.42.0



