Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FC1CDA14;
	Wed, 19 Feb 2025 08:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954891; cv=none; b=Hcc8q2SE8gXRUmv+vC6zbQKdmXbIP0iKA2jZZqU5THkTHEhXD+vKZ1N2ifL/13dMp03wbVCSgvLb2aRNklHkbxGK2t1DR4nqRXI9u40xKgSt71y4EFpFWqFZ+0dAaJwv2R2vflembweHgbdlRupP1DHeXlCQRuQb735ATtEpwJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954891; c=relaxed/simple;
	bh=y/dW4tlpsKfvXqntTYhCf5CzFYPhP/Lci8B08Ra97EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyJLIb0v9yMbI5Nica4nLda+QPRj/t+AIRrFzvU6Ysgi5lRRcajT7F+9dTI7jVkSQtfFel1dWiy+NQFd5b6568b4Mf03GvzKvoxoAx/acag3vwP8Hz9+v0U+F/5JL0xFMSzFSpnqIWsYhbW2IsY83c7EhrxvBMANL0l3U7ZAILY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qf/bz0Sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qf/bz0Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC76C4CEE6;
	Wed, 19 Feb 2025 08:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954891;
	bh=y/dW4tlpsKfvXqntTYhCf5CzFYPhP/Lci8B08Ra97EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf/bz0SpTNoschSo3W6jmBbw4Ve8Pv6704Om28CjrzZTx419VJDxWaEXblQ8We+0N
	 bKeIMC8uu8H5l/S+CaXe/TFijUp/AMEGjSuYC2N6/oVIcXVdFr75EXk1h5tPuNd9hb
	 W5SfeoFtC7H0P/C+KPgOKA/BZ/U8YFTHx4HKD9oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/230] media: uvcvideo: Implement dual stream quirk to fix loss of usb packets
Date: Wed, 19 Feb 2025 09:26:25 +0100
Message-ID: <20250219082604.369496794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Isaac Scott <isaac.scott@ideasonboard.com>

[ Upstream commit c2eda35e675b6ea4a0a21a4b1167b121571a9036 ]

Some cameras, such as the Sonix Technology Co. 292A, exhibit issues when
running two parallel streams, causing USB packets to be dropped when an
H.264 stream posts a keyframe while an MJPEG stream is running
simultaneously. This occasionally causes the driver to erroneously
output two consecutive JPEG images as a single frame.

To fix this, we inspect the buffer, and trigger a new frame when we
find an SOI.

Signed-off-by: Isaac Scott <isaac.scott@ideasonboard.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20241128145144.61475-2-isaac.scott@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 27 ++++++++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h  |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index d2fe01bcd209e..eab7b8f557305 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/unaligned.h>
 
+#include <media/jpeg.h>
 #include <media/v4l2-common.h>
 
 #include "uvcvideo.h"
@@ -1137,6 +1138,7 @@ static void uvc_video_stats_stop(struct uvc_streaming *stream)
 static int uvc_video_decode_start(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const u8 *data, int len)
 {
+	u8 header_len;
 	u8 fid;
 
 	/*
@@ -1150,6 +1152,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		return -EINVAL;
 	}
 
+	header_len = data[0];
 	fid = data[1] & UVC_STREAM_FID;
 
 	/*
@@ -1231,9 +1234,31 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		return -EAGAIN;
 	}
 
+	/*
+	 * Some cameras, when running two parallel streams (one MJPEG alongside
+	 * another non-MJPEG stream), are known to lose the EOF packet for a frame.
+	 * We can detect the end of a frame by checking for a new SOI marker, as
+	 * the SOI always lies on the packet boundary between two frames for
+	 * these devices.
+	 */
+	if (stream->dev->quirks & UVC_QUIRK_MJPEG_NO_EOF &&
+	    (stream->cur_format->fcc == V4L2_PIX_FMT_MJPEG ||
+	    stream->cur_format->fcc == V4L2_PIX_FMT_JPEG)) {
+		const u8 *packet = data + header_len;
+
+		if (len >= header_len + 2 &&
+		    packet[0] == 0xff && packet[1] == JPEG_MARKER_SOI &&
+		    buf->bytesused != 0) {
+			buf->state = UVC_BUF_STATE_READY;
+			buf->error = 1;
+			stream->last_fid ^= UVC_STREAM_FID;
+			return -EAGAIN;
+		}
+	}
+
 	stream->last_fid = fid;
 
-	return data[0];
+	return header_len;
 }
 
 static inline enum dma_data_direction uvc_stream_dir(
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 272dc9cf01ee7..74ac2106f08e2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -76,6 +76,7 @@
 #define UVC_QUIRK_NO_RESET_RESUME	0x00004000
 #define UVC_QUIRK_DISABLE_AUTOSUSPEND	0x00008000
 #define UVC_QUIRK_INVALID_DEVICE_SOF	0x00010000
+#define UVC_QUIRK_MJPEG_NO_EOF		0x00020000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.39.5



