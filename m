Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1334112B7B;
	Sat,  3 Feb 2024 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933649; cv=none; b=aRwgO8Xhp37PXN5kwD/RbMWro2frivurUj39DWOQXySgVksSxYGL51HfP6b2k9DHmvSQHE7+BaLZT7pj2KMHoqGTjwru5w4pwfudrWUXwJEq1gb7I5GOTXQL5USDV2wY5kEivBzAn/0Fo+rfb96UCFF5FOK30O6Sv22U6QABHts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933649; c=relaxed/simple;
	bh=wiM2SHmmWymIKCPtjlfvnOmizJ+DscnW2/AsqXHDfuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUYVSVKhYPkNkDrkChKR5jzk0kaG9LZulqbCM5Q9MFaGqUbW3MuMjt12+cO7ooSjb2wncA8OcvKfclnGUHl3QfvXh4GqtSigK0tKL2wwLc4Cow6UoLzA6pwrMvLvJvbMB6ZpB5xj4P7owMgS2+RZbueMHBchp/nC8zsqJT0Z4C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUriiMmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUriiMmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D068FC433F1;
	Sat,  3 Feb 2024 04:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933648;
	bh=wiM2SHmmWymIKCPtjlfvnOmizJ+DscnW2/AsqXHDfuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUriiMmI8CIHUKSkehws7j76hTSW+L/FJvrao57X13M1YiXumohJ66y5RvcpDSGL0
	 UMXHyNfHhVq/Hing7EAmvYHoh391REUXgLBbQL63vsKZT0+sb892xfXsRxf1HgpqId
	 RtskJa9daP3kKn9hCHtUhNVQKigg7xIk2KAgAfgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/322] xhci: fix possible null pointer deref during xhci urb enqueue
Date: Fri,  2 Feb 2024 20:05:29 -0800
Message-ID: <20240203035406.695733896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e2e2aacf042f52854c92775b7800ba668e0bdfe4 ]

There is a short gap between urb being submitted and actually added to the
endpoint queue (linked). If the device is disconnected during this time
then usb core is not yet aware of the pending urb, and device may be freed
just before xhci_urq_enqueue() continues, dereferencing the freed device.

Freeing the device is protected by the xhci spinlock, so make sure we take
and keep the lock while checking that device exists, dereference it, and
add the urb to the queue.

Remove the unnecessary URB check, usb core checks it before calling
xhci_urb_enqueue()

Suggested-by: Kuen-Han Tsai <khtsai@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231201150647.1307406-20-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 132b76fa7ca6..e39c5ba9b7c7 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1498,24 +1498,7 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 	struct urb_priv	*urb_priv;
 	int num_tds;
 
-	if (!urb)
-		return -EINVAL;
-	ret = xhci_check_args(hcd, urb->dev, urb->ep,
-					true, true, __func__);
-	if (ret <= 0)
-		return ret ? ret : -EINVAL;
-
-	slot_id = urb->dev->slot_id;
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
-	ep_state = &xhci->devs[slot_id]->eps[ep_index].ep_state;
-
-	if (!HCD_HW_ACCESSIBLE(hcd))
-		return -ESHUTDOWN;
-
-	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
-		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
-		return -ENODEV;
-	}
 
 	if (usb_endpoint_xfer_isoc(&urb->ep->desc))
 		num_tds = urb->number_of_packets;
@@ -1554,12 +1537,35 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
+	ret = xhci_check_args(hcd, urb->dev, urb->ep,
+			      true, true, __func__);
+	if (ret <= 0) {
+		ret = ret ? ret : -EINVAL;
+		goto free_priv;
+	}
+
+	slot_id = urb->dev->slot_id;
+
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		ret = -ESHUTDOWN;
+		goto free_priv;
+	}
+
+	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
+		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
+		ret = -ENODEV;
+		goto free_priv;
+	}
+
 	if (xhci->xhc_state & XHCI_STATE_DYING) {
 		xhci_dbg(xhci, "Ep 0x%x: URB %p submitted for non-responsive xHCI host.\n",
 			 urb->ep->desc.bEndpointAddress, urb);
 		ret = -ESHUTDOWN;
 		goto free_priv;
 	}
+
+	ep_state = &xhci->devs[slot_id]->eps[ep_index].ep_state;
+
 	if (*ep_state & (EP_GETTING_STREAMS | EP_GETTING_NO_STREAMS)) {
 		xhci_warn(xhci, "WARN: Can't enqueue URB, ep in streams transition state %x\n",
 			  *ep_state);
-- 
2.43.0



