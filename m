Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5554A32BF24;
	Sat, 30 May 2026 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163193; cv=none; b=K+kcpdTdMjZoNoV5Qe09ZvR4vN2xRh2G7kYBsaYk3SdY1TFEmvEwV17zGanT6Up4UArja3NFWa2H86AzS9XocW3wz20fwI9U9IaT67mvAPitqOvwis4pG2pavvpQ69YY4cp/562rSCTmnTVAyzfvJsjP49gVvKEGPdUsPplbCVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163193; c=relaxed/simple;
	bh=kYHgJ3fSEhuv3voU21bCaXkiXiZA0MYN8J1fl+lSuRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV6dpjhT1vmQTQQCg0kbtrSXm4S2Wbttf/Bc5qykHTugywIHmZfdNrXo0AZNXyWmlDhb8i1WcTCtzXY4MJmlRYuxdqzNhvbH5taiLkXonguuDXDtdlw2YFNIuyYat3cwKL3uSIhsszBkXQYCyFgapJCEApQXbA/DZP1l+dM5aHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9OGoOgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9OGoOgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCC51F00893;
	Sat, 30 May 2026 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163192;
	bh=BX3O1mFErEhRVNsDXPbJO/+twTt+MD+9+Yl7nqRTh8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9OGoOgFOJZHGIgv4QNNgpoSxDKZ6V5L71il5sZwr4s/lC1yaAjJ4MFAH7J8m70fO
	 DsqN8SCQ5j+RdqqFSmbIR1tbmrG88/bRLqe/1rSLK7HEXDya0jtDY+wbklag1TabEg
	 8OJCUUo/DGC6jV/fgOvauldZMlqEzWaItThe6A6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 184/776] usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()
Date: Sat, 30 May 2026 17:58:18 +0200
Message-ID: <20260530160245.256065212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3233,7 +3233,6 @@ rescan:
 		xhci_dbg(xhci, "endpoint disable with ep_state 0x%x\n",
 			 ep->ep_state);
 done:
-	host_ep->hcpriv = NULL;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -54,7 +54,8 @@ struct ep_device;
  * @ssp_isoc_ep_comp: SuperSpeedPlus isoc companion descriptor for this endpoint
  * @urb_list: urbs queued to this endpoint; maintained by usbcore
  * @hcpriv: for use by HCD; typically holds hardware dma queue head (QH)
- *	with one or more transfer descriptors (TDs) per urb
+ *	with one or more transfer descriptors (TDs) per urb; must be preserved
+ *	by core while BW is allocated for the endpoint
  * @ep_dev: ep_device for sysfs info
  * @extra: descriptors following this endpoint in the configuration
  * @extralen: how many bytes of "extra" are valid


