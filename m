Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85411494AC;
	Tue, 27 Aug 2024 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769707; cv=none; b=fcc4CdmYjH/opGdd2+s3awejMsy/YKnuguspIqtyGOqkNViicx293+s3OBo1UTXOwgX2v0u2hvZYF8mmHFSF6jPtH/CybCcVUXH/xILg39MgE1+XeeJpcp2RK6iTy8sd5gFbU4PhCO5iWPKZdEmy0Oh7sXNe8/Vadwa97N4H2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769707; c=relaxed/simple;
	bh=npP/AYtztZ3v+ezq0LIvevnQgMnkKYKSH5+Kmuj1/Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk2Hf1eZ8YPXwPzipNnntYB5CjdEixDcor7ji7lrZkyUqh92ZvaFgdTl5U+hK2nd+CRwuHtfa8mQPGp4PIPZNgRmxNh+R3cPrP3m91BrebMoWHc4+6ltTF8l9xltRpXEIE4nICHUt5H2ex1JBBJMZje0+jKKJh43VqH5mh3GImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cqh/gPiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cqh/gPiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3386CC4AF17;
	Tue, 27 Aug 2024 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769707;
	bh=npP/AYtztZ3v+ezq0LIvevnQgMnkKYKSH5+Kmuj1/Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cqh/gPiGqBVleTj6gp7Tq49kHMlzMpV13DHF1YKJ2P6fUwSFihv9vXoJyBWCd2w2I
	 uUhN7q1P1BNaGKixT3QtTgTM8gex9SDWi5C1MFkeuVgRACqq6lYa7886sHaGNTiRVa
	 cNFGl3exgAxJnV+ByxpGo0TsL4eaWETIxrNEEE0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 013/341] xhci: Fix Panther point NULL pointer deref at full-speed re-enumeration
Date: Tue, 27 Aug 2024 16:34:04 +0200
Message-ID: <20240827143843.909795047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

commit af8e119f52e9c13e556be9e03f27957554a84656 upstream.

re-enumerating full-speed devices after a failed address device command
can trigger a NULL pointer dereference.

Full-speed devices may need to reconfigure the endpoint 0 Max Packet Size
value during enumeration. Usb core calls usb_ep0_reinit() in this case,
which ends up calling xhci_configure_endpoint().

On Panther point xHC the xhci_configure_endpoint() function will
additionally check and reserve bandwidth in software. Other hosts do
this in hardware

If xHC address device command fails then a new xhci_virt_device structure
is allocated as part of re-enabling the slot, but the bandwidth table
pointers are not set up properly here.
This triggers the NULL pointer dereference the next time usb_ep0_reinit()
is called and xhci_configure_endpoint() tries to check and reserve
bandwidth

[46710.713538] usb 3-1: new full-speed USB device number 5 using xhci_hcd
[46710.713699] usb 3-1: Device not responding to setup address.
[46710.917684] usb 3-1: Device not responding to setup address.
[46711.125536] usb 3-1: device not accepting address 5, error -71
[46711.125594] BUG: kernel NULL pointer dereference, address: 0000000000000008
[46711.125600] #PF: supervisor read access in kernel mode
[46711.125603] #PF: error_code(0x0000) - not-present page
[46711.125606] PGD 0 P4D 0
[46711.125610] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
[46711.125615] CPU: 1 PID: 25760 Comm: kworker/1:2 Not tainted 6.10.3_2 #1
[46711.125620] Hardware name: Gigabyte Technology Co., Ltd.
[46711.125623] Workqueue: usb_hub_wq hub_event [usbcore]
[46711.125668] RIP: 0010:xhci_reserve_bandwidth (drivers/usb/host/xhci.c

Fix this by making sure bandwidth table pointers are set up correctly
after a failed address device command, and additionally by avoiding
checking for bandwidth in cases like this where no actual endpoints are
added or removed, i.e. only context for default control endpoint 0 is
evaluated.

Reported-by: Karel Balej <balejk@matfyz.cz>
Closes: https://lore.kernel.org/linux-usb/D3CKQQAETH47.1MUO22RTCH2O3@matfyz.cz/
Cc: stable@vger.kernel.org
Fixes: 651aaf36a7d7 ("usb: xhci: Handle USB transaction error on address command")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240815141117.2702314-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2808,7 +2808,7 @@ static int xhci_configure_endpoint(struc
 				xhci->num_active_eps);
 		return -ENOMEM;
 	}
-	if ((xhci->quirks & XHCI_SW_BW_CHECKING) &&
+	if ((xhci->quirks & XHCI_SW_BW_CHECKING) && !ctx_change &&
 	    xhci_reserve_bandwidth(xhci, virt_dev, command->in_ctx)) {
 		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
 			xhci_free_host_resources(xhci, ctrl_ctx);
@@ -4150,8 +4150,10 @@ static int xhci_setup_device(struct usb_
 		mutex_unlock(&xhci->mutex);
 		ret = xhci_disable_slot(xhci, udev->slot_id);
 		xhci_free_virt_device(xhci, udev->slot_id);
-		if (!ret)
-			xhci_alloc_dev(hcd, udev);
+		if (!ret) {
+			if (xhci_alloc_dev(hcd, udev) == 1)
+				xhci_setup_addressable_virt_dev(xhci, udev);
+		}
 		kfree(command->completion);
 		kfree(command);
 		return -EPROTO;


