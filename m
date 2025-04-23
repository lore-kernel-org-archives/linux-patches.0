Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259E328936C;
	Wed, 23 Apr 2025 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422368; cv=none; b=AKQvZzM8YAsRb0y2TKZ5bUmZ6y9KL4Z9XaQ/Vw05ps+rvK+qbwwXZRwYiGRagcz2K1QOANqKCin3UXUgSUCuzyV+9u8khnPy9oqU6p2hSGaCK6udzItNHqvTtgEzkLxGOv9rfDRfZpj/abx8bwGLtgotkj7uNff8FoWmD0jbDx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422368; c=relaxed/simple;
	bh=ub8jAfTc/vVRIp9QtMUJRBcw+I840dW13UPmPUto5Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDKD1jsmw7bx1c3i5mNL6sZVKa80pyh5C/UXdGLI7pnt+yGWLLnUAJjfx34veJLR0Aj7yQjhDJtK/gF5Q0bSMekubF/E+8XaOiExWf77zHagvJsyiRYxBA2r2qbyg5L7ja9LKDXsOWu8VcKNuLQ8SbJ+/AjSq4ltQ5v8ysO/xaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrilMxL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrilMxL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5414BC4CEE2;
	Wed, 23 Apr 2025 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422367;
	bh=ub8jAfTc/vVRIp9QtMUJRBcw+I840dW13UPmPUto5Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrilMxL1Cpj17PKuIfYl+jwA00VtLSovOUuL+2tufvw47yq4Z1KD6k1vDumHTRLsX
	 5ScZf3ty3JYLDgbex7sTinoLxDZrWoIevgzFgptFpzJpX2r1MthAUSU2dEJhn1UB3M
	 Snc9PEy8yOxv5Gr0w1iXWEMcK1UBzaGE89WXtSDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cal Peake <cp@absolutedigital.net>,
	Athul Krishna <athul.krishna.kr@protonmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 6.6 301/393] Revert "PCI: Avoid reset when disabled via sysfs"
Date: Wed, 23 Apr 2025 16:43:17 +0200
Message-ID: <20250423142655.768130157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit bc0b828ef6e561081ebc4c758d0c4d166bb9829c upstream.

This reverts commit 479380efe1625e251008d24b2810283db60d6fcd.

The reset_method attribute on a PCI device is only intended to manage the
availability of function scoped resets for a device.  It was never intended
to restrict resets targeting the bus or slot.

In introducing a restriction that each device must support function level
reset by testing pci_reset_supported(), we essentially create a catch-22,
that a device must have a function scope reset in order to support bus/slot
reset, when we use bus/slot reset to effect a reset of a device that does
not support a function scoped reset, especially multi-function devices.

This breaks the majority of uses cases where vfio-pci uses bus/slot resets
to manage multifunction devices that do not support function scoped resets.

Fixes: 479380efe162 ("PCI: Avoid reset when disabled via sysfs")
Reported-by: Cal Peake <cp@absolutedigital.net>
Closes: https://lore.kernel.org/all/808e1111-27b7-f35b-6d5c-5b275e73677b@absolutedigital.net
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220010
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250414211828.3530741-1-alex.williamson@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5714,8 +5714,6 @@ static bool pci_bus_resettable(struct pc
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5792,8 +5790,6 @@ static bool pci_slot_resettable(struct p
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;


