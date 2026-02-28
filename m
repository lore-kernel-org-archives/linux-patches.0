Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7438F631
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302138; cv=none; b=gv6Jb30lKj4YKr7fqHjwLTg8dlCb0OMVWEd8F88oFiQyiEuei6DF6TawvMjRrOsHaOYRcSiZjAWDbHitdTkxTcbrL2ZR7Xex5FNRpMCJoLJEWuToMNTPKQ6Qh23jr0pzR6S2GkLSDBo/uZ7ww3d0MACxfOthKjzo87O3tIxvrao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302138; c=relaxed/simple;
	bh=08/eeXb2+s4Cl5mSKd9vLpcCZArgwYxs0j9VpntVyN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lb/eHA1ydt1cwjYQDpY0aQ5/Tx15/2uj0pzovRcLpruMY7u2aik8gDyMIsGvhYP2Z7Kt+Q2E5WbJ1fxlCDkMK/lfESFRGwYV/0AxmdepRakvB0tkz0AWct+87eAwg+3iHGxjH+xDnxqi5TlhEZVugZWA9jB/PKIxL4gZfejZB/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qcz+MgIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qcz+MgIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F62FC116D0;
	Sat, 28 Feb 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302138;
	bh=08/eeXb2+s4Cl5mSKd9vLpcCZArgwYxs0j9VpntVyN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qcz+MgIZuKQUCGI64kNlXjFhiRuPiV+h6SY8Ahx+E0Z1kyorTULZWw5cy4jMzJc0c
	 MCr73fijOrsTkimvJq4lu8+h6RsgxJMbHNkWNIykkmmp7IylUm0vsxr3Jbs2xDdpIU
	 /XTSlXMUtxL0Iclw0e0dsigx5NKbYFDuBeejmak08pgC7phKKSAvl+mRkVQkz3r2Kk
	 kAHc/42yCUDhelxoqC93V6/z6/55H5h6RwNhxwKW+lo5ya2DJFqqp6mt1mPoa1jca1
	 VeyzIEowN4bS1bx51LwwcAPEGfSG/5S/eOgMwc7M2W0K3rBdmG131ZaxDbPAoIi3tI
	 1tMbuY+v1BnPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/283] PCI: Supply bridge device, not secondary bus, to read window details
Date: Sat, 28 Feb 2026 13:04:33 -0500
Message-ID: <20260228180709.1583486-131-sashal@kernel.org>
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

[ Upstream commit 281e1f137a97dae4fe47a7d30635c5b83def790b ]

Previously we logged information about devices *below* the bridge before
logging information about the bridge itself, e.g.,

  pci 0000:00:01.0: [8086:1901] type 01 class 0x060400
  pci 0000:01:00.0: [10de:13b6] type 00 class 0x030200
  pci 0000:01:00.0: reg 0x10: [mem 0xec000000-0xecffffff]
  pci 0000:00:01.0: PCI bridge to [bus 01]
  pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]

This is partly because the bridge windows are read in this path:

  pci_scan_child_bus_extend
    for (devfn = 0; devfn < 256; devfn += 8)
      pci_scan_slot(bus, devfn)       # scan below bridge
    pcibios_fixup_bus(bus)
      pci_read_bridge_bases(bus)      # read bridge windows
        pci_read_bridge_io(bus)

Remove the assumption that the secondary (child) pci_bus already exists by
passing in the bridge device (instead of the pci_bus) and a resource
pointer when reading bridge windows.  A future change can use this to log
the bridge details before we enumerate the devices below the bridge.

No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a43f9e9352e47..a91ac2faf9a90 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -344,13 +344,11 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-static void pci_read_bridge_io(struct pci_bus *child)
+static void pci_read_bridge_io(struct pci_dev *dev, struct resource *res)
 {
-	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
 	unsigned long io_mask, io_granularity, base, limit;
 	struct pci_bus_region region;
-	struct resource *res;
 
 	io_mask = PCI_IO_RANGE_MASK;
 	io_granularity = 0x1000;
@@ -360,7 +358,6 @@ static void pci_read_bridge_io(struct pci_bus *child)
 		io_granularity = 0x400;
 	}
 
-	res = child->resource[0];
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
 	base = (io_base_lo & io_mask) << 8;
@@ -384,15 +381,12 @@ static void pci_read_bridge_io(struct pci_bus *child)
 	}
 }
 
-static void pci_read_bridge_mmio(struct pci_bus *child)
+static void pci_read_bridge_mmio(struct pci_dev *dev, struct resource *res)
 {
-	struct pci_dev *dev = child->self;
 	u16 mem_base_lo, mem_limit_lo;
 	unsigned long base, limit;
 	struct pci_bus_region region;
-	struct resource *res;
 
-	res = child->resource[1];
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = ((unsigned long) mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
@@ -406,16 +400,13 @@ static void pci_read_bridge_mmio(struct pci_bus *child)
 	}
 }
 
-static void pci_read_bridge_mmio_pref(struct pci_bus *child)
+static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res)
 {
-	struct pci_dev *dev = child->self;
 	u16 mem_base_lo, mem_limit_lo;
 	u64 base64, limit64;
 	pci_bus_addr_t base, limit;
 	struct pci_bus_region region;
-	struct resource *res;
 
-	res = child->resource[2];
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
 	base64 = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
@@ -527,9 +518,9 @@ void pci_read_bridge_bases(struct pci_bus *child)
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
 
-	pci_read_bridge_io(child);
-	pci_read_bridge_mmio(child);
-	pci_read_bridge_mmio_pref(child);
+	pci_read_bridge_io(child->self, child->resource[0]);
+	pci_read_bridge_mmio(child->self, child->resource[1]);
+	pci_read_bridge_mmio_pref(child->self, child->resource[2]);
 
 	if (dev->transparent) {
 		pci_bus_for_each_resource(child->parent, res) {
-- 
2.51.0

