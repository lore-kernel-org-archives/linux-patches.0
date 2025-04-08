Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ECC2192F2;
	Tue,  8 Apr 2025 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112394; cv=none; b=NrgAs6JQpU/ptjVd9vQ9DLeciO9QPZXywNjADpCJRt12uR5jYA6dw4ycMv2+c2soyNatrY7s0kNHxWqsfHigPOdWQZ3rfdBGQx+1rqeiIiCpXVBc9EJWKIE0tOrfxjOO2OsI4DbmfaMW6UFOamH+AFsO21tkU30/o50EtM/fCIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112394; c=relaxed/simple;
	bh=kJfStFs8E3ZJmH2I+b8A/Ok+/EPeZige3bpnNuhHWm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIIHEY05VytXuhe4LAAfdEfehwSTQI7U0ROVxBlmv2xBMBARJIKo+OkPtBrpZvA+/BawsRP3dqTXLSFc3FcIc25JsaYE5Kx4vg6jA8dh+2AuORNV/KQFw5Ps0UJ1X9l5UC3Fn/h/fcZw/ELEavh4Zm3GMgeG18x6xo0AJP8U0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5aH64DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5aH64DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762C4C4CEE5;
	Tue,  8 Apr 2025 11:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112393;
	bh=kJfStFs8E3ZJmH2I+b8A/Ok+/EPeZige3bpnNuhHWm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5aH64DHLINgPZoJqkh8tlldzTFho6FYfXNr5QszniNurgFMJLMUUYoOQvqz3hmvy
	 cAfDdUESU0mRe0R7iufDu9glwcEK+8Ui93o3cmXgfycDrxvbE5B8LWLBhOXYGWjzK3
	 z2KzZvQUfxuin/j9DUm3zra3SiHI/LTSFWIpIxvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boon Khai Ng <boon.khai.ng@intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 053/279] USB: serial: ftdi_sio: add support for Altera USB Blaster 3
Date: Tue,  8 Apr 2025 12:47:16 +0200
Message-ID: <20250408104827.794066223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1057,6 +1057,20 @@ static const struct usb_device_id id_tab
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
@@ -1605,3 +1605,16 @@
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


