Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBDC33D4E2;
	Thu, 30 Jul 2026 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421582; cv=none; b=EwPry8a3TUXX1iMpTI0LERktznJGDCEN0edX4HkL73NZA5f1nTsarc4sSnClMjScNyhzpUuH1iLDEdqOYswxltbz7zIEMLZT2PZnr/JGKVUQyHFSp9arVoWTCDgaTx1yUEKQgEW6Q5hMLl0FelfYE37VZMlbrnItd/+2sL61OJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421582; c=relaxed/simple;
	bh=MitNT1npYBOu8u5U9eBhjjjWPvdJtd+fjKiAISizyuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWgFbmjKtPL6MVFOlVkwNSMGQmYQF+wg7KFenZ6jaARfwMQQO+DEXhljuWB+ojvo2jW6wJormO9JkqSK91bXHSEAqpzAWyiGH4dKNDYbx124alPQeaoKgbHCwuXKrE81fM6r7275lLVaFHUFuE49IMbtqbKPmvdv5Q+RHx3wOig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxXnQhBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxXnQhBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EAD1F000E9;
	Thu, 30 Jul 2026 14:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421581;
	bh=w1QR0qxMWvQ9tRXk1JkyKft1+1C8zDJ0woyiwCEYFVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxXnQhBvO9L4BsyTP8NLMJ9J4EVu3XcVEbi0jI9TD4uTy5adQpywg4jtxP73Z6Ex9
	 ZqnRf2xU2q/v5xHlqVYZKPa4TXLfjNoGrM2S3J34P3Kg8H5dCa/538PuuG4q3HmR4V
	 MX5lj/Jg/ja3V2mAR49G2uVQbh+FxpuwCKcRFd+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 7.1 152/744] usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer
Date: Thu, 30 Jul 2026 16:07:05 +0200
Message-ID: <20260730141447.517785815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,6 +200,8 @@ uvc_send_response(struct uvc_device *uvc
 		return usb_ep_set_halt(cdev->gadget->ep0);
 
 	req->length = min_t(unsigned int, uvc->event_length, data->length);
+	if (req->length > sizeof(data->data))
+		req->length = sizeof(data->data);
 	req->zero = data->length < uvc->event_length;
 
 	memcpy(req->buf, data->data, req->length);


