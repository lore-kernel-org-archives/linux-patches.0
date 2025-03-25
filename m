Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8189E267393;
	Tue, 25 Mar 2025 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905741; cv=none; b=u+/CjDZQxD8ByqlltrgwZcLnV2nNtsfqjZnzN3Q6YB+yHkQCu+yERS26n1jqhqVPfP4q8RB1zCH+Ryqbhpqqjoll9ae+s5QhSNkNNLiV3035eLUOQ3AuE10S26KIM5PMWHKIzvi7Yu0aHNCn9FfuPiZinXzhSP/lobylGZ0i24I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905741; c=relaxed/simple;
	bh=5bV5DW8dyxI9O7MKOc9zt/7dYEbC9LBWBB59ZcqRQQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV4mbZiapg4MqnhvoYJjI15jdNhtQiVt6PO+4RKX/AQQX/u5/1zDwe+1C9Wsf3LZncbKaWzIqbVDEPlS3VU+tIT1eVw8AKirOlCC2OHfgvueV6VH3eyPPD2C/9Ne4HW2MHphHMy8M+obGztrP5JHnCmRaDtDW4+rU0sWXHTZRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reg/oDfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reg/oDfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6ECC4CEE4;
	Tue, 25 Mar 2025 12:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905741;
	bh=5bV5DW8dyxI9O7MKOc9zt/7dYEbC9LBWBB59ZcqRQQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reg/oDfHAPPa2begPIx90bvVEG0PKgYisuWaBLCQHY58bzD+MG7uhnAQPP9K7HnHo
	 EwNP/O3mjinSbwt13CfKWrd9vDEZZxqWFVR2HiII8c8CHa9LuCvGLrLVNkLGum40IC
	 3F1DNB37U+v47b/pJIsh1+ldFKx+BD9b/P+O7Jds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boon Khai Ng <boon.khai.ng@intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 108/198] USB: serial: ftdi_sio: add support for Altera USB Blaster 3
Date: Tue, 25 Mar 2025 08:21:10 -0400
Message-ID: <20250325122159.487989529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boon Khai Ng <boon.khai.ng@intel.com>

commit 18e0885bd2ca738407036434418a26a58394a60e upstream.

The Altera USB Blaster 3, available as both a cable and an on-board
solution, is primarily used for programming and debugging FPGAs.

It interfaces with host software such as Quartus Programmer,
System Console, SignalTap, and Nios Debugger. The device utilizes
either an FT2232 or FT4232 chip.

Enabling the support for various configurations of the on-board
USB Blaster 3 by including the appropriate VID/PID pairs,
allowing it to function as a serial device via ftdi_sio.

Note that this check-in does not include support for the
cable solution, as it does not support UART functionality.
The supported configurations are determined by the
hardware design and include:

1) PID 0x6022, FT2232, 1 JTAG port (Port A) + Port B as UART
2) PID 0x6025, FT4232, 1 JTAG port (Port A) + Port C as UART
3) PID 0x6026, FT4232, 1 JTAG port (Port A) + Port C, D as UART
4) PID 0x6029, FT4232, 1 JTAG port (Port B) + Port C as UART
5) PID 0x602a, FT4232, 1 JTAG port (Port B) + Port C, D as UART
6) PID 0x602c, FT4232, 1 JTAG port (Port A) + Port B as UART
7) PID 0x602d, FT4232, 1 JTAG port (Port A) + Port B, C as UART
8) PID 0x602e, FT4232, 1 JTAG port (Port A) + Port B, C, D as UART

These configurations allow for flexibility in how the USB Blaster 3 is
used, depending on the specific needs of the hardware design.

Signed-off-by: Boon Khai Ng <boon.khai.ng@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |   14 ++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   13 +++++++++++++
 2 files changed, 27 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1079,6 +1079,20 @@ static const struct usb_device_id id_tab
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/* GMC devices */
 	{ USB_DEVICE(GMC_VID, GMC_Z216C_PID) },
+	/* Altera USB Blaster 3 */
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_6022_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_6025_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_6026_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_6026_PID, 3) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_6029_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602A_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602A_PID, 3) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602C_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602D_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602D_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 2) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1612,3 +1612,16 @@
  */
 #define GMC_VID				0x1cd7
 #define GMC_Z216C_PID			0x0217 /* GMC Z216C Adapter IR-USB */
+
+/*
+ *  Altera USB Blaster 3 (http://www.altera.com).
+ */
+#define ALTERA_VID			0x09fb
+#define ALTERA_UB3_6022_PID		0x6022
+#define ALTERA_UB3_6025_PID		0x6025
+#define ALTERA_UB3_6026_PID		0x6026
+#define ALTERA_UB3_6029_PID		0x6029
+#define ALTERA_UB3_602A_PID		0x602a
+#define ALTERA_UB3_602C_PID		0x602c
+#define ALTERA_UB3_602D_PID		0x602d
+#define ALTERA_UB3_602E_PID		0x602e


