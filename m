Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551B1B21B5;
	Mon, 23 Dec 2024 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970275; cv=none; b=Ns+i4UeZIhjStw6Khxy06mJtLyskxcgnXiUjer3Pr1dvkixlPiyFjcVxlKNeLh2i1XbwzR5VeFAxSkkFm6pVdn/8r6G+x/8bukS58GaOfFmN7S7xkEbBBNVPmpcL86PdBxW1UH6dXBL0mzhri296I4rpgZDXxU5KtpiIPYqsYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970275; c=relaxed/simple;
	bh=EDrgD27exHzjCPgtENLK/UlyXQcHwBSLV6ACZYMceE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az9wxEiiXADXWq5pv++GHFclbbcIU4Sjmt4lFpWK9vIBYNy7JJA71lHd+NfKb1iWTbNs9hb5KEvhZBRZ/jY6ctpcyDHnAdcIe+/iJNMtpCJVT0ZbeTVJuDGVYaeTA0BLz4jMZv4EsIYS56FFOV69bzWeUGteXo2ENOtlnbBJyKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haV6SZAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haV6SZAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EE0C4CED3;
	Mon, 23 Dec 2024 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970275;
	bh=EDrgD27exHzjCPgtENLK/UlyXQcHwBSLV6ACZYMceE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haV6SZASZIvFESUqNg8ITY+UBGPIyPdv39+evLy72XaboXipakoo2RQJR2rBFOsM8
	 SZei7u0Hsuaoz+r7c4N/4bCoyGAgFNZIitNAEZ5YPuNq5517D/XJS1cS4Le27FEUEM
	 +q+xkPa7gOyebJA5KsFZ4shBrQFMUQgTolAwaBRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/116] PCI: Use preserve_config in place of pci_flags
Date: Mon, 23 Dec 2024 16:57:59 +0100
Message-ID: <20241223155359.903141493@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 7246a4520b4bf1494d7d030166a11b5226f6d508 ]

Use preserve_config in place of checking for PCI_PROBE_ONLY flag to enable
support for "linux,pci-probe-only" on a per host bridge basis.

This also obviates the use of adding PCI_REASSIGN_ALL_BUS flag if
!PCI_PROBE_ONLY, as pci_assign_unassigned_root_bus_resources() takes care
of reassigning the resources that are not already claimed.

Link: https://lore.kernel.org/r/20240508174138.3630283-5-vidyas@nvidia.com
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-host-common.c |  4 ----
 drivers/pci/probe.c                      | 20 +++++++++-----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/pci-host-common.c b/drivers/pci/controller/pci-host-common.c
index 6be3266cd7b5..e2602e38ae45 100644
--- a/drivers/pci/controller/pci-host-common.c
+++ b/drivers/pci/controller/pci-host-common.c
@@ -73,10 +73,6 @@ int pci_host_common_probe(struct platform_device *pdev)
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
-	/* Do not reassign resources if probe only */
-	if (!pci_has_flag(PCI_PROBE_ONLY))
-		pci_add_flags(PCI_REASSIGN_ALL_BUS);
-
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->msi_domain = true;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 03b519a22840..7e84e472b338 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3096,20 +3096,18 @@ int pci_host_probe(struct pci_host_bridge *bridge)
 
 	bus = bridge->bus;
 
+	/* If we must preserve the resource configuration, claim now */
+	if (bridge->preserve_config)
+		pci_bus_claim_resources(bus);
+
 	/*
-	 * We insert PCI resources into the iomem_resource and
-	 * ioport_resource trees in either pci_bus_claim_resources()
-	 * or pci_bus_assign_resources().
+	 * Assign whatever was left unassigned. If we didn't claim above,
+	 * this will reassign everything.
 	 */
-	if (pci_has_flag(PCI_PROBE_ONLY)) {
-		pci_bus_claim_resources(bus);
-	} else {
-		pci_bus_size_bridges(bus);
-		pci_bus_assign_resources(bus);
+	pci_assign_unassigned_root_bus_resources(bus);
 
-		list_for_each_entry(child, &bus->children, node)
-			pcie_bus_configure_settings(child);
-	}
+	list_for_each_entry(child, &bus->children, node)
+		pcie_bus_configure_settings(child);
 
 	pci_bus_add_devices(bus);
 	return 0;
-- 
2.39.5



