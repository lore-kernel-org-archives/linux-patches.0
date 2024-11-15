Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C03BBEB;
	Fri, 15 Nov 2024 06:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653048; cv=none; b=Bme/mLaGp0zt11wyPRJHpMIOv/tqYId3kMvrK03SCcwY1x5ugq02CVz88rgi3wzGzfDQvh++ah+UHSPyoSm+ffEUPSFicTVqhrLhz4dYuZxE6qp/61mmKRTorMysUbQzis/uFGDyVPDvdPZk5epS/24hNoJjEqPRaMJALXNjxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653048; c=relaxed/simple;
	bh=LsWgmVfnE8+hUxasReQuB6322CSlwWbIw1GduvKVL/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyuecdZZ0h3WjFDetOtmRakvQCq54sr+QUcOausbqaNQhg6rFnysVN9NJcIK6WKxxxlIR5U+xqmxTYDTDkgo2NfleGlKy9XDeOK0w1LtlYJFrkRj/f4pvoUC3lNYM8cImIFjqSOtvqqYB016FGXjeIPbGEWXfgM9k1OQxmg+qHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taQGMDb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taQGMDb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EB8C4CECF;
	Fri, 15 Nov 2024 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653048;
	bh=LsWgmVfnE8+hUxasReQuB6322CSlwWbIw1GduvKVL/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taQGMDb0e7TgfBwJnqYDISmAlg5Ju4/P3d/Do2OoTrKBJ1rEGcu6QlGBaLcfGuQS4
	 91zfKlY2xJLMbC8BtDk0nChNsMtGqHXXzq0UiKM/9hcct1wMP2+oymNJEp3DZf/Rqm
	 sA4pLTD6trbRk1YgTeM6GeHJQjeb9svb9ZqLheeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benoit Sevens <bsevens@google.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 38/66] media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format
Date: Fri, 15 Nov 2024 07:37:47 +0100
Message-ID: <20241115063724.221589096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoit Sevens <bsevens@google.com>

commit ecf2b43018da9579842c774b7f35dbe11b5c38dd upstream.

This can lead to out of bounds writes since frames of this type were not
taken into account when calculating the size of the frames buffer in
uvc_parse_streaming.

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Signed-off-by: Benoit Sevens <bsevens@google.com>
Cc: stable@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -602,7 +602,7 @@ static int uvc_parse_format(struct uvc_d
 	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
 	 * based formats have frame descriptors.
 	 */
-	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	while (ftype && buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	       buffer[2] == ftype) {
 		frame = &format->frame[format->nframes];
 		if (ftype != UVC_VS_FRAME_FRAME_BASED)


