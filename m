Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C3843E068;
	Tue, 21 Jul 2026 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671345; cv=none; b=EanhIU9RXVhL5mJm+I1YOY1XwjtivMnHketm/0o1+js4Tl4rsk4lzXi9z9Lwkc3BwHWHXIifnFONLGjGrpKeLzB0YSNVG/lo3U0PB1uzKqLN++pQHIRmWZO+sNlGxHPQRpTEG+K720+cZEakXM0iFACOpjB9OknmoejmfMygRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671345; c=relaxed/simple;
	bh=CverW/qX5BR66VuqiiX1oJ+TsaxVJ3baGWySfx0X2kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHwIMPgI2cBH6AR8uCb/bIvs3qdzNd5U9IXoMsHNEtMSPuwvJ51ZjQGTxUL9WGtgQpa+UKZPmMTQIGiyl5LQpcNjXwpzousdXBXfGVXLc5ka86I0kX+BZoEA1pZkq2nDK83a1pd6eT8ZU1dO1EeMq/cQTPe1OaiYgy7pbFByuM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulogSSj2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulogSSj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132A31F000E9;
	Tue, 21 Jul 2026 22:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671342;
	bh=H3f+4gYs8hmg8aAjm4LRRlwphDdXzfYgp6oS3jPc2ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulogSSj27gCbeCy5Has0JMRBSlL3wfeV+ZaNkE85vZJJgkL09np8sKNBBFlr8UVYy
	 iubPTLGnFsk5eBTAXQzQ1w2qXpElxqQhvPi7MlhaJhbs3hZoWRHbIgb4jhzw65WdXo
	 Hru4+h0iil3Gf4XGDqYZlauQbB4qQq/uo8gwoAcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 209/843] media: uvcvideo: Fix buffer sequence in frame gaps
Date: Tue, 21 Jul 2026 17:17:24 +0200
Message-ID: <20260721152410.720257844@linuxfoundation.org>
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
@@ -1098,6 +1098,19 @@ static int uvc_video_decode_start(struct
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
@@ -1136,10 +1149,6 @@ static int uvc_video_decode_start(struct
 			return -ENODATA;
 		}
 
-		buf->buf.field = V4L2_FIELD_NONE;
-		buf->buf.sequence = stream->sequence;
-		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
-
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
 		if (meta_buf)


