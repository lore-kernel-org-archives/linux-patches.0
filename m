Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8762571C6;
	Thu, 17 Apr 2025 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914954; cv=none; b=Tyz4yXanBcnJYYNd+OQBqntF5Ir9HArI7viDu5D2T9ite2GoBeUWZWVbL3loF8PNMkXnjOCMghjkVMk9vQz0jD/u0z01Mr9l0ObuEKmc0ujGzkdjLSlnN495n5veA1RMEnk/hc0bQ5364gv/n4chW3rDCg56Ax4cqQBRWbReNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914954; c=relaxed/simple;
	bh=KXO9D7P6PMM5hNLbOJRhTppZAQaEqyqTbn/xsI1G3lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzGMVQ6xQ+f15xdZ7JYrjWncU/V8vGtMHM5rN2XhHFXistdLjuh9+1FTklkMYuIIkXVYrAt4t7iXdwLRhTcP+hwW81Nj+lVh5I1kp8sloW6fkWRTLKltEeMwA6kQbmZWoT7Wl8OYr1zgGpL1wJVCQPqTJy9FWGNuFxQ9yNscxBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OILRiGnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OILRiGnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2990FC4CEE4;
	Thu, 17 Apr 2025 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914954;
	bh=KXO9D7P6PMM5hNLbOJRhTppZAQaEqyqTbn/xsI1G3lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OILRiGnAsFCUmIf/llaUU6dnpaGlW2kjySxxGRdLdLV5GY6GVMS7KvX5oNjf/yMkC
	 jqOpZtKYNP8CH3PLVhHwF/UpVtfXcg15ZHKvN3RrYpde+ZltNhmSd1F/s2M/ZNY6BX
	 /i3L80Ww8RMZRu1dA41CZkgAngHS3Du4peB+I4RY=
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
Subject: [PATCH 6.13 386/414] PCI: pciehp: Avoid unnecessary device replacement check
Date: Thu, 17 Apr 2025 19:52:24 +0200
Message-ID: <20250417175127.000824240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


