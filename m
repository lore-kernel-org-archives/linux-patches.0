Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D7E2571B8;
	Thu, 17 Apr 2025 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916162; cv=none; b=BiMc+teiHc7dXN3bW/oEcS/5Nks0VUl/lMGInlgE1x3hBnE+QzO6YxI5qLr2PoT9MR59yQz3QNmFard2UhRjgixgU7KdwmoYmwusw12D+3Ka3Emwcc9Cq1wYrSM1HOSscfJFZNWzin6DEWxSIfy0EsEtz2HhyP1xljC5cL41gmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916162; c=relaxed/simple;
	bh=t28SF8A/ivwgXajiPefd3bdqD7ogqPqzsunE9GK5WM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdeJWn1Y6jpXC+taX6tCHyZQ1OQX+zzBtyBmSKBy+N2o86Mw0x7XvdAhsD8ar4/gNw75gKyxvd+rvn8sC29tPhgI698jff1/lJVretSs4i6CvQSjEd4AeJunlkFWsh1kL97FjaAxH7TdvWbEOLk7SI98so0M6+AJfpokepGPcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Or7Gpu9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Or7Gpu9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20660C4CEEA;
	Thu, 17 Apr 2025 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916162;
	bh=t28SF8A/ivwgXajiPefd3bdqD7ogqPqzsunE9GK5WM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Or7Gpu9j9BwhnB9GP4kdRTVoDpj8mQmv6/SkgrR1B5Z/PlZrfmWZYyfe71Dwi5Wul
	 UbTMy+Pb09T+Q14znhZnoBK3q9IYo0dg0SJVld7BW8GDGiKUYU/f7CTM8jzZlgHPdq
	 I/0s8BeJsIwoG2642qR0tnpkUKoj9GjLBNtb5uT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Crudup <kenny@panix.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.12 364/393] PCI: pciehp: Avoid unnecessary device replacement check
Date: Thu, 17 Apr 2025 19:52:53 +0200
Message-ID: <20250417175122.243963080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lukas Wunner <lukas@wunner.de>

commit e3260237aaadc9799107ccb940c6688195c4518d upstream.

Hot-removal of nested PCI hotplug ports suffers from a long-standing race
condition which can lead to a deadlock:  A parent hotplug port acquires
pci_lock_rescan_remove(), then waits for pciehp to unbind from a child
hotplug port.  Meanwhile that child hotplug port tries to acquire
pci_lock_rescan_remove() as well in order to remove its own children.

The deadlock only occurs if the parent acquires pci_lock_rescan_remove()
first, not if the child happens to acquire it first.

Several workarounds to avoid the issue have been proposed and discarded
over the years, e.g.:

https://lore.kernel.org/r/4c882e25194ba8282b78fe963fec8faae7cf23eb.1529173804.git.lukas@wunner.de/

A proper fix is being worked on, but needs more time as it is nontrivial
and necessarily intrusive.

Recent commit 9d573d19547b ("PCI: pciehp: Detect device replacement during
system sleep") provokes more frequent occurrence of the deadlock when
removing more than one Thunderbolt device during system sleep.  The commit
sought to detect device replacement, but also triggered on device removal.
Differentiating reliably between replacement and removal is impossible
because pci_get_dsn() returns 0 both if the device was removed, as well as
if it was replaced with one lacking a Device Serial Number.

Avoid the more frequent occurrence of the deadlock by checking whether the
hotplug port itself was hot-removed.  If so, there's no sense in checking
whether its child device was replaced.

This works because the ->resume_noirq() callback is invoked in top-down
order for the entire hierarchy:  A parent hotplug port detecting device
replacement (or removal) marks all children as removed using
pci_dev_set_disconnected() and a child hotplug port can then reliably
detect being removed.

Link: https://lore.kernel.org/r/02f166e24c87d6cde4085865cce9adfdfd969688.1741674172.git.lukas@wunner.de
Fixes: 9d573d19547b ("PCI: pciehp: Detect device replacement during system sleep")
Reported-by: Kenneth Crudup <kenny@panix.com>
Closes: https://lore.kernel.org/r/83d9302a-f743-43e4-9de2-2dd66d91ab5b@panix.com/
Reported-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Closes: https://lore.kernel.org/r/20240926125909.2362244-1-acelan.kao@canonical.com/
Tested-by: Kenneth Crudup <kenny@panix.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -286,9 +286,12 @@ static int pciehp_suspend(struct pcie_de
 
 static bool pciehp_device_replaced(struct controller *ctrl)
 {
-	struct pci_dev *pdev __free(pci_dev_put);
+	struct pci_dev *pdev __free(pci_dev_put) = NULL;
 	u32 reg;
 
+	if (pci_dev_is_disconnected(ctrl->pcie->port))
+		return false;
+
 	pdev = pci_get_slot(ctrl->pcie->port->subordinate, PCI_DEVFN(0, 0));
 	if (!pdev)
 		return true;


