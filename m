Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCC2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C01C4339B;
	Sun, 22 Jan 2023 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400616;
	bh=ZU2CzIa1Z6i9krREWfu/jHBVqtH8xoJW+ncIsXa/iWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ga4ES8xdCb9Gy5Pflc2MTyiL4CHzzXM6QJpvlGaS1BKHjx1VPtUfrTHNgO9Sopzks
	 rfu3QA1GNRCtJpPNGCvO2YYdQmlRqNz5yC1QQWxK3FgLt53Cxa+cYuj8xlKNrbIiUH
	 5xZhPuwDCajT9+yK+/UNw9urd1nhABP2ltOciApA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 044/117] xhci: Fix null pointer dereference when host dies
Date: Sun, 22 Jan 2023 16:03:54 +0100
Message-Id: <20230122150234.575040276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a2bc47c43e70cf904b1af49f76d572326c08bca7 upstream.

Make sure xhci_free_dev() and xhci_kill_endpoint_urbs() do not race
and cause null pointer dereference when host suddenly dies.

Usb core may call xhci_free_dev() which frees the xhci->devs[slot_id]
virt device at the same time that xhci_kill_endpoint_urbs() tries to
loop through all the device's endpoints, checking if there are any
cancelled urbs left to give back.

hold the xhci spinlock while freeing the virt device

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3962,6 +3962,7 @@ static void xhci_free_dev(struct usb_hcd
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -3990,7 +3991,11 @@ static void xhci_free_dev(struct usb_hcd
 	}
 	virt_dev->udev = NULL;
 	xhci_disable_slot(xhci, udev->slot_id);
+
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_free_virt_device(xhci, udev->slot_id);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
 }
 
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)


