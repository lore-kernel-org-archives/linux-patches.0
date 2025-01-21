Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3421F666B;
	Tue, 21 Jan 2025 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483095; cv=none; b=CfsSd7n3kbQWCJzHYc7Io7ZqCAn2pOgQOCaMCGLs2S4shcZhpWzTy/RYiomOQLfPZduzM/UjFnjYUAzAhcULqVGR1AVXjFKeShSKyOadC18dHup23TNfIQtoOoQmc2FNR8wHe+bfLM0iNqLj4NuSafSZ7501WX75bxkHRzsYfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483095; c=relaxed/simple;
	bh=vn43Tvul0CSMqpWhiigG/zArpl7SKIUvbILHgn1OLL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnhgUzG1Z/q4iSFk8AZj/rgYMcTmg3endKeh8Z3B8tF3A3++VGvgkjhTqKbOyKhojGzqp1ZYZhPN6eyTa/Eh9DEURjTxJQSCQix6etvkLBh7hsNa+Z7jVe3YZc+GCZvW2MMj3rF3C3j7cNxKUgdaP5zS6R7cxjQOg8UYvtwCgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oy0HmJF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oy0HmJF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EEC4CEDF;
	Tue, 21 Jan 2025 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483095;
	bh=vn43Tvul0CSMqpWhiigG/zArpl7SKIUvbILHgn1OLL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy0HmJF/CRmmeXn81DhPlKhNDswf0ic1FscfN/SXdsuSl/LhlLAcpmOlEtWphEp/c
	 R4njFW4dlRPmsibM1i5BSWoSSySvD6otXhggxXxs/v0pUSJxPw/zBb7WnVvRU5suQs
	 tFMVISuFB3T45U9awk2cT0ISe+1LBXjf1XIRMRCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>
Subject: [PATCH 5.15 115/127] Revert "PCI: Use preserve_config in place of pci_flags"
Date: Tue, 21 Jan 2025 18:53:07 +0100
Message-ID: <20250121174534.079239702@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

This reverts commit c1a1393f7844c645389e5f1a3f1f0350e0fb9316 which is
commit 7246a4520b4bf1494d7d030166a11b5226f6d508 upstream.

This patch causes a regression in cuttlefish/crossvm boot on arm64.

The patch was part of a series that when applied will not cause a regression
but this patch was backported to the 5.15 branch by itself.

The other patches do not apply cleanly to the 5.15 branch.

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
@@ -3048,18 +3048,20 @@ int pci_host_probe(struct pci_host_bridg
 
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


