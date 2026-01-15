Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5B27B340;
	Thu, 15 Jan 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498827; cv=none; b=iX1tN/K1ozH48YlQHyiz8H6fFijHPyxO5KZFvOI+Fyyxc1R6ZzBE0vPVyert0crM7Y/PtJr8EXRtGHmqT6G+PBZRXMtkKENMH/3y+KoHKa2lcT4xUhM+SDjSNNhrIPhWLl3+vJNw7pileUkiM2SLIAptbxGyp3LkgVTEo3cmbM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498827; c=relaxed/simple;
	bh=1oOxh62t/Nefek9UJSNnYGcEbvdYzBC4aIFRK4t9diM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+PQ2VY8TBqSJ7H7micrVLVxTdGROkjvpKPtwKzAa7izXbgQzhcb/J080TeoOPeTUys0rg3zdAJ3IbSqcirbf28I23VbwHHseJ6PqdSsVE5Q8FhKlhBEwjgCkl0slByjw7kogRV/UpEXqqkHbtHMYVcqlloioJ6W+QKfJML9k0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgW5kW0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgW5kW0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96D2C116D0;
	Thu, 15 Jan 2026 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498827;
	bh=1oOxh62t/Nefek9UJSNnYGcEbvdYzBC4aIFRK4t9diM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgW5kW0xCGB9nWOHsUkNEYaTNqrhmGzEDcTQvwnwSpoH5gzPNCBenOK+zZITCxGQm
	 wF1buYnxz6cqmbssz6xT2Xw6rRyrChk9HpW9gqpcPQxbiGCOWWBXhW71o8wb1cBh1f
	 z8/LqGX9UlqWzZlNt6c8lfe/sFQgdJOM9Qu/pmeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 013/451] USB: serial: ftdi_sio: match on interface number for jtag
Date: Thu, 15 Jan 2026 17:43:34 +0100
Message-ID: <20260115164231.368330906@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4e31a5d0a9ee672f708fc993c1d5520643f769fd upstream.

Some FTDI devices have the first port reserved for JTAG and have been
using a dedicated quirk to prevent binding to it.

As can be inferred directly or indirectly from the commit messages,
almost all of these devices are dual port devices which means that the
more recently added macro for matching on interface number can be used
instead (and some such devices do so already).

This avoids probing interfaces that will never be bound and cleans up
the match table somewhat.

Note that the JTAG quirk is kept for quad port devices, which would
otherwise require three match entries.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c |   72 ++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -606,10 +606,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
-	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLXM_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_TIAO_UMPA_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_NT_ORIONLXM_PID, 1) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLX_PLUS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORION_IO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONMX_PID) },
@@ -820,24 +818,17 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_ELSTER_UNICOM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_JTAGCABLEII_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_ISPCABLEIII_PID) },
-	{ USB_DEVICE(FTDI_VID, CYBER_CORTEX_AV_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, CYBER_CORTEX_AV_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(OLIMEX_VID, OLIMEX_ARM_USB_OCD_H_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(OLIMEX_VID, OLIMEX_ARM_USB_TINY_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(OLIMEX_VID, OLIMEX_ARM_USB_TINY_H_PID, 1) },
-	{ USB_DEVICE(FIC_VID, FIC_NEO1973_DEBUG_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, LMI_LM3S_DEVEL_BOARD_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FIC_VID, FIC_NEO1973_DEBUG_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_OOCDLINK_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_DEVEL_BOARD_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_TURTELIZER_PID, 1) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_SCU18) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
@@ -879,17 +870,14 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
 	{ USB_DEVICE(DE_VID, STB_PID) },
 	{ USB_DEVICE(DE_VID, WHT_PID) },
-	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(ADI_VID, ADI_GNICE_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ADI_VID, ADI_GNICEPLUS_PID, 1) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID,
 					USB_CLASS_VENDOR_SPEC,
 					USB_SUBCLASS_VENDOR_SPEC, 0x00) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ACTEL_VID, MICROSEMI_ARROW_SF2PLUS_BOARD_PID, 2) },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
-	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(MARVELL_VID, MARVELL_SHEEVAPLUG_PID, 1) },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
 	{ USB_DEVICE(FTDI_VID, PI_C865_PID) },
@@ -912,10 +900,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(PI_VID, PI_1016_PID) },
 	{ USB_DEVICE(KONDO_VID, KONDO_USB_SERIAL_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
-	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, TI_XDS100V2_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, MARVELL_OPENRD_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, TI_XDS100V2_PID, 1) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
@@ -924,18 +910,14 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_HD_RADIO_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_XM_RADIO_PID) },
-	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_ST_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SLITE_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH2_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, XVERVE_SIGNALYZER_ST_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, XVERVE_SIGNALYZER_SLITE_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, XVERVE_SIGNALYZER_SH2_PID, 1) },
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
 	{ USB_DEVICE(FTDI_VID, ACCESIO_COM4SM_PID) },
-	{ USB_DEVICE(IONICS_VID, IONICS_PLUGCOMPUTER_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(IONICS_VID, IONICS_PLUGCOMPUTER_PID, 1) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_24_MASTER_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_PC_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_USB_DMX_PID) },
@@ -950,15 +932,12 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(FTDI_VID, FTDI_CINTERION_MC55I_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_FHE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
-	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(ST_VID, ST_STMCLT_2232_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(ST_VID, ST_STMCLT_2232_PID, 1) },
 	{ USB_DEVICE(ST_VID, ST_STMCLT_4232_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
-	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID, 1) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
@@ -1033,8 +1012,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7561U_PID) },
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7563U_PID) },
 	{ USB_DEVICE(WICED_VID, WICED_USB20706V2_PID) },
-	{ USB_DEVICE(TI_VID, TI_CC3200_LAUNCHPAD_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(TI_VID, TI_CC3200_LAUNCHPAD_PID, 1) },
 	{ USB_DEVICE(CYPRESS_VID, CYPRESS_WICED_BT_USB_PID) },
 	{ USB_DEVICE(CYPRESS_VID, CYPRESS_WICED_WL_USB_PID) },
 	{ USB_DEVICE(AIRBUS_DS_VID, AIRBUS_DS_P8GR) },
@@ -1054,10 +1032,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
 	{ USB_DEVICE_INTERFACE_NUMBER(UBLOX_VID, UBLOX_EVK_M101_PID, 2) },
 	/* FreeCalypso USB adapters */
-	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_BUF_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_UNBUF_PID),
-		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_FALCONIA_JTAG_BUF_PID, 1) },
+	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_FALCONIA_JTAG_UNBUF_PID, 1) },
 	/* GMC devices */
 	{ USB_DEVICE(GMC_VID, GMC_Z216C_PID) },
 	/* Altera USB Blaster 3 */


