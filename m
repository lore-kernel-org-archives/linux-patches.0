Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3D71F542C;
	Tue, 21 Jan 2025 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482178; cv=none; b=uycMPXnwoSyXnmLVFm5RZX2hRbG1+BgTfe+u9CG6IqyPx+9YRNTmzEzqtSas+2O8icXaNIfzxkYQ5OJeZJ8dB/EQKJBJ/ZO0M9IQb9+bHBuDeM18jbf8ekPLPBXy+BzmOjUv0i6CzzSsrYEO7TCrzgVM2oEeVrX4PrXq0J42qac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482178; c=relaxed/simple;
	bh=bT3Z/vurvBSRBkATLZqQcYTL+WvUSvl3kyuBOIANy04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7LjZOR210fQB7I3UTACOYkaGx3QIaoGI8kwd1wUi6atAB7xWN8Jdjg9QyJegF6i+uOSkkJBTRMdQbDGTay9M7rPFxz1Donlj4swtlbSbmSNJpOK8ga9dCw+pjTLj5V7hE6phgzz495uBFo70makvvYKnLRtqO7CXzEOX1g0+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZLrnFJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZLrnFJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8693C4CEDF;
	Tue, 21 Jan 2025 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482178;
	bh=bT3Z/vurvBSRBkATLZqQcYTL+WvUSvl3kyuBOIANy04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZLrnFJxaN/S07FiPK3YZYKXZB0zhfJdqNryK62vMzprEhDe5Bhtsa8S6kxntv9aV
	 xp5w2j7LElDSOUoUlSoZm9hFJJbbJA7Hve5CC1N5NuGeTY4GOpejgTqxAmJsjos3IE
	 qou9vVevbGjZQ14kRtvz094EUTFmVgst209it2UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>
Subject: [PATCH 6.6 61/72] Revert "PCI: Use preserve_config in place of pci_flags"
Date: Tue, 21 Jan 2025 18:52:27 +0100
Message-ID: <20250121174525.783130583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

From: Terry Tritton <terry.tritton@linaro.org>

This reverts commit 3e221877dd92dfeccc840700868e7fef2675181b which is
commit 7246a4520b4bf1494d7d030166a11b5226f6d508 upstream.

This patch causes a regression in cuttlefish/crossvm boot on arm64.

The patch was part of a series that when applied will not cause a regression
but this patch was backported to the 6.6 branch by itself.

The other patches do not apply cleanly to the 6.6 branch.

Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-host-common.c |    4 ++++
 drivers/pci/probe.c                      |   20 +++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/pci/controller/pci-host-common.c
+++ b/drivers/pci/controller/pci-host-common.c
@@ -73,6 +73,10 @@ int pci_host_common_probe(struct platfor
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
+	/* Do not reassign resources if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->msi_domain = true;
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3096,18 +3096,20 @@ int pci_host_probe(struct pci_host_bridg
 
 	bus = bridge->bus;
 
-	/* If we must preserve the resource configuration, claim now */
-	if (bridge->preserve_config)
-		pci_bus_claim_resources(bus);
-
 	/*
-	 * Assign whatever was left unassigned. If we didn't claim above,
-	 * this will reassign everything.
+	 * We insert PCI resources into the iomem_resource and
+	 * ioport_resource trees in either pci_bus_claim_resources()
+	 * or pci_bus_assign_resources().
 	 */
-	pci_assign_unassigned_root_bus_resources(bus);
+	if (pci_has_flag(PCI_PROBE_ONLY)) {
+		pci_bus_claim_resources(bus);
+	} else {
+		pci_bus_size_bridges(bus);
+		pci_bus_assign_resources(bus);
 
-	list_for_each_entry(child, &bus->children, node)
-		pcie_bus_configure_settings(child);
+		list_for_each_entry(child, &bus->children, node)
+			pcie_bus_configure_settings(child);
+	}
 
 	pci_bus_add_devices(bus);
 	return 0;


