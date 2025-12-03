Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCF3074B3;
	Wed,  3 Dec 2025 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780396; cv=none; b=P2XchlAakEg/0kqM1KQgpa7CkD+qDJnyjBsoifEGO/hCTN8LfWvFYex5GNBba7jiFK8T6/ns+BrOPyZn+ZwErzpxTIS31KHj9N68pVRla6biNV3bcIcGEaxvw9Kwp+zGRRTWihC3jtfahZH/CDnvXcowQPrTEYQ9RktlmVwV4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780396; c=relaxed/simple;
	bh=dTR7N+BS2p+GR9BK9nZgmYBxuLTjhg+hsdibaOPE5Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZCBleN2uK40z6xLpEQNmCmv9x+9QZZj9XNPJcshV5pAWHVGO0SN3uWBZVxux8hghHEqLM3kyahrpUyxD6YVbPWvT9C79BqxuO3DKTES3mYmzfGLsb7n1SGWSkX/K5Qj/OgAXnJOv30Lskgk9U/krh9blEWZreRcZIrsCXAutpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj8Fv74l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj8Fv74l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BBC4CEF5;
	Wed,  3 Dec 2025 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780396;
	bh=dTR7N+BS2p+GR9BK9nZgmYBxuLTjhg+hsdibaOPE5Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj8Fv74l4irXh0npUIkbiZbmxu2PNt9Zz/4nDcqOdgaSJA1S3OLMf39PmdetU7RBk
	 AJqdyiq7EUcfJoScVhrGSmb7NPRos6rM76p0U2kQ/pGg9VUZw+csodKflQpTjfJaTd
	 CoGbD3Gh9m5bEgFxg+R4FLsEfrULczNROS112PaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Suvorov <cryosay@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 545/568] USB: serial: ftdi_sio: add support for u-blox EVK-M101
Date: Wed,  3 Dec 2025 16:29:07 +0100
Message-ID: <20251203152500.672124327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Suvorov <cryosay@gmail.com>

commit 2d8ab771d5316de64f3bb920b82575c58eb00b1b upstream.

The U-Blox EVK-M101 enumerates as 1546:0506 [1] with four FTDI interfaces:
- EVK-M101 current sensors
- EVK-M101 I2C
- EVK-M101 UART
- EVK-M101 port D

Only the third USB interface is a UART. This change lets ftdi_sio probe
the VID/PID and registers only interface #3 as a TTY, leaving the rest
available for other drivers.

[1]
usb 5-1.3: new high-speed USB device number 11 using xhci_hcd
usb 5-1.3: New USB device found, idVendor=1546, idProduct=0506, bcdDevice= 8.00
usb 5-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1.3: Product: EVK-M101
usb 5-1.3: Manufacturer: u-blox AG

Datasheet: https://content.u-blox.com/sites/default/files/documents/EVK-M10_UserGuide_UBX-21003949.pdf

Signed-off-by: Oleksandr Suvorov <cryosay@gmail.com>
Link: https://lore.kernel.org/20250926060235.3442748-1-cryosay@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1074,6 +1074,7 @@ static const struct usb_device_id id_tab
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
+	{ USB_DEVICE_INTERFACE_NUMBER(UBLOX_VID, UBLOX_EVK_M101_PID, 2) },
 	/* FreeCalypso USB adapters */
 	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_BUF_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1614,6 +1614,7 @@
 #define UBLOX_VID			0x1546
 #define UBLOX_C099F9P_ZED_PID		0x0502
 #define UBLOX_C099F9P_ODIN_PID		0x0503
+#define UBLOX_EVK_M101_PID		0x0506
 
 /*
  * GMC devices


