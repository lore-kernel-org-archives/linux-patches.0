Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC12EBB8C;
	Mon, 13 Apr 2026 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097100; cv=none; b=YpChYke9TlxbvaUTpq910cMr06pMbg4TJPgH8j5ElWTkSlT30tpT2bl6zxkF4PFM0upJudQdJoWpDi3ojZwRAY+SExlPRueJxpvbxsPMc5nKI9qzmJXaJjuIoCFiMmzZbIIvwu6HlrBwUYjMYlru4gRrTZBDWIYzezdGyFdsbuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097100; c=relaxed/simple;
	bh=iZiZTWguWpIhP6O74iW4SP/58ORmlvHNlGQ+5lQCbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqANDV7lpSj/1q+LQ7+HLvK+4Pf8zDNgwoeh9lbFlIT5z/hFFF2/YCyF30DDLq/7aQ6sO8OSVa5GvlP+FnDQcAOizFUgW0VZA6qw8CoJi6wT8mpj34kU4IOOz3H5kSw3/jHp2LuBdX5vOhhJ70cTENJ2jrRyC+wcPdpfpMgMwEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcZccmc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcZccmc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723D1C2BCAF;
	Mon, 13 Apr 2026 16:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097100;
	bh=iZiZTWguWpIhP6O74iW4SP/58ORmlvHNlGQ+5lQCbsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcZccmc981eHTTAu6topCy1T6tyXSWbdGP1EwMVUpMIm8P3oj5J1XXGTAT/J5r5jR
	 iRyxqU4NhUs9/1c6EEbGb/NMiq/McRJdiohs2yfU12k/bGxJUe0I3qHgi9I372woV7
	 BN9Ac7b2Wv8yyDhIsP/5fe+llsrtYqYXEbvylo4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hancock <john@kernel.doghat.io>,
	bjorn.forsman@gmail.com,
	Linux kernel regressions list <regressions@lists.linux.dev>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.1 55/55] Revert "PCI: Enable ACS after configuring IOMMU for OF platforms"
Date: Mon, 13 Apr 2026 18:01:29 +0200
Message-ID: <20260413155726.884698810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

This reverts commit 5d57164c0ab0ac5c99eca49c577994bfbca70a2a which is
commit c41e2fb67e26b04d919257875fa954aa5f6e392e upstream.

The original commit attempted to enable ACS in pci_dma_configure() prior
to IOMMU group assignment in iommu_init_device() to fix the ACS enablement
issue for OF platforms. But that assumption doesn't hold true for kernel
versions prior to v6.15, because on these older kernels,
pci_dma_configure() is called *after* iommu_init_device(). So the IOMMU
groups are already created before the ACS gets enabled. This causes the
devices that should have been split into separate groups by ACS, getting
merged into one group, thereby breaking the IOMMU isolation as reported on
the AMD machines.

So revert the offending commit to restore the IOMMU group assignment on
those affected machines. It should be noted that ACS has never really
worked on kernel versions prior to v6.15, so the revert doesn't make any
difference for OF platforms.

Reported-by: John Hancock <john@kernel.doghat.io>
Reported-by: bjorn.forsman@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221234
Fixes: b20b659c2c6a ("PCI: Enable ACS after configuring IOMMU for OF platforms")
Cc: Linux kernel regressions list <regressions@lists.linux.dev>
Link: https://lore.kernel.org/regressions/2c30f181-ffc6-4d63-a64e-763cf4528f48@leemhuis.info
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |    8 --------
 drivers/pci/pci.c        |   10 +++++++++-
 drivers/pci/pci.h        |    1 -
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1667,14 +1667,6 @@ static int pci_dma_configure(struct devi
 		ret = acpi_dma_configure(dev, acpi_get_dma_attr(adev));
 	}
 
-	/*
-	 * Attempt to enable ACS regardless of capability because some Root
-	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
-	 * the standard ACS capability but still support ACS via those
-	 * quirks.
-	 */
-	pci_enable_acs(to_pci_dev(dev));
-
 	pci_put_host_bridge_device(bridge);
 
 	if (!ret && !driver->driver_managed_dma) {
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1040,7 +1040,7 @@ static void pci_std_enable_acs(struct pc
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
  */
-void pci_enable_acs(struct pci_dev *dev)
+static void pci_enable_acs(struct pci_dev *dev)
 {
 	if (!pci_acs_enable)
 		goto disable_acs_redir;
@@ -3777,6 +3777,14 @@ bool pci_acs_path_enabled(struct pci_dev
 void pci_acs_init(struct pci_dev *dev)
 {
 	dev->acs_cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
+
+	/*
+	 * Attempt to enable ACS regardless of capability because some Root
+	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
+	 * the standard ACS capability but still support ACS via those
+	 * quirks.
+	 */
+	pci_enable_acs(dev);
 }
 
 /**
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -526,7 +526,6 @@ static inline resource_size_t pci_resour
 }
 
 void pci_acs_init(struct pci_dev *dev);
-void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);


