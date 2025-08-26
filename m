Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E27D352FE2;
	Tue, 26 Aug 2025 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219362; cv=none; b=rm71drM2HXb2V4E68ULvUGKgAZW9iY1NXkKD/KZXwnqJ3fe+V7G+ovaNcbTNIJSFNfgS3u3L5I5+udsfr+R2RB95r4I4IsmfSS1QlXuCNTT2BPxEeKp9wO/raR27zJSpO4WKLyiDSYzeZhYYY83DAW9Hp8iWTnR+sjUtlAYsLyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219362; c=relaxed/simple;
	bh=jSD+hVdZ2Gwa6KZHOTZR55gg69Up+ntj0uJnWO1TKhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQp8snE1Cs1waEWq18gpCjskFyPrISy8JJRF1ndoxi5sS/nQ6Nzru4JwOUfLd+xuKxELNXfGTx11jNyzZeCDQI5M55KWcQ4RwoK14oI5eBF/i0XRFV9K6e1D9bos85MUEeDd90WgY3vgk+yyHyOsTHY/RraGeZ2v4oEwRzcU9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DS0Q/0bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DS0Q/0bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1511C4CEF1;
	Tue, 26 Aug 2025 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219362;
	bh=jSD+hVdZ2Gwa6KZHOTZR55gg69Up+ntj0uJnWO1TKhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DS0Q/0bY0MkLbwoEaPtcGLhVdE+UMwkb33x6zPVaOvfQ61rs4scoRhDid4JipwHzn
	 IDaBWVx17EEMw7X6on4A3fJDN7cAUtU0eWUOHAtZUx6hzSFGVQxhTIIDrQecqEqvY4
	 4NcPPYhdYLtA63muHamFif/2mhLwbzCaVjj4tKmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zenm Chen <zenmchen@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 321/403] USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles
Date: Tue, 26 Aug 2025 13:10:47 +0200
Message-ID: <20250826110915.676680042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1490,6 +1490,28 @@ UNUSUAL_DEV( 0x0bc2, 0x3332, 0x0000, 0x9
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


