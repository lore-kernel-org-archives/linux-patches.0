Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1A101C1;
	Sat,  3 Feb 2024 04:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933401; cv=none; b=pkghgteLuba2QYsyEh7CQxuB0ABOeIrlOHrxw6COccXO6xQ0GhkmeUQ3Yus7Kuh1Cs1xM7w2Lv438QKXOm63BxU7atRlxzQu8/H8Y0z3DM3M2GeTTdt1UlQL0CsXtJ2kOwozlG6u+EtvLkz9l+wIcVVUZ/zp/TEgPIdPasY40Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933401; c=relaxed/simple;
	bh=dWPIQ0ScG5L8xH7oZPI+/mrqsRlIiNIsUENxPBxtKmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfMcoJfQZC+/9HeygwvLYrhUTr2QgPN3uShyWu2YCZslieEFHjrWdn+NuMKEThpxb+JSyt4SSOQgnRmMYAtDj29Dy3IYpwoZSpMY8kSyFq5cBdQZbqy5OjkFcnZkMIgI1H4cWS2YqsU0pcnuUrn+U0kYZoZUleP2fnyjfkWiueU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBlO345E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBlO345E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE075C43390;
	Sat,  3 Feb 2024 04:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933401;
	bh=dWPIQ0ScG5L8xH7oZPI+/mrqsRlIiNIsUENxPBxtKmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBlO345EzxLtU0y3jH6h4NDxSqUuxDIuIikOI9DTCac1HhAtZaMjY5VrFnjKA+5AP
	 gcSyrr8RzpcvUoTmKBYUOo91ECP5o+474IRBIfZiUkga6LoQGJZA3/Gj2ieLFqAM6p
	 xlr9zqU+mVj0kT0uGI3agx4NjmAHsDN4JhtYD1W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/219] media: rockchip: rga: fix swizzling for RGB formats
Date: Fri,  2 Feb 2024 20:04:51 -0800
Message-ID: <20240203035334.120241630@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 61b25fcf826e..9b20cef5afc6 100644
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



