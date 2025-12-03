Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E4832C944;
	Wed,  3 Dec 2025 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781162; cv=none; b=We1qP23GqmxoHFvjkl9cNTgtltA3dgeTSz4NsXHFn6/mAOIFTu3rdTNcbzrokCZ7SYmjNRhz/kYZ8DVlKIz07y+5df7TY7n6yAew87bR88z7942fc+A88GuSqMSp4mD9NsQ/NLRM/mZP7HsWH3vY0KOEBo0MbQy0rxCf0WflhE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781162; c=relaxed/simple;
	bh=0YIWKbvjDM60pCRq4ocxHcy3Vg4nTjkiu/qk7II+Z6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf7I3DFWTFuS0LdL+2hav5jf/Ckz+SaJhghef0MOqa3zHidrmkO5ax2iQMdhPcLJHBaydaWucxd/1E9XPn1VvrJ2RWtSXr9/wie2ezRAg/TQ1F+suoCHfJDeUineeKsGfzm8IwZKyQNv/dlWcIXRwEN09sSz2+4ifloJvlGw4Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5IOIJI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5IOIJI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E312C4CEF5;
	Wed,  3 Dec 2025 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781161;
	bh=0YIWKbvjDM60pCRq4ocxHcy3Vg4nTjkiu/qk7II+Z6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5IOIJI9gXxGkEtyYzuscyl3ZHvxUGjojG3Z4D1vhDw/YiREN282PMJl3bHWSgOm4
	 MnIbzYJQ/oPml2JRBHZX5ZG4k+89njCAQP8sIgzu8zgtSSOkb48r2Q6X4agwly8ljE
	 W8Rx4jy0T8QkIvQk3rIgllb8YAMZ2ZQcNWtCBLT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Suvorov <cryosay@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 69/93] USB: serial: ftdi_sio: add support for u-blox EVK-M101
Date: Wed,  3 Dec 2025 16:30:02 +0100
Message-ID: <20251203152339.075313724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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


