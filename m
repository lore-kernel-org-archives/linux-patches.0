Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0234252C;
	Mon, 20 Apr 2026 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701023; cv=none; b=I7s0EHiOomTrtjtXTW82AUGvcP+lw6OsRoSSzO9aUXETEfTSaXxVJvPZx8pHHhI7bkRrJk3nqpn/MiWJuolmAXIUg/HJqwUAiQ5R3drAYkPgbDjx3ZBJv8cJ+M0NjWjS/ezDLlftvSjS6F5OyZO/J6305k0JdsdBAmESqTBXbQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701023; c=relaxed/simple;
	bh=HOOT8khQpY4FPj9Els6eiY9ToHxO32ASfkF0ftI3dSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3gmMA/HqlnUUlzIfZcW5LIoVELF8lN9oNhdm2nIQuOkIuaizv02Dj5/vGtUt0FMSby/UI59LOcO+hmEwtr3SN9A9YfgrSI4Q+tg3ITAShNJdCDW5A7wwo20XE4zDa9PbGWAMyxeWgEuADbB6qZR6DdDBJ3mxCnIKrpOrOJKZK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqzvqNZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqzvqNZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF4C19425;
	Mon, 20 Apr 2026 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701023;
	bh=HOOT8khQpY4FPj9Els6eiY9ToHxO32ASfkF0ftI3dSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqzvqNZC4M6XHSv6DcxEsh7gmmhSISn+xOnwMZiLlbegcfNCYfyDOvk2TkL8uuz1O
	 4WrAsRCcocp0oQfrsiJv9DiPuOn3l8wEtiiaKiBF52U/qjKf+JXGyw6zs6+c/N2c9M
	 ats+o5WVOZg2FogGDhhfIGo6kLibuBY0g8CRDuV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 152/198] wifi: rtw88: fix device leak on probe failure
Date: Mon, 20 Apr 2026 17:42:11 +0200
Message-ID: <20260420153941.079142934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1040,7 +1040,7 @@ static int rtw_usb_intf_init(struct rtw_
 			     struct usb_interface *intf)
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
-	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
+	struct usb_device *udev = interface_to_usbdev(intf);
 	int ret;
 
 	rtwusb->udev = udev;
@@ -1066,7 +1066,6 @@ static void rtw_usb_intf_deinit(struct r
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
-	usb_put_dev(rtwusb->udev);
 	kfree(rtwusb->usb_data);
 	usb_set_intfdata(intf, NULL);
 }


