Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2139768C;
	Tue, 21 Jul 2026 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673440; cv=none; b=DVXd0Ilb+fkwLdYFRI/1UZRZ09FG9Bnk72n/01zBCf7CJSxkTDi6Qe9GJiSGpxImPE2g9UX15RnYtdLqMFX8dLApB/1DXh4aC68QD1BZPq8Dzokgs/L30BpLJ/dQXuPxgk+BYaVXy0RFYuslaPyy/Kk6Yg1nYlQ3VXfCFT6paks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673440; c=relaxed/simple;
	bh=UnZqUPEwnL0gkpUh2QuQGuf9NPuZreI8hPPWHl5em8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCNAz8hX1j01nQAyIySslAuEQ8JSvJaS/G1UzsbGiJhFDvi59RVkoUqrJIlkcXwrZFdDvb1fZOIE5MfHFoNYn+qrJSRtPeUh+KazGqTm+UfVIwcI4clBDLEOkhlul6FVxz0MMGAEOONIW3OL26blhwSaATU6w+6w+r7FH2DVsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIhCBE43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIhCBE43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44AA1F000E9;
	Tue, 21 Jul 2026 22:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673439;
	bh=CcEzdAbRSGc5Yy41aprYm3xXQJe7Mgulk4Rnebuake8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIhCBE43RzqmG0yDXkvuFQZiOKwY2EqDZKswot53D7jYh9SmM8D663RAMM+XaKt6n
	 W3pzKMflBM1kmKl6ktmb7Xvr4gglZXB8M61p8myCpfPqEOeztulif0EA8raaVYoj7k
	 H3WDecUJlGIPpzSEzN9oevQYdcDO4p+iKs4zNx0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 162/699] media: uvcvideo: Avoid partial metadata buffers
Date: Tue, 21 Jul 2026 17:18:41 +0200
Message-ID: <20260721152359.358680548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -1071,7 +1071,9 @@ static void uvc_video_stats_stop(struct
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const u8 *data, int len)
+				  struct uvc_buffer *buf,
+				  struct uvc_buffer *meta_buf,
+				  const u8 *data, int len)
 {
 	u8 fid;
 
@@ -1138,6 +1140,8 @@ static int uvc_video_decode_start(struct
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
+		if (meta_buf)
+			meta_buf->state = UVC_BUF_STATE_ACTIVE;
 	}
 
 	/* Mark the buffer as done if we're at the beginning of a new frame.
@@ -1306,7 +1310,7 @@ static void uvc_video_decode_meta(struct
 	ktime_t time;
 	const u8 *scr;
 
-	if (!meta_buf || length == 2)
+	if (length <= 2 || !meta_buf || meta_buf->state != UVC_BUF_STATE_ACTIVE)
 		return;
 
 	has_pts = mem[1] & UVC_STREAM_PTS;
@@ -1422,7 +1426,7 @@ static void uvc_video_decode_isoc(struct
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
@@ -1470,7 +1474,8 @@ static void uvc_video_decode_bulk(struct
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
+						     len);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);


