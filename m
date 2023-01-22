Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD782590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A27C433D2;
	Sun, 22 Jan 2023 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400340;
	bh=7raMjUpcOc8k3fzUvaw8U5yB1P7eIoRQmIkIbYQiE7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aRcQcDyNFT/2timxg3OBBuYWwbN/89+e7G2KZvycVO7XUnKlgruOMfSdM+qz+SQi
	 snUO/p2c84pRROBTTXbNoUZmbVSHQYvFsOIRbpCmkhm4prWLKCUZkfwjTnLHelZWyb
	 XuvV9OzLijZ0OUcv6EkfYWCVQq6l4XOT9QBtsxB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 37/98] xhci: Fix null pointer dereference when host dies
Date: Sun, 22 Jan 2023 16:03:53 +0100
Message-Id: <20230122150231.051389112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
@@ -3919,6 +3919,7 @@ static void xhci_free_dev(struct usb_hcd
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -3947,7 +3948,11 @@ static void xhci_free_dev(struct usb_hcd
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


