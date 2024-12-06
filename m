Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46603B2BB;
	Fri,  6 Dec 2024 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498160; cv=none; b=filJV8NcWLFp3bMUHLfKxyAcE2Lg7KrZOc/8MMR7jyDn8bf5Oussticwi1tD0BMxVn62YwIEg1hi7YI9Dl0h7Kob0hkGfWe7XJCPRENaDRIe42vCuVuJmAEF1mZzYOo+DtE71vgkV50d9D8XqW8yZYTpXw8TCqfKUBhYm9k7k0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498160; c=relaxed/simple;
	bh=077Aw0qBpaVAlEWHqNnszd0R5VIVTKhDzbZGhWfuow0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvd50/zl45Z/lxHMbQgwViOtD6st8tkaco3CgImFhWg/6xeYwTDp+hrfbHSGt+dZF4rNXxjVFCgBuAom8kWNSe+pT8kaWbQCBkYf7ANctmxPooDIdcuyjaeKDJ8km084Ta8e1mm0krtUOEV/i23RoKIyoOqwIAueGMEMifwPSIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rzd+U5+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rzd+U5+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C122CC4CEDC;
	Fri,  6 Dec 2024 15:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498160;
	bh=077Aw0qBpaVAlEWHqNnszd0R5VIVTKhDzbZGhWfuow0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rzd+U5+CxR9BA1PbmK8TxH1mNxWKu7gttCwdPS079t8pHt12kJ4fDdWpNrQUw/rr3
	 UbZ4WOw5Bqb6GH6HqtEvoYSwcDDagSpdh7+zO4rXz5E0WX2k8z1SQn9iogWl1FzFyt
	 s4hqzgM+J97X48A9iM6eV0mnQa9atk5IxjZh6HFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Vrastil <michal.vrastil@hidglobal.com>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Peter korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.6 502/676] Revert "usb: gadget: composite: fix OS descriptors w_value logic"
Date: Fri,  6 Dec 2024 15:35:21 +0100
Message-ID: <20241206143712.965237758@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michal Vrastil <michal.vrastil@hidglobal.com>

commit 51cdd69d6a857f527d6d0697a2e1f0fa8bca1005 upstream.

This reverts commit ec6ce7075ef879b91a8710829016005dc8170f17.

Fix installation of WinUSB driver using OS descriptors. Without the
fix the drivers are not installed correctly and the property
'DeviceInterfaceGUID' is missing on host side.

The original change was based on the assumption that the interface
number is in the high byte of wValue but it is in the low byte,
instead. Unfortunately, the fix is based on MS documentation which is
also wrong.

The actual USB request for OS descriptors (using USB analyzer) looks
like:

Offset  0   1   2   3   4   5   6   7
0x000   C1  A1  02  00  05  00  0A  00

C1: bmRequestType (device to host, vendor, interface)
A1: nas magic number
0002: wValue (2: nas interface)
0005: wIndex (5: get extended property i.e. nas interface GUID)
008E: wLength (142)

The fix was tested on Windows 10 and Windows 11.

Cc: stable@vger.kernel.org
Fixes: ec6ce7075ef8 ("usb: gadget: composite: fix OS descriptors w_value logic")
Signed-off-by: Michal Vrastil <michal.vrastil@hidglobal.com>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Acked-by: Peter korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/20241113235433.20244-1-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2111,8 +2111,20 @@ unknown:
 			memset(buf, 0, w_length);
 			buf[5] = 0x01;
 			switch (ctrl->bRequestType & USB_RECIP_MASK) {
+			/*
+			 * The Microsoft CompatID OS Descriptor Spec(w_index = 0x4) and
+			 * Extended Prop OS Desc Spec(w_index = 0x5) state that the
+			 * HighByte of wValue is the InterfaceNumber and the LowByte is
+			 * the PageNumber. This high/low byte ordering is incorrectly
+			 * documented in the Spec. USB analyzer output on the below
+			 * request packets show the high/low byte inverted i.e LowByte
+			 * is the InterfaceNumber and the HighByte is the PageNumber.
+			 * Since we dont support >64KB CompatID/ExtendedProp descriptors,
+			 * PageNumber is set to 0. Hence verify that the HighByte is 0
+			 * for below two cases.
+			 */
 			case USB_RECIP_DEVICE:
-				if (w_index != 0x4 || (w_value & 0xff))
+				if (w_index != 0x4 || (w_value >> 8))
 					break;
 				buf[6] = w_index;
 				/* Number of ext compat interfaces */
@@ -2128,9 +2140,9 @@ unknown:
 				}
 				break;
 			case USB_RECIP_INTERFACE:
-				if (w_index != 0x5 || (w_value & 0xff))
+				if (w_index != 0x5 || (w_value >> 8))
 					break;
-				interface = w_value >> 8;
+				interface = w_value & 0xFF;
 				if (interface >= MAX_CONFIG_INTERFACES ||
 				    !os_desc_cfg->interface[interface])
 					break;


