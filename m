Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08A23BB680;
	Tue, 21 Jul 2026 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673443; cv=none; b=DiUglX+g5g8ESt4teRicV9EQZAoQG9M7GxnfdGAb7CvTGWdfi7Bxywwspa/YXXON5pXOGuD24VJRqyE557xW/OqHRYEcZEVR3hishjKHaAMvkgnyx42skX13MBW6DNUZTAVBHxmi1Oj68TtP+O8lHZX83TLsgBUK92tZbsEmLqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673443; c=relaxed/simple;
	bh=YQkJevpstgLPO/VyyyDW06WQtZlj8s4m4V6ml1vCSxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxGC9kHRDLhj2KFhpSb6kOMjOxKHnukNhXw9vvZi/BSr7jvYj9Ro2lfa7XQ8W/ggyHTTbtpUFGlZOM/7Kkmk9BPAJBrjAoQRm6ikUjbGDcPrW8vKVqiekZEeP/tcmxvihsovWdqBBWeXjfEOUO/0LHS6dBnOVjK7SKIAVB8+GQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBHXd+81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBHXd+81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F041F000E9;
	Tue, 21 Jul 2026 22:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673441;
	bh=AFzLN0nwqJmOA6/YHpwSbDWBB5jpmRbsm1b0PZiiN58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBHXd+81LkgOT5BxAhA+eIzPFpuy2zVAKcfWU3weS9Z5wCv1Qn2SyThX5N/bFzp7a
	 AOiZMUgIFBQC9UMHdQBT1EowuQE+JVWWiORHrezo1qOpq6+WjRA/h8t26SvB5Fiib2
	 V7RXOKeAKgqPyBzJX6vDUCgzXKAY+sjM+CidqT5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 163/699] media: uvcvideo: Fix buffer sequence in frame gaps
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152359.381123962@linuxfoundation.org>
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
@@ -1096,6 +1096,19 @@ static int uvc_video_decode_start(struct
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
@@ -1134,10 +1147,6 @@ static int uvc_video_decode_start(struct
 			return -ENODATA;
 		}
 
-		buf->buf.field = V4L2_FIELD_NONE;
-		buf->buf.sequence = stream->sequence;
-		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
-
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
 		if (meta_buf)


