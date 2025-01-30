Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C550A1E7C27;
	Thu, 30 Jan 2025 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246656; cv=none; b=L5aAoiApLbUF9d2+eDF/NdIqG9ZhX8RuMnLjhyig7h9pu28n4BRljOzqT1kIlPUvirmSKjCpWYjq4VbmEGSYG6tHyMUyTPN/lK7y/0I3iP8oW7WbcbHXX1qf7kaG7a4dFxZ/BLCTW8VUxK+/gzEDBRrDRwm+xteo9a4qvdZ7ANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246656; c=relaxed/simple;
	bh=kDFylhuwTKtMQgVm3i21iw70JjfnNz7o24VfrlrYV8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0JB5EGSa4Vfz0HlOBXt57l+6OVOfgwr2l9oDj3iMPvnaG4aXaYuHWo2nToyKpVsiPRCI2Qwhf/U/zpbMEJ0lXoXNz48XoFHOG3qLhvzTkr1VqQUj6zb84cEVIpY5NB7TkfBmoRkRnloksf2oBLubhuIpNxtAr6g2zYV1r7i7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1R/ALS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1R/ALS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48528C4CED2;
	Thu, 30 Jan 2025 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246656;
	bh=kDFylhuwTKtMQgVm3i21iw70JjfnNz7o24VfrlrYV8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1R/ALS5taQ3oVJggtR+HDDY62NC4ACezM0GPxlLuI9Hh1vxwHHBzEUXSyji2azze
	 d9FY7W7hvQWzgakmKbsRXBZECIWC2kfwdT6q0yo7EXZyK6mIcQJmBwLi9B+5HU7+G6
	 5x7oZ0DxmFcjGabuL3IcJqkL0yceDzH+AcKodXR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Corbelli <giuseppe.corbelli@antaresvision.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 23/91] USB: serial: cp210x: add Phoenix Contact UPS Device
Date: Thu, 30 Jan 2025 15:00:42 +0100
Message-ID: <20250130140134.595300782@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 854eee93bd6e3dca619d47087af4d65b2045828e upstream.

Phoenix Contact sells UPS Quint devices [1] with a custom datacable [2]
that embeds a Silicon Labs converter:

Bus 001 Device 003: ID 1b93:1013 Silicon Labs Phoenix Contact UPS Device
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1b93
  idProduct          0x1013
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 Phoenix Contact UPS Device
  iSerial                 3 <redacted>
  bNumConfigurations	 1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              2 Phoenix Contact UPS Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

[1] https://www.phoenixcontact.com/en-pc/products/power-supply-unit-quint-ps-1ac-24dc-10-2866763
[2] https://www.phoenixcontact.com/en-il/products/data-cable-preassembled-ifs-usb-datacable-2320500

Reported-by: Giuseppe Corbelli <giuseppe.corbelli@antaresvision.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -224,6 +224,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1B93, 0x1013) }, /* Phoenix Contact UPS Device */
 	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */


