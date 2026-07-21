Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F3242CAF1;
	Tue, 21 Jul 2026 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661371; cv=none; b=Ni6o4XGeFi9I4DxeutzW4A9cY4mBh8PhGzDDEMUXxIcDY9AIALUJ+/Mbk/O8WvtZQU+/nr/3c1TLmKt9hsmuOXdaVV1lZRMUyFAM7FgQd9lgVRJUA/nwQaQcYCiSgEhBi704rh1isMAlv3Zln3TtT9f1xPezP1XXgZBbBVK52bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661371; c=relaxed/simple;
	bh=z763mv8O344Sh7I0vfy1r9/ComHX4G9i0lFDAZq3SaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=codYauYoJ07WY7u5VQOEwNwhu1/By3b5KVJ+hbMFqPDYa1Sw00MzeixMFEgAb3L5KGoAcAGZXdP/rJ0NG4dKzwVZYNKexenZq6qMNdH51sgDAx4GzTc8oxNnCv0ozI8OXTMrHOdYQVoSUTkmCHObA9u4BiyFhaFfPkVyBCZMWig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3MAK5Tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3MAK5Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897601F000E9;
	Tue, 21 Jul 2026 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661370;
	bh=raiYXjuhRYRTdLKN+BDaxA6Mkr8rzrS6aqe2/F06fZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3MAK5Tnn7Kz7Sq0L6mpvbD389fNuyVmVZOxZOeda0e5PK/v6tS5UnGUHOVVmW1GQ
	 kIomjKacCYRBxvZKFo+itoVIAKrTEY5VQMej+1yMZB0M7GrQ8hXAuqSc9tD5Zl0d4r
	 vnM6wqTJxJS1xmxB7WDvPV+XoilndA6WsXeGTTXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0040/1276] media: uvcvideo: Use hw timestaming if the clock buffer is full
Date: Tue, 21 Jul 2026 17:08:03 +0200
Message-ID: <20260721152446.981760392@linuxfoundation.org>
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

commit ede7de6e6b3db552d10ac50557d69c50d1b08486 upstream.

In some situations, even with a full clock buffer, it does not contain
250msec of data. This results in the driver jumping back from software
to hardware timestapsing creating a nasty artifact in the video.

If the clock buffer is full, use it to calculate the timestamp instead
of defaulting to software stamps, the reduced accuracy is less visible
than jumping from one timestamping mechanism to the other.

Fixes: 6243c83be6ee8 ("media: uvcvideo: Allow hw clock updates with buffers not full")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Yunke Cao <yunkec@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260513-uvc-hwtimestamp-v3-2-7a64838b0b02@chromium.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -829,15 +829,22 @@ void uvc_video_clock_update(struct uvc_s
 		y2 += 2048 << 16;
 
 	/*
-	 * Have at least 1/4 of a second of timestamps before we
-	 * try to do any calculation. Otherwise we do not have enough
-	 * precision. This value was determined by running Android CTS
-	 * on different devices.
+	 * If the buffer is not full, we want to gather at least 1/4th of
+	 * timestamps before using HW timestamping. We do this to avoid jitter
+	 * on the initial frames.
+	 *
+	 * If the buffer is full we would use it regardless of how much data
+	 * it represents. This could be solved with an infinite big circular
+	 * buffer, but RAM is expensive these days, specially the infinitely
+	 * big.
+	 *
+	 * The value of 1/4th of a second was determined by running Android's
+	 * CTS on different devices.
 	 *
 	 * dev_sof runs at 1KHz, and we have a fixed point precision of
 	 * 16 bits.
 	 */
-	if ((y2 - y1) < ((1000 / 4) << 16))
+	if (clock->size != clock->count && (y2 - y1) < ((1000 / 4) << 16))
 		goto done;
 
 	y = (u64)(y2 - y1) * (1ULL << 31) + (u64)y1 * (u64)x2


