Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DE563FA1;
	Wed,  9 Sep 2026 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962732; cv=none; b=cwlTR+XVMtQXGqgZq+ziFM762VAvcJrmcbQUgrTmuncxnu61YfWAZRmsUbH2UGd0YiLxxlG2Wm9KyZL5daUchMDUfKcND5SSr/CSrUiMiR4sqsipHavNcNEGnJKFtyX58oUu5aWmqQf26qLWeUydqFrusvgbZuV1VN6WSexqH6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962732; c=relaxed/simple;
	bh=EJo42BoE7cNDLZTqAq1ampJ1Vgc6+rPOig8Si4VxFTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUvsguXCAjFWSHlyMpsnq5aq7dHLxbn6MldPslfye5qOObK4oRj25KpgxHDpMMu8dHAj+8r6dx22NJDBcSehvGn9zqup11otIleDqQlrzzKqorKw8/0xXtwsIshFRaPIJD3UKriufLKkn+E8qF/abao2SFzl5LAfKe8bwgf0n1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXOF2doG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXOF2doG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097E41F00A3A;
	Wed,  9 Sep 2026 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962731;
	bh=gcWvB4QIC535mbEKUNCkJnrEJE5TflVXSNPvCNI38aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXOF2doGevtgDoj9q9axLu4vCXyXtbMgjkrYsX2qXLA4iNHkcDuJvC4ZT0qN6ttDD
	 dSFsFNKZ8JuPpFU4no8vbOSbM2bn/mvv0QECdhsTTHEISNgyA7TUbfgeBI28hCU8l1
	 0s9908ALlNC8WF8Q5+QFQPr0k4tZ0rGiK3roxfUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 385/556] media: rockchip: rga: dont change RGB quantization
Date: Wed,  9 Sep 2026 15:41:05 +0200
Message-ID: <20260909134244.222205148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Püschel <s.pueschel@pengutronix.de>

commit 7acc334cf038b5ac1a7ee480d3ec59d288d2f5f3 upstream.

Don't change the quantization of an RGB format when converting between
RGB and YUV with the RGA3. As the RGA3 only supports doing conversions
to full range YUV with BT601, it wants to announce it through
try_fmt/s_fmt.

As it is only relevant, when converting between RGB and YUV, it's
guarded by a given condition. But the condition also causes the
RGB format quantization to be adjusted to limited range, which
is incorrect.

Therefore simplify the condition to only apply when the current format
is a YUV format. Also document the reason for checking if the other
format is an RGB format.

Fixes: 24a63d4c9d3c ("media: rockchip: rga: add rga3 support")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rga/rga3-hw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga3-hw.c b/drivers/media/platform/rockchip/rga/rga3-hw.c
index ca1c268303dd..c4a71306278b 100644
--- a/drivers/media/platform/rockchip/rga/rga3-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga3-hw.c
@@ -450,10 +450,14 @@ static void *rga3_adjust_and_map_format(struct rga_ctx *ctx,
 	other_format = is_output ? &ctx->out.pix : &ctx->in.pix;
 	other_format_info = v4l2_format_info(other_format->pixelformat);
 
-	if ((v4l2_is_format_rgb(format_info) &&
-	     v4l2_is_format_yuv(other_format_info)) ||
-	    (v4l2_is_format_yuv(format_info) &&
-	     v4l2_is_format_rgb(other_format_info))) {
+	/*
+	 * Only apply the quantization restrictions when we need to
+	 * convert between RGB and YUV. Otherwise there is no point
+	 * to limit the quantization for operations like scaling or
+	 * rotations.
+	 */
+	if (v4l2_is_format_yuv(format_info) &&
+	    v4l2_is_format_rgb(other_format_info)) {
 		/*
 		 * The RGA3 only supports BT601, BT709 and BT2020 RGB<->YUV conversions
 		 * Additionally BT709 and BT2020 only support limited range YUV.
-- 
2.55.0



