Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC46D352FDE;
	Tue, 26 Aug 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216718; cv=none; b=UvFdf5w4dE/Nt+hup1thf5KiFczOYt+mOIt8XzJUrnXoRGYXNVOfNByyWRa9ujXc7buyYMFUf7qhj7BcSU0g6al4npVJ/GRBlEAPSn/ac8ft4WuDyXl5yVNhvhZO7MhNXj7vPEnD0h83zaKqwRRp53kHu9Md9RtPzJSM9UY3Tms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216718; c=relaxed/simple;
	bh=ART/uR7zHKbMWQW0DWgI8T2jFz2Crs+NErMim6IA+PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWqU2zgHiTLsrUP9SE9G6FK2f75KsS/bvJnoUu3v9AGTQksBh7cii97JBu4VXeWHdyKimcDw7RHrPgW3ZIqPU16Wzk8tSuyGImLXCHabcHhHbyZhBGoRQZf831I7MuADbwUgt0qDwcJw+Wp6TIgGCyECwHvHeulp/GIn5BtMq6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUDXBcSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUDXBcSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB0C4CEF1;
	Tue, 26 Aug 2025 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216718;
	bh=ART/uR7zHKbMWQW0DWgI8T2jFz2Crs+NErMim6IA+PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUDXBcSXbHEYwhclh6R3GuRl4jzokZPQs2+UeyjCvzyyBwh4U8S0GzziRyDr1ivWR
	 JC+g1M4DqAICawO1K0tQsWqYciVivvQoAPL5U6tJoUMBr9yclkJckUx0pWGVe03FgN
	 n3yQv9lu03rMoQqZRGy9TgcLVYnT0faXXzc1qD7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <markpearson@lenovo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/644] usb: hub: avoid warm port reset during USB3 disconnect
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826110959.344099770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2857,6 +2857,8 @@ static unsigned hub_is_wusb(struct usb_h
 #define PORT_INIT_TRIES		4
 #endif	/* CONFIG_USB_FEW_INIT_RETRIES */
 
+#define DETECT_DISCONNECT_TRIES 5
+
 #define HUB_ROOT_RESET_TIME	60	/* times are in msec */
 #define HUB_SHORT_RESET_TIME	10
 #define HUB_BH_RESET_TIME	50
@@ -5681,6 +5683,7 @@ static void port_event(struct usb_hub *h
 	struct usb_device *udev = port_dev->child;
 	struct usb_device *hdev = hub->hdev;
 	u16 portstatus, portchange;
+	int i = 0;
 
 	connect_change = test_bit(port1, hub->change_bits);
 	clear_bit(port1, hub->event_bits);
@@ -5757,17 +5760,27 @@ static void port_event(struct usb_hub *h
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
@@ -5775,6 +5788,7 @@ static void port_event(struct usb_hub *h
 			usb_lock_port(port_dev);
 			connect_change = 0;
 		}
+		break;
 	}
 
 	if (connect_change)


