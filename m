Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21F5361977;
	Sat, 12 Sep 2026 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240886; cv=none; b=dlKsfTFOZi6env2jX53h5vSLsqwnGjdM9456DQEeu26zSzK1EKcedXc51Phqi2Q7g0F3oQiTUAX8/zYsP+EJHe9/3eA6MHtMM6XiEJwVy1dZqvx+rDl1YnJGWbC+IGsJtNaIkZvOIHqYxWaY/ZfUU3lSnr5pDC+UGrTbgm/o8DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240886; c=relaxed/simple;
	bh=uMrB8qu/HFNnUuVoNF0k6m90VVhDDF9OnuBzgkDpzFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYqFbq7+nVmLKlbEGo5cNAt7Qf+kX4o9wVHV3Nun3wFzNlFyXO2OIlmhmbPRKcuRaiVX6A96A36g005+PETwTA3qSaO+A2IEW3TiSAMxz5I5dPp6ZqkUAn9Km+cAlzQvmNZd7ofNCDn4E0jFJ0q2M7gdR29CMDC0YL5hepWZ8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cn0NpbPj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cn0NpbPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AC41F000FF;
	Sat, 12 Sep 2026 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240885;
	bh=fJvL3ENxE8YRwUyznSdDy/2qfUncb5IyfTpQcCv6dCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cn0NpbPjupTSywJjoN35FJfswOVh4/OHlK54lJ69fJSw96mCCGUCG5Xhi5xEe5pv8
	 ZXzowHAN4ewGlekzG8DSwQ+k3Vjbh9IXaquUu/32ceXiNV4HB0UbvBIfxn961CnV7L
	 X6QjaUc5/IvrWDzuM032ub0qI8kxsexprC3ZZias=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 024/798] media: vicodec: fix out-of-bounds write in FWHT encoder
Date: Sat, 12 Sep 2026 08:54:12 +0200
Message-ID: <20260912065517.512912362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit cf4500ebf6fb57bf4ab83c3dd349a40257dbe2a9 upstream.

vidioc_s_fmt_vid_out() sizes the encoder CAPTURE buffer from the
compressed descriptor pixfmt_fwht, whose sizeimage_mult is 3:
coded_w * coded_h * 3 + sizeof(struct fwht_cframe_hdr). fwht_encode_frame()
encodes one plane per component, and an incompressible plane takes the
FWHT_FRAME_UNENCODED path in encode_plane(), copying the plane verbatim.

For a 4-component pixel format all four planes are full resolution
(width_div == height_div == 1), so a frame that forces every plane
through the unencoded fallback writes
sizeof(struct fwht_cframe_hdr) + 4 * coded_w * coded_h bytes, overrunning
the plane by coded_w * coded_h, which can result in corruption
of adjacent kernel heap memory.

Bump pixfmt_fwht.sizeimage_mult from 3 to 4, matching the largest
components_num among the supported raw formats, so the capture buffer is
always large enough for the unencoded fallback.

Fixes: 16ecf6dff97c ("media: vicodec: Add support for 4 planes formats")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -61,11 +61,11 @@ struct pixfmt_info {
 };
 
 static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
-	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0, 1
+	V4L2_PIX_FMT_FWHT, 0, 4, 1, 1, 1, 1, 1, 0, 1
 };
 
 static const struct v4l2_fwht_pixfmt_info pixfmt_stateless_fwht = {
-	V4L2_PIX_FMT_FWHT_STATELESS, 0, 3, 1, 1, 1, 1, 1, 0, 1
+	V4L2_PIX_FMT_FWHT_STATELESS, 0, 4, 1, 1, 1, 1, 1, 0, 1
 };
 
 static void vicodec_dev_release(struct device *dev)


