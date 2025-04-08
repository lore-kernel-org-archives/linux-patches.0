Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B011264A76;
	Tue,  8 Apr 2025 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111227; cv=none; b=udBcJ+ONidUFJ9Onk0z8VdWZXvUWEvHvq9E3TlgwjF06B3VNPbHb1p0MpEU8d+qgzaZhOAO1XxgAL9c6hqlOn23pIYeClfWAvvHnycZ3RXBF3HRVxKn/ZKhUFW5Da8J6TvQ9OXO7aW7qm46TzLFfB24uwRzCzm+pbAw7TwyPcCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111227; c=relaxed/simple;
	bh=rHxd7Qbj4cAA1Glt96uPuYbfXyyaX/k4z/OcMHNgqY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzoC9WXg9tZBdoMvAFxYvOyF2exrc28O6vwIgmlgGxuJByR1sLbAT4M63sGKzWLig6ns1bT0mRNtR5eY829/h9c/w2itdDqxVhEGy9MRaBuBtPUPNc23LV/qQF+t4CfhNn/gE9OhwZpG+dDpK0A+nlRR9TejPCZaYDJZjczJFn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQYIlfvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQYIlfvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9FEC4CEE5;
	Tue,  8 Apr 2025 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111226;
	bh=rHxd7Qbj4cAA1Glt96uPuYbfXyyaX/k4z/OcMHNgqY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQYIlfvOu+R5MI8TdEAHQ8BF9Fsw91IRV56yosSY0OHGlVv/tIPMRWQt0kcVDIyTa
	 OARFxGnhJ5v//VgAHWdQ/87J4+nilVjFwqRVD/b4tBVtKIkZdJnQ/RcQAMX6fBq51Z
	 aJXMPMlAokoI9/wAjDdNxjJUv8bTxSf7YqsKQLUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 338/731] PCI: Fix BAR resizing when VF BARs are assigned
Date: Tue,  8 Apr 2025 12:43:55 +0200
Message-ID: <20250408104922.137661204@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 9ec19bfa78bd788945e2445b09de7b4482dee432 ]

__resource_resize_store() attempts to release all resources of the device
before attempting the resize. The loop, however, only covers standard BARs
(< PCI_STD_NUM_BARS). If a device has VF BARs that are assigned,
pci_reassign_bridge_resources() finds the bridge window still has some
assigned child resources and returns -NOENT which makes
pci_resize_resource() to detect an error and abort the resize.

Change the release loop to cover all resources up to VF BARs which allows
the resize operation to release the bridge windows and attempt to assigned
them again with the different size.

If SR-IOV is enabled, disallow resize as it requires releasing also IOV
resources.

Link: https://lore.kernel.org/r/20250320142837.8027-1-ilpo.jarvinen@linux.intel.com
Fixes: 91fa127794ac ("PCI: Expose PCIe Resizable BAR support via sysfs")
Reported-by: Michał Winiarski <michal.winiarski@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index b46ce1a2c5542..0e7eb2a42d88d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1556,7 +1556,7 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 		return -EINVAL;
 
 	device_lock(dev);
-	if (dev->driver) {
+	if (dev->driver || pci_num_vf(pdev)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
@@ -1578,7 +1578,7 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 
 	pci_remove_resource_files(pdev);
 
-	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
 		if (pci_resource_len(pdev, i) &&
 		    pci_resource_flags(pdev, i) == flags)
 			pci_release_resource(pdev, i);
-- 
2.39.5



