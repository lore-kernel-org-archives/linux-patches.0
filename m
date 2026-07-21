Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CFB35C6A7;
	Tue, 21 Jul 2026 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668687; cv=none; b=Wx0OkSNmWJSB9JdYbgKVn9MGk56ZajJs5aky2j7f26jlx+9tfWY7wui7CnQparyBOcvDjvjzp7aK7zt3SfoAFT0eMHLl9A06iVhMFrpXANuIyDvvNKH0qEYBckbC4Bq5PR+YxqGRPY1db5sxuYdxdLj9C95mLzgt/vNO9mQtcUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668687; c=relaxed/simple;
	bh=CO5cdSicEOCYN84ogxcT6YhFJ5OFtdhWa6YFz0rLdUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+FhfVlPaXzCHtnJMih7jz72pZLz1Zbo1yLGPuDHoCA3niBysZTWCxvrrWcCprLnWU2vQFW2XHuBaBn9lstOoBZdnnui60QBDFDWxSzgsgdweyyuuqkkzClOmmdaVoggQVtSgH6tda47qi1TWyEfcysq7ND6nRUgu+Ptq1dzXro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjmoY0Sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjmoY0Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39181F000E9;
	Tue, 21 Jul 2026 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668684;
	bh=IKeeVvOi0k/c64POZeDY61QvPgVN5F8/V1L576OHD0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjmoY0Srs8R08Uu9rrzth9E0yvlSstLL1lYKayHtxETC1U6PI7wxCW+Nt6NB/VqGM
	 wxTrx5W8LTCb005DvQaiUx43xi+vzgO+jTZ78NJbKxalNFXBaF13QNoX389AQoKw4u
	 /fHDG9oKTjj7nmGPYH2fK2BAvqPkGnb8UDKbzbkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0268/1067] media: uvcvideo: Avoid partial metadata buffers
Date: Tue, 21 Jul 2026 17:14:29 +0200
Message-ID: <20260721152430.589587221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1085,7 +1085,9 @@ static void uvc_video_stats_stop(struct
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const u8 *data, int len)
+				  struct uvc_buffer *buf,
+				  struct uvc_buffer *meta_buf,
+				  const u8 *data, int len)
 {
 	u8 fid;
 
@@ -1156,6 +1158,8 @@ static int uvc_video_decode_start(struct
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
+		if (meta_buf)
+			meta_buf->state = UVC_BUF_STATE_ACTIVE;
 	}
 
 	/*
@@ -1350,7 +1354,7 @@ static void uvc_video_decode_meta(struct
 	ktime_t time;
 	const u8 *scr;
 
-	if (!meta_buf || length == 2)
+	if (length <= 2 || !meta_buf || meta_buf->state != UVC_BUF_STATE_ACTIVE)
 		return;
 
 	has_pts = mem[1] & UVC_STREAM_PTS;
@@ -1467,7 +1471,7 @@ static void uvc_video_decode_isoc(struct
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
@@ -1516,7 +1520,8 @@ static void uvc_video_decode_bulk(struct
 	 */
 	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(stream, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, meta_buf, mem,
+						     len);
 			if (ret == -EAGAIN)
 				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);


