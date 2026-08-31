Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B7439F8F;
	Mon, 31 Aug 2026 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184590; cv=none; b=XDrzilTG6F0m/P/qR6YmJKO8zB13uqz4uUDreMVxFvUo49NxYYPcAVGLKmozoYXdQGMdzftBiyh2GAr5apYBQ7EoxhQLeMoEPm6zcMILaMbAn3xKopeAuvIDgOn5XMeNFwP/cFYYERB2GrSLh+ypF5o3NVO5XJxEQ/eiBiOA7xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184590; c=relaxed/simple;
	bh=9lxCRzzG2nAPoIWUlcDYCluAR5bpbkRDZRpF9Rxf/1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDJ+QsBzDkU3BiRGZfjGLjBYTeytLXlCtPs26cMNj9f4+V0MSX/RURu+boF6Gz4SI7etpsunGTgOPDStRBZuMsMH9E4LB3oyh3qZxhD++HycRY3e6rNPsp0kg+1CHC5AzSESpLbDP5+oOof+ogNS3aSddmQ/3kZScB825qQ4U8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1755p+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1755p+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE521F00A3D;
	Mon, 31 Aug 2026 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184589;
	bh=ZZWZ0B7hvGer/mHWv8NPcxa4O540p8YrkDr8G+1EMS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1755p+SNO6Jj9MUf1GPFiII5BLDl3ieend9o/ZSqoKvFkErFjrUTB2xeO9xOU/0T
	 YpisuAfkFzWURrXB3KIR46bqYH9YGiVm+fS7A7OYPO53k2E4r8/hfJi49UPwQyVwhl
	 UVgDWcez6vJaGcTrw3qcmc3RrAAYcTfj8InrT2SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Semih Baskan <strst.gs@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 59/91] usb: xhci: Handle USB3 port events when there is one roothub
Date: Mon, 31 Aug 2026 15:34:47 +0200
Message-ID: <20260831133402.797287004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Semih Baskan <strst.gs@gmail.com>

commit 3e91ec3e7d80a327fb558207613c80415d3bf756 upstream.

handle_port_status() drops every USB3 port event when xhci->shared_hcd is
NULL. The check dates from a time when xhci-plat always created a shared
hcd, so a NULL one could only mean the hcd had been removed.

Since commit 4736ebd7fcaf ("usb: host: xhci-plat: omit shared hcd if
either root hub has no ports") that is no longer true. A controller whose
USB2 root hub has no ports gets a single roothub, the USB3 rhub is served
by the main hcd, and shared_hcd stays NULL for the lifetime of the device.
Every SuperSpeed port event is then thrown away as bogus behind a debug
message, so devices never enumerate even though the port sees the device
and its change bits stay set:

  0x006a1203 Powered Connected Enabled Link:U0 PortSpeed:4
  Change: CSC WRC PRC PLC

Broadcom Northstar is such a controller. USB3 works there up to 5.15 and
stops working from 5.19 onwards.

Ask xhci_get_usb3_hcd() instead. It returns the shared hcd when there is
one, the main hcd when the USB2 root hub has no ports, and NULL once the
shared hcd is gone, which keeps the original meaning of the check.

Tested on an Asus RT-N18U (BCM47081), which has a single roothub. Before
the change nothing enumerates on the USB3 port; after it SuperSpeed
devices enumerate normally over repeated connect and disconnect cycles,
the change bits shown above clear, and USB2 is unaffected on both ports.

Fixes: 4736ebd7fcaf ("usb: host: xhci-plat: omit shared hcd if either root hub has no ports")
Cc: stable@vger.kernel.org
Signed-off-by: Semih Baskan <strst.gs@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-17-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2010,7 +2010,7 @@ static void handle_port_status(struct xh
 	}
 
 	/* We might get interrupts after shared_hcd is removed */
-	if (port->rhub == &xhci->usb3_rhub && xhci->shared_hcd == NULL) {
+	if (port->rhub == &xhci->usb3_rhub && xhci_get_usb3_hcd(xhci) == NULL) {
 		xhci_dbg(xhci, "ignore port event for removed USB3 hcd\n");
 		bogus_port_status = true;
 		goto cleanup;


