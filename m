Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A177B3F2;
	Wed, 21 Feb 2024 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522643; cv=none; b=KYDF+1YzUePZxHxOAGJ534kv+czUXcDSqTLwr55yk0CcArsdS735ioaX/NotO3iALIcJvjUopsPC+yS8jfTyYbVfLPdRTH5c16RI7YD30jVhUQihdqUdhc9ptmzhSyxpoW3EaEjSkqI+PrJtGP8F8Vwi2fR5/EKVF8Cj4WKOq8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522643; c=relaxed/simple;
	bh=ZfbOTySsZNqc50oEruDp9bIguhTibXKYzMFo6VxLIYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC3+cwOv6tLa3MTc/Wnfg6oq0cIkcq4Ymk6250LOxIQWVso/FEv3T17AbVtwwPgbz4soIxZrHm/3b6GTZdq/2Vicm8FztC3ijgjDa5jH/5vTTgRmUlC4nicaFDPcctKGQpSEDj2WUBjK/LDkmVcO1+54kPf/es7j9Xjauw42n2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9qk8+qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9qk8+qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3D2C433F1;
	Wed, 21 Feb 2024 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522643;
	bh=ZfbOTySsZNqc50oEruDp9bIguhTibXKYzMFo6VxLIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9qk8+qfAN+Mml6iM09LM9rrB+yEp7T79h3faObC/lKHVAV0orOGdSk0a/0tqc0Q+
	 75hGN7TA07iBFCRcsTRlA/e5KXLoKtudjJKCvXAs4V79sIEiWUbGcIxCpYBMn02JJV
	 b49EAI7h1lD+8oPOgvBX9RvPoNx020kA0G8PKBaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/476] media: rockchip: rga: fix swizzling for RGB formats
Date: Wed, 21 Feb 2024 14:04:30 +0100
Message-ID: <20240221130015.990395080@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 9e7dc39260edac180c206bb6149595a40eabae3e ]

When using 32 bit RGB formats, the RGA on the rk3568 produces wrong
colors as the wrong color channels are read or written.  The reason is
that the format description for the channel swizzeling is wrong and the
wrong bits are configured. For example, when converting ARGB32 to NV12,
the alpha channel is used as blue channel.. This doesn't happen if the
color format is the same on both sides.

Fix the color_swap settings of the formats to correctly handle 32 bit
RGB formats.

For RGA_COLOR_FMT_XBGR8888, the RGA_COLOR_ALPHA_SWAP bit doesn't have an
effect. Thus, it isn't possible to handle the V4L2_PIX_FMT_XRGB32. Thus,
it is removed from the list of supported formats.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index e3246344fb72..bcbbd1408b36 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -187,25 +187,16 @@ static int rga_setup_ctrls(struct rga_ctx *ctx)
 static struct rga_fmt formats[] = {
 	{
 		.fourcc = V4L2_PIX_FMT_ARGB32,
-		.color_swap = RGA_COLOR_RB_SWAP,
+		.color_swap = RGA_COLOR_ALPHA_SWAP,
 		.hw_format = RGA_COLOR_FMT_ABGR8888,
 		.depth = 32,
 		.uv_factor = 1,
 		.y_div = 1,
 		.x_div = 1,
 	},
-	{
-		.fourcc = V4L2_PIX_FMT_XRGB32,
-		.color_swap = RGA_COLOR_RB_SWAP,
-		.hw_format = RGA_COLOR_FMT_XBGR8888,
-		.depth = 32,
-		.uv_factor = 1,
-		.y_div = 1,
-		.x_div = 1,
-	},
 	{
 		.fourcc = V4L2_PIX_FMT_ABGR32,
-		.color_swap = RGA_COLOR_ALPHA_SWAP,
+		.color_swap = RGA_COLOR_RB_SWAP,
 		.hw_format = RGA_COLOR_FMT_ABGR8888,
 		.depth = 32,
 		.uv_factor = 1,
@@ -214,7 +205,7 @@ static struct rga_fmt formats[] = {
 	},
 	{
 		.fourcc = V4L2_PIX_FMT_XBGR32,
-		.color_swap = RGA_COLOR_ALPHA_SWAP,
+		.color_swap = RGA_COLOR_RB_SWAP,
 		.hw_format = RGA_COLOR_FMT_XBGR8888,
 		.depth = 32,
 		.uv_factor = 1,
-- 
2.43.0



