Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35E46AA69;
	Tue, 21 Jul 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648008; cv=none; b=ltbylQK+QivKpHJMvetw1IPIoEIJ1rA0k1c3JyLq6zkxe6L3NZFHpkQcc5qGlNbKsyegMmgVzLuiOgrKBUjd9X9YL8ludIjeW87ZoSM8GnXUTjIwV7RyJujCHN0T7mhvcURSNiaoOareZv36Fvj3PqwiMY6eevbmbiM2bWEV5/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648008; c=relaxed/simple;
	bh=ehzTYaWAi2ODCUMfca3OA6uyVvf1WS/WB2LjqKE9Ijo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D91soFw4MgenXs/M0IF0baY4RCwcRBnfNfmRrnSZQFKBUY4oT4ImWduDiOxJ8JPxOvfiO+nmQ0VEcldK2SK4LnEvAROy9+GwbNLd+1VIekEOlhRZOVEWx4EldrN6vkhB3vQR9E6wzW2SMZqJpgiHIW8GiUv5lggNzQXLSS5SMEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oB6W/XiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oB6W/XiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12001F00A3A;
	Tue, 21 Jul 2026 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648007;
	bh=QefEtPEAmHth8oh5E/YHD1Yj9whMd9ILXfRzFHwNa00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB6W/XiZ1eVtTYJe+y9zAoIKjFCA+F06EZTrGsc6SdJDCVBpcZFbWudSseKMzmAxd
	 jgqkTFDWiGJyxV6jWtHcbrLYd1yjjSpzqqbINPWM0DtSmO1antBaugE4ESY6IbpA2j
	 z9pyzVW8m9kHI5MwzEEJ/dDyv6Al7FBSTS2oD5Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 0009/2077] media: uvcvideo: Use hw timestaming if the clock buffer is full
Date: Tue, 21 Jul 2026 16:54:42 +0200
Message-ID: <20260721152552.884575293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -833,15 +833,22 @@ void uvc_video_clock_update(struct uvc_s
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


