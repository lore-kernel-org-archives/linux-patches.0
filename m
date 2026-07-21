Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3A31716E;
	Tue, 21 Jul 2026 19:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661517; cv=none; b=k62aMlmvyguvB7n3BGSDWCWqhBHzI8s9ez56yrIwxyCQB8wVRgLHMpEg2RIxk3vZIkGaEngRObURhtmWu3DomZwRSe+9ZbK3uiHlYTuVt920CgQdv6nHSiXm28SJzXH35zvOHw96/RMJExqEH7zSfFYY91za0RSIwDA8F1DDCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661517; c=relaxed/simple;
	bh=v0iOWCUYjKxrBmJVekhsNQL/1cHVG3lFXI+JoSg6URQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuHtmS/yHtr1fyvKUykdqIRZ7E0NLoFZ1dFNC8lDvFA3DScIc2HI49VR9+dc9lwzz3vtK0FvhhrwZUvz/ncjjiOGH15ATCmfs8GVPVoOBrt/fWqfqyzwRb8aVeCUuU37YcWnV2ZD4U3Zjph9rHJ0GIqYq49T400xowLsBW6/ayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJqeMk9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJqeMk9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767751F000E9;
	Tue, 21 Jul 2026 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661516;
	bh=Fj8p7X3Xys8DFEV1YGkVNxa56LqUbkzsOr2rk9ldr8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJqeMk9SQHsTLqrPOswErfjgSR6hVwhh5RFSEXJvrCjZf3vyqINlMqTqDIbFWLFe4
	 9lpthDFKfaXi0Z0khs7q9CtuCdpo11oUdBa9eBO3sF2bKAmkGWydmUMqAbrR6LLPIp
	 IWOLTczZVl9zxDUATwkEzH7+hcGCYkcI3ab4UhNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0042/1276] media: uvcvideo: Fix buffer sequence in frame gaps
Date: Tue, 21 Jul 2026 17:08:05 +0200
Message-ID: <20260721152447.028544057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 2f24ac8dd87983a55f0498898f34a5f2b735b802 upstream.

In UVC, the FID flips with every frame. For every FID flip, we increase
the stream sequence number.

Now, if a FID flips multiple times and there is no data transferred between
the flips, the buffer sequence number will be set to the value of the
stream sequence number after the first flip.

Userspace uses the buffer sequence number to determine if there have been
missing frames. With the current behaviour, userspace will think that the
gap is in the wrong location.

This patch modifies uvc_video_decode_start() to provide the correct buffer
sequence number and timestamp.

Cc: stable@kernel.org
Fixes: 650b95feee35 ("[media] uvcvideo: Generate discontinuous sequence numbers when frames are lost")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1181,6 +1181,19 @@ static int uvc_video_decode_start(struct
 		stream->sequence++;
 		if (stream->sequence)
 			uvc_video_stats_update(stream);
+
+		/*
+		 * On a FID flip initialize sequence number and timestamp.
+		 *
+		 * The driver already takes care of injecting FID flips for
+		 * UVC_QUIRK_STREAM_NO_FID and UVC_QUIRK_MJPEG_NO_EOF.
+		 */
+		if (buf) {
+			buf->buf.field = V4L2_FIELD_NONE;
+			buf->buf.sequence = stream->sequence;
+			buf->buf.vb2_buf.timestamp =
+					ktime_to_ns(uvc_video_get_time());
+		}
 	}
 
 	uvc_video_clock_decode(stream, buf, data, len);
@@ -1221,10 +1234,6 @@ static int uvc_video_decode_start(struct
 			return -ENODATA;
 		}
 
-		buf->buf.field = V4L2_FIELD_NONE;
-		buf->buf.sequence = stream->sequence;
-		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
-
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
 		if (meta_buf)


