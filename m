Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0A7223DE5;
	Mon, 23 Jun 2025 21:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713465; cv=none; b=cHNMVbiug/CEL5+JtAXVld6l+YA0odHrclo54Tww4ZY2xiRpaVDq1RPvroZBCgGeFJc+TXhSiJWRSB6leDJ+mR8FUsvZ9VzWA1WJPaccXfx8dy8WznGkfDLVLDI+l8w9/PSKf+27tDzf84masemFByOsrrNhN419T5rbOH2IX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713465; c=relaxed/simple;
	bh=mt7B4K+gcv/9qIujptitBaEZl6SKqBDFabLLy53olOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7hEr2xo+7Kyn54hxS/NJmcOTA03n2KJ6ZXAg3hMufQ8L7gQfxeFqMFo05zdcM9NIzZrlOKKM+Ewd6cqhyaC3dpRcRPVp882EEoMcHpqfY/267zHeC/wMWA1Ac2ET5YXdBaY86THB7TgnSQe46ApsxGO15gOKfAaSbqSWjXYzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBgVVbQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBgVVbQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3F1C4CEEA;
	Mon, 23 Jun 2025 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713465;
	bh=mt7B4K+gcv/9qIujptitBaEZl6SKqBDFabLLy53olOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBgVVbQlb7lmQWYoJGYsK7VhTHP5k9CWPGX4y7XBraCfI39FQ+wmXw3hPeUHGa32s
	 32fP+ytrf7Yx3NMYoe8455XkgNGMuJI9CVhsjFfjYzULgrwOTAntxfhsBfUCBUf66r
	 tVtrdQ/IQk2hVUb+8YB66HyarC551B7dJO0VbIn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 065/414] media: imx-jpeg: Drop the first error frames
Date: Mon, 23 Jun 2025 15:03:22 +0200
Message-ID: <20250623130643.696252420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


