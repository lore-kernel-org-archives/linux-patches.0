Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5EF19ABC6;
	Thu, 17 Apr 2025 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915706; cv=none; b=okzKGdUU8PRZyI2GrhfQ83EvnRJEfWJHhbZ4ls0flkDuWxcdo/PXsTYM6GIEAsim4wPQYvp/RMGwbV8odo92W/dKngm4jqnGdiJHL5xvAHLDXV/OdQnAV9nLPgvGAhsLNAqc+N4NHHTY3rP/lR79k2UiCEzn3kuGFp5U2VSLRKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915706; c=relaxed/simple;
	bh=kGPvkYKG6Diq53xVrj6MFHncb/c/Z6wpLKYoleZ2IbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCzgj0IemA9p2RDDB+CiXExHSOhXN4+2LifY6aWhU8Y6DK2kl6yDVX2jdFzSEfTyaEwOI0Bd2SidRFNqT9s93XXAXSZJu8uHIyxCGUHTMlFkqLHxM3V59mu0nbbh7ajvQK7slEVP8tkzTf/eVqWuWocnXP96nHCqcopcvxSxzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfEzfFvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfEzfFvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0319CC4CEE4;
	Thu, 17 Apr 2025 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915705;
	bh=kGPvkYKG6Diq53xVrj6MFHncb/c/Z6wpLKYoleZ2IbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfEzfFvwpq6L5slKqzv0gqGKlp55SS5irLX2YXpLkS5TDmV4MiKoCJYVBTwitQR9i
	 qu6YkpRNaoY90q/wWRLKhxK3obSUzY8jF9oPYf/qgIYVeK2Vxls6K5LynN9Yfaukod
	 d4QN4yrkOXOi8AhG8NrAGBPlE1gpzFJ8aWoE6JN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 213/393] media: visl: Fix ERANGE error when setting enum controls
Date: Thu, 17 Apr 2025 19:50:22 +0200
Message-ID: <20250417175116.147392308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


