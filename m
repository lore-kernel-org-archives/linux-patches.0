Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333EA2C0298;
	Mon, 23 Mar 2026 14:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277757; cv=none; b=F9X6XQPz1h/himUQWQkpPzX3ccxgmFhEGpk+QcARC6VbIwHU6ZlrRaqCafn5Kyh4jsGLDmswxgLq3jyWU/8SUXfUz2RrA0b8Jq2E/1OE4R3cvLc8Jxv0t3uK4lwG7ruB3eEqSHT9cpws8LE/qcJ4XELO4kVvtZNBeXgpuoLbhFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277757; c=relaxed/simple;
	bh=Nes0HsE9ytVPU41UExlatCP9oMFv3/FSjgAxVhqTYEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njgsqmygTPct3YW+jRRzffHp3jjbA8QU1Q1SxKJsHVKz0iT0ng1XL5n3111S+aHSJz+0jtFzi2qNZmwePDFZBOqJGCH+jGGmplBk4bmzYJU6WIi260dfWhZz6lwPH0mZuUcn6FEnlAwrneTYUwuhYnu713BhLtr+HPe+Ocoe0tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnidu1CF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnidu1CF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75279C4CEF7;
	Mon, 23 Mar 2026 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277756;
	bh=Nes0HsE9ytVPU41UExlatCP9oMFv3/FSjgAxVhqTYEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnidu1CF+nClDvAhpRbAzC4K3Q9MpMGHsgOgVV+D7n4stVDMsEwfcEJrMUHbcdED0
	 LZI58CE+y9qUfcA3Cs65IXaq0rZnd1X+zfEbmnDhHG6r8FceamJV7TP/0Dkjhedihi
	 yd2/T7sgY7AV361d8vfvyYbRR87oVcmevfQ7cX14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 091/567] net: usb: kalmia: validate USB endpoints
Date: Mon, 23 Mar 2026 14:40:11 +0100
Message-ID: <20260323134536.082632776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c58b6c29a4c9b8125e8ad3bca0637e00b71e2693 upstream.

The kalmia driver should validate that the device it is probing has the
proper number and types of USB endpoints it is expecting before it binds
to it.  If a malicious device were to not have the same urbs the driver
will crash later on when it blindly accesses these endpoints.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B3730")
Link: https://patch.msgid.link/2026022326-shack-headstone-ef6f@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kalmia.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -132,11 +132,18 @@ kalmia_bind(struct usbnet *dev, struct u
 {
 	int status;
 	u8 ethernet_addr[ETH_ALEN];
+	static const u8 ep_addr[] = {
+		1 | USB_DIR_IN,
+		2 | USB_DIR_OUT,
+		0};
 
 	/* Don't bind to AT command interface */
 	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_VENDOR_SPEC)
 		return -EINVAL;
 
+	if (!usb_check_bulk_endpoints(intf, ep_addr))
+		return -ENODEV;
+
 	dev->in = usb_rcvbulkpipe(dev->udev, 0x81 & USB_ENDPOINT_NUMBER_MASK);
 	dev->out = usb_sndbulkpipe(dev->udev, 0x02 & USB_ENDPOINT_NUMBER_MASK);
 	dev->status = NULL;


