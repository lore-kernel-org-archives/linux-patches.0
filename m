Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A73DEACB;
	Mon,  4 May 2026 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903673; cv=none; b=LLo0K2efyAn7TtehoVUnXwvtIB1roFYYvTEI/NAPZVkuxXPHEmJv1huOniO6H6lemMDzfdtbtboZ0G+fsJH61IOp068/OOnVAJztp6inY/HaBtosOQzwFor77WnPvGhyu/CdIMlx+luFM4da+UUjd2ei1OPH47H6Bo5w2/WkP3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903673; c=relaxed/simple;
	bh=J4Y4hXCluyAxgdUioJ5vwvSh0Ht3LT5pPV+9kg57g3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM7WX/+VAqYa0qjkOUjByQKUa0rLUJqeMax+7I3oOVfzTaxbHltazS9C85xEZPgqQGfcJVx5HUr/dCX0QqTmQ7ayvZFv2RktqmBiymWGKYv69+pG0TwgckBoyn0L7+mC7AJimAdThs9r9zcaYZXCSJXxHXtW27Z1EHJVFoBUwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8I7Jv52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8I7Jv52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AE3C2BCB8;
	Mon,  4 May 2026 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903672;
	bh=J4Y4hXCluyAxgdUioJ5vwvSh0Ht3LT5pPV+9kg57g3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8I7Jv52N7KpeXm81rCkqHhyVS5/ibeZVP8xp292bNL5xHJnhkzp+xYEdVgi/FWf+
	 1a5BlE1IzIfOTB4qfbULLNNa0QB3wRSfHhyQoBWYj1FioUa0g1QBocGJ2v+eYcIMHC
	 jMvvbrv7UbOe3oSjfl3tuEADtNtz0kpqXb/vGKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 004/275] usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()
Date: Mon,  4 May 2026 15:49:04 +0200
Message-ID: <20260504135143.098994818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 25e531b422dc2ac90cdae3b6e74b5cdeb081440d upstream.

xHCI hardware maintains its endpoint state between add_endpoint()
and drop_endpoint() calls followed by successful check_bandwidth().
So does the driver.

Core may call endpoint_disable() during xHCI endpoint life, so don't
clear host_ep->hcpriv then, because this breaks endpoint_reset().

If a driver calls usb_set_interface(), submits URBs which make host
sequence state non-zero and calls usb_clear_halt(), the device clears
its sequence state but xhci_endpoint_reset() bails out. The next URB
malfunctions: USB2 loses one packet, USB3 gets Transaction Error or
may not complete at all on some (buggy?) HCs from ASMedia and AMD.
This is triggered by uvcvideo on bulk video devices.

The code was copied from ehci_endpoint_disable() but it isn't needed
here - hcpriv should only be NULL on emulated root hub endpoints.
It might prevent resetting and inadvertently enabling a disabled and
dropped endpoint, but core shouldn't try to reset dropped endpoints.

Document xhci requirements regarding hcpriv. They are currently met.

Fixes: 18b74067ac78 ("xhci: Fix use-after-free regression in xhci clear hub TT implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260402131342.2628648-26-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    1 -
 include/linux/usb.h     |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3278,7 +3278,6 @@ rescan:
 		xhci_dbg(xhci, "endpoint disable with ep_state 0x%x\n",
 			 ep->ep_state);
 done:
-	host_ep->hcpriv = NULL;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -55,7 +55,8 @@ struct ep_device;
  * @eusb2_isoc_ep_comp: eUSB2 isoc companion descriptor for this endpoint
  * @urb_list: urbs queued to this endpoint; maintained by usbcore
  * @hcpriv: for use by HCD; typically holds hardware dma queue head (QH)
- *	with one or more transfer descriptors (TDs) per urb
+ *	with one or more transfer descriptors (TDs) per urb; must be preserved
+ *	by core while BW is allocated for the endpoint
  * @ep_dev: ep_device for sysfs info
  * @extra: descriptors following this endpoint in the configuration
  * @extralen: how many bytes of "extra" are valid


