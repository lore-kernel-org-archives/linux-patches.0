Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA722C11DE;
	Mon, 17 Aug 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979114; cv=none; b=tqnFnplKoAYY62YzBpWD6ekddreXQzLduoWNiuwMY09haJVhC4b+X22xG8GRG1jVxl6JKaPWFZGcChpnNIgQ+i7Zrv8mOMQdJMfc+jJQATUq4tFtdMZFb1fTP9nGw4fx/bCGOYPGsNo90jRiVYJ0nX+1MkqJKSYIdvmpGand7no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979114; c=relaxed/simple;
	bh=gsW1dLDpx6BiASbQo6fJQ0GAaIgeYm/pdd8Ef0Q/vf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBQgLJHNPQgq9kxkMpHED8+IANRk6bfdPah6PocsOqdt1b+CgmrNtUXnblJ9ziZ/YA1+yafdRb2y0mq5q9wEO3rxrlmv9Vc1VfAWxqajBhBcWFBng9Z+s70T1z5RL6+KMe/bbcIh9MEN3g5OibR/cKqQAmHU/4dJG1oDKmRvCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOt5sphU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOt5sphU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECDC1F000E9;
	Mon, 17 Aug 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979112;
	bh=G9UyWupSYICVEoPLQZw32Kxp+z3KrmgheioCP8oH3r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOt5sphUYy+dd/oFx0CkxUlgLGMVsOMYEGxBvUYZ/LEd7AfWzDa7mI8SovmYJGEyh
	 SnC0qD6+DBSQWyUwbwrWlX/9FBbaVhlM02xGAjCOjCN1LuLa0+nWfbZIF32FuXCVlV
	 bclc0/xG9AMkJJtsbLkvUN2mWiwkcjiowYzbW/2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	stable <stable@kernel.org>,
	Huang Wei <huangwei@kylinos.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 074/609] USB: storage: add NO_ATA_1X quirk for Longmai USB Key
Date: Mon, 17 Aug 2026 15:26:10 +0200
Message-ID: <20260817132545.993554173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


