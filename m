Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62F31E522;
	Thu, 30 Jan 2025 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247236; cv=none; b=I8ZKEZvoNy++5dx5O4cew77tGEK+T8CCorPX/aKTgEcf68Pemmi+MnzH698m7AQk/QI7HtrcN2pPkoFGK4wPdo8CSVbCThIWr7BJA5I1zBZhjURge80dvA1mDhIDOQdJubvp2ZIyDH1QmoqfUJGF8uuWhTHcNj5tE1sKQSBl66w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247236; c=relaxed/simple;
	bh=D5mSuqxdK+vyi49Ww1+I7DMzuXmV9hoba5atpKYK2wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkLqfcUBrVhHnrUkE95VLxIz5EvXSlel54X+xPyqP5QayVtYdz0N/wiXc1imgvH681usbHBAeT+FuHUTOv7gEVByja12hg+EJuqzcM21tS8YCZbgBoYS76IbPxQXL6KoZusypbnKKyQSPAGvkiLhjDMFbmZhF5eWLWokRGeNjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZQzYoFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZQzYoFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F3BC4CED2;
	Thu, 30 Jan 2025 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247235;
	bh=D5mSuqxdK+vyi49Ww1+I7DMzuXmV9hoba5atpKYK2wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZQzYoFBY+vdJAz+H3Fn4i7fNGxEpA3EyCuybWKu0zx13H61/qJQyOSvrlwZJ2kQ+
	 cPqvqsiHa3So5AVG3ocBa5xkfrjGdYnPAvUxh+RTdA6TMLqNfCnRVUSt4aJvkP9eCE
	 QL7b5iZTBvG/jJqGyKaDIVp9Kb7qwnPn1SIlAxpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>
Subject: [PATCH 5.10 099/133] Revert "PCI: Use preserve_config in place of pci_flags"
Date: Thu, 30 Jan 2025 15:01:28 +0100
Message-ID: <20250130140146.517696293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

This reverts commit 0dde3ae52a0dcc5cdfe2185ec58ec52b43fda22e which is
commit 7246a4520b4bf1494d7d030166a11b5226f6d508 upstream.

This patch causes a regression in cuttlefish/crossvm boot on arm64.

The patch was part of a series that when applied will not cause a regression
but this patch was backported to the 5.10 branch by itself.

The other patches do not apply cleanly to the 5.10 branch.

Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-host-common.c |    4 ++++
 drivers/pci/probe.c                      |   20 +++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/pci/controller/pci-host-common.c
+++ b/drivers/pci/controller/pci-host-common.c
@@ -71,6 +71,10 @@ int pci_host_common_probe(struct platfor
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
+	/* Do not reassign resources if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3018,18 +3018,20 @@ int pci_host_probe(struct pci_host_bridg
 
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


