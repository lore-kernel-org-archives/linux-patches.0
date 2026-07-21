Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636E03EEAC7;
	Tue, 21 Jul 2026 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661453; cv=none; b=DWU5p2IdLFTG4ZowpQMcFi74uuFDVojEMUtMSEYZZjVOEULyGZoe2ayUOK13bAG5XlG0SFLgVwSszHL2/90f2duN3APG3B4elJ2/9KkK/8vfS4ujfG9pqvp6uWwbl5F/PBmKYzBwQdBNP1AHXNnef0IBkmDES0rFmelWzW7WgXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661453; c=relaxed/simple;
	bh=NqtEKBjM+8emVX6PYADvu+32U/wGqtYpBmGccNPxF48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN3DBhZQKRX44zbjtgtfWFiQwQKcRgG28RNsD8GFc6Rou++oqRILP/2tgFCEXVsW4jQQX2vtB2xlRZh+u0GTwHgp8wiCs0nsffeRWbsNF4KZVjDtJ9fuo/Y32/L0gH0PHDDx+M5IaKGxpapRCL+5LXAIypjqRnZ2DuE44gu/m0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykRXlbYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykRXlbYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89F81F000E9;
	Tue, 21 Jul 2026 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661452;
	bh=myuOleNJ52ZCBCm+nKia6XJsIamfz3Ay/wiNyfsXZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykRXlbYZmfhuaTeyKzwoezlI8qzH55GEAGHC1u89TzpqZspXkaCP8INr/HbNMLngX
	 L85a1ElMhQBxKdv9hwZ91rr4SgQoP0RoFiwayJq9a1XP0YuiusSyRsqBi0oX6/tE+K
	 HBvFHKxV3smBp5p6jnOi/oQ9rZBsbPTdpjP7l3Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0045/1276] media: uvcvideo: Relax the constrains for interpolating the hw clock
Date: Tue, 21 Jul 2026 17:08:08 +0200
Message-ID: <20260721152447.096068772@linuxfoundation.org>
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

commit 1719d78f832dda8dd3f09a867ba74e05d6f11308 upstream.

In the initial version we set the min value to 250msec. Looks like
100msec can also provide a good value.

Now that we are at it, add a macro to make it cleaner.

Fixes: 6243c83be6ee8 ("media: uvcvideo: Allow hw clock updates with buffers not full")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Yunke Cao <yunkec@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260513-uvc-hwtimestamp-v3-3-7a64838b0b02@chromium.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -489,6 +489,13 @@ static int uvc_commit_video(struct uvc_s
  * Clocks and timestamps
  */
 
+/*
+ * The accuracy of the hardware timestamping depends on having enough data to
+ * interpolate between the different clock domains. This value is sof cycles,
+ * this is, milliseconds.
+ */
+#define UVC_MIN_HW_TIMESTAMP_DIFF 100
+
 static inline ktime_t uvc_video_get_time(void)
 {
 	if (uvc_clock_param == CLOCK_MONOTONIC)
@@ -849,13 +856,13 @@ void uvc_video_clock_update(struct uvc_s
 	 * buffer, but RAM is expensive these days, specially the infinitely
 	 * big.
 	 *
-	 * The value of 1/4th of a second was determined by running Android's
-	 * CTS on different devices.
+	 * The value of UVC_MIN_HW_TIMESTAMP_DIFF was determined by running
+	 * Android's CTS on different devices.
 	 *
-	 * dev_sof runs at 1KHz, and we have a fixed point precision of
-	 * 16 bits.
+	 * y1 and y2 are dev_sof with a fixed point precision of 16 bits.
 	 */
-	if (clock->size != clock->count && (y2 - y1) < ((1000 / 4) << 16))
+	if (clock->size != clock->count &&
+	    (y2 - y1) < (UVC_MIN_HW_TIMESTAMP_DIFF << 16))
 		goto done;
 
 	y = (u64)(y2 - y1) * (1ULL << 31) + (u64)y1 * (u64)x2


