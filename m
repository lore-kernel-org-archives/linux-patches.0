Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A770838;
	Mon, 23 Jun 2025 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713002; cv=none; b=E74FykG34MMkHF89kppLHIdLNLm/WZCbUuJK/zeRYT7i/JMUBEDCqS6FJ2yA8pp1tT9vW7g5cy/Mj8OReIAuUUTpucIxoEzKsydHEbgXGY6CdbrNB71Fixjd+FSgFMFDTD0/cRJmbP0heIunTb1KKNcQMQ5aHpUQm905cCqI/LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713002; c=relaxed/simple;
	bh=yKOZEguaj330kMOYROtUNSaRPJJxPJmJtRgFl4K2SPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPhM84VjckN5ib62sQjVaaky2NgFeS7KGEIzXyBUx5YGTomtutl828HYxoSCV0b40Di2+tfoliLTTj5N9HczWWD+LaNJW/X5oYDOiieCZyEr+uPz41auSC0QEBB/EcCfT6J+IvgHJHmjxcdP79/bX/ROUweX0U46WsGGeGECFHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfLKnOgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfLKnOgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5ECC4CEEA;
	Mon, 23 Jun 2025 21:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713002;
	bh=yKOZEguaj330kMOYROtUNSaRPJJxPJmJtRgFl4K2SPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfLKnOgbzAT8XJUkcy1FRA5srkdEPHimrjPnpCF7bbgoDQQ5uZHCwjYoI5cuUGERL
	 KaCSvWMASiMdlNtKaSe8cqY07V7JinrKNNaqFeMAkO1M23JDn7iqe0rz20mFbmakjA
	 171uI2QtdV077/szVfnZGi/RV+uQgkQQD4gIakBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 042/290] media: imx-jpeg: Drop the first error frames
Date: Mon, 23 Jun 2025 15:05:03 +0200
Message-ID: <20250623130628.273979125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
@@ -1913,9 +1913,19 @@ static void mxc_jpeg_buf_queue(struct vb
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


