Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75828314A;
	Tue, 26 Aug 2025 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218167; cv=none; b=q5C/KkplFHtXXtZcD+xoK4itetqOFt0idP4zxLsmaNUM5goiqsdOEt7ErE7m5Wtq2ngSjfTltoO9f1pK7pmdvMpvPeNXI7hHFIha3qI0WV55xhyO50DyjJOnoVgjLZkhkHKyIeQ6PZYq8AN8SGTx4oGmVTW/e09S1EVdS4T3zkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218167; c=relaxed/simple;
	bh=MW1k2+FfMZaJUJq9CueKIuMd4Y1VBtCehCXntA4MS/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+/j4Ju7wbneCFSzWUVoFEeaqGLV21cTGsERnr1FCoEcMQMuxSAH3FyCInm6yIYIPmLh2xE0nW4P3wUmsoq6Nstb6IYWlX2l2Di49CaeAlxtj9TUzqIUoCfq0JkfoNb3M4lfwD7DAn5LAAzBP/SMoMOBrnKF9AJJvCQeqUoZYMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaxZOR9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaxZOR9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BC0C4CEF1;
	Tue, 26 Aug 2025 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218167;
	bh=MW1k2+FfMZaJUJq9CueKIuMd4Y1VBtCehCXntA4MS/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaxZOR9wfgVMPT7vIUrBP+4u7EUnER4Z8cSn7KEZm5Na0Jb6KiHr5oaEuvTSCHXWK
	 QzRGJ2S2DOZa3WUBq7i+oyynBUd5MgjG6AX880C6bxJ/MN1tKyJxdUu14CctRrHqcc
	 epejWN40r1xcfgMdpz+JIK/GZwSC7meRwdG+ryIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <markpearson@lenovo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/523] usb: hub: avoid warm port reset during USB3 disconnect
Date: Tue, 26 Aug 2025 13:10:29 +0200
Message-ID: <20250826110934.792035044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit f59f93cd1d720809466c7fd5aa16a236156c672b ]

During disconnect USB-3 ports often go via SS.Inactive link error state
before the missing terminations are noticed, and link finally goes to
RxDetect state

Avoid immediately warm-resetting ports in SS.Inactive state.
Let ports settle for a while and re-read the link status a few times 20ms
apart to see if the ports transitions out of SS.Inactive.

According to USB 3.x spec 7.5.2, a port in SS.Inactive should
automatically check for missing far-end receiver termination every
12 ms (SSInactiveQuietTimeout)

The futile multiple warm reset retries of a disconnected device takes
a lot of time, also the resetting of a removed devices has caused cases
where the reset bit got stuck for a long time on xHCI roothub.
This lead to issues in detecting new devices connected to the same port
shortly after.

Tested-by: Mark Pearson <markpearson@lenovo.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211210111653.1378381-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2521106fc732 ("usb: hub: Don't try to recover devices lost during warm reset.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2884,6 +2884,8 @@ static unsigned hub_is_wusb(struct usb_h
 #define PORT_INIT_TRIES		4
 #endif	/* CONFIG_USB_FEW_INIT_RETRIES */
 
+#define DETECT_DISCONNECT_TRIES 5
+
 #define HUB_ROOT_RESET_TIME	60	/* times are in msec */
 #define HUB_SHORT_RESET_TIME	10
 #define HUB_BH_RESET_TIME	50
@@ -5685,6 +5687,7 @@ static void port_event(struct usb_hub *h
 	struct usb_device *udev = port_dev->child;
 	struct usb_device *hdev = hub->hdev;
 	u16 portstatus, portchange;
+	int i = 0;
 
 	connect_change = test_bit(port1, hub->change_bits);
 	clear_bit(port1, hub->event_bits);
@@ -5761,17 +5764,27 @@ static void port_event(struct usb_hub *h
 		connect_change = 1;
 
 	/*
-	 * Warm reset a USB3 protocol port if it's in
-	 * SS.Inactive state.
-	 */
-	if (hub_port_warm_reset_required(hub, port1, portstatus)) {
-		dev_dbg(&port_dev->dev, "do warm reset\n");
-		if (!udev || !(portstatus & USB_PORT_STAT_CONNECTION)
+	 * Avoid trying to recover a USB3 SS.Inactive port with a warm reset if
+	 * the device was disconnected. A 12ms disconnect detect timer in
+	 * SS.Inactive state transitions the port to RxDetect automatically.
+	 * SS.Inactive link error state is common during device disconnect.
+	 */
+	while (hub_port_warm_reset_required(hub, port1, portstatus)) {
+		if ((i++ < DETECT_DISCONNECT_TRIES) && udev) {
+			u16 unused;
+
+			msleep(20);
+			hub_port_status(hub, port1, &portstatus, &unused);
+			dev_dbg(&port_dev->dev, "Wait for inactive link disconnect detect\n");
+			continue;
+		} else if (!udev || !(portstatus & USB_PORT_STAT_CONNECTION)
 				|| udev->state == USB_STATE_NOTATTACHED) {
+			dev_dbg(&port_dev->dev, "do warm reset, port only\n");
 			if (hub_port_reset(hub, port1, NULL,
 					HUB_BH_RESET_TIME, true) < 0)
 				hub_port_disable(hub, port1, 1);
 		} else {
+			dev_dbg(&port_dev->dev, "do warm reset, full device\n");
 			usb_unlock_port(port_dev);
 			usb_lock_device(udev);
 			usb_reset_device(udev);
@@ -5779,6 +5792,7 @@ static void port_event(struct usb_hub *h
 			usb_lock_port(port_dev);
 			connect_change = 0;
 		}
+		break;
 	}
 
 	if (connect_change)


