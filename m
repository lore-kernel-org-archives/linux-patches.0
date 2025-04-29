Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A332482C60;
	Tue, 29 Apr 2025 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947912; cv=none; b=bgMljqF2bWbl2fICg6ZdQdHTCjR7VG20BGC0F9a5/harA1IXP1INznFLdhdmw2pG8YaYQ0Cwblq7rJHgYGcWc1euSPgaBW6IqmAXGM7C3HHet2Sd3sd2Rxj7JCiGC+OIeNuKPIMH/AiI8ORibl1/9pV35SWs7m9qRIul3uS/7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947912; c=relaxed/simple;
	bh=JF46PM/3YwuQn+vylc8hMbHQLUC206OWDQkt0pMjLK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbqq+c1wS397+xZU/R1qR+pQWSxDeuvu+T+vWgV0+E7PufwX4UOvM9kdjJZS7n5wDqaebPQ7a3JDxQNWtmGSDEj0Yv+63uZQG21DEvo/Cl9nl76+8X1Mk4PIWM60LlL4yTbfxHwq7e8b4Cd+jhcev0Cepyo3wUqRPxXsxJB0cZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rR3m26X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR3m26X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235CFC4CEE3;
	Tue, 29 Apr 2025 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947912;
	bh=JF46PM/3YwuQn+vylc8hMbHQLUC206OWDQkt0pMjLK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR3m26X7aky2sC4OqOYfbjB8KnTsHhXhXVebJJDsaA5D9sJmF+NV3GP9y8Psdyn6z
	 1l9seu5TeLSEQq5AMgcq/AZCfADjPnC5ilAmI+aDUIag9zuiG1wOvkMMVS9kXwJByL
	 jgrJ4D2sTaCk4YItg/wLfgkpfK3xNQHQs+/1J0YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Craig Hesling <craig@hesling.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 135/280] USB: serial: simple: add OWON HDS200 series oscilloscope support
Date: Tue, 29 Apr 2025 18:41:16 +0200
Message-ID: <20250429161120.653142387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
@@ -100,6 +100,11 @@ DEVICE(nokia, NOKIA_IDS);
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
@@ -134,6 +139,7 @@ static struct usb_serial_driver * const
 	&motorola_tetra_device,
 	&nokia_device,
 	&novatel_gps_device,
+	&owon_device,
 	&siemens_mpi_device,
 	&suunto_device,
 	&vivopay_device,
@@ -153,6 +159,7 @@ static const struct usb_device_id id_tab
 	MOTOROLA_TETRA_IDS(),
 	NOKIA_IDS(),
 	NOVATEL_IDS(),
+	OWON_IDS(),
 	SIEMENS_IDS(),
 	SUUNTO_IDS(),
 	VIVOPAY_IDS(),


