Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0D33E36A;
	Sat, 30 May 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162795; cv=none; b=sw60BTASM1Z66RmWM5J0JSWfyFuns3KLyTD0+vnn9cbU47Wo/pkxMPccNfVaaZdbkTKlHuZfiFi0v8wQa8Qc/hf6pOKKQHE6gYpOLXU+H8EESmqhxK+1KE9AvI4TcEnJ/9Fx+3GBxCZr5RCd7+lswta+NNVxbYQa0O07AgA3ErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162795; c=relaxed/simple;
	bh=0TA5vudNsJpmi4v3XBDwKQjDez34s3MzKp18wlON6xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWPmVkXmjn50mJi5VK2jUjrqo/D3R+gir0fk8YOJuetcxxJcpJzeeEEk1wqDwZxlCV5bDPLEB1IhWKHMYA0Cj2bHbVaYrTSCV9/KqXfFhuXnbEz33SSPfELxYR9GK3kVEQeGZG8wtxlFu6gclKMpnY7PKIo4rohdHgAEtfktgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3yYM8l3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3yYM8l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E501F00893;
	Sat, 30 May 2026 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162794;
	bh=YNp7nKe7mdUEI/GzDFc3LmQxDh++mxcpspRB5qiHpqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3yYM8l3NjwdzMYezcIYyQjM/PUrkVH3cG445aUxZe1+HWZ1mc36IzJ+AWPCmlguU
	 +uWJee/LA23eESWWDJpuqpytt65vx1TVmEfcG4y/X4R1bntGzUun/3r6MxuxJwjG2q
	 8eKWzVZViIBQiI07gJitYzeRZ/YEHRpGLOUALnFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 064/776] usb: gadget: renesas_usb3: validate endpoint index in standard request handlers
Date: Sat, 30 May 2026 17:56:18 +0200
Message-ID: <20260530160241.969693222@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f880aac8a57ebd92abfa685d45424b2998ac1059 upstream.

The GET_STATUS and SET/CLEAR_FEATURE handlers extract the endpoint
number from the host-supplied wIndex without any sort of validation.
Fix this up by validating the number of endpoints actually match up with
the number the device has before attempting to dereference a pointer
based on this math.

This is just like what was done in commit ee0d382feb44 ("usb: gadget:
aspeed_udc: validate endpoint index for ast udc") for the aspeed driver.

Fixes: 746bfe63bba3 ("usb: gadget: renesas_usb3: add support for Renesas USB3.0 peripheral controller")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040647-sincerity-untidy-b104@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -1611,6 +1611,10 @@ static bool usb3_std_req_get_status(stru
 		break;
 	case USB_RECIP_ENDPOINT:
 		num = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
+		if (num >= usb3->num_usb3_eps) {
+			stall = true;
+			break;
+		}
 		usb3_ep = usb3_get_ep(usb3, num);
 		if (usb3_ep->halt)
 			status |= 1 << USB_ENDPOINT_HALT;
@@ -1723,7 +1727,8 @@ static bool usb3_std_req_feature_endpoin
 	struct renesas_usb3_ep *usb3_ep;
 	struct renesas_usb3_request *usb3_req;
 
-	if (le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT)
+	if ((le16_to_cpu(ctrl->wValue) != USB_ENDPOINT_HALT) ||
+	    (num >= usb3->num_usb3_eps))
 		return true;	/* stall */
 
 	usb3_ep = usb3_get_ep(usb3, num);


