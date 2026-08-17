Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DEF2DC331;
	Mon, 17 Aug 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979025; cv=none; b=CRskqbTTyxshKLVbg33WWjqDs4BO3sAnKIdyUG8vM/B2h0bKu1AmfZu1AoX91W1nDezLik5IWbZ5ahrgMnJz1X7wXQyAmdoz3JyEoYtu5zV9PkujnZ0u1fIkLsXWYVhpT6t0avU000OY6ocAYswGx4iRVJmlbiUjnuGRudUWa4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979025; c=relaxed/simple;
	bh=OhEvIUrX43gFmb1IkyNuTCChvEbirVpnlp2aqFvihyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URMaZQT3+EfmoUADXzEc64tCbeD/zw6HalX8qHBLeen5Zs9C0FqAgYhXSjKllAPKteN3FqmZ7SpGEVgznj63uzavfibrSXgdFnMmLxumx29oZsSU763rNcupC/4TMZstS5ZzEaUFNX5rYCaXz4Q6jLgQ0a0y2siNRLm5lsaCpd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slbhO3nm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slbhO3nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F61F000E9;
	Mon, 17 Aug 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979024;
	bh=OL+f9oXx3HDFojGRInF7gN3k5FWaNf0ICbb78BEXxkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slbhO3nmfctQeNdw+5AGWMAiEZL+sQE7Uvyib02T0Tqc8JIe0h/FIgQj+dGwSTZAs
	 JxdT/nssGETMGWGgILrjS+RXXoAxlnoOJbn1OAlxOcdLZ/UHKK70kLRS3PNsGuDy4q
	 mEthA4int5ucsSfcCefHnpwGcjuoJ2i+LD4toqLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.1 083/609] usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer
Date: Mon, 17 Aug 2026 15:26:19 +0200
Message-ID: <20260817132546.362871009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


