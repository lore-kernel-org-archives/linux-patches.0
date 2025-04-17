Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888F625A64B;
	Thu, 17 Apr 2025 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914462; cv=none; b=uN+/LJqdhJN4oO6TvW/Xs2vFJNqoeXyGYzKWFS4JJ4dN2jpFftGfpn3I7uV7xcy31YumxiTVo6wLj7E63vWM2I+Whu7OtAft8Eh6deBTvUtBD68Co/9+19Za9H1FKcw5KQFQboMJEzZr3l0dePWcLRco22RyCzRhGeSkYv/YcDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914462; c=relaxed/simple;
	bh=EgqmW9mHu9+ZXFwuXXVe0wT/DXPQ4Dw6yEjzYx73vRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbuo51ujFisG2LfkFjcxStCfywMzEdEWxAOa2VAcip3+Ao00iCQraNwbpiig5Hv6UxAO6c7efYX+os0/oUDcjycyB9btOrsC5QCjgOLtmIAmXmA2q8BwTQv975HzB159tmO3FWriOsj4GvwAMG7t+MWh6bE64d3oPG2LUtjKp/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uz7UIY98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uz7UIY98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9DFC4CEE4;
	Thu, 17 Apr 2025 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914462;
	bh=EgqmW9mHu9+ZXFwuXXVe0wT/DXPQ4Dw6yEjzYx73vRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz7UIY983Ck1y+18AYZUKEvXWbQgnMjXhsC65i3hpx4w87jaS1G1QRt4DeRRHTAAI
	 xFQkFcXDC9OndzLXM0Va8bPqslW/AC6ydybKAOVU6oifaHgFKPRO8n3XwqjJedWHVv
	 YtmyVReHfMc5OD2pR3PR2+L0QjHg3iTam/cW6nhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 224/414] media: visl: Fix ERANGE error when setting enum controls
Date: Thu, 17 Apr 2025 19:49:42 +0200
Message-ID: <20250417175120.443973669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit d98e9213a768a3cc3a99f5e1abe09ad3baff2104 upstream.

The visl driver supports both frame and slice mode, with and without a
start-code. But, the range and default for these enum controls was not
set, which currently limits the decoder to enums with a value of 0. Fix
this by setting the decoder mode and start code controls for both the
H.264 and HEVC codecs.

Fixes: 0c078e310b6d ("media: visl: add virtual stateless decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/visl/visl-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/test-drivers/visl/visl-core.c
+++ b/drivers/media/test-drivers/visl/visl-core.c
@@ -161,9 +161,15 @@ static const struct visl_ctrl_desc visl_
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_H264_DECODE_MODE,
+		.cfg.min = V4L2_STATELESS_H264_DECODE_MODE_SLICE_BASED,
+		.cfg.max = V4L2_STATELESS_H264_DECODE_MODE_FRAME_BASED,
+		.cfg.def = V4L2_STATELESS_H264_DECODE_MODE_SLICE_BASED,
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_H264_START_CODE,
+		.cfg.min = V4L2_STATELESS_H264_START_CODE_NONE,
+		.cfg.max = V4L2_STATELESS_H264_START_CODE_ANNEX_B,
+		.cfg.def = V4L2_STATELESS_H264_START_CODE_NONE,
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_H264_SLICE_PARAMS,
@@ -198,9 +204,15 @@ static const struct visl_ctrl_desc visl_
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_HEVC_DECODE_MODE,
+		.cfg.min = V4L2_STATELESS_HEVC_DECODE_MODE_SLICE_BASED,
+		.cfg.max = V4L2_STATELESS_HEVC_DECODE_MODE_FRAME_BASED,
+		.cfg.def = V4L2_STATELESS_HEVC_DECODE_MODE_SLICE_BASED,
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_HEVC_START_CODE,
+		.cfg.min = V4L2_STATELESS_HEVC_START_CODE_NONE,
+		.cfg.max = V4L2_STATELESS_HEVC_START_CODE_ANNEX_B,
+		.cfg.def = V4L2_STATELESS_HEVC_START_CODE_NONE,
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_HEVC_ENTRY_POINT_OFFSETS,


