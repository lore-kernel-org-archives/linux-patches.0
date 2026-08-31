Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67D4F7999;
	Mon, 31 Aug 2026 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183570; cv=none; b=TydxuTJ1oFlBXhGq57Chxus7QPjfmuCnSR5mQVMuOw30LLkMZbUPZz1LZQhwhhUid6YVfxL3dr1KXSPF14qRCC7mKdCj84vcxON9NKBBavGxYL/yq028InM6iESlbx63xHtKaqTs52HZ5SBeIkcWbvc/+MfI0pEj3slbQ6gRjp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183570; c=relaxed/simple;
	bh=KKFxXpdsXhLmOa/ks+BulJ/ujFT0o2EcERJiuuFHSc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWeXreIAEp1BGHeg0QQx8PcIPYQJm7saxH6d9N7Ss31Qo6F+jUUZ8YmXxAZogCqpym+dXnCbJWh5RmixsOiU/+763mxAyxo+aE0dSuksOWL0lhbLT500nFI1BNxCnFF5/BIJPVsqWbC7yc9jnBKj3umLm9Z06RHk3tJDQIN3gZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mO87ohoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mO87ohoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0CE1F000E9;
	Mon, 31 Aug 2026 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183569;
	bh=fjTYq2ns3b+JwHZEPQ2Z9JFNd1ALs8N1LASygPyfk6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mO87ohoLwVrk+fRvn5uxHFTgqfJNiXqH8e+N4PKaAEHmrJ86XuRbsMzl1omNrszE1
	 aXEFnyXRevEb+bugEgmJiqEJmgWQrUarK7PqSYYFPRXdz00s9uC7OFa9Wcnk5UvVJP
	 9T7F11QS46HjJXAi2H2XA59jhd3f7c8pJl83ggGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Semih Baskan <strst.gs@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.2 08/71] usb: xhci: Handle USB3 port events when there is one roothub
Date: Mon, 31 Aug 2026 15:33:33 +0200
Message-ID: <20260831133359.420694320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2025,7 +2025,7 @@ static void handle_port_status(struct xh
 		vdev = xhci->devs[port->slot_id];
 
 	/* We might get interrupts after shared_hcd is removed */
-	if (port->rhub == &xhci->usb3_rhub && xhci->shared_hcd == NULL) {
+	if (port->rhub == &xhci->usb3_rhub && xhci_get_usb3_hcd(xhci) == NULL) {
 		xhci_dbg(xhci, "ignore port event for removed USB3 hcd\n");
 		bogus_port_status = true;
 		goto cleanup;


