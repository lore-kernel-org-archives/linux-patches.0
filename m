Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF8221DA7;
	Tue, 29 Apr 2025 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948990; cv=none; b=MeAeYqXHLPO9EBwT7bGtrWWczH5TQ1wkhRLOgSLl3ljP8AaF/g10CAa4JnfhI117S0f9T8SA4kDx2Lj9Hf7qnfRiSRuCYkgViteMz0xWS6EuH55H5DiC3A19gWn6mWDINbgUNiNDiFaF2YEvi7lvFL2xVmifW1zqux31Z1adcBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948990; c=relaxed/simple;
	bh=T4ygqG3r6v54msrQ6LTDo/GDj5w+f0Cvq8TsnfMcfes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKEbZ4XR3dQ9vvM3uDyUDED9PmQM+dByao6fA69uk4Q4hXbbExqO0GiVR4GHpri1Ea8LHcZwr35F99vfkdBhtMZByOjkHzvWaGW9FWKWd9eORkC+kcp4ut9TAQfjET+HcpuJ2GQ4Vcn3q8p9zf9GkrzbMVk9RR3gg2vA3iTKgns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCEGeNeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCEGeNeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8360AC4CEE3;
	Tue, 29 Apr 2025 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948989;
	bh=T4ygqG3r6v54msrQ6LTDo/GDj5w+f0Cvq8TsnfMcfes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCEGeNeUjYferoEGBqw4LfrxKVyUnmJf4OAsU7v0uCw8qJqAid/jvsqwNk4BqN5Iw
	 qqKT26a6F/RUsE/2n9c97BvIP6/xsfzrOSfYMehSe72DGIr95vkdNK0cqgs7FoYdcy
	 69X8H6rQEviQRlAEL1PR+HgHbt+xYbnyS4rGnThs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cal Peake <cp@absolutedigital.net>,
	Athul Krishna <athul.krishna.kr@protonmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 5.15 155/373] Revert "PCI: Avoid reset when disabled via sysfs"
Date: Tue, 29 Apr 2025 18:40:32 +0200
Message-ID: <20250429161129.526781955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5484,8 +5484,6 @@ static bool pci_bus_resetable(struct pci
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;
@@ -5562,8 +5560,6 @@ static bool pci_slot_resetable(struct pc
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;


