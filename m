Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417938D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302140; cv=none; b=bUAKNPdRA9KIRdor//6nlX9fAlhf98ZIXJ5KetabZZDrbMffWdG7/RBQj+0WbzwErLPyMKmHd9JklfRhw9Mor569E9EuklUvQi0I6+AXdHt3waSS8pFgo/h/7BK6b1uKNb2jC6HI4gkXtjCViPcK8o4cWms5Qhgl/CJ9YVPGu5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302140; c=relaxed/simple;
	bh=d6XoQNuMerUBgwS0sT0AiNx3sClklm9YGvt8SlGvNlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P99XwQCapRVK9HKgIndU3pwv8EmW4IcLdKqrt9ejpi6CUBiHMgLvreWJ5f/2NB0r3h1zTykLmNxgy4UHPuJW/+Q3DCHV5WedEvThV0itnLAs3CYzIYflpYYIvp7kzd50fQjO//nVCKc8uS3ZpEOFeJuHAXofpsv+ADQLY42JaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XX9ZdofV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XX9ZdofV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAF9C116D0;
	Sat, 28 Feb 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302140;
	bh=d6XoQNuMerUBgwS0sT0AiNx3sClklm9YGvt8SlGvNlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX9ZdofVZAUIWWVIw+li2VHh1izHGh+3hjkYyBjvpa9aXvh4AYQunv2UxuEzGuBwJ
	 n7GLrEmWC8dbaTT+mnXLU2KvLly9zbJJ5Ahh/kzpbQpbzKfX5ig2FDDw0WwVOjN0xr
	 KpJPUrAAs5IBJY3QpW7iMtmdDbhJsTKsBzvVhNpa/qS/Jo73IGZuQbOcob2BXdvBim
	 758TPdBvouZoj9/1cY5mPcnmInR4mySPeEmUPZn3RaM1PoqNlhMHTY4gj+vGqz3mxL
	 SJtU7MOTFAJIFaOYsk5vE2OzcH346RdPUntuNuNPPcY3s665RcMP+ESuMtduVxOU55
	 l7+hOWeNgOC+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/283] PCI: Log bridge info when first enumerating bridge
Date: Sat, 28 Feb 2026 13:04:35 -0500
Message-ID: <20260228180709.1583486-133-sashal@kernel.org>
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

[ Upstream commit 95140c2fbfdf3b6ca98578e5bdbc82d9922f08b9 ]

Log bridge secondary/subordinate bus and window information at the same
time we log the bridge BARs, just after discovering the bridge and before
scanning the bridge's secondary bus.  This logs the bridge and downstream
devices in a more logical order:

  - pci 0000:00:01.0: [8086:1901] type 01 class 0x060400
  - pci 0000:01:00.0: [10de:13b6] type 00 class 0x030200
  - pci 0000:01:00.0: reg 0x10: [mem 0xec000000-0xecffffff]
  - pci 0000:00:01.0: PCI bridge to [bus 01]
  - pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]

  + pci 0000:00:01.0: [8086:1901] type 01 class 0x060400
  + pci 0000:00:01.0: PCI bridge to [bus 01]
  + pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
  + pci 0000:01:00.0: [10de:13b6] type 00 class 0x030200
  + pci 0000:01:00.0: reg 0x10: [mem 0xec000000-0xecffffff]

Note that we read the windows into a temporary struct resource that is
thrown away, not into the resources in the struct pci_bus.

The windows may be adjusted after we know what downstream devices require,
and those adjustments are logged as they are made.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f7b01cddf5abf..8a2f1e57bee19 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -458,8 +458,17 @@ static void pci_read_bridge_mmio_pref(struct pci_dev *dev, struct resource *res,
 
 static void pci_read_bridge_windows(struct pci_dev *bridge)
 {
+	u32 buses;
 	u16 io;
 	u32 pmem, tmp;
+	struct resource res;
+
+	pci_read_config_dword(bridge, PCI_PRIMARY_BUS, &buses);
+	res.flags = IORESOURCE_BUS;
+	res.start = (buses >> 8) & 0xff;
+	res.end = (buses >> 16) & 0xff;
+	pci_info(bridge, "PCI bridge to %pR%s\n", &res,
+		 bridge->transparent ? " (subtractive decode)" : "");
 
 	pci_read_config_word(bridge, PCI_IO_BASE, &io);
 	if (!io) {
@@ -467,8 +476,12 @@ static void pci_read_bridge_windows(struct pci_dev *bridge)
 		pci_read_config_word(bridge, PCI_IO_BASE, &io);
 		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
 	}
-	if (io)
+	if (io) {
 		bridge->io_window = 1;
+		pci_read_bridge_io(bridge, &res, true);
+	}
+
+	pci_read_bridge_mmio(bridge, &res, true);
 
 	/*
 	 * DECchip 21050 pass 2 errata: the bridge may miss an address
@@ -505,6 +518,8 @@ static void pci_read_bridge_windows(struct pci_dev *bridge)
 		if (tmp)
 			bridge->pref_64_window = 1;
 	}
+
+	pci_read_bridge_mmio_pref(bridge, &res, true);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
@@ -524,9 +539,9 @@ void pci_read_bridge_bases(struct pci_bus *child)
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
 
-	pci_read_bridge_io(child->self, child->resource[0], true);
-	pci_read_bridge_mmio(child->self, child->resource[1], true);
-	pci_read_bridge_mmio_pref(child->self, child->resource[2], true);
+	pci_read_bridge_io(child->self, child->resource[0], false);
+	pci_read_bridge_mmio(child->self, child->resource[1], false);
+	pci_read_bridge_mmio_pref(child->self, child->resource[2], false);
 
 	if (dev->transparent) {
 		pci_bus_for_each_resource(child->parent, res) {
-- 
2.51.0

