Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69DFAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAE6C433D6;
	Thu, 27 Oct 2022 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890555;
	bh=xZnQqsZqBGELzOyDRwvxIqgdsMm43RBlybNEonWmITE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBN7LH0tF0tTIuEY93JJo9YRq6iguUetW6pqBsVe3FWxn7xSjvuZRdXqD4Jow+dr8
	 iRusZXoxIHIYqSeYXvjToM/KrvIT6WJkVBJVrsT/tHH4p1kLnAs2vRVk/8ZKaHD0/Y
	 mpE9YOlJhdRdEdHRJRu+LCFE6BUGbrH6UTcq4rY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 36/53] r8152: add PID for the Lenovo OneLink+ Dock
Date: Thu, 27 Oct 2022 18:56:24 +0200
Message-Id: <20221027165051.185317391@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>

commit 1bd3a383075c64d638e65d263c9267b08ee7733c upstream.

The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
a broken CDC device by default. Add the custom Lenovo PID to the r8152
driver to support it properly.

Also, systems compatible with this dock provide a BIOS option to enable
MAC address passthrough (as per Lenovo document "ThinkPad Docking
Solutions 2017"). Add the custom PID to the MAC passthrough list too.

Tested on a ThinkPad 13 1st gen with the expected results:

passthrough disabled: Invalid header when reading pass-thru MAC addr
passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/r8152.c     |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -764,6 +764,13 @@ static const struct usb_device_id	produc
 },
 #endif
 
+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5823,6 +5823,7 @@ static const struct usb_device_id rtl815
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},


