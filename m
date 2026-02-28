Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17949341050
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301133; cv=none; b=Pl8YynXZbMXWpe+NnrV0ZoFsRr53OsVByUWP5EgvcoSDBaX3RofL4ZBjY2JiAc/OsiU1wEVxQEO0O0d+0Xg9attYcXmUWlkR6wz3cnnxryvJFiaPKQhoj3Lr2z4jsREWYPUZaXRSoeV8COZzq4bN/l4uJxC5+f8hqzGVLaXbA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301133; c=relaxed/simple;
	bh=SI7QfBU4qh1aZxbFLkTGq6adNbVFpJRBlmsQP2G8vJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYURYo06aa5lq/r8mpYs9/JXNTdEhzslFZKawovKOpgGCyzK6+UnlBU3S8lqvWbRPsfW+qH3UQsvXIODm9obni7IbulsmFWIb86iSBL3Uips1WqVRZ3l5kRT5DsHUsMblF/iipYgV6shkfFcoOT/uhow+qhgJ4fgEptpmh9GZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XuzwCJXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XuzwCJXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C60C19424;
	Sat, 28 Feb 2026 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301133;
	bh=SI7QfBU4qh1aZxbFLkTGq6adNbVFpJRBlmsQP2G8vJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuzwCJXJGx37rV/HcJBLIKz5SPUkGzDUbXWaMAOqn1Rwe5izD2T4JZA0CMpQk+OT1
	 ZCKgQ+zUhtrXa3ewQGu5L6afhgBpcFaWZqI1xhSRNmIlOgzXD+edCGbcQYImza+xO2
	 NCPeXb59uU9jrxNPar542TUBMhb6/zDjD0gu7MX0w+if3dQLzU9u6Xm7HnivdkvVHZ
	 12XoWDgfVEc06ACCjIB8FmDc8wCqnOhbxJAf+xh/5DiA+THebTIcXxCSIzzgJBbaTv
	 gUFMvE8ubzY8aQZpQDjnu+oNw2dFv37rJmKg4qtrczPgy2ISh9l6321xfKQV5Fupa2
	 IbP0syC6ONgWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/752] PCI: Enable ACS after configuring IOMMU for OF platforms
Date: Sat, 28 Feb 2026 12:40:03 -0500
Message-ID: <20260228174750.1542406-292-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit c41e2fb67e26b04d919257875fa954aa5f6e392e ]

Platform, ACPI, or IOMMU drivers call pci_request_acs(), which sets
'pci_acs_enable' to request that ACS be enabled for any devices enumerated
in the future.

OF platforms called pci_enable_acs() for the first device before
of_iommu_configure() called pci_request_acs(), so ACS was never enabled for
that device (typically a Root Port).

Call pci_enable_acs() later, from pci_dma_configure(), after
of_dma_configure() has had a chance to call pci_request_acs().

Here's the call path, showing the move of pci_enable_acs() from
pci_acs_init() to pci_dma_configure(), where it always happens after
pci_request_acs():

    pci_device_add
      pci_init_capabilities
        pci_acs_init
 -        pci_enable_acs
 -          if (pci_acs_enable)                <-- previous test
 -            ...
      device_add
        bus_notify(BUS_NOTIFY_ADD_DEVICE)
          iommu_bus_notifier
            iommu_probe_device
              iommu_init_device
                dev->bus->dma_configure
                  pci_dma_configure            # pci_bus_type.dma_configure
                    of_dma_configure
                      of_iommu_configure
                        pci_request_acs
                          pci_acs_enable = 1   <-- set
 +                  pci_enable_acs
 +                    if (pci_acs_enable)      <-- new test
 +                      ...
        bus_probe_device
          device_initial_probe
            ...
              really_probe
                dev->bus->dma_configure
                  pci_dma_configure            # pci_bus_type.dma_configure
                    ...
                      pci_enable_acs

Note that we will now call pci_enable_acs() twice for every device, first
from the iommu_probe_device() path and again from the really_probe() path.
Presumably that's not an issue since we also call dev->bus->dma_configure()
twice.

For the ACPI platforms, pci_request_acs() is called during ACPI
initialization time itself, independent of the IOMMU framework.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://patch.msgid.link/20260102-pci_acs-v3-1-72280b94d288@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c |  8 ++++++++
 drivers/pci/pci.c        | 10 +---------
 drivers/pci/pci.h        |  1 +
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 327b21c48614d..b4111c92c9572 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1652,6 +1652,14 @@ static int pci_dma_configure(struct device *dev)
 		ret = acpi_dma_configure(dev, acpi_get_dma_attr(adev));
 	}
 
+	/*
+	 * Attempt to enable ACS regardless of capability because some Root
+	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
+	 * the standard ACS capability but still support ACS via those
+	 * quirks.
+	 */
+	pci_enable_acs(to_pci_dev(dev));
+
 	pci_put_host_bridge_device(bridge);
 
 	/* @drv may not be valid when we're called from the IOMMU layer */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 31d443f819a7c..d147e412668bf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1015,7 +1015,7 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
  */
-static void pci_enable_acs(struct pci_dev *dev)
+void pci_enable_acs(struct pci_dev *dev)
 {
 	struct pci_acs caps;
 	bool enable_acs = false;
@@ -3677,14 +3677,6 @@ bool pci_acs_path_enabled(struct pci_dev *start,
 void pci_acs_init(struct pci_dev *dev)
 {
 	dev->acs_cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
-
-	/*
-	 * Attempt to enable ACS regardless of capability because some Root
-	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
-	 * the standard ACS capability but still support ACS via those
-	 * quirks.
-	 */
-	pci_enable_acs(dev);
 }
 
 void pci_rebar_init(struct pci_dev *pdev)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 565acfcd7cdb1..36cf1ffb2023c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -920,6 +920,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 }
 
 void pci_acs_init(struct pci_dev *dev);
+void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
-- 
2.51.0

