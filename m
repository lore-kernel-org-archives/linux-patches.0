Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675F39B4A2;
	Tue, 21 Jul 2026 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655488; cv=none; b=Ca1Q2Qy4JI6KI3JzOb5pwl6yT+M2vzuJ32AK0NN7JoDmUzN8ndyiO41e4PHTQV4eVik0IqoX2rgOu84ul/DCKBrvzCfeNHbvn3AVMENUB5P274y2/JHtRrwPiHEFvdHQ01hlodaDzuln+4YEHwFjwV1tCEcraj1nNLX2klmWDok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655488; c=relaxed/simple;
	bh=xyvKVPVMEFETowrVXs2Y1Lv1vHeOqJZamh/XJszzFkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=josz8NJg72jH+e4j1Ua7m4/lPdze8jc291KSyzNtNOgrjm+PRcM4jAz8/WA9gU81h1qzJ0sZxKRrDU0fEwgeangs3hCILyQ2obkKXmaeXNyi2ONxdeDpIgRiK7bIbgXTHGgRJD1wgrwPLnCgHPx4v1H6xwXNlBIkT6wBYCaNWnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOsXaPWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOsXaPWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62E51F00A3A;
	Tue, 21 Jul 2026 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655486;
	bh=caQN9poKt2BlyZ4xe2BIPunvw8bRC8MQHKqy9BXo72M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOsXaPWWWpk+BTpGlCf5WjvAgUoQxSsnDe2xlxvAd8cicsdtn60jn55OjI4GGUJ6v
	 Y5h2v1DG+4q6sqdOdT2dUiy80nlJQ2kylEB6yvH0NAyKcOjt8DixbzLRhQHRBkDHXB
	 LNqsqzr24bzTHY+BeUebvd29NALLIPZW4UHv1Jo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0027/1611] media: uvcvideo: Fix buffer sequence in frame gaps
Date: Tue, 21 Jul 2026 17:02:23 +0200
Message-ID: <20260721152515.415922530@linuxfoundation.org>
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
@@ -1186,6 +1186,19 @@ static int uvc_video_decode_start(struct
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
@@ -1226,10 +1239,6 @@ static int uvc_video_decode_start(struct
 			return -ENODATA;
 		}
 
-		buf->buf.field = V4L2_FIELD_NONE;
-		buf->buf.sequence = stream->sequence;
-		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
-
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
 		if (meta_buf)


