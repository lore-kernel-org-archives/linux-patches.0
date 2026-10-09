Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C04E4C35;
	Fri,  9 Oct 2026 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557335; cv=none; b=A6t6SsfMPbaOAE1mTzQYSmumb9H8/RnosNSv0d4P6ct4S/EtGS2UBv9O8G9h9ZoT9zXrLVaeyzpTfYWOISBau44lLsEFmDNMKbltYn7xBJHvqVV8dY+Ffq+UGGOIjnUF7jBUnaeR1SqkxsAgtbCJrE38+0MHDDo/AXHJjWCBziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557335; c=relaxed/simple;
	bh=iTLpU/hrsJ9NFPpbyiFmWZ4z4AX/QvQAjhhGVgOodrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eEHrzPo6QLtoMRgRhh4ehm1O2R4GJQsbbRG00YqvUOUVRkUozat/Ul3Hx75BH4f5aqVBjF6YZ/Q+uMykiD0i/tzCYks6frMlDXBPWKLL0GUNhR0OGGDzTClvSuJVCj6CwjFsjFlWrCKLwakM19bsF14X6ioFpdKHEuwcHsZmPVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPZCFJxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPZCFJxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A65A1F000FF;
	Fri,  9 Oct 2026 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557334;
	bh=tV729A6j+iQVVzo5upyAukParvaGM4Wv1xkI3NwgRq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPZCFJxp7ZZV+wVuf6vtUhnO5IcMA6qHwI+b1NGxPxw7aRw2SOLUBElteo6Bf/ozn
	 nzL+hwUBdeLACA6aJuc0B0fmC05EaJLkRBsyKRHf5i9rQXOT6CrGuL1/gARhdJbFFh
	 PmzwNnqFNvwEOGo/HP4xEJwpTRm253DwGDHDvVo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Carrat?= <jeremy.carrat@icloud.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 339/428] USB: serial: cp210x: add Corsair AX1500i Power Supply
Date: Fri,  9 Oct 2026 16:11:16 +0200
Message-ID: <20261009140953.593642181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Carrat <jeremy.carrat@icloud.com>

commit d84e27d87738634b92001500435ae4dadba10a13 upstream.

The Corsair AX1500i power supply exposes its Corsair Link monitoring
interface on a mini-USB port through an on-board CP2103, using a
Corsair-specific product ID. Without the ID in the table no driver binds
and no tty is created.

Tested by forcing the driver association with

  echo 1b1c 1c02 > /sys/bus/usb-serial/drivers/cp210x/new_id

and then setting the serial port to 115200 8N1. Adding the ID is sufficient
to talk to the device: the tty reaches a USB-to-SMBus bridge sitting behind
the UART, which identifies itself as "USB to SMB Bridge (Firmware by Ross
Fosler)" version 0.9 and relays PMBus reads to the power supply controller.
Input voltage and current, input and output power, internal temperature and
fan speed were all read back on an AX1500i.

  [    7.806181] usb 3-14: New USB device found, idVendor=1b1c, idProduct=1c02, bcdDevice= 1.00
  [  698.526754] usbcore: registered new interface driver cp210x
  [  698.526767] usbserial: USB Serial support registered for cp210x
  [  698.527863] cp210x 3-14:1.0: cp210x converter detected
  [  698.529263] usb 3-14: cp210x converter now attached to ttyUSB0

The related AX1600i (1b1c:1c11, iProduct "USB API") is expected to be the
same kind of device but has not been tested here, so it is not added.

Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Carrat <jeremy.carrat@icloud.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -223,6 +223,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1B1C, 0x1C02) }, /* Corsair AX1500i Power Supply */
 	{ USB_DEVICE(0x1B93, 0x1013) }, /* Phoenix Contact UPS Device */
 	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */


