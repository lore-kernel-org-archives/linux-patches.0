Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41B74A92E8;
	Mon, 31 Aug 2026 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184951; cv=none; b=nzbDwfuhnFrVGNnNe2o+5fQiO497nf1OOK7CTMTORfhLGyukIZfB0MYsdwLf1IjDN0Tw6Bappen0oOW73j/32fw6HHJGOtosukFKGCDKsUktLECQf5uH7uXqiHddUAXV3MA7qLR9+plX2V6WILd3SAII7VXlApf3rsnC4NqgSDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184951; c=relaxed/simple;
	bh=t60dfad6jus/XPIFfoeVwUbcOu7Xzb1+xBXGLOLRc50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDrBQMsPryiwH9NESrjpa0fokNDw4jIhoESqHrXtO4kfvHwr2nRMzNQTWXtjquVOs3sSWucjaHdWvz2nfLmxVBjlWS5YzT8qJwF3UiNWOtRidy7Q9XR4rVMqafO6C6wG0ANt1eq4wAINc8RuMwH7w5wSr4vjkBM50+Oe7XTpn00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5eU/gEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5eU/gEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B15A1F000E9;
	Mon, 31 Aug 2026 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184950;
	bh=xpiafOH+OvjxcZhQfkGHqlIMDHqrud5KfjCS23z5G4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5eU/gEgHqU4FqVpidYYkJz1eKle+cg10fFOycyMRuzKzsu4YwgytNoLO/XvBfpLv
	 2ahxzU5GEJgpqVLfItI8QLyYaI/liiBewdJMgCnVSvLk5Un9uSJlFcPcUFatr8IVDV
	 3SOQx0zFxpt69RQGwf4n+CQ9eXjkRQAgeAnRnN8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Semih Baskan <strst.gs@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 64/92] usb: xhci: Handle USB3 port events when there is one roothub
Date: Mon, 31 Aug 2026 15:35:02 +0200
Message-ID: <20260831133402.978217559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
@@ -1965,7 +1965,7 @@ static void handle_port_status(struct xh
 	}
 
 	/* We might get interrupts after shared_hcd is removed */
-	if (port->rhub == &xhci->usb3_rhub && xhci->shared_hcd == NULL) {
+	if (port->rhub == &xhci->usb3_rhub && xhci_get_usb3_hcd(xhci) == NULL) {
 		xhci_dbg(xhci, "ignore port event for removed USB3 hcd\n");
 		bogus_port_status = true;
 		goto cleanup;


