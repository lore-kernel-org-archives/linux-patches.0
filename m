Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081553B1B4;
	Mon, 17 Aug 2026 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977170; cv=none; b=YnpAhsQyjDJDqdxBg5lGMiJSqz5W1aGYoiXIKZtHZmBslyM1kIN0LHlaTkyMF455HsvbZyMHshHSbBzG/FyAi+npbU74Jb4zAJExKrTvCWXV+xQSIxyI64Mx82Q9LGJcdvxq2cO4wopTdP4i8uFS0DxWFKFjneU9q/KTx1W7Uc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977170; c=relaxed/simple;
	bh=ULDTmmq3YuRRy56bcNK7fvILoYu5uoVg2EJjdAACzJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxjPTXbxWOqRpJ/uoWtW4lDEdVE7TL8Nikd81QhL/dvHwvzxpCwbod8H+ouBERCxmpOTt2tnySIUanJ0JDpWaYWc3h3VtGCPKKazO4OB6PZbdG6FMN6dTu9SxiaZyUkyppJwecvMYOOxoeKaNzctf1Q+utltPfW8p+VnmLnVLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1HXFYI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1HXFYI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8811F000E9;
	Mon, 17 Aug 2026 14:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977168;
	bh=DJyYw4Ec+GRgqRvtE8A2QYp1NwcolDLq20lAvDGbJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1HXFYI1No2KM3zA7oHtmqjrOCtyDvDgcSGFenU/aQAbrMwrGtaRehRGKeuT4hUy7
	 imznsE6B6EjDEUfJisy6gCQd3BjxK0Dqbmy5tSS3diZEZhVpEtavnTftTUR2l3vVlT
	 5Nn8JUhHKNObDuU0ZnNBelZVlnaeqJHnXUm2hrfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/456] media: uvcvideo: Implement dual stream quirk to fix loss of usb packets
Date: Mon, 17 Aug 2026 15:30:27 +0200
Message-ID: <20260817132549.351049990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac Scott <isaac.scott@ideasonboard.com>

commit c2eda35e675b6ea4a0a21a4b1167b121571a9036 upstream.

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
[Added JPEG_MARKER_SOI definition, jpeg header does not exist yet]
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 28 +++++++++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h  |  4 ++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3184308e6896..2a2c10daa07a 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -24,6 +24,8 @@
 
 #include "uvcvideo.h"
 
+#define JPEG_MARKER_SOI                0xd8
+
 /* ------------------------------------------------------------------------
  * UVC Controls
  */
@@ -1077,6 +1079,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 				  struct uvc_buffer *meta_buf,
 				  const u8 *data, int len)
 {
+	u8 header_len;
 	u8 fid;
 
 	/* Sanity checks:
@@ -1089,6 +1092,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		return -EINVAL;
 	}
 
+	header_len = data[0];
 	fid = data[1] & UVC_STREAM_FID;
 
 	/* Increase the sequence number regardless of any buffer states, so
@@ -1177,9 +1181,31 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
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
index be4b746d902c..2dd8d04589ab 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -212,6 +212,10 @@
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
 #define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
+#define UVC_QUIRK_NO_RESET_RESUME	0x00004000
+#define UVC_QUIRK_DISABLE_AUTOSUSPEND	0x00008000
+#define UVC_QUIRK_INVALID_DEVICE_SOF	0x00010000
+#define UVC_QUIRK_MJPEG_NO_EOF		0x00020000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.53.0



