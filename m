Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7D127CCD7;
	Wed, 23 Apr 2025 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421033; cv=none; b=aRL44o2xZaeVAk1HML1+xdjXh3nSdJpm8PlHM8oomKDnC3zXyVf/54NCjh6rt2p9oO0tAuh3D7u1VJ+ZLIvmWG8lnhTuDjU3SpEv40tM+494ySbBnGcP/W87lw/Tapq0doZnX5zINe5TPg7rnLg/h+1V+h9X7Ia18TNA8OlVmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421033; c=relaxed/simple;
	bh=9RiVrxTI1TTyOBCyZ/Pfy58z765U3EoamfFWb+UPBH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVsa8dcxjt+pQgnMxASMQ8F3qQ0UrI1GgtFGHxLq/HTfASmHyw1IrrCKi50XuYyjF/Q02mHvPqfx5hIl7zJyijpb1uh9aPwBafxmd+D0rnS+rULRrdwAevZFFQvzgVNrPB52X17421WmqPNMHQeYZNsUrpMHBu0jw8LbD/FMHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUfFmnH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUfFmnH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025A9C4CEE2;
	Wed, 23 Apr 2025 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421033;
	bh=9RiVrxTI1TTyOBCyZ/Pfy58z765U3EoamfFWb+UPBH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUfFmnH23xXBYE0wCni7aOSh0Ax8TA/d0GJpuJVX2EgsBhx8M0ScIRifiPYjX19x4
	 WSqEtP7wQEtvo845EhQpq0izdx7snu+R1tFdA/ki9HO9YtQVZQ1MUDe0LSMlCKruex
	 69IFgU1tMpoNR2bzppY07EPv7W8KmlwSDIWbd3LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 137/393] media: visl: Fix ERANGE error when setting enum controls
Date: Wed, 23 Apr 2025 16:40:33 +0200
Message-ID: <20250423142649.036449585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,9 +156,15 @@ static const struct visl_ctrl_desc visl_
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
@@ -193,9 +199,15 @@ static const struct visl_ctrl_desc visl_
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


