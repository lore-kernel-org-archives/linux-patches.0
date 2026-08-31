Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FF9441627;
	Mon, 31 Aug 2026 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185128; cv=none; b=DGFc3yV1VvR/YLcrA1Y8godpeVnOYyWNk2dDHlzX1E7XbJIkDv0CFqWuoEKnbDZWJmEtetq3yU0xAI9e6D0ZxMbRcrYZzalukJXyZvLlK7KKdLCtvhu++J4Lub8FonHdW1dSc1+dZ34qGAlrRMxjA8JHZ8tud6Q61oGCuq7OOEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185128; c=relaxed/simple;
	bh=aahhvzUCB5RpeQd4jU+Y+bGnX0sum3hGpBH4wGh5Scc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCRpsMR7o+XunT1LSjCUpmcpUPuJeGsOyp9FFBakwioVO+M1UIPx6OgLaRh9tOsdOt+DzKjcn3VjjBoMTlXs8Py5yV4BYV92CuMaFCZ/FfwOngExh84cfbboPvyUVFMLuzrjmcTXqd6lnrxUq1BSySEXX0sz8cmVaIlMDkyEWEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt6wCvjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt6wCvjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78981F00A3D;
	Mon, 31 Aug 2026 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185127;
	bh=zAqL/6OchFe6obKOkid0UZehMMyOr+t0EiOMjdYIqM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rt6wCvjsAFOWNcuBdBVreyhxYfWqVhwWMyHWmFhpBm/CtWo+hRgYA5FWWHN8J7jdT
	 IKGNFSKRvy1uiRSlb4EvzVItJl5vAIhz7cy8iU+Q0e28bdrvON4IzhRaj/Wjd7ydBI
	 cLjIl3zUbOOE7tZUMjjpFFCoSU3H7RATVzx7pqf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.15 62/69] usb: core: Add lock to usb_wakeup_notification()
Date: Mon, 31 Aug 2026 15:35:35 +0200
Message-ID: <20260831133401.838298545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit e263e18a9e7b1ff3e7301f0801c6ff87c31adfb6 upstream.

Add a spin lock to usb_wakeup notification to prevent a race condition
with dereferencing freed memory. This could be hit by the xHCI driver as
it calls this function from an IRQ and could race with the
hub_disconnect() function, which properly grabs this lock to protect the
state of the device.

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260713-usb_core_patches_1-v1-3-7721c2b33f53@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -714,10 +714,12 @@ void usb_wakeup_notification(struct usb_
 {
 	struct usb_hub *hub;
 	struct usb_port *port_dev;
+	unsigned long flags;
 
 	if (!hdev)
 		return;
 
+	spin_lock_irqsave(&device_state_lock, flags);
 	hub = usb_hub_to_struct_hub(hdev);
 	if (hub) {
 		port_dev = hub->ports[portnum - 1];
@@ -727,6 +729,7 @@ void usb_wakeup_notification(struct usb_
 		set_bit(portnum, hub->wakeup_bits);
 		kick_hub_wq(hub);
 	}
+	spin_unlock_irqrestore(&device_state_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
 


