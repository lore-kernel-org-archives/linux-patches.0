Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D083446055;
	Thu, 30 Jul 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425573; cv=none; b=Om2vQTu+purhl+HbgRXj1qZiIUci7NMFoFNzRDHaUNlElU2olS8kTocPOaSbYCVigph74fOPiVyy9Ih8wG4XWZ1bnkx7Ko6q8CdKWQUeUY6ly/WT2XWFFUmA07ln4WbSvrCHPmhdbjBoc2tmLDIjzAyJCbBL00TXYA8T6ov8f5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425573; c=relaxed/simple;
	bh=Y9Et4A0Kz/GkD19kvMqUYo+Up8uYqHAqYbvTC1eWEg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbgWGNaNl21+SWQ+VXyvx7fPZNdAuTUQh75W4vbajtQsyrDZRJs90CWSaKshrkiLr9+apdeDNS+RVZPK5ECeQ4VflgZc8axL0hPBKIovcCks2G2eUu8E3XBB5qfFuA8vuHdBqXhPRRmhEuyuLKRNM1tDYE69iX0sJ6zgIvMF3Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6KEeZGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6KEeZGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF171F00A3A;
	Thu, 30 Jul 2026 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425572;
	bh=aTVoTfClVCSQ3RSRQj/dc6dNdX6DuWwkCnvneuH90Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6KEeZGAnxrgFZnNYpNEWeNzFXYzgtjo4S1K9fNeR6MX+mKTmJpYVfAtRkZvYhw7x
	 IHLhsfykeGW4NzpofzhiO1Cli1MUjBxCHa7rqEAjWOhJI7eoAK0br7WorJvScScE9r
	 byX3bLqceiinPgJJZbyvZ9JDG04fyzvK7xc9foj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	stable <stable@kernel.org>,
	Huang Wei <huangwei@kylinos.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 116/602] USB: storage: add NO_ATA_1X quirk for Longmai USB Key
Date: Thu, 30 Jul 2026 16:08:28 +0200
Message-ID: <20260730141438.426363263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


