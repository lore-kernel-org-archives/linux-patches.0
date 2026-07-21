Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD0343634C;
	Tue, 21 Jul 2026 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665235; cv=none; b=rEsUDzCBaci+FDHZGv6rJSF3EWQK7uYqc8Dff4DgzlvjJB6kY6fT/yBmG3aXpeRiKdy3gpqr6MMPm8bktMe/PF7FQtUNRqHZrzUJiMOnxcpL31c1veoo+DIqwpSVdRIUvVY8RYHjMFt136a+skyv8HPZQUkpoQTi1CW8O6B0+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665235; c=relaxed/simple;
	bh=+WnLFdieCciT0KiNZfI9KWUxmTr1tKeq3MTvvEHNABc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGdHM7zXJC+Mr4uR/OFPTB4Q8Qz/iKgDbM10hDva2p1rCjoEtrV68KD3bfKH/5r+9R43O5pCZESjcnyA3jkwqQUsMtCE8t9cdwAgdK2iGgRfGuIvlVJtBQDPEBFh/jjbjyaXLJ5OMOU7p9v9fJWlg0izSLKI+BP8qetsuz32R/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hksqfIL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hksqfIL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3526E1F000E9;
	Tue, 21 Jul 2026 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665233;
	bh=KE4VUViKT6claYzeyq6MRjL3IMBF9WBK69/gOXymamc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hksqfIL62EIKJMNMsqnlNXu+Y/4/0PUNC7D0apx3HeGPwfUCVEXcC4c+Jl7MOhr8o
	 ACMWTZNdbMeJ1U9r8oLkeL/LGU4lMeRSmJieTP71Wgo8Kg0bmqgI4X+BzOCQUL5a2R
	 Z/oApP18J73HYeShVd1ISxm9cdSIIYQZaUsvVj8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Baldridge <jrb@expunge.us>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 0225/1266] usb: cdc_acm: Add quirk for Uniden BC125AT scanner
Date: Tue, 21 Jul 2026 17:11:02 +0200
Message-ID: <20260721152446.852181788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Baldridge <jrb@expunge.us>

commit 6eba58568f6cc3ff8515a00b05e258d8cfb72b72 upstream.

Uniden BC125AT radio scanner has a USB interface which fails to work
with the cdc_acm driver:
 usb 1-1: new full-speed USB device number 2 using uhci_hcd
 cdc_acm 1-1:1.0: Zero length descriptor references
 cdc_acm 1-1:1.0: probe with driver cdc_acm failed with error -22
 usbcore: registered new interface driver cdc_acm

Adding the NO_UNION_NORMAL quirk for the device fixes the issue:

 usb 1-1: new full-speed USB device number 2 using uhci_hcd
 cdc_acm 1-1:1.0: ttyACM0: USB ACM device
 usbcore: registered new interface driver cdc_acm

`lsusb -v` of the device:

 Bus 001 Device 002: ID 1965:0017 Uniden Corporation BC125AT
 Negotiated speed: Full Speed (12Mbps)
 Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            2 Communications
   bDeviceSubClass         0 [unknown]
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x1965 Uniden Corporation
   idProduct          0x0017 BC125AT
   bcdDevice            0.01
   iManufacturer           1 Uniden America Corp.
   iProduct                2 BC125AT
   iSerial                 3 0001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0030
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         2 Communications
       bInterfaceSubClass      2 Abstract (modem)
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x87  EP 7 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0 [unknown]
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
 Device Status:     0x0000
   (Bus Powered)

Signed-off-by: Jared Baldridge <jrb@expunge.us>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260530221959.612526-1-jrb@expunge.us
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1810,6 +1810,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
 	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
 	},
+	{ USB_DEVICE(0x1965, 0x0017), /* Uniden BC125AT */
+	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
+	},
 	{ USB_DEVICE(0x1965, 0x0018), /* Uniden UBC125XLT */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},


