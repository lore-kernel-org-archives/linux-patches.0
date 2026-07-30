Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0E94432EC;
	Thu, 30 Jul 2026 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425601; cv=none; b=ZVRb28rNWANUlEAvkMua8H7PijpwjdDhppR2N0OgJJmV/5q0OTCrOxwd9Ugqh7pQYRzdaBBKvwNW4rNysYvekwjzQhfQMkpEdCcPVNAq7XcBbf8wyrQtIud0TPSevNTAAGM3ihjq6rJAZHmAOSN6qVDPUCGFiKveB54CJ3igoi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425601; c=relaxed/simple;
	bh=1ZlMQHmSh2n/4DphsiMfXtG5znFFCD2gqhjdhnr7IO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1g69eSp9rVIRSJVCPjcf9GC7EJjJgJno063B+N9a8kcFnpzBkjntqcfLenequ+LDrlhtqlzleNVEV3/U0TXxiI9ubMI9t0oKNy/ijkJHi9M7kY0mDtjrnd9KaBo/i9+W20jr3h7qj2daFjAojU6F5RZjRj37POnMrieaG/UO6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRUY1nKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRUY1nKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48481F000E9;
	Thu, 30 Jul 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425600;
	bh=lEJiNIl6zTlwxU1ArqWc4/Ga+HMktx1xfmWMZi/i4ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRUY1nKwebb9k4kKHVRdcOgjEq86Pilu1eGrB0LvAix19CtWbHUL/ApiFpyIPxG6v
	 7dzk0AWWN1qr+h1x3LpPwrA8uwSg/Wj7dBarbVDKpaSz8++r2mfIh3dAZeF3IWSg6G
	 KGrnVxJGdSdVqYwfu9msOlE4aU4RqlTZomeaIDDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.12 125/602] usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer
Date: Thu, 30 Jul 2026 16:08:37 +0200
Message-ID: <20260730141438.614289257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -191,6 +191,8 @@ uvc_send_response(struct uvc_device *uvc
 		return usb_ep_set_halt(cdev->gadget->ep0);
 
 	req->length = min_t(unsigned int, uvc->event_length, data->length);
+	if (req->length > sizeof(data->data))
+		req->length = sizeof(data->data);
 	req->zero = data->length < uvc->event_length;
 
 	memcpy(req->buf, data->data, req->length);


