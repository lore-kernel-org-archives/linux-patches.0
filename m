Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48561F5439;
	Tue, 21 Jan 2025 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482715; cv=none; b=kdKd3/rI2tTu1iME8JSdtiAoB2dN7y/StUvZWzVTK1yfTBvfmWhotPM0s8qjZ4osYlRfyDgyCpWQ+US9GzmtqdE4mvrgqVYivbKtPAzmBa460+AyCmPiYA/UIw5eYRlp/6WMsZ+jR345qCqdksKPJnVNSFGPE78Jk9Ka513oBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482715; c=relaxed/simple;
	bh=Pu/MUSER2zQSWOEJoRq4dXAmZiKAoQ5SwA0f4Kkla5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXLNO/swegC7Cuxr9eVSobYcTJurbIrIZJc43qubQoPo5xFYisZqSx3of3in9wRftpzYPXeoy5d/dWsZWLtOne03LK1xztsqJCLuFMY5Lfyh7xxMqNnzGpZaUJBaa6V07VrtA6zdzczx69JfahSDSUQ3oztG5rng7IGEfUHL6n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKgf9v6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKgf9v6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E728C4CEDF;
	Tue, 21 Jan 2025 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482715;
	bh=Pu/MUSER2zQSWOEJoRq4dXAmZiKAoQ5SwA0f4Kkla5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKgf9v6a4kIJvJro3qzax9RYxlMyKaKNFcF1zarmbZ9MSLnIPG9372EvnhWsEFO5r
	 PhD62dKn5QZ4Om0CUKVy/tXDy96h0NSF42kJtqQp5q3bLCbhnrDwCXCnIM2t27MG8W
	 MKHgvFe5neWPlX1ofbMLFbTmoT8nPoDsNJ/829o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>
Subject: [PATCH 6.1 48/64] Revert "PCI: Use preserve_config in place of pci_flags"
Date: Tue, 21 Jan 2025 18:52:47 +0100
Message-ID: <20250121174523.384995870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

This reverts commit f858b0fab28d8bc2d0f0e8cd4afc3216f347cfcc which is
commit 7246a4520b4bf1494d7d030166a11b5226f6d508 upstream.

This patch causes a regression in cuttlefish/crossvm boot on arm64.

The patch was part of a series that when applied will not cause a regression
but this patch was backported to the 6.1 branch by itself.

The other patches do not apply cleanly to the 6.1 branch.

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
@@ -3082,18 +3082,20 @@ int pci_host_probe(struct pci_host_bridg
 
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


