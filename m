Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291535C682;
	Tue, 21 Jul 2026 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671341; cv=none; b=no7BarUzYeoMoWnr9sb09e9OQN7epDGkZufH32iyjqG3blqgpkBIZbIQKCukaudyLDitXuECTrIAGNbRbOIfvvKwVkkLZdZLDut5CDl5JVrzOZTE1RMQNHsjLfg95pYVMlAdHUsiJ6IS0u7JdLa5zvgApdl7bQuCx7hrW9h0gxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671341; c=relaxed/simple;
	bh=YMfa9hwhxZ9RMz4hXBUAslvTrX7lEugLjkm+stcQCnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp9lvhezU2Ld1eDYhkJpOohV2628LT/lrxJnG+guRYCaAS5gQZwshUQGlm26wzMu9Lr67NTLLM0KFzfX6W+B61kN1uwHgRK0ZX+Vbptgv+DfvCGn5Wrh1Hc5C8G7l7/lY3xP74n8ZLdwac1oRNLy55FuQ3RHz70AAVg/LRu7MyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpkW8jPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpkW8jPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7AA1F000E9;
	Tue, 21 Jul 2026 22:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671339;
	bh=Gk/kS/DmCqqOHVytHA6v9d9hW1/eO1+3Oa/ICnFv06g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpkW8jPLwowAqYD2Qu49pC/CkccxO+RGP8TRDRmvjmZeaqhFOOcAc8BUHO9kpF4l0
	 XmkqldEatH9tkEqAHKwR/HqNMkbhIZPCy3M/RwZH8wU8oyTLTkXbDo45NC/gGoyiub
	 KfXdns+b5D5TqMBWcSP3gNcGEt89OJUtBniU4oQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 208/843] media: uvcvideo: Avoid partial metadata buffers
Date: Tue, 21 Jul 2026 17:17:23 +0200
Message-ID: <20260721152410.697865526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -1073,7 +1073,9 @@ static void uvc_video_stats_stop(struct
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const u8 *data, int len)
+				  struct uvc_buffer *buf,
+				  struct uvc_buffer *meta_buf,
+				  const u8 *data, int len)
 {
 	u8 fid;
 
@@ -1140,6 +1142,8 @@ static int uvc_video_decode_start(struct
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
+		if (meta_buf)
+			meta_buf->state = UVC_BUF_STATE_ACTIVE;
 	}
 
 	/* Mark the buffer as done if we're at the beginning of a new frame.
@@ -1332,7 +1336,7 @@ static void uvc_video_decode_meta(struct
 	ktime_t time;
 	const u8 *scr;
 
-	if (!meta_buf || length == 2)
+	if (length <= 2 || !meta_buf || meta_buf->state != UVC_BUF_STATE_ACTIVE)
 		return;
 
 	has_pts = mem[1] & UVC_STREAM_PTS;
@@ -1449,7 +1453,7 @@ static void uvc_video_decode_isoc(struct
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
@@ -1497,7 +1501,8 @@ static void uvc_video_decode_bulk(struct
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
+						     len);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);


