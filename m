Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04D17A2F6;
	Tue, 21 Jul 2026 19:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661424; cv=none; b=ZPdwszDhxHcA5mQqAhEbmNvkt+s6Wu7G5nsuSFubjyZGEdsEQCrFKZo/qU/SNbp5EL3/TqXdZyntobMzRJq5cZyeTrjrAxzWg751tg/YotTUhHeqTaSn8t7Uiqr21OptL4IxDBM3O33gDwelgxqtncZiJjkwq5492oUAm3hv3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661424; c=relaxed/simple;
	bh=Iy8AAhW+TuW0ZIc/ndwP1fZMTmvmJvTzFs3T7EuwaL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZ+x0so7V9WYlAy+GZGDGrB2ugFtY+0mfwATW9ggr9bhuzjUSFxj+QYeJF/4Rhbj4hHBHH3dDZJDjgveBcAkOc6vp4iduMQkCgiYF0TR5Iu5TFAmb+5Q8oIje9JUVP7flnxAd0PcZ1YjtWoCvS2F0Hy/bgXjlbcmGgql0XsYfAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlrjVy/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlrjVy/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9801F000E9;
	Tue, 21 Jul 2026 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661423;
	bh=qWPSIEQnQ0C4lDoVE0slI7bQtI5OL+jl1dypxHPMoIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlrjVy/tOk10tdyp5fsTjuzsZ2QO4RYdrMPTBpx5JeNKghKvXDx0/TDM9+6gz0WYe
	 s7FA4wTNDzcNpmqd5bBE9C7EzfcI57EWJtt+6IdJbzR6N+dIpEOTHoz2avZJjw7ydu
	 iM36uN9YgkMTjX5NcMIFdq7BULVUu0Xfia0aXOJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0044/1276] media: uvcvideo: Do not add clock samples with small sof delta
Date: Tue, 21 Jul 2026 17:08:07 +0200
Message-ID: <20260721152447.074068182@linuxfoundation.org>
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

commit ba649fff36c1fe68489a86d00285224907edd436 upstream.

Some UVC 1.1 cameras running in fast isochronous mode tend to spam the
USB host with a lot of empty packets. These packets contain clock
information and are added to the clock buffer but do not add any
accuracy to the calculation. In fact, it is quite the opposite, in our
calculations, only the first and the last timestamp is used, and we only
have 32 slots.

Ignore the samples that will produce less than MIN_HW_TIMESTAMP_DIFF
data.

Fixes: 141270bd95d4 ("media: uvcvideo: Refactor clock circular buffer")
Cc: stable@vger.kernel.org
Tested-by: Yunke Cao <yunkec@google.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260513-uvc-hwtimestamp-v3-4-7a64838b0b02@chromium.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -532,6 +532,15 @@ static void uvc_video_clock_add_sample(s
 	spin_unlock_irqrestore(&clock->lock, flags);
 }
 
+static inline u16 sof_diff(u16 a, u16 b)
+{
+	/*
+	 * Because the result is modulo 2048 (via & 2047), we do not need a
+	 * special case for a < b.
+	 */
+	return (a - b) & 2047;
+}
+
 static void
 uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 		       const u8 *data, int len)
@@ -652,12 +661,13 @@ uvc_video_clock_decode(struct uvc_stream
 	sample.dev_sof = (sample.dev_sof + stream->clock.sof_offset) & 2047;
 
 	/*
-	 * To limit the amount of data, drop SCRs with an SOF identical to the
+	 * To limit the amount of data, drop SCRs with an SOF similar to the
 	 * previous one. This filtering is also needed to support UVC 1.5, where
 	 * all the data packets of the same frame contains the same SOF. In that
 	 * case only the first one will match the host_sof.
 	 */
-	if (sample.dev_sof == stream->clock.last_sof)
+	if (sof_diff(sample.dev_sof, stream->clock.last_sof) <=
+	    (UVC_MIN_HW_TIMESTAMP_DIFF / stream->clock.size))
 		return;
 
 	uvc_video_clock_add_sample(&stream->clock, &sample);


