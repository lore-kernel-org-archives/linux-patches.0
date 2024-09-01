Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1B81C68C;
	Sun,  1 Sep 2024 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208719; cv=none; b=XbjiMCDKL5X1bI4/wC5DnvNRt1zRaeUTr+XlyTLYusK0gxqr2QyJ8wVJ//ABM9jJN11IgQhdHWtiFW5O7yVwE32VQYM9VQl7nhfKxfZpcu56XzgtwuEUplLg72wfY294Jtiz6oKq1Sqt/xKc3QQGTOFly/5Noy1ibNs5NPO+NNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208719; c=relaxed/simple;
	bh=+yi8wDB/tOFWsfGBe5ziMoklY473gn2sKhT2/7AyzUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACmk0MNJK0p6zu9QXxQ0kGqtdA/3G0fiikzdciQGRjjNeGrtXQ0TgNjfrNPCvWI3FXatBmps8Q2cTzZ1PqrV1nG3agO4Jy1Tfs6DLX6t5ce2+Og9NeFgnfD/xiYVwuohjLNIBrnik5Y3zOnWND0VaGl1zPP6w0e0XMy3clBlQT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKCSheRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKCSheRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF68DC4CEC3;
	Sun,  1 Sep 2024 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208719;
	bh=+yi8wDB/tOFWsfGBe5ziMoklY473gn2sKhT2/7AyzUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKCSheRVKiR4NOU0o502cjiaOUNzhJXC8hn8TT2Bq4CQpr3m0AYo5ilsBpLpr4rT0
	 OejD7vyqbvnRMPxHrJp1Fwc9NrJC7MLJnmwbF5WKSHotkR8+0CNEsfRnKSz0QTpey1
	 kSo1Kvw+KuATwwu9dwkAKX+7KFcSKxy4GE2Own88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 003/134] xhci: Fix Panther point NULL pointer deref at full-speed re-enumeration
Date: Sun,  1 Sep 2024 18:15:49 +0200
Message-ID: <20240901160809.886561435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2819,7 +2819,7 @@ static int xhci_configure_endpoint(struc
 				xhci->num_active_eps);
 		return -ENOMEM;
 	}
-	if ((xhci->quirks & XHCI_SW_BW_CHECKING) &&
+	if ((xhci->quirks & XHCI_SW_BW_CHECKING) && !ctx_change &&
 	    xhci_reserve_bandwidth(xhci, virt_dev, command->in_ctx)) {
 		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
 			xhci_free_host_resources(xhci, ctrl_ctx);
@@ -4231,8 +4231,10 @@ static int xhci_setup_device(struct usb_
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


