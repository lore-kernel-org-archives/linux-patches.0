Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03898216605;
	Tue, 29 Apr 2025 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949412; cv=none; b=ML95yxzkYQpmxtmaFm4tAtvfpVKs+rAagxCmBKfrt9qYJmhVvK0ACrFZ286JjcgQoXJ3cfShwFxFD4QydNpvROzQgyV7PVpuCtDisrA70/D1/kwR6OCScJtXwIzB2rzILDcfKtfCtG6ywvGdoFNue5gdLF1+w7KYx4K0ERXcYME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949412; c=relaxed/simple;
	bh=jikojnoGfMnaD3HMwTLiCo3wpih+///IkU0x5PDmjP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR9k0rts3L5ZjXkZwsLWEfpxt0ZzvMtIEVRUByFbYrtgz0AlyEmXaZPFEf9Riw9i+5xXkZK94e5Wn5BOW3jM0Lo0x+XqKABJ/EXKD2m2Rm0Wmlk7FvCKL3JSCe3HD+1L0pwGyFcxgmrWTt0r2K5MVTVB7iMTI8+HjNBbPaz4/jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDuF+Gci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDuF+Gci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F77C4CEE3;
	Tue, 29 Apr 2025 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949411;
	bh=jikojnoGfMnaD3HMwTLiCo3wpih+///IkU0x5PDmjP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDuF+GciMvaIvW5cLnwLKIspnfEaI8j6XMjJoid/koKvX6dnDEWKHeXoLudEesAO2
	 2hNt8GB3Xc86zLXLXQvgKXvCDGa7LTFCU7kX/v/CVTaFh/T82x/HYQuBwAIBEYN3yE
	 f+hHqDh+CTl4ObXDuxpNNfLDY+VomaAT3LVMhHoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Craig Hesling <craig@hesling.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 309/373] USB: serial: simple: add OWON HDS200 series oscilloscope support
Date: Tue, 29 Apr 2025 18:43:06 +0200
Message-ID: <20250429161135.821588418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Craig Hesling <craig@hesling.com>

commit 4cc01410e1c1dd075df10f750775c81d1cb6672b upstream.

Add serial support for OWON HDS200 series oscilloscopes and likely
many other pieces of OWON test equipment.

OWON HDS200 series devices host two USB endpoints, designed to
facilitate bidirectional SCPI. SCPI is a predominately ASCII text
protocol for test/measurement equipment. Having a serial/tty interface
for these devices lowers the barrier to entry for anyone trying to
write programs to communicate with them.

The following shows the USB descriptor for the OWON HDS272S running
firmware V5.7.1:

Bus 001 Device 068: ID 5345:1234 Owon PDS6062T Oscilloscope
Negotiated speed: Full Speed (12Mbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x5345 Owon
  idProduct          0x1234 PDS6062T Oscilloscope
  bcdDevice            1.00
  iManufacturer           1 oscilloscope
  iProduct                2 oscilloscope
  iSerial                 3 oscilloscope
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0029
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
      bInterfaceClass         5 Physical Interface Device
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              0
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 5f 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              32
Device Status:     0x0000
  (Bus Powered)

OWON appears to be using the same USB Vendor and Product ID for many
of their oscilloscopes. Looking at the discussion about the USB
vendor/product ID, in the link bellow, suggests that this VID/PID is
shared with VDS, SDS, PDS, and now the HDS series oscilloscopes.
Available documentation for these devices seems to indicate that all
use a similar SCPI protocol, some with RS232 options. It is likely that
this same simple serial setup would work correctly for them all.

Link: https://usb-ids.gowdy.us/read/UD/5345/1234
Signed-off-by: Craig Hesling <craig@hesling.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb-serial-simple.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -101,6 +101,11 @@ DEVICE(nokia, NOKIA_IDS);
 	{ USB_DEVICE(0x09d7, 0x0100) }	/* NovAtel FlexPack GPS */
 DEVICE_N(novatel_gps, NOVATEL_IDS, 3);
 
+/* OWON electronic test and measurement equipment driver */
+#define OWON_IDS()			\
+	{ USB_DEVICE(0x5345, 0x1234) } /* HDS200 oscilloscopes and others */
+DEVICE(owon, OWON_IDS);
+
 /* Siemens USB/MPI adapter */
 #define SIEMENS_IDS()			\
 	{ USB_DEVICE(0x908, 0x0004) }
@@ -135,6 +140,7 @@ static struct usb_serial_driver * const
 	&motorola_tetra_device,
 	&nokia_device,
 	&novatel_gps_device,
+	&owon_device,
 	&siemens_mpi_device,
 	&suunto_device,
 	&vivopay_device,
@@ -154,6 +160,7 @@ static const struct usb_device_id id_tab
 	MOTOROLA_TETRA_IDS(),
 	NOKIA_IDS(),
 	NOVATEL_IDS(),
+	OWON_IDS(),
 	SIEMENS_IDS(),
 	SUUNTO_IDS(),
 	VIVOPAY_IDS(),


