Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829831D86FF;
	Tue, 11 Nov 2025 01:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824702; cv=none; b=j2PYJNopk6eMS30f93hwXuaqmTP2maaHCU2spsn3N8SW/s7sYxXc90cE5Ly2UB4UC545U3caObSOhJNDAZeFE3liBHznXtHAUACj4T6xOMhX1veaqpxLr38e+PwsNfOR725nP5v3Qh3m63gy9AV5l4R3xzi8woxO0BJn+NQMF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824702; c=relaxed/simple;
	bh=Cm3j8CyV6uvEeXa3I049W+3SD3RRfVGs+kMbI5NCUEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwnM8tpwIaXuOuqOd+rDoIStw6UuKRMBxYPWjK4jhVwEF3ksaADqIG1UmO1L2LuuNuOrqQKWchmZEIf4YJeSZo2xqpdTd2PngUyuoCMV5/XBdFjyBToV9TeWQb6qrGetSTeszepFMLF3ZvlJlr0Ip78GxVG3Hr3cXawxOHbj2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9ESmQvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9ESmQvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EEEC19421;
	Tue, 11 Nov 2025 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824702;
	bh=Cm3j8CyV6uvEeXa3I049W+3SD3RRfVGs+kMbI5NCUEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9ESmQvLgYd8VrHBruZHhpSpyNZPrD/TMULoUZc4t3RIVDwdUw48A9iFp4B3/36Vo
	 p6lL5y7xqmBWIC8B1z4QsjZz/hPvadOxKoe57rFdb3TOeX9OTjzQ2TwQulMbSNhopC
	 gFcgoPTeQXRO393hmYpWLSCsPJfa2UtB86lFquD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angel4005 <ooara1337@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 501/565] media: uvcvideo: Use heuristic to find stream entity
Date: Tue, 11 Nov 2025 09:45:57 +0900
Message-ID: <20251111004538.213498740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
 


