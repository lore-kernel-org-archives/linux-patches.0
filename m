Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA734C806;
	Sat, 30 May 2026 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158678; cv=none; b=tEPxjrQFkHcfUOss2RAEfU/1lPiMugzdd2znR1mnGMZ3v6hYv5m90NPylZVmJwkCyYfTwjSArvnMJcr3Kpt9hic0S5nlrRlVCQn/sND4ZqKBdCFb1L+5oVZK37sC4FfitVVT6ZQ2m2pwOH8vArBAfulfkZn37Hdru1YY3Q2jWlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158678; c=relaxed/simple;
	bh=nBD6q5UQZagrTJH511nXXTzQRm9h2CUg/C9wnQjV0w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnBWPy9r5Bu5JbH7DccFD2CTEMfVxWfSiDXFpGuTNo//kVqDbNeqZCLwY1JVStZC2f3qlMU4+JpQ3PYf2hoCBHFYO7OCOWFVfvSQ46lxbbirRrptWMPk3yHK3eH1fqjTLV3JSjAN+kGDFPOpiqAIc6wGRD03s6JsPZBe4eI2qSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Drx7fR4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Drx7fR4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B660E1F00893;
	Sat, 30 May 2026 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158677;
	bh=x1yheUnKave/5aua/NgU2YtHn2s6cIMYrvM0uIPAY1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Drx7fR4jI3rAON5wzoTjYkp12cZtWiXqMlLkZbqxfdsAdVUjqmHSvcboiOjcQphEi
	 UCrVDz9aNNSDzet3tD9CfmcdfABDiuQf8JfTDmvW0UwR706JCbaZWL0A8KG+SzPAeI
	 haEK4hQnE39G6eavvlZ29QA/R4qAv3yg4FiuDWyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 074/969] USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen
Date: Sat, 30 May 2026 17:53:18 +0200
Message-ID: <20260530160302.401681171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Carey <carvsdriver@gmail.com>

commit f58752ebcb35e156c85cd1a82d6579c7af3b9023 upstream.

The Lenovo Yoga Book 9 14IAH10 (83KJ) has a composite USB device
(17EF:6161) that controls both touchscreens via a CDC ACM interface.
Interface 0 is a standard CDC ACM control interface, but interface 1
(the data interface) incorrectly declares vendor-specific class (0xFF)
instead of USB_CLASS_CDC_DATA. cdc-acm rejects the device at probe with
-EINVAL, leaving interface 0 unbound and EP 0x82 never polled.

With no consumer polling EP 0x82, the firmware's watchdog fires every
~20 seconds and resets the USB bus, producing a continuous disconnect/
reconnect loop that prevents the touchscreens from ever initialising.

Add two new quirk flags:

VENDOR_CLASS_DATA_IFACE: Bypasses the bInterfaceClass check in
acm_probe() that would otherwise reject the vendor-class data
interface with -EINVAL.

ALWAYS_POLL_CTRL: Submits the notification URB at probe() rather than
waiting for a TTY open. This keeps EP 0x82 polled at all times,
permanently suppressing the firmware watchdog. The URB is resubmitted
after port_shutdown() and on system resume. SET_CONTROL_LINE_STATE
(DTR|RTS) is sent at probe and after port_shutdown() to complete
firmware handshake.

