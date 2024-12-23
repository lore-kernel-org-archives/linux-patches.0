Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C355019E98B;
	Mon, 23 Dec 2024 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970658; cv=none; b=eIcqQPbM9TrjOX3eKxiRnkKAnOz4MmPl52TYqWkvY699/8koxcAoiuMNpjdSDHaIV/4e8wlLbIRXd/uEZrk6WiMjHi59IhBnP520QNnIlk77JgsnkZ+V1LC5qZAIDE6D237+VAKmxHd/8+woCbIuXHFNCw0Fvr6eG7AEsHc10XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970658; c=relaxed/simple;
	bh=zA6Lf710iUsYQFFrOP+Z7wtSuMrJP7lJUDlUKsZXESY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncNUs93kDSjx350NLTfIbvoIbUmvNeVuPugN+guseY3WH/1b3Ubeazg+FM7ekF/BMxBj1sguzLwlpKLOnS7hK4wx4e8pqxWjm7dB3vfpOrumS6+zAPLjjGyr3kcZghs4EYpvYRWBvXD6+lGenpvGzfc6LtIXQFsHegtD3+92nww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/5MP5/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/5MP5/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31431C4CED3;
	Mon, 23 Dec 2024 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970658;
	bh=zA6Lf710iUsYQFFrOP+Z7wtSuMrJP7lJUDlUKsZXESY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/5MP5/QBL0b9T8l4pV1SI6r4cL8NcLHQqD4SKw//fzE2ijIC9bYzFi5BWJAYfHxK
	 rsYJVsYLUnIdo3TYdu6nKY76XvJtohSt36cyUxecxDrmKzZiuCWvM89UUY0Jv4kEOG
	 ItWcT5YfaST2SrdgUfsb4+1xbz5pzRbWTI/cye2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/83] PCI: Use preserve_config in place of pci_flags
Date: Mon, 23 Dec 2024 16:58:42 +0100
Message-ID: <20241223155353.776934002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3924a44db02..fd3020a399cf 100644
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
index 5c1ab9ee65eb..fbb47954a96c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3082,20 +3082,18 @@ int pci_host_probe(struct pci_host_bridge *bridge)
 
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



