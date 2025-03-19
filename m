Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044271E5B63;
	Wed, 19 Mar 2025 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395106; cv=none; b=k9C0atTLol/gV3Bng1SBytucagEyU2A0qbGP+os3EfazqUAfiak9l2gDarPrMri2uxgV+fgAT8FAsQCefWCqrIckRRZT3ho3HFVRYMdyEL4hNEqJoySA9U+x4HgIX+DSqX+ww900QtOh+tJGyHODjntrn0L/8smQY2g70motp28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395106; c=relaxed/simple;
	bh=XPiP+uho+W97Luot7y8HzXhyGugp9x2fxD8/MkQ9rfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwdGQumdSb2hbpJPDXF9LbP1a4n611F6IszCtKN+pknSy1NwN4mLaxVH0H+vuj7jC0gw7oKEsnDiv4iABofpa8FVA+OOeGKVgABLWA8bquyubDE2bmW/39rG7JjYlXTctZ9a76u9BEMq6hQgsuH8ANyq4iQ4Jh3AFcwAdeUhTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOFm8Y6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOFm8Y6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD606C4CEEA;
	Wed, 19 Mar 2025 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395105;
	bh=XPiP+uho+W97Luot7y8HzXhyGugp9x2fxD8/MkQ9rfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOFm8Y6DLLDjdA1NWRE+XfhY060x89c1IGRpOVx9gF+z234hzVOrqEUqSMDOTBYSt
	 oCVTOTuvVIVgy1z8ypipH7+Fku5QSVqFtWMku5el+Q2+FchqrD070OojOwLD0oflBQ
	 Ero+AnwLOENcNFfSd651XOVlypSBeTv/QlG8WZeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boon Khai Ng <boon.khai.ng@intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 158/231] USB: serial: ftdi_sio: add support for Altera USB Blaster 3
Date: Wed, 19 Mar 2025 07:30:51 -0700
Message-ID: <20250319143030.742783136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


