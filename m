Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373A53214;
	Thu, 15 Aug 2024 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732753; cv=none; b=UXh+ZusUmpFUXdnv2IzJgX5QbfvPNRkWNoQu40d+EGBxdwB22KOZ73eQXcQ+53xHzwRQ9/tx9usGzECpFXe6GLbJnN6A8jgTLgzs5EI4JTsKdk2zaTWwm2owNZknIsAlEYcjEiwE8recrdkDGHfPVYUQmTZLP/rF21ch2DD3qI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732753; c=relaxed/simple;
	bh=+GLnSjzjqF7U4zzvx5ney4i03qDr+IbEY14nOMAMmgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPh5ja+cAUPU1wh4WIjLbnDWdl3Byc+S9D9YogRfG1KveEaF8w67wEJY8aPeNIVpaogg6KxH76RH6bsPsmqON+8BGr7e+4SYIjDLCAJxGJqClZpNwE8fLUXAdPmKrOAQxBdeqQEYELOLQTFK1amWMXoM1o45kPSHf6rBuxvprgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3sjTbHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3sjTbHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31C9C32786;
	Thu, 15 Aug 2024 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732753;
	bh=+GLnSjzjqF7U4zzvx5ney4i03qDr+IbEY14nOMAMmgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3sjTbHKugDc1q273GcBnuHgo8QyW0Aoy9FxjdDHjiFXOZPOBTiVbTQTuXTYQYQ62
	 3+4GVLIdUkbX1fJx+TkzVTazc/ASCo8PnM84jQnZXcL1Uv5F4PUAryfH9ZNTjNPg41
	 QX2C3sWF01pZJLoz0e7Aq5XAsMyib1DPv6+IKDSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/352] media: uvcvideo: Fix the bandwdith quirk on USB 3.x
Date: Thu, 15 Aug 2024 15:25:41 +0200
Message-ID: <20240815131930.081286466@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 9e3d55fbd160b3ca376599a68b4cddfdc67d4153 ]

The bandwidth fixup quirk doesn't know that SuperSpeed exists and has
the same 8 service intervals per millisecond as High Speed, hence its
calculations are wrong.

Assume that all speeds from HS up use 8 intervals per millisecond.

No further changes are needed, updated code has been confirmed to work
with all speeds from FS to SS.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240414190040.2255a0bc@foxbook
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9a4c730943a90..288f097e2e6f2 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -207,13 +207,13 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 		/* Compute a bandwidth estimation by multiplying the frame
 		 * size by the number of video frames per second, divide the
 		 * result by the number of USB frames (or micro-frames for
-		 * high-speed devices) per second and add the UVC header size
-		 * (assumed to be 12 bytes long).
+		 * high- and super-speed devices) per second and add the UVC
+		 * header size (assumed to be 12 bytes long).
 		 */
 		bandwidth = frame->wWidth * frame->wHeight / 8 * format->bpp;
 		bandwidth *= 10000000 / interval + 1;
 		bandwidth /= 1000;
-		if (stream->dev->udev->speed == USB_SPEED_HIGH)
+		if (stream->dev->udev->speed >= USB_SPEED_HIGH)
 			bandwidth /= 8;
 		bandwidth += 12;
 
-- 
2.43.0



