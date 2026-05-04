Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54329E116;
	Mon,  4 May 2026 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904411; cv=none; b=XAlEnGlhdBHlBBIJVPIUZW/uPamJgHS0kgMS46RuhDZlDNE2HuPZOelWaVdpEf8L7+7/FItnjkbV2Yv2ovtiORpzE4255FhdlcFYH7VLjk7YXWQEXZRVrIdrFK0OnedYfms4OhldVPT2kZu6TDAuv77CSWxeeVAIdnGzuLCFeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904411; c=relaxed/simple;
	bh=oYMF/2w9gZ43XgGJ1WGoZtjJgdll1kbc/68qx9qL6Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnVt+CFYMppp/4Hn8qA2cWro1ZMQJsbGNlejIezwmP13uviE8mVyt5Fy7IC7cn6PXpqNZkgSMzbslnAOZ/2DUumlIblxM1DgctQED+aJUPPWma7w/58Ibs+eJBC5/40QY1Aes7Ly4YX3XLfnEKAwkab6CqbH+3R95Zo5UggOSjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dh+UxsNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh+UxsNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28775C2BCB8;
	Mon,  4 May 2026 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904411;
	bh=oYMF/2w9gZ43XgGJ1WGoZtjJgdll1kbc/68qx9qL6Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh+UxsNTaXeikCObeLzBotsexKnDwbfYDHovn9k3dkD53AHKKPoJP0r708pHgXZsx
	 fjjD7tspN/0hrEJ/LKmBmt0VQSckbj3ohud6f46NOF47L96NcW6beCpXLrgSCpvJGi
	 DxXmRNnNR//eQbnUQ1JCFKedXozOPIeGWFIfUj/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 004/215] usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()
Date: Mon,  4 May 2026 15:50:23 +0200
Message-ID: <20260504135130.336054371@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -3080,7 +3080,6 @@ rescan:
 		xhci_dbg(xhci, "endpoint disable with ep_state 0x%x\n",
 			 ep->ep_state);
 done:
-	host_ep->hcpriv = NULL;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -53,7 +53,8 @@ struct ep_device;
  * @ssp_isoc_ep_comp: SuperSpeedPlus isoc companion descriptor for this endpoint
  * @urb_list: urbs queued to this endpoint; maintained by usbcore
  * @hcpriv: for use by HCD; typically holds hardware dma queue head (QH)
- *	with one or more transfer descriptors (TDs) per urb
+ *	with one or more transfer descriptors (TDs) per urb; must be preserved
+ *	by core while BW is allocated for the endpoint
  * @ep_dev: ep_device for sysfs info
  * @extra: descriptors following this endpoint in the configuration
  * @extralen: how many bytes of "extra" are valid


