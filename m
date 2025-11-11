Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF22727FD;
	Tue, 11 Nov 2025 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824465; cv=none; b=FcveKLUfYx8VYk8dFmkrTi8QWkU593D1Xj0PqQ34MU/wErbzYuKiMSLuwVKhxKv/Kwmu1PXqNRGVHOS7KDuyKSa7WZ0I55Tchj9yho8ZJOKnzythWGBE/+Gi/Kj7E6jEw6svAPMqxBab7X0D3iuNsVtihb4sVj50AwRx2gtvy/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824465; c=relaxed/simple;
	bh=us8YPSbszm8EA6SwHIb4wfylW8GhN7nfBueuMUtNrw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxjwcXrTnAHlLCQJbszJWuCDiK4AjVjx9S7p06BATxbKKXEloFWBO4Avi/4/2N2/fJZoT39fFWxJQULklbqc/fmnDaxD4OyLlMCcEPuQ9SAa7v+Vp2766bE7qkoahF21OiZLvQjd3aXU0TgdKqjDf7uN/flubXX/DAeL0Oan+7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN8MLly6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN8MLly6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E56FC4CEF5;
	Tue, 11 Nov 2025 01:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824464;
	bh=us8YPSbszm8EA6SwHIb4wfylW8GhN7nfBueuMUtNrw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tN8MLly6++hFha0EB0+t7rv1oSiikB+uWkjWDkYyWKZmad3JnyPCtrLZ/H0a9qmjl
	 O79azMQM7dwYoNMjlzL/QKZZTuoPng5EwJB9d1mtwjcYvjjAXBLn4v599NJ66Hy2CN
	 2kG0RW5ADIDb4FoBt1WIGVnCllBS3w3TIKd33nU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arisa Snowbell <arisa.snowbell@gmail.com>,
	Michal Kubecek <mkubecek@suse.cz>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Michal Pecio <michal.pecio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/565] usb: xhci-pci: Fix USB2-only root hub registration
Date: Tue, 11 Nov 2025 09:45:07 +0900
Message-ID: <20251111004537.036909887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

[ Upstream commit 8607edcd1748503f4f58e66ca0216170f260c79b ]

A recent change to hide USB3 root hubs of USB2-only controllers broke
registration of USB2 root hubs - allow_single_roothub is set too late,
and by this time xhci_run() has already deferred root hub registration
until after the shared HCD is added, which will never happen.

This makes such controllers unusable, but testers didn't notice since
they were only bothered by warnings about empty USB3 root hubs. The bug
causes problems to other people who actually use such HCs and I was
able to confirm it on an ordinary HC by patching to ignore USB3 ports.

Setting allow_single_roothub during early setup fixes things.

Reported-by: Arisa Snowbell <arisa.snowbell@gmail.com>
Closes: https://lore.kernel.org/linux-usb/CABpa4MA9unucCoKtSdzJyOLjHNVy+Cwgz5AnAxPkKw6vuox1Nw@mail.gmail.com/
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Closes: https://lore.kernel.org/linux-usb/lnb5bum7dnzkn3fc7gq6hwigslebo7o4ccflcvsc3lvdgnu7el@fvqpobbdoapl/
Fixes: 719de070f764 ("usb: xhci-pci: add support for hosts with zero USB3 ports")
Tested-by: Arisa Snowbell <arisa.snowbell@gmail.com>
Tested-by: Michal Kubecek <mkubecek@suse.cz>
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 933d9fdd9516b..5f60528453e91 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -588,6 +588,8 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	if (!usb_hcd_is_primary_hcd(hcd))
 		return 0;
 
+	xhci->allow_single_roothub = 1;
+
 	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
 		xhci_pme_acpi_rtd3_enable(pdev);
 
@@ -643,7 +645,6 @@ int xhci_pci_common_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	xhci = hcd_to_xhci(hcd);
 	xhci->reset = reset;
 
-	xhci->allow_single_roothub = 1;
 	if (!xhci_has_one_roothub(xhci)) {
 		xhci->shared_hcd = usb_create_shared_hcd(&xhci_pci_hc_driver, &dev->dev,
 							 pci_name(dev), hcd);
-- 
2.51.0



ice video_is_primary_device
+#endif
 
 #include <asm-generic/video.h>
 
-- 
2.51.0



