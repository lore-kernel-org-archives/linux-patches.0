Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D752E8DEB;
	Sat, 17 Oct 2026 17:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256692; cv=none; b=HCjXL6hyeBydOkDl5ebIjftOhavILUB0LEokT7CNWSHP8wnttcjg0IogLH1SfZOzCb1Pycm5oM32RRnxZjvuf0b6SbP1GYfVBxcQM/5qgU6v3w4R3l21nxliOX3gjJyU1kfeMZ3BFN2jYipbVZ9qDikynbU3xHvpiMEOCAleuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256692; c=relaxed/simple;
	bh=DJqvFcaexoMIN98Z40xqKqfH/i2OWduVfz28ck8R3FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YdZYfCRZoD2p/YIxl83uluDKYf96ZQLJVOAIjQ4EUrs4e2cGdVJ1hN/NeTuinzbKv4t554GNgAJHdUAsCAd8kieRAOJE0X9/DJ+9woE6K6piMILuMZB9DWnSDndcv1LogggOH+Svboi/OwD9t72qlrdXAe11r6UCCXt1INtutOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVDD/BIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVDD/BIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D321F000C4;
	Sat, 17 Oct 2026 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256691;
	bh=YnY0AfFYbiTa+R0+6U891ODdnS2brhHbJM3398jiyms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVDD/BIrosdUjjZ+C0dNU1jC1xyCH/8XO1el+Cl9xtkJUfRFc2Q7dqpo95DkQSBMh
	 wqh6StL4Qx/OLjoBJs5Hpv0rJE5hXLFZCPoh1tyaEosrQzgkRX00RwHt09KOEgPelS
	 1WJHsoPwH70z0PnCJCNO58iP4LmoujgeFRR2wdHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Carrat?= <jeremy.carrat@icloud.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0320/1674] USB: serial: cp210x: add Corsair AX1500i Power Supply
Date: Sat, 17 Oct 2026 17:43:12 +0200
Message-ID: <20261017160439.331399232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


