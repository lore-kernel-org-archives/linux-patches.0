Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759232ED55;
	Tue, 16 Jun 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631043; cv=none; b=ANpGNjF5y6SA3QHUqhMLZRyB1cbBeyIb0bleoenh1az2pfKMJ4wUfrn5nOWB8EYY4w7Zz7Y4phlIqf8Uk/31rL9Md9e2/wQA7G2d7Zo4X8TX9ZXP0gtrH4YD8DiuwxqDFK8T5Dbk4RhLheQvmDfpj4PrKLRBnlJa/+K2hUZV6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631043; c=relaxed/simple;
	bh=1zpMhg61DwNIiQil9sF6tTPyjmBOChSuHM1TtGOl96o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crzcH+P/K+9ylR7cRNbUnFLXEPQHV8cj2ZfNAkiXgSOGq/B8m3SXYNR6ymBqcsFZM575WevLi97sEDXsJ0g0/kf31nAldjnK3KBAZMLTUiTms1BwFdvm1jLBLAGovpSDqNt4UIiZ6+ptVZMo//6ssAp5YuOQRrwPxBd5QHskhJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B05czxBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B05czxBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C81F000E9;
	Tue, 16 Jun 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631042;
	bh=DNTbtxKJCs6wLjVb5oJJpCD6PD3J5eysrz5akQpcQ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B05czxBJKyMAyRkangikIwkAH7XvXPH3U6IiQUFjiOJ7fua+vkhSzGLeUeYK63PwT
	 YCERiF1QG0dPNHHWwKS0H5ezDeroBG7ls6/J6zV6wH9mX5Jul80cNFezLu+sQYLqxK
	 jdoMaAmzyIzZwHyEQtcn8yXlVCb0IfUHhD/BvJXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Burkels <sam@1a38.nl>,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 146/522] usb: storage: Add quirks for PNY Elite Portable SSD
Date: Tue, 16 Jun 2026 20:24:53 +0530
Message-ID: <20260616145132.924183783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Sam Burkels <sam@1a38.nl>

commit b53ebb811e00be50a779ce4e7aee604178b4a825 upstream.

The PNY Elite Portable SSD (USB ID 154b:f009) is a sibling of the
already-quirked PNY Pro Elite SSDs (154b:f00b and 154b:f00d). Like its
siblings, it uses a Phison-based USB-SATA bridge that exhibits
firmware bugs when bound to the uas driver.

Without quirks, the device fails to complete READ CAPACITY commands
when accessed over UAS on a SuperSpeed (USB 3) port. The device
enumerates and reports as a SCSI direct-access device, but reports
zero logical blocks and never finishes spin-up:

    usb 2-3: new SuperSpeed USB device number 8 using xhci_hcd
    usb 2-3: New USB device found, idVendor=154b, idProduct=f009
    usb 2-3: Product: PNY ELITE PSSD
    usb 2-3: Manufacturer: PNY
    scsi host0: uas
    scsi 0:0:0:0: Direct-Access     PNY      PNY ELITE PSSD   0
    sd 0:0:0:0: [sda] Spinning up disk...
    [...10+ seconds of polling, no progress...]
    sd 0:0:0:0: [sda] Read Capacity(16) failed: hostbyte=DID_ERROR
    sd 0:0:0:0: [sda] Read Capacity(10) failed: hostbyte=DID_ERROR
    sd 0:0:0:0: [sda] 0 512-byte logical blocks: (0 B/0 B)

Tested each individual quirk to find the minimum that fixes this:
  - US_FL_NO_ATA_1X alone: device hangs on spin-up
  - US_FL_NO_REPORT_OPCODES alone: works on USB 2.0, hangs on USB 3.0
  - US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES: works on both

With both quirks the device enumerates correctly while still using
the uas driver, and delivers full UAS throughput (~281 MB/s
sequential read on a USB 3.0 Gen 1 port).

The existing PNY Pro Elite entries (f00b, f00d) only set NO_ATA_1X,
but this device additionally chokes on REPORT OPCODES under
SuperSpeed.

Signed-off-by: Sam Burkels <sam@1a38.nl>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260501132346.86572-1-sam@1a38.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -132,6 +132,13 @@ UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES),
 
+/* Reported-by: Sam Burkels <sam@1a38.nl> */
+UNUSUAL_DEV(0x154b, 0xf009, 0x0000, 0x9999,
+		"PNY",
+		"PNY ELITE PSSD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",


