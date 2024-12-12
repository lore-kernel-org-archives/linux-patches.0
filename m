Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF7E211A34;
	Thu, 12 Dec 2024 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020166; cv=none; b=h2OWgnnvOQHX4HhpYi9Y/8VtGW8QR8B0rs3OhrwNvyQH4w0RY9//yM7F+G1Ji+bgFM+8DdxM34BgoyOTeZ5cVZxiGCgki8wzT0IkdnZm2485OXzkxov+qBQW/2UgXx6ouCI1t4+Fc4DJWuj5lHl8dZOkXcA5xd7VYOd1WWErSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020166; c=relaxed/simple;
	bh=HR6ZDmIPKxVSdCw7CAGdg7IQxYmmfcCua6qkd+C57+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=craYDBZX3F20SVCCzgCZIhP1nO/7WSo0P+qpmkNOJoutWpjMKMQ/qtlRQjOctiMwL/xiptbGo7hIUnW1nbJ4OyMBbk+V9KRMlAvfooSGn+RaMTpJ6vGQE7lDATrKd5E6/U0B6Cla0E+IxBw+oM7rFDVBWazvoaHgRQLt4ycosNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVVAy27i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVVAy27i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9678C4CECE;
	Thu, 12 Dec 2024 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020166;
	bh=HR6ZDmIPKxVSdCw7CAGdg7IQxYmmfcCua6qkd+C57+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVVAy27iWJDVmsGQziKS7/OcI8wEmTG3GyH0TpjbN8flY7JzZho6sIeTdHil3KsrJ
	 qW9uxYhNtgeFpfuDRyAENteUICZIGLdEhZMy4oHgsd7PhxzXHN6EUdphi6b7ui7VZ1
	 ZL8w5Fql8z7HtBj2mRp8TGefpn5AaNrDamhfYvgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Vrastil <michal.vrastil@hidglobal.com>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Peter korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.1 387/772] Revert "usb: gadget: composite: fix OS descriptors w_value logic"
Date: Thu, 12 Dec 2024 15:55:32 +0100
Message-ID: <20241212144405.901770934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2032,8 +2032,20 @@ unknown:
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
@@ -2049,9 +2061,9 @@ unknown:
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


