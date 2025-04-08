Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C0326FD99;
	Tue,  8 Apr 2025 12:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116270; cv=none; b=l76nWU1oX+oVgwDJy4z2xQDyooS38casYgKMN2CuALc3QmiZlwd7lRvFbyOmpVTEUORqoKOCGNIqjnJQw9L4WZq4+o5tqRuKQ9wqSzCabsZCBF+Lqexi6rgc1Kn4sAg7zQ8DEqrWezAxa+dui1LcdN8hnf2rhgA3oBrnmkfeASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116270; c=relaxed/simple;
	bh=2Ri6vN45AyznpefHf7ft286BADK5PdQ4F3ziWKDWG98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+3uHvddAZ+jXF8Axspr0WC8y+HW8enW3dhWhiIf1G2H3VV7N4p/YtI3Zg5HnMDDu1v6WqCgT/RvgvYAVQNTO6hEGYjCAEBWh3UN/9RD7MCDuFHJcTBlfNLaslCzoTMgQ+eQLMcDagXh8EjdXjYRuqRaKOr9gLEGFO8ONwUKtGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWxzA/6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWxzA/6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE166C4CEE5;
	Tue,  8 Apr 2025 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116270;
	bh=2Ri6vN45AyznpefHf7ft286BADK5PdQ4F3ziWKDWG98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWxzA/6liYOpE1kWczHq3JMwtOpvKFyKOoWWKzsWc7cm2Q4MN/S9zazDsP4YhkaVd
	 daWisG7zAxgvn8YFFj2zH5fXg3aNrsr9+JJjJGwMCajy+w9N+qVCDRcJdbZuxJehYH
	 fyuBrqCcvmqxbDuoaqLLKyOcKcHBmN7JG1XySJWw=
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
Subject: [PATCH 6.12 077/423] PCI: Avoid reset when disabled via sysfs
Date: Tue,  8 Apr 2025 12:46:43 +0200
Message-ID: <20250408104847.536938544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 25211d1219227..169aa8fd74a11 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5528,6 +5528,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5604,6 +5606,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
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



