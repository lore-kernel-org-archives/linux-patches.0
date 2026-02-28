Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8138CFFE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302139; cv=none; b=IiiFNyRejiicsJO0loc9YzItmLrkrJCpt9w9LHKYqkbzMTBuyzbc8a7EKiiK9qXP+sxN6rqTb0jWojCufgvXQpLrmohGcrmq1Hs5IY/I8BLFmkwA8coXKa12W1Ejqu0rApCcD7kSeD3/BM7gkTjNjkSDaP3uDGi5zIB4m2Px66M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302139; c=relaxed/simple;
	bh=ju1Ois66013KtE8MyIs78+94ws/MnuUEVbdU3eemD4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avWL1hhvFWglfeIcYjOGln5qpKQc8fP1K9XyGdPCagDNs/LauJ+98s3X+knLo27RuTVWvIDt8y/YaGMGm+uw/AEkPJnngeP7C5bCDtugH2N3idEpoN1NgfmYQ6/uX8IZSOljc5TGcnPZqxOGznV8erG38BvlTC9r7tOncJbPe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dm3cGLRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dm3cGLRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E290C19423;
	Sat, 28 Feb 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302139;
	bh=ju1Ois66013KtE8MyIs78+94ws/MnuUEVbdU3eemD4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm3cGLRw2VyLcKC4uyKZEC24WshJ2+7s3A++WB23DnlpVmTbwpG0/ARagq2tXHbbl
	 MjiPa/01kT/IyB+WZyK3eZ8UmPWXEOQHMcfpT7DaZ10u9xn2Vu1rrjG1tN53YlLAuw
	 zZaAPOrW2c6SSiTp3flbFy+Rk1HHR9VoLxko6cKvDcjozWh6zxHqOqo6XtbvAdp2+j
	 KhN4PdWG84a/0kZ4WIVMp9PIj+NgbLm9+bBezj1NA6PycZhz1RJBZwDvcKyi/DExFx
	 /tu6GOTv9lSNCMXztlplNtSVViTJCo8TW76CkL4kK/1j1Qyaoi57vXknsGpDR/TyS7
	 QDkMCe1CGyUTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/283] PCI: Log bridge windows conditionally
Date: Sat, 28 Feb 2026 13:04:34 -0500
Message-ID: <20260228180709.1583486-132-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 63c6ebb294b7c708cc987d621e59499686650683 ]

Previously pci_read_bridge_io(), pci_read_bridge_mmio(), and
pci_read_bridge_mmio_pref() unconditionally logged the bridge window
resource.  A future change will call these functions earlier and more
often.  Add a "log" parameter so callers can control whether to generate
the log message.  No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a91ac2faf9a90..f7b01cddf5abf 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -344,7 +344,8 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-static void pci_read_bridge_io(struct pci_dev *dev, struct resource *res)
+static void pci_read_bridge_io(struct pci_dev *dev, struct resource *res,
+			       bool log)
 {
 	u8 io_base_lo, io_limit_lo;
 	unsigned long io_mask, io_granularity, base, limit;
@@ -377,11 +378,13 @@ static void pci_read_bridge_io(struct pci_dev *dev, struct resource *res)
 		region.start = base;
 		region.end = limit + io_granularity - 1;
 		pcibios_bus_to_resource(dev->bus, res, &region);
-		pci_info(dev, "  bridge window %pR\n", res);
+		if (log)
+			pci_info(dev, "  bridge window %pR\n", res);
 	}
 }
 
-static void pci_read_bridge_mmio(struct pci_dev *dev, struct resource *res)
+static void pci_read_bridge_mmio(struct pci_dev *dev, struct resource *res,
+				 bool log)
 {
 	u16 mem_base_lo, mem_limit_lo;
 	unsigned long base, limit;
@@ -396,11 +399,13 @@ static void pci_read_bridge_mmio(struct pci_dev *dev, struct resource *res)
 		region.start = base;
 		region.end = limit + 0xfffff;
 		pcibios_bus_to_resource(dev->bus, res, &region);
-		pci_info(dev, "  bridge window %pR\n", res);
+		if (log)
+			pci_info(dev, "  bridge window %pR\n", res);
 	}
 }
 
-static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res)
+static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res,
+				      bool log)
 {
 	u16 mem_base_lo, mem_limit_lo;
 	u64 base64, limit64;
@@ -446,7 +451,8 @@ static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res)
 		region.start = base;
 		region.end = limit + 0xfffff;
 		pcibios_bus_to_resource(dev->bus, res, &region);
-		pci_info(dev, "  bridge window %pR\n", res);
+		if (log)
+			pci_info(dev, "  bridge window %pR\n", res);
 	}
 }
 
@@ -518,9 +524,9 @@ void pci_read_bridge_bases(struct pci_bus *child)
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
 
-	pci_read_bridge_io(child->self, child->resource[0]);
-	pci_read_bridge_mmio(child->self, child->resource[1]);
-	pci_read_bridge_mmio_pref(child->self, child->resource[2]);
+	pci_read_bridge_io(child->self, child->resource[0], true);
+	pci_read_bridge_mmio(child->self, child->resource[1], true);
+	pci_read_bridge_mmio_pref(child->self, child->resource[2], true);
 
 	if (dev->transparent) {
 		pci_bus_for_each_resource(child->parent, res) {
-- 
2.51.0

