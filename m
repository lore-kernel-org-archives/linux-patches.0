Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF872206AF;
	Mon, 18 Aug 2025 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524527; cv=none; b=rTQvPYkkXzt9W4YupfemGSFvrIAbt0SUJ/DzvVifluYTuYIJqYm4MOYPl/4UTpM4DiLfz6ZXUaipD5zTPINztqwXxz7PNsO6icqglRhxYh4gkVIsbKJmXr3GmPDKUrL4rFHfmP0+FNqjt1GOmpT6988QNJF7czwr+wc7iYbHgXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524527; c=relaxed/simple;
	bh=PrXDA7qWPCvqaNbUvEnznPXrBkV03Gf7MRkzWw86paU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU3/7wrICfhYh7kj/OSNkmKmlkn5NRGwz7KmHg22wevFlkCqHFoqmVKAxXa+1tCmjpXMeHaCOre9KyDLVhU6l9jATSVCp2PZe1jlwk2eUpCfG+8dHXikeWFLzDB/cze4T74oJlBzprdl+yOdRcHO4gy4DZeEvv7RVlRgvlXjMGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYP7g6DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYP7g6DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46933C4CEEB;
	Mon, 18 Aug 2025 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524526;
	bh=PrXDA7qWPCvqaNbUvEnznPXrBkV03Gf7MRkzWw86paU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYP7g6DQPLiXQuoPYJRmYKxHttu3w8UUYXeHP2nhncW5Y5KUU3mX/1JrAK42je1+U
	 EzEiPSqRqD9w0LYNQK4YoYIQ5yVP0gKb9GRbFZFXxX+6Ab8bBMaWzHN5nSTwOnzPqm
	 dxauOtMCNYfLqEAxTbYj2BkxUGPz1rWAeleaipPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 498/515] media: uvcvideo: Do not mark valid metadata as invalid
Date: Mon, 18 Aug 2025 14:48:04 +0200
Message-ID: <20250818124517.616103572@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit bda2859bff0b9596a19648f3740c697ce4c71496 upstream.

Currently, the driver performs a length check of the metadata buffer
before the actual metadata size is known and before the metadata is
decided to be copied. This results in valid metadata buffers being
incorrectly marked as invalid.

Move the length check to occur after the metadata size is determined and
is decided to be copied.

Cc: stable@vger.kernel.org
Fixes: 088ead255245 ("media: uvcvideo: Add a metadata device node")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250707-uvc-meta-v8-1-ed17f8b1218b@chromium.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1442,12 +1442,6 @@ static void uvc_video_decode_meta(struct
 	if (!meta_buf || length == 2)
 		return;
 
-	if (meta_buf->length - meta_buf->bytesused <
-	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
-		meta_buf->error = 1;
-		return;
-	}
-
 	has_pts = mem[1] & UVC_STREAM_PTS;
 	has_scr = mem[1] & UVC_STREAM_SCR;
 
@@ -1468,6 +1462,12 @@ static void uvc_video_decode_meta(struct
 				  !memcmp(scr, stream->clock.last_scr, 6)))
 		return;
 
+	if (meta_buf->length - meta_buf->bytesused <
+	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
+		meta_buf->error = 1;
+		return;
+	}
+
 	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
 	local_irq_save(flags);
 	time = uvc_video_get_time();


