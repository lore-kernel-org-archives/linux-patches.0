Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262F4402442;
	Tue, 21 Jul 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648011; cv=none; b=lKoraLWR+a4Ea4P/wLnHQ1wbSnWqgs6/0o8oXl6q53LfQoUF7pP5Vs1/TW3PB1swP5fOLuqFw/9qX3CyH/+D1lARweBiWBjgcxe/kZgv4UoMozoi2OECxUuZkuYRIB5EDt888b5Qc5Ps5N8uVTukljsFDZUoWct9vA887cX5yss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648011; c=relaxed/simple;
	bh=8lDe93F8SCfeUHfzmZZZoWbdmpzEPHz/iWeV7TTqp4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1QOkp7+nMrKwJgG8JsPKuKhrEzBWSis4rc3ZCbblvLt5s7GBd5pfw8E1ukoD9Mq6EhTecIoWShRclSNyp717cRj6XeyAKeU4797iG7+vBxm5JElKATLav+3z/iYiWdtTPt+btuuqkL+DcRsLZ9L7AnW+8FyJOj9nMLnEWZw/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjVkAB5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjVkAB5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7AF1F000E9;
	Tue, 21 Jul 2026 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648010;
	bh=5tR/aapMYsZjWlVeGxUIufqlihTPUyTArhvDjR0wsOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjVkAB5qyRcn6gLH5xbqZC0fk0uCS8PSHM3DE4sVW6N8Iu2RtYEM/CGPSn3XGn3qN
	 eHvthXP0TORkSR9maCQyn9RpWTXJXAbDRGRivWB8Q1UJJi8ibKHghprLxkZYTR7gwn
	 WPGDIQjYVKQ2Gi+auL7MOogo45b/cx6Qyy24m7pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 0010/2077] media: uvcvideo: Avoid partial metadata buffers
Date: Tue, 21 Jul 2026 16:54:43 +0200
Message-ID: <20260721152552.907418757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit a15b773fe4ffa450b56347cc506b2d1405600f5d upstream.

If the metadata queue that is empty receives a new buffer while we are
in the middle of processing a frame, the first metadata buffer will
contain partial information.

Avoid this by tracking the state of the metadata buffer and making sure
that it is in sync with the data buffer.

Now that we are at it, make sure that we skip buffers of size 1 or 0.
They are not allowed by the spec... but it is a simple check to add and
better be safe than sorry.

Fixes: 088ead255245 ("media: uvcvideo: Add a metadata device node")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260417-uvc-meta-partial-v2-2-31d274af7d2d@chromium.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1156,7 +1156,9 @@ static void uvc_video_stats_stop(struct
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const u8 *data, int len)
+				  struct uvc_buffer *buf,
+				  struct uvc_buffer *meta_buf,
+				  const u8 *data, int len)
 {
 	u8 header_len;
 	u8 fid;
@@ -1229,6 +1231,8 @@ static int uvc_video_decode_start(struct
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
+		if (meta_buf)
+			meta_buf->state = UVC_BUF_STATE_ACTIVE;
 	}
 
 	/*
@@ -1431,7 +1435,7 @@ static void uvc_video_decode_meta(struct
 	ktime_t time;
 	const u8 *scr;
 
-	if (!meta_buf || length == 2)
+	if (length <= 2 || !meta_buf || meta_buf->state != UVC_BUF_STATE_ACTIVE)
 		return;
 
 	has_pts = mem[1] & UVC_STREAM_PTS;
@@ -1548,7 +1552,7 @@ static void uvc_video_decode_isoc(struct
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
@@ -1597,7 +1601,8 @@ static void uvc_video_decode_bulk(struct
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
+						     len);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);


