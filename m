Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721A1350D55;
	Tue, 26 Aug 2025 13:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216554; cv=none; b=GYhZ1CLYp9xnNTAqbcfW6uKIzXu7eM/whEODQ0OxzrIHKWGagv4oqnCMzJWhJDIq0MJ3cdxi9LxAF4Q3IyrRZ3wqJfMWOhcFE1UL/tnvGy671q9oeiTYiwE/A9/GWweiPu83hrvkEGM9g6X0nfxw2Nrq+1j1t+12YGpFSQLyMTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216554; c=relaxed/simple;
	bh=H/zEYOtiL4JdCNuWIwDVq1I0VQ7gFQVC3Ojoq3shVyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV7OSO2xv9fsbKBItkS+EXJtwse5zmu4OljFZc1XbZvGj4XkRQRsjoDpKm2+IABvPN5GvPhuQTQ+n/MmOpG2QS1gdCFHNnsHQt1dNJYesqt6Cr5XvQGuCWWEqxlGXnPc39cyKZXpcHkbVD58kYBZyJkLAc1dXPy98CsOmg+BU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQRsxZJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQRsxZJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B0C4CEF1;
	Tue, 26 Aug 2025 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216554;
	bh=H/zEYOtiL4JdCNuWIwDVq1I0VQ7gFQVC3Ojoq3shVyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQRsxZJX2j0hufOS6+pHBDpdYLBXV3/So/qighWXvlbzrJyg8HBZDNY7mEvOKhHCa
	 VC/J9R0dBSI8beZFpAM5jejATPh2H8yBD/4hHkQ0DgL7AMWsZ7yVLvrkO1p4t3VaRA
	 wclTZjQKX77tXx5j1qGLs3hPAzLpYXTp2mr6Y6PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 454/644] media: uvcvideo: Do not mark valid metadata as invalid
Date: Tue, 26 Aug 2025 13:09:05 +0200
Message-ID: <20250826110957.726154188@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1335,12 +1335,6 @@ static void uvc_video_decode_meta(struct
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
 
@@ -1361,6 +1355,12 @@ static void uvc_video_decode_meta(struct
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


