Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD772DAFA3;
	Tue,  8 Jul 2025 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993829; cv=none; b=HAxhnDpcdMQeLnd1NrLfYLbbuiZldXoj1Z8J/Ab9ICcWxnm196cdA0DEnOFii5gIC81SyQxGHaN/WXe8C/QjSCeO2MStT9gERyZhLIenFeQ3yvH+xF8rGMI3+WRxiLH1NgHy88sTQ7m4gFHXDiff+G9aOrz9RpK7djL/8EzARHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993829; c=relaxed/simple;
	bh=xzlN8cJhfyhTJhWbpcBWMT2oTPRBh4usrJTywvziSa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtaSB05D1D+z+ia+7QJBT+B/nTTUuuBDcb6V7eK1bNJ2g1U0WipGmHKvHfazcpkPM7pfFrMwBPH7PUT0PPgtAm58OmkAn8WHZ/7fKEBsl8RJIYH+KnwcjzxpFjCiIaKg7VYBt/8NaU0RodUfky4rMLYD7e8xjn3fZ+4tPhZ6VgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPwJ6jTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPwJ6jTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A3AC4CEED;
	Tue,  8 Jul 2025 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993829;
	bh=xzlN8cJhfyhTJhWbpcBWMT2oTPRBh4usrJTywvziSa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPwJ6jTwBI1aQCxogCcLTsPMHIAOiBFPE7dOpMyX9+JDTS7+Ug/Iuu6oTkHD4hBzv
	 YTpGL1zzxlZeuZrdGdEe1X/b9KHlTNb39GC7EN32lqNCZNVLYD68/8BP84GbHf2kP0
	 JNfniLaPWFZgOAwOeJcHatBUC0XUtpYLnlFzhyK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/160] media: imx-jpeg: Drop the first error frames
Date: Tue,  8 Jul 2025 18:21:09 +0200
Message-ID: <20250708162232.414946962@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit d52b9b7e2f10d22a49468128540533e8d76910cd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 059e45aa03b7f..2ab03444f742a 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -1450,9 +1450,19 @@ static void mxc_jpeg_buf_queue(struct vb2_buffer *vb)
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
-- 
2.39.5



