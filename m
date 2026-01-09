Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D435BDCD;
	Fri,  9 Jan 2026 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962405; cv=none; b=tqsiiNsSPOipjDFzu2mPuxQHxCG4DVmXLqYMAqyhMet5JJQGAAwWDCX76AQQ1CYP/4BWidzufQLdJ82h9lpPz6oZc5oRMG0Wd6mqhTosQ4lx4N/7oYhjcaTGd1/NygJf65uwusChc/bFAcJkmvxqUwLJabPAFUOyArirWm+XppY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962405; c=relaxed/simple;
	bh=JvSZ8nz2CbcahI1nNN6HKzRt2FG7zEkH+EJFHLqfaSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv7PSWV1mHiP/4erL0iWZ7ovUECo2zbRYNK8GGh6YMcJaXzCGKKDKaf55F688pfFIawVHu8CQv0L4ak4u6HYowcmspzKnxIcXfQrGYcLYhEWuO2z/dk115lqZ3n6pWvuC2DAimsts0eeae5l2C5VeSAxpDhlBYEa93FsdJ9PKWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqpIezYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqpIezYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE2C4CEF1;
	Fri,  9 Jan 2026 12:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962405;
	bh=JvSZ8nz2CbcahI1nNN6HKzRt2FG7zEkH+EJFHLqfaSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqpIezYzUaYGWYc7NFHHKZNYRQKuEzPD0HhSPlXR+QhIciFptE6Av9eu/RYYipTZ4
	 JG4v4y1sFE7OW7TgC0uRxr51YIfSMG8xnABy1+lP2VrMe7kWb/qhLTElAFvk4+zCFE
	 Kt7QR3qV8ufK40p/vjATdLuoPzHwHBqiiwp6fPqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/634] usb: xhci: limit run_graceperiod for only usb 3.0 devices
Date: Fri,  9 Jan 2026 12:39:49 +0100
Message-ID: <20260109112129.234398248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

[ Upstream commit 8d34983720155b8f05de765f0183d9b0e1345cc0 ]

run_graceperiod blocks usb 2.0 devices from auto suspending after
xhci_start for 500ms.

Log shows:
[   13.387170] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.387177] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.387182] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.387188] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.387191] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.387193] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.387296] hub_event:5779: hub 3-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.393343] handle_port_status:2034: xhci-hcd PNP0D10:02: handle_port_status: starting usb5 port polling.
[   13.393353] xhci_hub_control:1271: xhci-hcd PNP0D10:02: Get port status 5-1 read: 0x206e1, return 0x10101
[   13.400047] hub_suspend:3903: hub 3-0:1.0: hub_suspend
[   13.403077] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.403080] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.403085] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.403087] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.403090] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.403093] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.403095] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.405002] handle_port_status:1913: xhci-hcd PNP0D10:04: Port change event, 9-1, id 1, portsc: 0x6e1
[   13.405016] hub_activate:1169: usb usb5-port1: status 0101 change 0001
[   13.405026] xhci_clear_port_change_bit:658: xhci-hcd PNP0D10:02: clear port1 connect change, portsc: 0x6e1
[   13.413275] hcd_bus_suspend:2250: usb usb3: bus auto-suspend, wakeup 1
[   13.419081] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.419086] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.419095] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.419100] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.419106] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.419110] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event
[   13.419112] hcd_bus_resume:2303: usb usb7: usb auto-resume
[   13.420455] handle_port_status:2034: xhci-hcd PNP0D10:04: handle_port_status: starting usb9 port polling.
[   13.420493] handle_port_status:1913: xhci-hcd PNP0D10:05: Port change event, 10-1, id 1, portsc: 0x6e1
[   13.425332] hcd_bus_suspend:2279: usb usb3: suspend raced with wakeup event
[   13.431931] handle_port_status:2034: xhci-hcd PNP0D10:05: handle_port_status: starting usb10 port polling.
[   13.435080] hub_resume:3948: hub 7-0:1.0: hub_resume
[   13.435084] xhci_hub_control:1271: xhci-hcd PNP0D10:03: Get port status 7-1 read: 0x2a0, return 0x100
[   13.435092] hub_event:5779: hub 7-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   13.435096] hub_suspend:3903: hub 7-0:1.0: hub_suspend
[   13.435102] hcd_bus_suspend:2250: usb usb7: bus auto-suspend, wakeup 1
[   13.435106] hcd_bus_suspend:2279: usb usb7: suspend raced with wakeup event

usb7 and other usb 2.0 root hub were rapidly toggling between suspend
and resume states. More, "suspend raced with wakeup event" confuses people.

So, limit run_graceperiod for only usb 3.0 devices

Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 4619d5e89d5b..6a7f3047ead3 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1652,7 +1652,7 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 	 * SS devices are only visible to roothub after link training completes.
 	 * Keep polling roothubs for a grace period after xHC start
 	 */
-	if (xhci->run_graceperiod) {
+	if (hcd->speed >= HCD_USB3 && xhci->run_graceperiod) {
 		if (time_before(jiffies, xhci->run_graceperiod))
 			status = 1;
 		else
-- 
2.51.0



