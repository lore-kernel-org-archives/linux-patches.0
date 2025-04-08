Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716CF2676E1;
	Tue,  8 Apr 2025 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113145; cv=none; b=LG6mke+lfj0thoxuS0K+kg3RNhKdLOV1maeQrprCTB5GiX832c9yprjwbzg2RtZXxtusTKWezCbgYmd6Oo0MjHsHZFLFySC212x2yR4R8hIUmP0gg1gcvDzbHcMh89Q8pLtJZMiD2BxSI4OD0T4bxPsuhls7gEUt31icME1rcXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113145; c=relaxed/simple;
	bh=0QXs6IDCTTPykhgHrEEA3cOPqbwaPyKtRozVVSK6Vpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oseERYeTPJA45K9Dysgzqy0BYnjAeNyw6Id49hG8Q6wyEGCDlD1WCpKQ6tgwMuoeHdQ5cJqAdYz4xEjK9h830PYE3UVa1Absw7FL6LSn6DxCsM3oZWOxM9RiFS12yEiqRiHXl8mLDT+S3tVhkEErswJzxiHZG0ONRWmLFX9UoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8QmSGYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8QmSGYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F5CC4CEED;
	Tue,  8 Apr 2025 11:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113145;
	bh=0QXs6IDCTTPykhgHrEEA3cOPqbwaPyKtRozVVSK6Vpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8QmSGYVs90oTxaMw6Okb7rNMR5IzymLGljXrfjzT+0cr90CNfG+qz4XCHibN0H4w
	 dwDT8YLRukKzJn8F0BSqUswL8r8WhqT4wRGPj2qpsVKa+P23DQ6MYj6cjx1xWzWse+
	 d1Lo1rYbPRcJUUmVWWslklqqnQr7d3hacG2tgV4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Aravamudan <naravamudan@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/268] PCI: Avoid reset when disabled via sysfs
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104829.850087654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Nishanth Aravamudan <naravamudan@nvidia.com>

[ Upstream commit 479380efe1625e251008d24b2810283db60d6fcd ]

After d88f521da3ef ("PCI: Allow userspace to query and set device reset
mechanism"), userspace can disable reset of specific PCI devices by writing
an empty string to the sysfs reset_method file.

However, pci_slot_resettable() does not check pci_reset_supported(), which
means that pci_reset_function() will still reset the device even if
userspace has disabled all the reset methods.

I was able to reproduce this issue with a vfio device passed to a qemu
guest, where I had disabled PCI reset via sysfs.

Add an explicit check of pci_reset_supported() in both
pci_slot_resettable() and pci_bus_resettable() to ensure both the reset
status and reset execution are bypassed if an administrator disables it for
a device.

Link: https://lore.kernel.org/r/20250207205600.1846178-1-naravamudan@nvidia.com
Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: Amey Narkhede <ameynarkhede03@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 095fa1910d36d..bcce569a83395 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5714,6 +5714,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5790,6 +5792,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
-- 
2.39.5



