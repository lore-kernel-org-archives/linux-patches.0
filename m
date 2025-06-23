Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7EA24A06B;
	Mon, 23 Jun 2025 13:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684479; cv=none; b=hYe4nYO7/so8ipC5Zgui6fmMaWDlUKh8KhKAsB7r6DE/REMdaZtAphb+juRKax9qR23VhBTQ0sqBNu/D+3FJG+1J6pjb01qXRzdrcFQwM2/cBQWjwrNZwVfjtYClmlLrVtL9G5EH+XxHEHkrPSsUfkVgFxiKZW1GrR3I+x+44eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684479; c=relaxed/simple;
	bh=IxX/CsQg8vIkZlblxP5nftohn4ElJmo81SBRt3NCseE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTBsQIQKs3g9KANeZw0WQeuQewoB+yY8eZSUrN/4Hg0Bdyf4mrRuMjEVwMTc7LD4KUIRhsEMqwIl1f/ySA/zerh6fiM7CGu2QESJeQI0fd2SVudxIoTlaRywc9OFmGaHYlcQs/yb0V4shCXsCxH4tk/hgw0yYOLj+gmq0eeV0bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhWBQp5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhWBQp5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A68C4CEEA;
	Mon, 23 Jun 2025 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684479;
	bh=IxX/CsQg8vIkZlblxP5nftohn4ElJmo81SBRt3NCseE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhWBQp5H5hGLyZecghPTrmDHMaaNNcWEbBmd1c0oo0EPNqA1bGURzpNS3pF9RPV8X
	 QVuNTZWGBFBV8fi/VYbH5q1kgPNj7w4sSAIt6kLA8U4fId3GP4ZRx9o4ytuK8emrWD
	 lgUss2w5a3l7etzyqVXNlmovT8m1gPYPudRqS8fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 085/592] media: imx-jpeg: Drop the first error frames
Date: Mon, 23 Jun 2025 15:00:43 +0200
Message-ID: <20250623130702.300933717@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit d52b9b7e2f10d22a49468128540533e8d76910cd upstream.

When an output buffer contains error frame header,
v4l2_jpeg_parse_header() will return error, then driver will mark this
buffer and a capture buffer done with error flag in device_run().

But if the error occurs in the first frames, before setup the capture
queue, there is no chance to schedule device_run(), and there may be no
capture to mark error.

So we need to drop this buffer with error flag, and make the decoding
can continue.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1918,9 +1918,19 @@ static void mxc_jpeg_buf_queue(struct vb
 	jpeg_src_buf = vb2_to_mxc_buf(vb);
 	jpeg_src_buf->jpeg_parse_error = false;
 	ret = mxc_jpeg_parse(ctx, vb);
-	if (ret)
+	if (ret) {
 		jpeg_src_buf->jpeg_parse_error = true;
 
+		/*
+		 * if the capture queue is not setup, the device_run() won't be scheduled,
+		 * need to drop the error buffer, so that the decoding can continue
+		 */
+		if (!vb2_is_streaming(v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx))) {
+			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+			return;
+		}
+	}
+
 end:
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }


