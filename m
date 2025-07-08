Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CE3BE46;
	Tue,  8 Jul 2025 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993670; cv=none; b=awJvMFrv2BNMLgl2G8QK9sLoDvVAnjdaae/DmjLxbACDPapZtZJ5F6u0+wBz4W+avbL+gy+rTCDvQFkaisDv3n+3xMceX32YEuuoZxwskR85NvLmYtl/Wv8eaK0jOLEIFVAD5dZRXpkTu2a3Cl5j6sTNa6tUGucP25pI3FFrOb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993670; c=relaxed/simple;
	bh=P1rj8AWxyUYV3J9qkZ0wtQbgHxMWJRaQvYysrS3Wdow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWpDGzFRefcCkakgF2o5VZGQrbdcHJWRcfgq5nxD/C+Kh++Pg4PjktVadFCH6rMna9w+XjfEzm0vQjSGrUYo4r2PJ/vF+QQKD5eZVO4TNHgLz72Fz56PNzrTLk5egA+rht/LdDn/Xr3HTaPI/nWEWi+t8ZnCKjaZPBibgxwWVs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfeMtsqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfeMtsqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511CC4CEED;
	Tue,  8 Jul 2025 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993670;
	bh=P1rj8AWxyUYV3J9qkZ0wtQbgHxMWJRaQvYysrS3Wdow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfeMtsqCQkCDbv+uce4K50xfOhxWsZhosFTwjSjDpKIU70NFVb/qWCPf1jKpfYE/1
	 E33L439KMhVEORb5rAAYjxsj805k9uzTVjBDBx4CeMUw3rgKw3bRcvz7b1+zM/Zy0j
	 vLeWBnMxoPqxnu3fiRxlpBiV+8hlVPzcIcBlrY7g=
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
Subject: [PATCH 6.15 154/178] usb: chipidea: udc: disconnect/reconnect from host when do suspend/resume
Date: Tue,  8 Jul 2025 18:23:11 +0200
Message-ID: <20250708162240.526176956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2374,6 +2374,10 @@ static void udc_suspend(struct ci_hdrc *
 	 */
 	if (hw_read(ci, OP_ENDPTLISTADDR, ~0) == 0)
 		hw_write(ci, OP_ENDPTLISTADDR, ~0, ~0);
+
+	if (ci->gadget.connected &&
+	    (!ci->suspended || !device_may_wakeup(ci->dev)))
+		usb_gadget_disconnect(&ci->gadget);
 }
 
 static void udc_resume(struct ci_hdrc *ci, bool power_lost)
@@ -2384,6 +2388,9 @@ static void udc_resume(struct ci_hdrc *c
 					OTGSC_BSVIS | OTGSC_BSVIE);
 		if (ci->vbus_active)
 			usb_gadget_vbus_disconnect(&ci->gadget);
+	} else if (ci->vbus_active && ci->driver &&
+		   !ci->gadget.connected) {
+		usb_gadget_connect(&ci->gadget);
 	}
 
 	/* Restore value 0 if it was set for power lost check */


