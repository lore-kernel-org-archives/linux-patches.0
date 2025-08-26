Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959D3451AA;
	Tue, 26 Aug 2025 11:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207869; cv=none; b=IhcGR9LMXtE0A2ts1O4Mv4vzYsjvcTfNL+x8ByQ5dyl8Wy8XbsXK9JXL3dx19vJ888+eS1zeqLqCXyGFpgkPPKT7bimRll63jQEB1dxaYY2xyRecOgbksFuFOcUwvODTs4tnK9PkqQk2Ij2Lh7xo9y+80EpeQBq2e+JXI03IeuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207869; c=relaxed/simple;
	bh=+BFQWOvGtPBwo4SG53yU1cO3oG7P0QaEtpA4tWgI1CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+oVpdOlpI//sxj+CwzvALm56pmgP6XTa71e89ZkUHbP4xZdUoVdG+QcrtsC9+BK+UhSJhag+M2qxmQygyn+E342kAmZk4i56CR+ytXuQ4IwUffQ+8GY1a7tVdyREWJjaRGUIF2m9KShKfnkfI8nj0RjMvN4G6g0lfDBTWIvGLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFo+si1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFo+si1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B118C4CEF1;
	Tue, 26 Aug 2025 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207869;
	bh=+BFQWOvGtPBwo4SG53yU1cO3oG7P0QaEtpA4tWgI1CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFo+si1Fb+bhs78qbaYlpgAnNt1PU0AwHa6wW8qqUzhRvXTVEpTaexpm3jy97pgtZ
	 FzhUvOvRmQbYMfTHHQUmEW47NlRJqMrKLJTON9tWTFav1WjjI7s9EFD056rqUOs551
	 Cv1YdHNCfzTsH4lVocy35AX0RBKbARqMgbKOrX+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zenm Chen <zenmchen@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.16 318/457] USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles
Date: Tue, 26 Aug 2025 13:10:02 +0200
Message-ID: <20250826110945.212660517@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

commit a3dc32c635bae0ae569f489e00de0e8f015bfc25 upstream.

Many Realtek USB Wi-Fi dongles released in recent years have two modes:
one is driver CD mode which has Windows driver onboard, another one is
Wi-Fi mode. Add the US_FL_IGNORE_DEVICE quirk for these multi-mode devices.
Otherwise, usb_modeswitch may fail to switch them to Wi-Fi mode.

Currently there are only two USB IDs known to be used by these multi-mode
Wi-Fi dongles: 0bda:1a2b and 0bda:a192.

Information about Mercury MW310UH in /sys/kernel/debug/usb/devices.
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 12 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=a192 Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=DISK
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=(none)
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Information about D-Link AX9U rev. A1 in /sys/kernel/debug/usb/devices.
T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#= 55 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=1a2b Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=DISK
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=(none)
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Cc: stable <stable@kernel.org>
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250813162415.2630-1-zenmchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1501,6 +1501,28 @@ UNUSUAL_DEV( 0x0bc2, 0x3332, 0x0000, 0x9
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_WP_DETECT ),
 
+/*
+ * Reported by Zenm Chen <zenmchen@gmail.com>
+ * Ignore driver CD mode, otherwise usb_modeswitch may fail to switch
+ * the device into Wi-Fi mode.
+ */
+UNUSUAL_DEV( 0x0bda, 0x1a2b, 0x0000, 0xffff,
+		"Realtek",
+		"DISK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE ),
+
+/*
+ * Reported by Zenm Chen <zenmchen@gmail.com>
+ * Ignore driver CD mode, otherwise usb_modeswitch may fail to switch
+ * the device into Wi-Fi mode.
+ */
+UNUSUAL_DEV( 0x0bda, 0xa192, 0x0000, 0xffff,
+		"Realtek",
+		"DISK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE ),
+
 UNUSUAL_DEV(  0x0d49, 0x7310, 0x0000, 0x9999,
 		"Maxtor",
 		"USB to SATA",


