Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3732AF1D;
	Sun,  7 Jun 2026 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829235; cv=none; b=Hh9gcDJ8RDVG2CV2iSgnIsSHZrHn9SGaqNDxaYj08o79vL7aStaVmly9tSkqT9CVDVjCSAsX+jnEEHbXrtoynXQNTUu2O6/bZDBPl+k8JMkdAgGRv25OHGWoBMccmrzhoXD/MzawFY7gPPDpZT6hF95JdE73V9lXKTfnhvIpXPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829235; c=relaxed/simple;
	bh=tJOJx3rlJnP6Tlm9b+T1RZtfZFiGBOl7SG79BfU8UAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0LgFQB2egrSQONuUazmSNt7m2FjZzffpXwOd0miRrITCCvYNDoMUWtwfqZTyZxIPq4joI8nwNMuvIfnGsZVu4T2J+aTARSyaYdxtCt7Jhdc/Co6C8y250RWzKbz+sm4fpfAbIwsJv3fnToRuajwGIvi6RcXeg8hgKr+nXdhFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xztGLJL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xztGLJL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4F81F00893;
	Sun,  7 Jun 2026 10:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829234;
	bh=ShcGgJGtoaqtL/NAGr8IN955bobj+dYh5wG3a0JYSfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xztGLJL58w8kLjHT0mM9KvtHKRxrTjPsMX2eEYWwGxNbxS0IOjGNQ3vra8A8PrPFs
	 0DOqa5kLeBB65Uiiy5Nkt7aAxEl8KmMQYf+Ow/O6djmIfETUkwK9UaTX16LvidDIlW
	 AEgFbBcfpZavprI5CJ9FgI3gNWokrHM0b/gXwWQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Burkels <sam@1a38.nl>,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 256/332] usb: storage: Add quirks for PNY Elite Portable SSD
Date: Sun,  7 Jun 2026 12:00:25 +0200
Message-ID: <20260607095737.447850393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


