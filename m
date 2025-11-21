Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66F6258ECB;
	Fri, 21 Nov 2025 13:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733039; cv=none; b=YQfHW1ShGMXQqP/NYSrf/B9KWadLdoQS+UrHHbAtEEPi4xJAIaB+GIViMoc7KBEJn4kiGZZw+GnDTbcYXjk3aj4zoiRXIbTc4BwgQdTPY7vRW6kAV7RNS8VFXCxCT+P9X/4QbvauzMKesBe3SEfgta9UkzGLlocDMbMzoPLHOL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733039; c=relaxed/simple;
	bh=hT21iXneMz5//QkhieUrOfgZFr3O1KUoSYdhaLRwk/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDVcl1UAeyRZ7dY/Oj0hDdbBs/+MBnnHvwFh1wMtqGxUn7wZvPivu0EDngVt/9RQ3yfGH0ruZW/J9OnRGr7uIULPHrJIsmZpO3yZsOxhb+DPEDr9gmqsg2vL4kSX/nrYKgdr95LmvWaMzt2IjZH+OzrSOufbYqCi/HLGF1rH4Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3ZsM/ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3ZsM/ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E650C4CEF1;
	Fri, 21 Nov 2025 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733038;
	bh=hT21iXneMz5//QkhieUrOfgZFr3O1KUoSYdhaLRwk/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3ZsM/ai2ltDx5jD4xqi+MihyxBa0NQD5VfI/iDAW7hcd8IkpRRud3cM/+rHQdTtX
	 reQQs+WIYjOn67vGyyGpILEmlaCOzhlh/mI90ypc8fwMbptkllXhXpoVG+eCDXpiFb
	 ODLw0RFT4S2Aoypj1IE9Cu49QNSoRdLbrhy+r/Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angel4005 <ooara1337@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 330/529] media: uvcvideo: Use heuristic to find stream entity
Date: Fri, 21 Nov 2025 14:10:29 +0100
Message-ID: <20251121130242.768769562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 758dbc756aad429da11c569c0d067f7fd032bcf7 upstream.

Some devices, like the Grandstream GUV3100 webcam, have an invalid UVC
descriptor where multiple entities share the same ID, this is invalid
and makes it impossible to make a proper entity tree without heuristics.

We have recently introduced a change in the way that we handle invalid
entities that has caused a regression on broken devices.

Implement a new heuristic to handle these devices properly.

Reported-by: Angel4005 <ooara1337@gmail.com>
Closes: https://lore.kernel.org/linux-media/CAOzBiVuS7ygUjjhCbyWg-KiNx+HFTYnqH5+GJhd6cYsNLT=DaA@mail.gmail.com/
Fixes: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -165,13 +165,26 @@ static struct uvc_entity *uvc_entity_by_
 
 static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, int id)
 {
-	struct uvc_streaming *stream;
+	struct uvc_streaming *stream, *last_stream;
+	unsigned int count = 0;
 
 	list_for_each_entry(stream, &dev->streams, list) {
+		count += 1;
+		last_stream = stream;
 		if (stream->header.bTerminalLink == id)
 			return stream;
 	}
 
+	/*
+	 * If the streaming entity is referenced by an invalid ID, notify the
+	 * user and use heuristics to guess the correct entity.
+	 */
+	if (count == 1 && id == UVC_INVALID_ENTITY_ID) {
+		dev_warn(&dev->intf->dev,
+			 "UVC non compliance: Invalid USB header. The streaming entity has an invalid ID, guessing the correct one.");
+		return last_stream;
+	}
+
 	return NULL;
 }
 


