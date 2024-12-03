Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D621E3DED;
	Tue,  3 Dec 2024 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239615; cv=none; b=irv/xpvKJUmFf5l3MgXjYb2cUKwXAAqVWu6es0k7fDTMsiyd0r8hmpoC4xHQl8JpprevGd9ijw6exq4UG+UM66fHN+n8ly/FGhWvflPn57mr9adBxzXnHatMaHVkv08jW7rKgD77FLNQm/mGPQwN9VmYNgUysNj4Nl4FCj24nhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239615; c=relaxed/simple;
	bh=hlKwPsSdKNXFrXQQZmdNXDpLPBQpJ/tBkFtcxzXp3Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keNt4OvIQgA4lTte0jTHDbumJIi1TbIyqtZD1PviP3veE4NB794eEBjxke/i9d2su3LSBxU4UV2ia/LlXpaknwSLVxMwtltqg+4cewZ9B2dmusOpk3ebm8/JAyokt0Amf4XJx1jUHIzWtQYn4qjNFTMjeajEx1mwHCkJO2Wu94c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEHBFYY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEHBFYY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D8C4CECF;
	Tue,  3 Dec 2024 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239614;
	bh=hlKwPsSdKNXFrXQQZmdNXDpLPBQpJ/tBkFtcxzXp3Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEHBFYY/assoPKPrGuJej4fLFBMD7PnIAxIQyBsgvnARdmXQIL4YnTQ65J9umZzQa
	 dZkt7xT8T68E/rFLz4CdMaBtv9GDgjFloWdb9AktDl2QOEu2jnWd7KxSJ63k/KqVnU
	 MViElWv0ESbwNd/XelblVNIU9XfUYTZvPDJUQ7s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.11 673/817] xhci: Fix control transfer error on Etron xHCI host
Date: Tue,  3 Dec 2024 15:44:05 +0100
Message-ID: <20241203144022.227486775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 5e1c67abc9301d05130b7e267c204e7005503b33 upstream.

Performing a stability stress test on a USB3.0 2.5G ethernet adapter
results in errors like this:

[   91.441469] r8152 2-3:1.0 eth3: get_registers -71
[   91.458659] r8152 2-3:1.0 eth3: get_registers -71
[   91.475911] r8152 2-3:1.0 eth3: get_registers -71
[   91.493203] r8152 2-3:1.0 eth3: get_registers -71
[   91.510421] r8152 2-3:1.0 eth3: get_registers -71

The r8152 driver will periodically issue lots of control-IN requests
to access the status of ethernet adapter hardware registers during
the test.

This happens when the xHCI driver enqueue a control TD (which cross
over the Link TRB between two ring segments, as shown) in the endpoint
zero's transfer ring. Seems the Etron xHCI host can not perform this
TD correctly, causing the USB transfer error occurred, maybe the upper
driver retry that control-IN request can solve problem, but not all
drivers do this.

|     |
-------
| TRB | Setup Stage
-------
| TRB | Link
-------
-------
| TRB | Data Stage
-------
| TRB | Status Stage
-------
|     |

To work around this, the xHCI driver should enqueue a No Op TRB if
next available TRB is the Link TRB in the ring segment, this can
prevent the Setup and Data Stage TRB to be breaked by the Link TRB.

Check if the XHCI_ETRON_HOST quirk flag is set before invoking the
workaround in xhci_queue_ctrl_tx().

Fixes: d0e96f5a71a0 ("USB: xhci: Control transfer support.")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-20-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3741,6 +3741,20 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *
 	if (!urb->setup_packet)
 		return -EINVAL;
 
+	if ((xhci->quirks & XHCI_ETRON_HOST) &&
+	    urb->dev->speed >= USB_SPEED_SUPER) {
+		/*
+		 * If next available TRB is the Link TRB in the ring segment then
+		 * enqueue a No Op TRB, this can prevent the Setup and Data Stage
+		 * TRB to be breaked by the Link TRB.
+		 */
+		if (trb_is_link(ep_ring->enqueue + 1)) {
+			field = TRB_TYPE(TRB_TR_NOOP) | ep_ring->cycle_state;
+			queue_trb(xhci, ep_ring, false, 0, 0,
+					TRB_INTR_TARGET(0), field);
+		}
+	}
+
 	/* 1 TRB for setup, 1 for status */
 	num_trbs = 2;
 	/*


