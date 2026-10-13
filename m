Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E844FC8FB;
	Tue, 13 Oct 2026 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895262; cv=none; b=U1uHTuvOx+PWrE2UKzszClThxJHaDr47wzObNJjQyr742PzW+xdN+C9A5FJcyVCciJmPYu6Ngx+QM1YMF/JRaAI6zwwF8Lhg/kQhdzVtmsXaD4xMQd1790Mc+pvjOL5ReaNevUvJV4nebwwMhg8TDGpSCTNDGQvdZriubXjoHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895262; c=relaxed/simple;
	bh=1RSkdCHB8rcuKJFmBmQfd8A2qqRG1LWDI4HASXY+TvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SiFZ8YkWdamLUwZVobf0Qi74O5uOR5xR3uxq16dzE4e1//4/BofKmxtwLHZ2R4v4dPHr1fBASZvB7Cfku9sIlmy8ztbXmaT7ryxSjP54znSe5bT60/6ewzm59voNp1CwpqcNuIAOjz1Rc6kqyh+g2CG+lUG1W9e5vseFBRl8CB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efX+QTkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efX+QTkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8A21F000FF;
	Tue, 13 Oct 2026 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895261;
	bh=d1kxxzyeKAEwXL7bk3i1+7rfUm93TBh1YVjq/F31TOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efX+QTkkx+on4UMMpUBUGa4iJFNTBennhKgcs7k32FFfjVR+CoAQAPWOnXCDcdXh6
	 Ra5ANw36LU/vaVa1ProN2kkzWUQtHVv5YOPT+iXzSEuuRuS+Z0sBlGnwlKwSB2uNnY
	 PaFxk/z0F5UXrrBrIj84vbezQ1jcin/d+TTVS7Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Carrat?= <jeremy.carrat@icloud.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 214/497] USB: serial: cp210x: add Corsair AX1500i Power Supply
Date: Tue, 13 Oct 2026 13:36:21 +0200
Message-ID: <20261013112912.973582408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