Note: the firmware performs exactly 4 USB connect/disconnect cycles
(~19 s each) on every cold boot before stabilising. This is a fixed
firmware property; touch is available ~75-80 s after power-on.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Cc: stable <stable@kernel.org>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260402182950.389016-1-carvsdriver@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   53 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 7 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -113,6 +113,8 @@ static int acm_ctrl_msg(struct acm *acm,
 	int retval;
 
 	retval = usb_autopm_get_interface(acm->control);
+#define VENDOR_CLASS_DATA_IFACE		BIT(9)  /* data interface uses vendor-specific class */
+#define ALWAYS_POLL_CTRL		BIT(10) /* keep ctrl URB active even without an open TTY */
 	if (retval)
 		return retval;
 
@@ -699,12 +701,14 @@ static int acm_port_activate(struct tty_
 	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
 	acm->control->needs_remote_wakeup = 1;
 
-	acm->ctrlurb->dev = acm->dev;
-	retval = usb_submit_urb(acm->ctrlurb, GFP_KERNEL);
-	if (retval) {
-		dev_err(&acm->control->dev,
-			"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
-		goto error_submit_urb;
+	if (!(acm->quirks & ALWAYS_POLL_CTRL)) {
+		acm->ctrlurb->dev = acm->dev;
+		retval = usb_submit_urb(acm->ctrlurb, GFP_KERNEL);
+		if (retval) {
+			dev_err(&acm->control->dev,
+				"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
+			goto error_submit_urb;
+		}
 	}
 
 	acm_tty_set_termios(tty, NULL);
@@ -777,6 +781,14 @@ static void acm_port_shutdown(struct tty
 
 	acm_unpoison_urbs(acm);
 
+	if (acm->quirks & ALWAYS_POLL_CTRL) {
+		acm->ctrlurb->dev = acm->dev;
+		if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL))
+			dev_dbg(&acm->control->dev,
+				"ctrl polling restart failed after port close\n");
+		/* port_shutdown() cleared DTR/RTS; restore them */
+		acm_set_control(acm, USB_CDC_CTRL_DTR | USB_CDC_CTRL_RTS);
+	}
 }
 
 static void acm_tty_cleanup(struct tty_struct *tty)
@@ -1304,6 +1316,9 @@ skip_normal_probe:
 			dev_dbg(&intf->dev,
 				"Your device has switched interfaces.\n");
 			swap(control_interface, data_interface);
+		} else if (quirks & VENDOR_CLASS_DATA_IFACE) {
+			dev_dbg(&intf->dev,
+				"Vendor-specific data interface class, continuing.\n");
 		} else {
 			return -EINVAL;
 		}
@@ -1498,6 +1513,9 @@ skip_countries:
 	acm->line.bDataBits = 8;
 	acm_set_line(acm, &acm->line);
 
+	if (quirks & ALWAYS_POLL_CTRL)
+		acm_set_control(acm, USB_CDC_CTRL_DTR | USB_CDC_CTRL_RTS);
+
 	if (!acm->combined_interfaces) {
 		rv = usb_driver_claim_interface(&acm_driver, data_interface, acm);
 		if (rv)
@@ -1519,6 +1537,13 @@ skip_countries:
 
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
+	if (acm->quirks & ALWAYS_POLL_CTRL) {
+		acm->ctrlurb->dev = acm->dev;
+		if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL))
+			dev_warn(&intf->dev,
+				 "failed to start persistent ctrl polling\n");
+	}
+
 	return 0;
 
 err_release_data_interface:
@@ -1645,7 +1670,7 @@ static int acm_resume(struct usb_interfa
 
 	acm_unpoison_urbs(acm);
 
-	if (tty_port_initialized(&acm->port)) {
+	if (tty_port_initialized(&acm->port) || (acm->quirks & ALWAYS_POLL_CTRL)) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_ATOMIC);
 
 		for (;;) {
@@ -1992,6 +2017,20 @@ static const struct usb_device_id acm_id
 	/* CH343 supports CAP_BRK, but doesn't advertise it */
 	{ USB_DEVICE(0x1a86, 0x55d3), .driver_info = MISSING_CAP_BRK, },
 
+	/*
+	 * Lenovo Yoga Book 9 14IAH10 (83KJ) — INGENIC 17EF:6161 touchscreen
+	 * composite device.  The CDC ACM control interface (0) uses a standard
+	 * Union descriptor, but the data interface (1) is declared as vendor-
+	 * specific class (0xff) with no CDC data descriptors, so cdc-acm would
+	 * normally reject it.  The firmware also requires continuous polling of
+	 * the notification endpoint (EP 0x82) to suppress a 20-second watchdog
+	 * reset; ALWAYS_POLL_CTRL keeps the ctrlurb active even when no TTY is
+	 * open.  Match only the control interface by class to avoid probing the
+	 * vendor-specific data interface.
+	 */
+	{ USB_DEVICE_INTERFACE_CLASS(0x17ef, 0x6161, USB_CLASS_COMM),
+	  .driver_info = VENDOR_CLASS_DATA_IFACE | ALWAYS_POLL_CTRL },
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },


