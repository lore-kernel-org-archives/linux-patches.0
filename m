Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11867443E2F;
	Tue, 21 Jul 2026 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655482; cv=none; b=JSMM/v8zy1D+SFsaGe8JDqJrqzst9KBpKyvi8Fprak89HCQXfcJXMNlBssMmxjstfDb8sjwKeGIAv3iYbS71/V7kGSla4j8HFS6Gsym2EH8yYzRmYIv/yDPwwmyXzre9l2Ap1sOIioDO9QISHrUbvSUoc3OCtbnndbAWG3wXIKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655482; c=relaxed/simple;
	bh=IZya+k2jX0/IYDDBjMD9HmzpdvVIldKGnwL4B3tTo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4E5qHbKJBwFaivTwI+4uHGRd5PfgqYMS9qyLB79Z+5jcZGUp6nBd6A/UkzDjt8gZ6xSb3UYBVC3MKIAujNe/rPjo/XauRvS9u9FAMranErhyQy61BCIHbYz/hegSZjt4dEzQoD3BZY67kCeLQyGfL3vLELGHStdvyJAPom6lj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOutKryS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOutKryS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC651F000E9;
	Tue, 21 Jul 2026 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655481;
	bh=NJMOLBcn0j1EPQG2tMtkZJkuSPRfQj2Yo3UkwV/3yyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOutKryS2qzjVZF2y8dx/zsyN6za4cbMkEIF/62W4NGbtUC1+0VuqIQWpw6yMP5SB
	 W/p0psYEhOy6FzkGUJm3A8ov5eHyCIKaCzDSY5dsgfWDkBeaFA2ZA/ms+v2e4O8gKh
	 VWKsizaEDZ8FSMGKJMM4B86Au6OqAefF8chBwc14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0025/1611] media: uvcvideo: Use hw timestaming if the clock buffer is full
Date: Tue, 21 Jul 2026 17:02:21 +0200
Message-ID: <20260721152515.369992847@linuxfoundation.org>
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
@@ -834,15 +834,22 @@ void uvc_video_clock_update(struct uvc_s
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


