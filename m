Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DC29ACCD;
	Sat, 14 Feb 2026 21:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104409; cv=none; b=Ke0KoQo2agkE9woh+BmTPdXCUhUeeYEz/DHXqI7MdVPZMRgWJN65o+LfqlAgSGCIWKneGrDVpAwBLsn3MWXrv5ONaqx9b5wQeMfFJxWfBj9Q9VzFVobPT3KA9MnKvYQSb1+1cyGfynwm4agLRs3rVJ/eB8++8T3008lbhcaHJvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104409; c=relaxed/simple;
	bh=dm92s9uuRZ2z5LFgepcQwNGiVK+zDhDUsX9U12FpVyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bv2eb8tQgjxtJ7aYwk64+/Mjm8cEAZMzVlRHu3lVj+zO1ZW3afuXja4ItmHX48GZmaVkycpCifVd/9bi4154od2//aCB8MFMhtbY3OhoPu95KE3i58rMCWbbmlEhE76yaH/dwHhq0TxmxHKCWl5CIl9GOLMIQpoPGbk3SUVOVYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXW3nM/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXW3nM/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCA3C16AAE;
	Sat, 14 Feb 2026 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104408;
	bh=dm92s9uuRZ2z5LFgepcQwNGiVK+zDhDUsX9U12FpVyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXW3nM/dIPvdGrayzmLBZiaRMT8q9t+OW0lHuSRWiEdDcGEInlsOM4ttl32jpnPbX
	 yV4E6Y0yA2ZHVDboa4iu3txUIW2uXOXXMm3LVfCxaNh5E2Tk+2px65Dl/y3DenUa40
	 HtysWwaPuNwhbLAInq2kjWHFEb6oFQrulWXjOnWTFravSQ/aUg2XE2y7hq7FZjhhtb
	 dr7NbChIchDtP0tqSlIRi9XAyExaKMEn5doAAvtzhMapldKfWL2NwTrNGlBXTBZu1W
	 kq42MVab7I/FFsOk0c7HPEbeBUVrPArF8JCvcIJlcZ4dp3yRHBlFYRbJGTwf4u21t6
	 /GFVhgVJ2/AuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] PCI: Enable ACS after configuring IOMMU for OF platforms
Date: Sat, 14 Feb 2026 16:23:33 -0500
Message-ID: <20260214212452.782265-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
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

LLM Generated explanations, may be completely bogus:

The commit under review builds on the existing `pci_enable_acs()`
infrastructure. The key dependency is on `f3c3ccc4fe49d` ("PCI: Fix
pci_enable_acs() support for the ACS quirks") from v6.12 era, which
restructured `pci_enable_acs()` and `pci_dev_specific_enable_acs()`. The
code structure in the diff matches what's in current mainline,
suggesting this applies to the current code layout which includes the
ACS refactoring from 6.11/6.12.

### 6. STABLE KERNEL ASSESSMENT

**Meets stable criteria:**
- **Fixes a real bug**: ACS not being enabled on the first PCI device on
  OF platforms
- **Obviously correct**: Simply moves a function call to after its
  dependency is satisfied
- **Small and contained**: ~30 lines changed across 3 files, all in PCI
  subsystem
- **No new features**: Just reorders existing functionality
- **Tested**: Two Tested-by tags
- **Written by subsystem experts**: PCI maintainer involvement

**Concerns:**
- The commit depends on the `pci_enable_acs()` refactoring from
  `47c8846a49ba` ("PCI: Extend ACS configurability") and its fix
  `f3c3ccc4fe49d`. These are from v6.11/v6.12 timeframe, so they should
  be in recent stable trees but may not be in older LTS trees (5.15,
  5.10). The backport would need to be adapted for trees where
  `pci_enable_acs()` has a different structure.
- For recent stable trees (6.6+, 6.12+) this should apply cleanly or
  with minor adjustments.

### 7. CONCLUSION

This is a real bug fix for OF/DT platforms where ACS is never enabled on
the first PCI device (Root Port). This impacts IOMMU isolation, device
passthrough, and security. The fix is small, surgical, well-understood,
and tested. It moves an existing function call to the correct point in
the initialization sequence. The risk is low — the function is
idempotent and the change doesn't alter any logic, only timing.

The primary concern is dependency on ACS refactoring in newer kernels,
but for stable trees that have that infrastructure, this is a clear
backport candidate.

**YES**

 drivers/pci/pci-driver.c |  8 ++++++++
 drivers/pci/pci.c        | 10 +---------
 drivers/pci/pci.h        |  1 +
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7c2d9d5962586..301a9418e38e0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1650,6 +1650,14 @@ static int pci_dma_configure(struct device *dev)
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
index b99ad5f50f30d..479887ece9e7a 100644
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
@@ -3648,14 +3648,6 @@ bool pci_acs_path_enabled(struct pci_dev *start,
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
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0e67014aa0013..4592ede0ebcc6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -939,6 +939,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 }
 
 void pci_acs_init(struct pci_dev *dev);
+void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
-- 
2.51.0

