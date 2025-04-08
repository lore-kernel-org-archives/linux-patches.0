Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0077E26B0A2;
	Tue,  8 Apr 2025 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115619; cv=none; b=Ub38bEzaMXD9PfRPcm/LD4rrARq2vi4J4WDDCjU40IONiAJutWnPmPpKHmgjKi+AOQe1WBh5LSnnYHggYf6aj57GwxF45eWkYWrSiaxQB9WoQd4vH+Zzr+9jEjKo6YszaHFTwp8eRaVUpAviecPc1pAdGXsWBp2XdW0E0TAo4n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115619; c=relaxed/simple;
	bh=E9DG16rGjxhVdUjqa2Nrvaspzl1sSlcOeF1oHh1gHsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/rAgDg4zLiNLXLWYRGqOw0ftOhi7KUGyF+tfm4F9nbS1BV4mojBeTWBm4UDDylzEd++FWY2TIxAtcRO7uUMAl8PesgD/pJw1dvAUJDj2PjFQfneGXjWbHm+5mTpQeWjxBlXYl8jfmIj1Loo40VuM8ZVfFI04NcPSUDr6ahWpNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ur8t34Zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ur8t34Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55791C4CEE5;
	Tue,  8 Apr 2025 12:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115618;
	bh=E9DG16rGjxhVdUjqa2Nrvaspzl1sSlcOeF1oHh1gHsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ur8t34ZbW292UoeIWW4ToPGvN3xr0KXN0nEyII5ce8VUq+vs+V5EPM2P6lXrqX3pQ
	 iGZFnirKoSCE7Od1Wr2iVyzVde7/1JFPoFyDHMyvwZipS/FxUTIZ4xaMl2M5vFJdb2
	 X06IRwWyZPjbHNkm0KSKuJJ3LvS7+RMa+r/O3pNM=
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
Subject: [PATCH 6.1 042/204] PCI: Avoid reset when disabled via sysfs
Date: Tue,  8 Apr 2025 12:49:32 +0200
Message-ID: <20250408104821.581067871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a35a9887302d..f411cef0186e1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5578,6 +5578,8 @@ static bool pci_bus_resetable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;
@@ -5654,6 +5656,8 @@ static bool pci_slot_resetable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;
-- 
2.39.5



