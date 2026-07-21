Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF96D46C4D1;
	Tue, 21 Jul 2026 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655491; cv=none; b=ayDCra0kKCz0/hlZb5ZuopAQ44noXY2ZKZgWnUbD7QZIRNcqZLR3djtryE0G9Tyz/BS1KXj+7hTlNmWK1dJWkMY02/K81M35wuXxSHQzGjMCE08h5nPdyJO3ex2Y1iYFJR0U5SH+iR3Sv8w/4zJX6GfxZuAc0jJHS7iTHp575Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655491; c=relaxed/simple;
	bh=D2wMiNPmAV3PyDOCZGm5tKW8rpEGEA/anpkWmuQZ51M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr6rB8ooVLaOBoDCeKkiS0NpjCB0ffnLOnnEf64SKvKgxnY268mioxt6PyqZMSwbRAf7D45tWWC1BggIaCCqfsHhvaJdCLiedRmRIAkiKAqO/5dyXYOE7bBeElW7VNR3JKxzAuToXkdMT4HXrTQHTMgy7fdf7s0ZIg/Fo6GiG0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj5cArru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj5cArru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788361F000E9;
	Tue, 21 Jul 2026 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655489;
	bh=cHFn0m0xYCA8nk3RucFMkHzHVmurlGhlvrTsKc9yH/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qj5cArruZqWDL6J8OtV0MsQ/StErO1wpwjpkmGG7cRY62LNtjAooCbjetRszMu598
	 IfmHxfXlNCsj+QXljLBKuMm7V/VX4XonPAmCbQ4JXXwZ6jK2WNCThkYiTkn8NuVkyc
	 yNr3iKv7H3gBVZ5dg8btaZVl6ZNnO2QrliItjoBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0028/1611] media: uvcvideo: Fix dev_sof filtering in hw timestamp
Date: Tue, 21 Jul 2026 17:02:24 +0200
Message-ID: <20260721152515.441246886@linuxfoundation.org>
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

commit edc1917599c5339aedc83135cade66517e0a2972 upstream.

To avoid filling the clock circular buffer with duplicated data we only
add it if the new value sof is different than the last added sof.

The issue is that we compare the unprocess sof with the processed sof.
If there is a sof_offset, or UVC_QUIRK_INVALID_DEVICE_SOF is enabled,
the comparison will not work as expected.

This patch moves the comparison to the right place.

Fixes: 141270bd95d4 ("media: uvcvideo: Refactor clock circular buffer")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Yunke Cao <yunkec@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260513-uvc-hwtimestamp-v3-1-7a64838b0b02@chromium.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -583,16 +583,7 @@ uvc_video_clock_decode(struct uvc_stream
 	if (!has_scr)
 		return;
 
-	/*
-	 * To limit the amount of data, drop SCRs with an SOF identical to the
-	 * previous one. This filtering is also needed to support UVC 1.5, where
-	 * all the data packets of the same frame contains the same SOF. In that
-	 * case only the first one will match the host_sof.
-	 */
 	sample.dev_sof = get_unaligned_le16(&data[header_size - 2]);
-	if (sample.dev_sof == stream->clock.last_sof)
-		return;
-
 	sample.dev_stc = get_unaligned_le32(&data[header_size - 6]);
 
 	/*
@@ -664,6 +655,16 @@ uvc_video_clock_decode(struct uvc_stream
 	}
 
 	sample.dev_sof = (sample.dev_sof + stream->clock.sof_offset) & 2047;
+
+	/*
+	 * To limit the amount of data, drop SCRs with an SOF identical to the
+	 * previous one. This filtering is also needed to support UVC 1.5, where
+	 * all the data packets of the same frame contains the same SOF. In that
+	 * case only the first one will match the host_sof.
+	 */
+	if (sample.dev_sof == stream->clock.last_sof)
+		return;
+
 	uvc_video_clock_add_sample(&stream->clock, &sample);
 	stream->clock.last_sof = sample.dev_sof;
 }


