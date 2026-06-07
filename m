Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF22DFF04;
	Sun,  7 Jun 2026 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829368; cv=none; b=K9o1O+6kS7rx/a0Z8XDigX6ZGkn/asea3xaKtFuQr7xJ8Ik8kRZaGaoPRHTG07a/kTnZBO3nw7A1xaGNur6POrdrAHng7B7Er+L6z0wWUiXqHu9EhMhdHQRRvkLV8Jq2a07esImZOnC1VOko5dsMZbdpguIEnQJuc+vmkNDo8tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829368; c=relaxed/simple;
	bh=xMWgCxGLe7zxNnXltd9TMc6uY676QprFK8elW/Z7Gq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR2v7sY8MUhSOePLLkSFPAIVkoQYdPhf/lZCCLyPcVvIMUJTCdSCqXfE3QulSQnMBlqX9fA09921BFemMyHgHYj3f45m3bJZFrQZXnBukDn6UM6yoHzEiblCwpL7cCmf/ecBr9bWqW5lA0AVLskgmCkaQ0QbqH2s3eYbY7cUIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN75zdig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN75zdig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333AB1F00893;
	Sun,  7 Jun 2026 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829367;
	bh=zbsbscQCHGyuSihXNXWfMe04w0eJMM7k1iIcX7QUats=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SN75zdigWDSzC0VJCBEzgCZi8HnmK2J5H4KgrFVR3Wm0atQPgJdlNXAmdg9IYPrcA
	 VC1UvhTig67wBdP2/L1SmtgjmDi2WsOF8RMFZeZVDxSUkMk5cuab1IkuyHc+cJkka3
	 zbYQjs5y5tEECrqcKRaO8qCbFgI5Mi1oXAIRhP0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Burkels <sam@1a38.nl>,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 218/307] usb: storage: Add quirks for PNY Elite Portable SSD
Date: Sun,  7 Jun 2026 12:00:15 +0200
Message-ID: <20260607095735.723636562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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


