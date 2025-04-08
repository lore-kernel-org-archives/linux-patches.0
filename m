Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C41264A76;
	Tue,  8 Apr 2025 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111108; cv=none; b=Igu84tWke/BS+o3DcFr+AzdfIgQrmWzuWhfM1JLG6YKAcrL0bagyqKl0KfIc9TiFVlEzJkdp5GvPT5G5bZErT+QPWfOQvG7s98R2Hf9CTTfv+F/DXM/Yz3aZW32dMkPCFngVkjDtJlaAku89VOFg1AY6xAbTl6u+RPxmlvssfzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111108; c=relaxed/simple;
	bh=VpvDmR3m/o5C1LoPMsMshcIFQ7Gq4j3cXuQ0ZFdt2vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQ1eBl6efeW7Q+mJASYswdfHebHHaWKrl6oNA6Nmt4Oir3wbgcV+m6PN2V378qqWdX46GH2UWR35oJFozUtpM/GxEi+QRtIzFNc+gF/IYPNOJNltk6VjPnGnyOQ6oYEua/DcrZmdXHShhcGeT5O1b2mvKvfnn/jRK9oZAQx6+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRLdo+i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRLdo+i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62EAC4CEE5;
	Tue,  8 Apr 2025 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111108;
	bh=VpvDmR3m/o5C1LoPMsMshcIFQ7Gq4j3cXuQ0ZFdt2vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRLdo+i4n2mXEKVxaj8AFP+yVzR6AOo/4R6y1BR1nRx+RBsNUvydOIv7KNCafhTuD
	 7X9IwiCzkUuGPNul3AIyuOJVk+pGH6i8BnZDIrqg/uImJqWDtud2437WeEKkGigJ1W
	 m3a9EZt/MAkRY42aIHqpudM/erDGUXiDRHriJ/Yg=
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
Subject: [PATCH 6.14 312/731] PCI: Avoid reset when disabled via sysfs
Date: Tue,  8 Apr 2025 12:43:29 +0200
Message-ID: <20250408104921.534669220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 23609dd123f95..3e78cf86ef03b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5413,6 +5413,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5489,6 +5491,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
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



