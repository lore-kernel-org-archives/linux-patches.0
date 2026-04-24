Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB433E347;
	Fri, 24 Apr 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037927; cv=none; b=XSp31BNI7KgIWDzaXgU6sKt8h26kmCJauE4HLioNr2M0+hxRVAmxGF5jAbMHMVn9cTffyGr66eKK6CAMBA128cwavn6CfAbIQq7Cnhihaj4q4oJ9dPBw11jKHYalKnn9xPvDSKMK/FeZR3hLd70steIybWv1+xkavkjI9xp4MIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037927; c=relaxed/simple;
	bh=1Q5ZzLP4r5WSdfRfJObZ5CtnduigDhiv4kMSipqd90I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr+70bqWzJl/l0UAl/vKBK9/UTNjI5U6QqY/JIX/9pJ+f9jXITgTSxOdoFj3EnCf09yMHcZpJhfsPSnIOBPj2Qn3/mySpgWDiIo1ozWtfi9A8VGFTbQIUTXxn/Y8mfO0lMnkB6egmJZ5sSnPwAVidfp32I0NPmKKib40425wE1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewWeaiIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewWeaiIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA5C19425;
	Fri, 24 Apr 2026 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037926;
	bh=1Q5ZzLP4r5WSdfRfJObZ5CtnduigDhiv4kMSipqd90I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewWeaiInZMH9oRWg0hOpPbY0k5yC0q5s4s4zIYCLPZxaM9xptjfeCtAc3EcMwzt8P
	 3CZ1tBIiJJPMQo1lccAgnU/9BofPPFm3BzGXvfcUH7Uv7kmUgO1PaN75iQo1JBpktu
	 dyf/TVQb1UPd4gaMFNMIMMXJ1v29v3JlO1/KZWmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 091/166] wifi: rtw88: fix device leak on probe failure
Date: Fri, 24 Apr 2026 15:30:05 +0200
Message-ID: <20260424132551.760113690@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit bbb15e71156cd9f5e1869eee7207a06ea8e96c39 upstream.

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

This driver takes a reference to the USB device during probe but does
not to release it on all probe errors (e.g. when descriptor parsing
fails).

Drop the redundant device reference to fix the leak, reduce cargo
culting, make it easier to spot drivers where an extra reference is
needed, and reduce the risk of further memory leaks.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/netdev/2026022319-turbofan-darkened-206d@gregkh/
Cc: stable@vger.kernel.org	# 6.2
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260306085144.12064-19-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -811,7 +811,7 @@ static int rtw_usb_intf_init(struct rtw_
 			     struct usb_interface *intf)
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
-	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
+	struct usb_device *udev = interface_to_usbdev(intf);
 	int ret;
 
 	rtwusb->udev = udev;
@@ -837,7 +837,6 @@ static void rtw_usb_intf_deinit(struct r
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
-	usb_put_dev(rtwusb->udev);
 	kfree(rtwusb->usb_data);
 	usb_set_intfdata(intf, NULL);
 }


