Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977547DD59;
	Sat, 12 Sep 2026 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219771; cv=none; b=hoseQjtLjuWDNT4iO6JM+464hPxJG2AMMk1RUD577j/jAEw+kY+cWw1hXsiwDG2p0sdeC4WIs2cfKjD4PfyEpCXOiDkl0GrAM3Ql/Cyz0fXVJNAAAszw2Vc+2hppd6G9LgjsUPXQxDOELWjJ+BIxXAr62EgfQm7nAn/Qe5d2P3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219771; c=relaxed/simple;
	bh=yYvUBvPjtU826JaILs0mGnbm783f1/PnGrdLwgJCRFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXFu4HTQNmCg8Iie7pwF2f1LW+CZeUIFyqHZbtq2YfC1a6baG9jeGagd4LKQ8kTSTnIdwQPpv7As/n63XiaV+NuJnFxo88kLXo8JtIIUWdRZK1zELlGZj2U195T33ZUcDKBH/lk+n0O3tahgvWrsSlM18Clnym09PjltRoFxZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQNGCX+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQNGCX+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979331F000FF;
	Sat, 12 Sep 2026 13:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219769;
	bh=rCSCEBMCIc+WmdYetXLRt7CAi9lHh51V2P6UdAxTAis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQNGCX+6VNyIqWSHcHnjO7XTjcDcwLvJo7xgpjvIgRkiua0KquerBwoORsmeIPoBA
	 /l6u4+8U3+P1FxI/+I8TuEzC+ESUvFKKFrCbGrRo/lS2hcBMuD3hmBAAVm3ceeQ2Gu
	 FrsrakzjEexnqbZvnB4U5XFAmlW+DcB1J1ewP4dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0042/1424] media: vicodec: fix out-of-bounds write in FWHT encoder
Date: Sat, 12 Sep 2026 08:41:14 +0200
Message-ID: <20260912065608.246154133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


