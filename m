Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B508F21773D;
	Tue,  8 Jul 2025 16:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992575; cv=none; b=G8T38ytBAdK054B8/4z2oNZHTvhfBsKJx7KTeTyksNmozXPSOEEURUEoZ0oCsHSYf9FM27owWYy7RYrp7q0sSnGYW0bLEDqaYzvoxTJelBs5o+VGU2QtyMHOd2ZX/fIO/yDibYNhFreSbzIKpVwEqMEnt/pYm2dNvIyBcd4no4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992575; c=relaxed/simple;
	bh=MvuQDNH0mc5mOoyR6j6P0tZwFdfbN2cVyha1il82h70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cP/wvX6ruCudRTF+aCLS1/c/YRs7KVzbRLYo1wmtIs0CXw6GYbV5tZbRzK1cpIFksh5IDAobNQsmg72lH2cTGnSNhGwKAkBAoPDE6Uqj6Q8Jet3NOGCnRmbHMQXcXp1r4cpRQi79HE4QfLnY1Lz0yhXDoKG5ydAGIujK39em14I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9toLzj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9toLzj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2ECC4CEED;
	Tue,  8 Jul 2025 16:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992575;
	bh=MvuQDNH0mc5mOoyR6j6P0tZwFdfbN2cVyha1il82h70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9toLzj987FYR00nsaBLGll7JZEb1lQxLaYJerOQeNF5mHqVId8qRYks1pZV5GxcE
	 Hmazo3EYUurtboQj7CTN4HOWE5t7ni6FX84fwEuGu/tKZkZOOiZdURSrCIW/vh7+OF
	 LcVNCncmsPtW9rzJLWaiFTEF8jaTMOzQjWyT0Gzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	John Ernberg <john.ernberg@actia.se>,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 116/132] usb: chipidea: udc: disconnect/reconnect from host when do suspend/resume
Date: Tue,  8 Jul 2025 18:23:47 +0200
Message-ID: <20250708162233.952456341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 31a6afbe86e8e9deba9ab53876ec49eafc7fd901 upstream.

Shawn and John reported a hang issue during system suspend as below:

 - USB gadget is enabled as Ethernet
 - There is data transfer over USB Ethernet (scp a big file between host
                                             and device)
 - Device is going in/out suspend (echo mem > /sys/power/state)

The root cause is the USB device controller is suspended but the USB bus
is still active which caused the USB host continues to transfer data with
device and the device continues to queue USB requests (in this case, a
delayed TCP ACK packet trigger the issue) after controller is suspended,
however the USB controller clock is already gated off. Then if udc driver
access registers after that point, the system will hang.

The correct way to avoid such issue is to disconnect device from host when
the USB bus is not at suspend state. Then the host will receive disconnect
event and stop data transfer in time. To continue make USB gadget device
work after system resume, this will reconnect device automatically.

To make usb wakeup work if USB bus is already at suspend state, this will
keep connection for it only when USB device controller has enabled wakeup
capability.

Reported-by: Shawn Guo <shawnguo@kernel.org>
Reported-by: John Ernberg <john.ernberg@actia.se>
Closes: https://lore.kernel.org/linux-usb/aEZxmlHmjeWcXiF3@dragon/
Tested-by: John Ernberg <john.ernberg@actia.se> # iMX8QXP
Fixes: 235ffc17d014 ("usb: chipidea: udc: add suspend/resume support for device controller")
Cc: stable <stable@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250614124914.207540-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/udc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2213,6 +2213,10 @@ static void udc_suspend(struct ci_hdrc *
 	 */
 	if (hw_read(ci, OP_ENDPTLISTADDR, ~0) == 0)
 		hw_write(ci, OP_ENDPTLISTADDR, ~0, ~0);
+
+	if (ci->gadget.connected &&
+	    (!ci->suspended || !device_may_wakeup(ci->dev)))
+		usb_gadget_disconnect(&ci->gadget);
 }
 
 static void udc_resume(struct ci_hdrc *ci, bool power_lost)
@@ -2223,6 +2227,9 @@ static void udc_resume(struct ci_hdrc *c
 					OTGSC_BSVIS | OTGSC_BSVIE);
 		if (ci->vbus_active)
 			usb_gadget_vbus_disconnect(&ci->gadget);
+	} else if (ci->vbus_active && ci->driver &&
+		   !ci->gadget.connected) {
+		usb_gadget_connect(&ci->gadget);
 	}
 
 	/* Restore value 0 if it was set for power lost check */


