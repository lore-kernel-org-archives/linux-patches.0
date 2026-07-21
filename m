Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94D246AA88;
	Tue, 21 Jul 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647948; cv=none; b=YtdNszqrKuZLwo9tWKMT0isfkfcRLN4Cu9QXNRmbFPGqk2M/Kp27JaoyfUXVkyOyIPDWIFhFiypLwdwBnRsmaTx37SIQPJijIC2gfox84AtGn12fmg28VXzd9zP5l8d3HL+cRWZy3O8FGPKMtYa+idzTHvqWL4tE4OO3evd9xqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647948; c=relaxed/simple;
	bh=TsPxzkGnFh/deyo3BxiQgVb6nYFkIvVE4HM7O1G4+Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOfQS0AwzK8lfHPzMoDiwhAhqxNOZQTxireb3/nOXc5O8lSN0GNxZK9G4niKPZ/iLNN8xW3/rXThAZezZxgjTWYQHWmVXcnT8Vhbf3kw3lpdyHkgbtMnL0tOxR2jtPQq1OEmjl26qP2ATVZGOkJ6eXPiMqd9DcpuWvBz2s+YW9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HP+Begv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HP+Begv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4644C1F00A3A;
	Tue, 21 Jul 2026 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647944;
	bh=U5KNUstIh8G1SovxYy9rMtWn9UqQB5+sXqVhrzCfE3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0HP+BegvE/sBkUBWwcOUPdhTVkf0At+pw0axsjZQjrMuh8j+rr6I3GmPwRFwtSoCT
	 3WHpHYkO3p1+oEo5tgYI4JZvfg3cCGnYMnb2z2S3dmh4T8GSw1ucj19tktDRQ6xJi8
	 iUdI7JGepO5SjxyqnqkEkMt3iJ0QpRG3Poevodjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 0014/2077] media: uvcvideo: Relax the constrains for interpolating the hw clock
Date: Tue, 21 Jul 2026 16:54:47 +0200
Message-ID: <20260721152553.002819757@linuxfoundation.org>
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
@@ -494,6 +494,13 @@ static int uvc_commit_video(struct uvc_s
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
@@ -853,13 +860,13 @@ void uvc_video_clock_update(struct uvc_s
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


