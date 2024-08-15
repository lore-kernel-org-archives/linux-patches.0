Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731187DA7D;
	Thu, 15 Aug 2024 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730355; cv=none; b=oHtqEADHqVjsbysI6NssTrxJZ21ebhytwDMFMHaupeEk1H8hZXayC34PCMDSnEzKraULKzbbAMlfc3s/Usc7QtSlpZh1ufeZgD+H4uy3q+Texe/jXsbzpoPK740BUZQ9cfNX5UhOCARQAy9GdNrSoJV5ibqC8IgD/oQTT1v2STg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730355; c=relaxed/simple;
	bh=qM+0MYMlaIo0YLccsGeUSzlnBmiBON1/ngZOXPxBYRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6BhvhRhDAZSWPjdNMhcm22P/OjekEh0YxLc2BcLErG109cBT2AjuXjzkn4uPL8OwTA+Q/r3NStCYDcn/5Sso5LhCzFu0nFFKYJphSjV/zY64f7OVuzzh/vz0OZ/WCynC8JOaMT8pJupzDRnGyLw70H+783EIml21zRJf832NP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsImfU1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsImfU1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15C5C4AF0C;
	Thu, 15 Aug 2024 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730355;
	bh=qM+0MYMlaIo0YLccsGeUSzlnBmiBON1/ngZOXPxBYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsImfU1Cc+74RzYHjKBL5HXdhrO4jv5MI7RJljGyg7rqoHrVAoXsdpSpfrj2vWiKy
	 K/fXnxAHvycKGiqxa+IPNt/S04BrySB2Kwv+zEUSRqS2OJpt6mbeOpX3+kwFYplovg
	 onyn7EXwUrRvU9WmitlfMRfxHjroJcc764JUrJIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/484] media: uvcvideo: Fix the bandwdith quirk on USB 3.x
Date: Thu, 15 Aug 2024 15:24:01 +0200
Message-ID: <20240815131956.240840555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a45d3b85e828c..446fe67e07c47 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -210,13 +210,13 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
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



