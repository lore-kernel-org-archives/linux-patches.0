Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F2269825;
	Tue,  8 Apr 2025 12:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114448; cv=none; b=ebi/4/2JP2BN8jDqAStZb/haw4kTK/kDXQm0w6R0gvUYSxR6jjTZUvC3ihU9YaHw5w5YtwDXfEbuj8/K6Fe0v0XTbAZWJUALXuasJoKPiX5BAoNt91VK+XhV6SSKrKdTPTmmbU/9ugEgNXMKg/5v2RrdFVUEw88sdHxS2V+c4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114448; c=relaxed/simple;
	bh=LoQpP9Hv1XHUCBEH5FLXvzXXa6lVN4ThlNzQHdL+TZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyO53ZQO8Dj0YAJR6bL4nJnXDPe4a/K4HqsSeUnyFdB3wMCBVadEaw0os5iKsLb1LM90BbdKlhFqPCvnNJEhOKXBEhuynjbPRFgR0IUPsniwAH2XoP+HUzgfY5DQEAtPSWJyabKeZpQP7eDSkOBf5Rfm2/XcN2fTyVmaW9GDDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeY4cU1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeY4cU1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440F4C4CEE5;
	Tue,  8 Apr 2025 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114447;
	bh=LoQpP9Hv1XHUCBEH5FLXvzXXa6lVN4ThlNzQHdL+TZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeY4cU1Gg3lKEhwXbdrXh1uaMMSHB6wfhI3wyfOtN+N4e8zTKckgcf729Ij8isCMD
	 e7zgixrcaFINUQN5EhXXWL5xmRa2RvU3aA9PMQ16d23V8q2sjhzmltw/qjQweeHSv3
	 K3SPjBI/YhtDIa56JrI0Yn58e4BcNt11xf7pL62k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 110/499] PCI: Fix BAR resizing when VF BARs are assigned
Date: Tue,  8 Apr 2025 12:45:22 +0200
Message-ID: <20250408104853.947512814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 7679d75d71e53..ab54c92c34353 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1448,7 +1448,7 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 		return -EINVAL;
 
 	device_lock(dev);
-	if (dev->driver) {
+	if (dev->driver || pci_num_vf(pdev)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
@@ -1470,7 +1470,7 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 
 	pci_remove_resource_files(pdev);
 
-	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
 		if (pci_resource_len(pdev, i) &&
 		    pci_resource_flags(pdev, i) == flags)
 			pci_release_resource(pdev, i);
-- 
2.39.5



