Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF5B285061;
	Mon, 17 Aug 2026 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975492; cv=none; b=nASgYSYzvwZNHvsVtL1cKIIvmCgzRfQa0L+Tp5dvDDjrmbRbfiP9TacDxcZx4BvHoMECTEkZWip8Vrt57tK+u4q0WBtvGaBZfwuShp4cpykTTAjJSbEG4IdLEeyv+1Rc1yODVcU8jirnl1F8s6dRg4tiH7Z5oBW92szGGPMFnb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975492; c=relaxed/simple;
	bh=yOp5J6RSpQH4gO8sQykqG/j+EVXiH7JZKZFrLTJ3Dtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBGImmGIMXOht9Tja7Yfk+PJ8lKTMlGpkaR5YnFC2JbZeO+UwwJgT+Cs2myTIIvEMeYFwrtcRMDbVB1SLqj9UY1TOi8IBCPuZj0Wsn9KX0vuzB2plMthsk2QJviTcV/yqP2EQ8kUzA0qmB8efm8vb129hssWFOhglnQjayFbtfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iueewkHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iueewkHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3E71F000E9;
	Mon, 17 Aug 2026 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975490;
	bh=YT6e/J9pyQajfLUqiN2AryZcGlxDsONGufKM7xfc9x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iueewkHIuAqyTMAqG1PqQo0d8H7VS6rrFwKnokxPaCzbmyWcffBWM9mczwSQJuxRT
	 Ij7Bfu0g+SnwgBvlnlYEXZUqbCIMAOSlBwgGtoLLPg8AaS68XraDqnxDhZDIVcbdRD
	 EGAWHl3/ruyBq/bo5lRhV8r9j+5+yc3hZctkk1DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	stable <stable@kernel.org>,
	Huang Wei <huangwei@kylinos.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 046/389] USB: storage: add NO_ATA_1X quirk for Longmai USB Key
Date: Mon, 17 Aug 2026 15:28:05 +0200
Message-ID: <20260817132540.803367486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Huang Wei <huangwei@kylinos.cn>

commit 3b4ca2e01c1dd8c00b675b794732945f460a471b upstream.

The Longmai Technologies USB Key (0x04b4:0xb708) advertises itself as a
SCSI/Bulk-only mass storage device but does not correctly handle ATA
pass-through commands. When such a command (ATA_12 or ATA_16) is sent to
the device it fails to respond and the transfer eventually times out,
leaving the device unusable.

Add an unusual_devs entry for this device that sets the US_FL_NO_ATA_1X
flag, so usb-storage short-circuits ATA pass-through commands and returns
INVALID COMMAND OPERATION CODE (0x20 0x05 0x24 0x00) instead of forwarding
them to the device.

Information about the device in /sys/kernel/debug/usb/devices:

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 12 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=06 Prot=50 MxPS=64 #Cfgs=  1
P:  Vendor=04b4 ProdID=b708 Rev= 1.00
S:  Manufacturer=Longmai Technologies
S:  Product=USB Key
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Reported-by: Ai Chao <aichao@kylinos.cn>
Cc: stable <stable@kernel.org>
Signed-off-by: Huang Wei <huangwei@kylinos.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260716033341.2830872-1-huangwei@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -395,6 +395,13 @@ UNUSUAL_DEV(  0x04b3, 0x4001, 0x0110, 0x
 		USB_SC_DEVICE, USB_PR_CB, NULL,
 		US_FL_MAX_SECTORS_MIN),
 
+/* Reported by Ai Chao <aichao@kylinos.cn> */
+UNUSUAL_DEV(  0x04b4, 0xb708, 0x0000, 0xffff,
+		"Longmai Technologies",
+		"USB Key",
+		USB_SC_SCSI, USB_PR_BULK, NULL,
+		US_FL_NO_ATA_1X),
+
 /*
  * Reported by Simon Levitt <simon@whattf.com>
  * This entry needs Sub and Proto fields


