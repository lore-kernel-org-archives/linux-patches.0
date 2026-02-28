Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD3D313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300999; cv=none; b=eS8TvudKatTgj9V9eXxcyvP3gIG0oiYOYnmmscZJkpIsEkcObAzq+kSSvAyYemTBNCfzNv/5WZQ+EmPrZUwDqYlld2ud7yQHvwbhFx5NA2cpD5V3tlK3rvCv4O4XXfpU+irt+o4n7oupchNwXVASQ534mNhqCUpAbSWdWLFxcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300999; c=relaxed/simple;
	bh=diWvckYIFXeOe6phtc9YGTOKJ+joKOgIt1D2BRCZP48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt5Q/rvfXL58qoybYAv9+vVjHNtAV42tpdgWX9Flayms0/43CZ1icRzxgBVNX4Vi0rNFkV5UusjSveuxy4g9ED7jozL7gZ+JhXazoSfhXCuT3bq+G8zp1ntkl6qHiLUtDcY6nB08gBGUKvB7yj+GseQjlisnzpxxtgMZS7DHZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqo/ntcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqo/ntcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E43BC19424;
	Sat, 28 Feb 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300998;
	bh=diWvckYIFXeOe6phtc9YGTOKJ+joKOgIt1D2BRCZP48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqo/ntczzBz/bqyFIZqPiGEU911PRNaowBMAXWtsb6F1EaFfto7Th8uQUSvUOve2N
	 k8x0wZwJ++RQqhXRjiYBgks65uYVwZupUVrKDtV4lMSwvrp2k1Kq+eJpOP/03xXUq3
	 Wtdp/ILKn+LfeH0LNRHDohiIdcYC0yxsQcBK4PQj87bmrKo0v1yQqglqfQnhHLAW2T
	 xIJ1NBvfChAjnZ+M0fpWrWZuccWNkzUYh+igZv18wQulrTmj8cv+5V7OInVVdKgzp1
	 WcCoPxgABv4kAPkcdt64gRHi99QlUaAk5UICYyF+KzFhdOPJs6jiQrjoeBLxMsN+An
	 n5GwuPdaISywQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/752] media: omap3isp: isppreview: always clamp in preview_try_format()
Date: Sat, 28 Feb 2026 12:37:22 -0500
Message-ID: <20260228174750.1542406-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 17e1e1641f74a89824d4de3aa38c78daa5686cc1 ]

If prev->input != PREVIEW_INPUT_MEMORY the width and height weren't
clamped. Just always clamp.

This fixes a v4l2-compliance error:

	fail: v4l2-test-subdevs.cpp(171): fse.max_width == ~0U || fse.max_height == ~0U
	fail: v4l2-test-subdevs.cpp(270): ret && ret != ENOTTY
test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/ti/omap3isp/isppreview.c   | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/ti/omap3isp/isppreview.c b/drivers/media/platform/ti/omap3isp/isppreview.c
index e383a57654de8..5c492b31b5160 100644
--- a/drivers/media/platform/ti/omap3isp/isppreview.c
+++ b/drivers/media/platform/ti/omap3isp/isppreview.c
@@ -1742,22 +1742,17 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 	switch (pad) {
 	case PREV_PAD_SINK:
-		/* When reading data from the CCDC, the input size has already
-		 * been mangled by the CCDC output pad so it can be accepted
-		 * as-is.
-		 *
-		 * When reading data from memory, clamp the requested width and
-		 * height. The TRM doesn't specify a minimum input height, make
+		/*
+		 * Clamp the requested width and height.
+		 * The TRM doesn't specify a minimum input height, make
 		 * sure we got enough lines to enable the noise filter and color
 		 * filter array interpolation.
 		 */
-		if (prev->input == PREVIEW_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
-					     preview_max_out_width(prev));
-			fmt->height = clamp_t(u32, fmt->height,
-					      PREV_MIN_IN_HEIGHT,
-					      PREV_MAX_IN_HEIGHT);
-		}
+		fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
+				     preview_max_out_width(prev));
+		fmt->height = clamp_t(u32, fmt->height,
+				      PREV_MIN_IN_HEIGHT,
+				      PREV_MAX_IN_HEIGHT);
 
 		fmt->colorspace = V4L2_COLORSPACE_SRGB;
 
-- 
2.51.0

