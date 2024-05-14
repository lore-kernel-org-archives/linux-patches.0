Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94B2943F;
	Tue, 14 May 2024 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685694; cv=none; b=rhv0FW+DSmS/UQhVhyAw/oJihMn6fWoJwjb0oeWfYjECORCfF0FG8OBgn9VxoJtWFvoi9iEW/d4/suqxEHL+pG0+B0mr/NcxJin2VmmhXa42PmAPVsx6arManiC5DziUFeAyXaTQYb8DAB20Lri+qfry+NYZV+gpsyTIKR8jSrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685694; c=relaxed/simple;
	bh=dHkVzL1WXiKzgod0KuwU3f/sX6gQEppuqy60hOSvOGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ1hmSU3sZaueOxZrbXOzJXiIgYEzeRLyAHoi02JEPbUm1giKGBLl3jWpHu96UR6yFLaoZReCuWI75eZqtU9AwI2BdEtrq/RipMKYa1g4irswzK7xA3cIobVq3IknQoviU9nHjjp9/1CG5kBSCk5TVfKAlkiQfZ1IWKDvrcBafw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnQa+Gd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnQa+Gd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FE7C2BD10;
	Tue, 14 May 2024 11:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685693;
	bh=dHkVzL1WXiKzgod0KuwU3f/sX6gQEppuqy60hOSvOGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnQa+Gd1eUc/D+vtCEMcoexb7wEQ96kh57Xn92VsqNDtqNMFDioUcrjMdjj89f7cD
	 fAxxC6jc0lkOSf5l2+kMO4q7Qn5btfdVjQ335kz7GOAdS6A0H+Ae6ITiaqYHBE2r97
	 uQ3HZ/L0UzK97XjEV0xQT0n99+t9mRauGpjXNV7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Roger Whittaker <roger.whittaker@suse.com>
Subject: [PATCH 6.6 227/301] usb: Fix regression caused by invalid ep0 maxpacket in virtual SuperSpeed device
Date: Tue, 14 May 2024 12:18:18 +0200
Message-ID: <20240514101040.827722853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c78c3644b772e356ca452ae733a3c4de0fb11dc8 upstream.

A virtual SuperSpeed device in the FreeBSD BVCP package
(https://bhyve.npulse.net/) presents an invalid ep0 maxpacket size of 256.
It stopped working with Linux following a recent commit because now we
check these sizes more carefully than before.

Fix this regression by using the bMaxpacketSize0 value in the device
descriptor for SuperSpeed or faster devices, even if it is invalid.  This
is a very simple-minded change; we might want to check more carefully for
values that actually make some sense (for instance, no smaller than 64).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Roger Whittaker <roger.whittaker@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1220569
Link: https://lore.kernel.org/linux-usb/9efbd569-7059-4575-983f-0ea30df41871@suse.com/
Fixes: 59cf44575456 ("USB: core: Fix oversight in SuperSpeed initialization")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/4058ac05-237c-4db4-9ecc-5af42bdb4501@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5077,9 +5077,10 @@ hub_port_init(struct usb_hub *hub, struc
 	}
 	if (usb_endpoint_maxp(&udev->ep0.desc) == i) {
 		;	/* Initial ep0 maxpacket guess is right */
-	} else if ((udev->speed == USB_SPEED_FULL ||
+	} else if (((udev->speed == USB_SPEED_FULL ||
 				udev->speed == USB_SPEED_HIGH) &&
-			(i == 8 || i == 16 || i == 32 || i == 64)) {
+			(i == 8 || i == 16 || i == 32 || i == 64)) ||
+			(udev->speed >= USB_SPEED_SUPER && i > 0)) {
 		/* Initial guess is wrong; use the descriptor's value */
 		if (udev->speed == USB_SPEED_FULL)
 			dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);


