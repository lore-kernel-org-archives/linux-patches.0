Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476103E49F0;
	Tue, 21 Jul 2026 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655486; cv=none; b=ZxiYeHZGuYs9pdAzNUCFPMVFKOJsgS3O+h9pRCXh683VMMrAckLKrmVOLH1sl6CFOrONkHdmq3wBqtBHO5hLtQHIdi0l6Df6z6Br0ZluF3AhnGn/TTFMQag5aMJPNiso9Woy0l3rPYPclb65HLiuW8C3j+f0liSIG+/bKlh/iiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655486; c=relaxed/simple;
	bh=8ol5AKrOoYQTP96GqZeRC5gEPF+wmEwN+5l6/QY9iic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVMh6mNEiVgrc87xWXjqhsf2asJN/BJWOW0CYCU8n+KxUieYiJOkz40ERVd05F4ZQfvvv55QN7mLSV5afzmONFpP7RdT26iz/Ezlb6FuT8V+cQ3HmtQEbVR3nvnuZhZZ12Cyd+ykEOT2aJp0wAthmLXsLkW1awiwRqVrPlwm3CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bw3dOPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bw3dOPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353331F000E9;
	Tue, 21 Jul 2026 17:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655483;
	bh=iwHcePlFBxU6Pcn9Sl0KrejIqZ08BUoArfbPPaghNQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bw3dOPYag+2FcjuL7wv++EQ96ayoZkW15rIqcDWTqgPiR7QCYor8uLWwrmn/e+1h
	 rXSq5GBNi1Vzx/jxY5ZWIH9NmIQpHdKyloRzIGAPzaGDB7hbo3zCkT82vMVL5aBFou
	 TYaTnSy+G8cOSJvfyHsNA/5+WI6UQLXONUGxLtKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0026/1611] media: uvcvideo: Avoid partial metadata buffers
Date: Tue, 21 Jul 2026 17:02:22 +0200
Message-ID: <20260721152515.392628750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1157,7 +1157,9 @@ static void uvc_video_stats_stop(struct
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
@@ -1230,6 +1232,8 @@ static int uvc_video_decode_start(struct
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
+		if (meta_buf)
+			meta_buf->state = UVC_BUF_STATE_ACTIVE;
 	}
 
 	/*
@@ -1432,7 +1436,7 @@ static void uvc_video_decode_meta(struct
 	ktime_t time;
 	const u8 *scr;
 
-	if (!meta_buf || length == 2)
+	if (length <= 2 || !meta_buf || meta_buf->state != UVC_BUF_STATE_ACTIVE)
 		return;
 
 	has_pts = mem[1] & UVC_STREAM_PTS;
@@ -1549,7 +1553,7 @@ static void uvc_video_decode_isoc(struct
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
@@ -1598,7 +1602,8 @@ static void uvc_video_decode_bulk(struct
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
+						     len);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);


