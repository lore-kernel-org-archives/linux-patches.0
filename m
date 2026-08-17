Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307343A8734;
	Mon, 17 Aug 2026 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976686; cv=none; b=Qn1MrdMiwmkBh8T0RjCwypowZ43An9rYuXAuamODnRrk4iIAkpyeUGcsIJNNpw721GmNyCfHVM0Iaax1eYioKjhsXK/rBbCCljKQH7rtikn61E3/GE5eGP67vt2xoPi7MWkE/fOtcgYo+BqWJjvA3L/Npw0Ur6YB0/JW0OuX0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976686; c=relaxed/simple;
	bh=f580wEsNmwGKtqE7ZXby0ewtcAkg2hbhoIUhPDfschI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYW4Hl52zr8U7bMCKclfZr28c4f6QgzighOr8G0nxkx6W0f241FtFV9vSJcOha73xFkV/11cGBJT8y8J1ITgfpabqEZ9AjzoIzezFgaR6fOhmUIUwDtQTujO3XCO05lbpVzJHWtsks0hj7VDTaehuxcO8gvG0ooHYSLeXqN0zZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spcZMakL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spcZMakL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8C71F000E9;
	Mon, 17 Aug 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976683;
	bh=CpWLVE82rZ013qrEfc78EWNOmm/em/K9aJ+36vt+1qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spcZMakLXthijmeFj7rubiOJoPNuCiYZgMIj21DE80QrauQPfRcvlCYIuLJ5JAdO0
	 JqDZWz+sES5aVZvj+PtuKSAYDrZFdSdR3KtuH0jJDswl4ym3VyDh+z5leZ9WwlCAtT
	 5VagRXUF/EaKvfg0xYTqkLUddZsVrLzXXIP9gx4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 5.15 069/456] usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer
Date: Mon, 17 Aug 2026 15:27:39 +0200
Message-ID: <20260817132542.750793810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit b70dc75e85ba968b7b76eebfe5d63000080b875b upstream.

uvc_send_response() builds the UVC control response from a user-supplied
struct uvc_request_data:

	req->length = min_t(unsigned int, uvc->event_length, data->length);
	...
	memcpy(req->buf, data->data, req->length);

req->length is clamped to uvc->event_length, which is taken from the
host control request wLength (up to UVC_MAX_REQUEST_SIZE, 64), and to
data->length, which comes from the UVCIOC_SEND_RESPONSE ioctl and is
only checked for being negative.  The source buffer data->data is only
60 bytes, so a response with uvc->event_length and data->length both
greater than 60 makes memcpy() read past the end of data->data.

Clamp req->length to sizeof(data->data) as well.

Fixes: a5eaaa1f33e7 ("usb: gadget: uvc: use capped length value")
Cc: stable <stable@kernel.org>
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260629195004.148405-1-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_v4l2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -39,6 +39,8 @@ uvc_send_response(struct uvc_device *uvc
 		return usb_ep_set_halt(cdev->gadget->ep0);
 
 	req->length = min_t(unsigned int, uvc->event_length, data->length);
+	if (req->length > sizeof(data->data))
+		req->length = sizeof(data->data);
 	req->zero = data->length < uvc->event_length;
 
 	memcpy(req->buf, data->data, req->length);


