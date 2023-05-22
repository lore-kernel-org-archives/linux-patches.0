Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9DD171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0779CC433EF;
	Mon, 22 May 2023 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784128;
	bh=uuO2L/NIq/nMVZPZi7LFumN8mAwh2IvzP50feO5GFoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5ORpXVuO9LE7cGmtRLSj8Fu/p8lEe64T2X052Gty876OxQJTfdYXV7akmzHBm5KJ
	 s2ouhhcoLC0CRRmdrdKQ6wsEkyQjuIQ93dqyMp8nUOVyMmxGIGxcvMAV9KFjEeOWsu
	 1nGMUmbKnL2IDGQYO2JA2ZGpfcMqVaWVOjPv6R14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 265/292] serial: 8250_exar: Add support for USR298x PCI Modems
Date: Mon, 22 May 2023 20:10:22 +0100
Message-Id: <20230522190412.565650982@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Davis <afd@ti.com>

commit 95d698869b404772cc8b72560df71548491c10bc upstream.

Possibly the last PCI controller-based (i.e. not a soft/winmodem)
dial-up modem one can still buy.

Looks to have a stock XR17C154 PCI UART chip for communication, but for
some reason when provisioning the PCI IDs they swapped the vendor and
subvendor IDs. Otherwise this card would have worked out of the box.

Searching online, some folks seem to not have this issue and others do,
so it is possible only some batches of cards have this error.

Create a new macro to handle the switched IDs and add support here.

Signed-off-by: Andrew Davis <afd@ti.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230420160209.28221-1-afd@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -40,9 +40,13 @@
 #define PCI_DEVICE_ID_COMMTECH_4224PCIE		0x0020
 #define PCI_DEVICE_ID_COMMTECH_4228PCIE		0x0021
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE		0x0022
+
 #define PCI_DEVICE_ID_EXAR_XR17V4358		0x4358
 #define PCI_DEVICE_ID_EXAR_XR17V8358		0x8358
 
+#define PCI_SUBDEVICE_ID_USR_2980		0x0128
+#define PCI_SUBDEVICE_ID_USR_2981		0x0129
+
 #define PCI_DEVICE_ID_SEALEVEL_710xC		0x1001
 #define PCI_DEVICE_ID_SEALEVEL_720xC		0x1002
 #define PCI_DEVICE_ID_SEALEVEL_740xC		0x1004
@@ -829,6 +833,15 @@ static const struct exar8250_board pbn_e
 		(kernel_ulong_t)&bd			\
 	}
 
+#define USR_DEVICE(devid, sdevid, bd) {			\
+	PCI_DEVICE_SUB(					\
+		PCI_VENDOR_ID_USR,			\
+		PCI_DEVICE_ID_EXAR_##devid,		\
+		PCI_VENDOR_ID_EXAR,			\
+		PCI_SUBDEVICE_ID_USR_##sdevid), 0, 0,	\
+		(kernel_ulong_t)&bd			\
+	}
+
 static const struct pci_device_id exar_pci_tbl[] = {
 	EXAR_DEVICE(ACCESSIO, COM_2S, pbn_exar_XR17C15x),
 	EXAR_DEVICE(ACCESSIO, COM_4S, pbn_exar_XR17C15x),
@@ -853,6 +866,10 @@ static const struct pci_device_id exar_p
 
 	IBM_DEVICE(XR17C152, SATURN_SERIAL_ONE_PORT, pbn_exar_ibm_saturn),
 
+	/* USRobotics USR298x-OEM PCI Modems */
+	USR_DEVICE(XR17C152, 2980, pbn_exar_XR17C15x),
+	USR_DEVICE(XR17C152, 2981, pbn_exar_XR17C15x),
+
 	/* Exar Corp. XR17C15[248] Dual/Quad/Octal UART */
 	EXAR_DEVICE(EXAR, XR17C152, pbn_exar_XR17C15x),
 	EXAR_DEVICE(EXAR, XR17C154, pbn_exar_XR17C15x),


