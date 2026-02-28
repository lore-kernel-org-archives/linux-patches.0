Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397A338F62D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302138; cv=none; b=rbh2Z8WwGXeHh1URHTqSRHvNIGjfKM+QRu6jjMZJ5DXQoqSEKxsgcFrnbdCQVNGBy0NwvQxoGRWHprjzXQIaiVLqSiMdPUoO7qkZUcpVW7sRJZkhDcj8WDc75GRuATylBn2FbCw0jm6SZr7WRu9T2okPu1Ug8XkSSXYIlcAbSQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302138; c=relaxed/simple;
	bh=5EqR+vab7Q3Tg78J/0ih5m7+W7TXyaEDpGZOGHs9RTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf+fE8pE/vzWYI8+L+6twMCm2OOuNR1azDByxATps1MSvP66V6Bn/exY1MxWqLFSglFKmPd1qVAVDrndhTyULlvGUvw1zQzbrar2b0tETZluoOH2lDLDjXrqlMtR9GveAuEqIEVfve0ioGmG2Rurz0lCU5eJQT8VonwtzZkt1oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPUg9LeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPUg9LeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AE0C19424;
	Sat, 28 Feb 2026 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302138;
	bh=5EqR+vab7Q3Tg78J/0ih5m7+W7TXyaEDpGZOGHs9RTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPUg9LeNjOc6fesvFDmjczXltzweyQqzWa/ChfAC4Z0WGxoGemAOdCPRT8BqlJs6B
	 /OPiXYQnk/w5NoftT+pmY1qMmLQwz9qhPs+9VrCf0dlSR30hjZM1QRUD1+Ykg6cU+p
	 2lNE23wlJU0/ODFe9qOvRBHL89zzKSKukk05tZQYylMVUxYYUPstIEgcRvjwie3F2s
	 Eh29S46LhP6qnoRMy+eIvxptmS+oSIXucPuadgv/kQ06gF3JucMEx4OueVHPv4zCIc
	 X+Q9zo5wSz1wXGFgl2XIfT8ZzMQX9cGYvvvtxUOTZmzm8gpWJReVP8cy5OX1MbnkFg
	 u41rEq3JjO4JQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/283] PCI: Move pci_read_bridge_windows() below individual window accessors
Date: Sat, 28 Feb 2026 13:04:32 -0500
Message-ID: <20260228180709.1583486-130-sashal@kernel.org>
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

[ Upstream commit 6f32099a91720b6d91da961858d48173f01a729d ]

Move pci_read_bridge_windows() below the functions that read the I/O,
memory, and prefetchable memory windows, so pci_read_bridge_windows() can
use them in the future.  No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 102 ++++++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e51a5c38739a4..a43f9e9352e47 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -344,57 +344,6 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-static void pci_read_bridge_windows(struct pci_dev *bridge)
-{
-	u16 io;
-	u32 pmem, tmp;
-
-	pci_read_config_word(bridge, PCI_IO_BASE, &io);
-	if (!io) {
-		pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
-		pci_read_config_word(bridge, PCI_IO_BASE, &io);
-		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
-	}
-	if (io)
-		bridge->io_window = 1;
-
-	/*
-	 * DECchip 21050 pass 2 errata: the bridge may miss an address
-	 * disconnect boundary by one PCI data phase.  Workaround: do not
-	 * use prefetching on this device.
-	 */
-	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
-		return;
-
-	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-	if (!pmem) {
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
-					       0xffe0fff0);
-		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
-	}
-	if (!pmem)
-		return;
-
-	bridge->pref_window = 1;
-
-	if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
-
-		/*
-		 * Bridge claims to have a 64-bit prefetchable memory
-		 * window; verify that the upper bits are actually
-		 * writable.
-		 */
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &pmem);
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-				       0xffffffff);
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, pmem);
-		if (tmp)
-			bridge->pref_64_window = 1;
-	}
-}
-
 static void pci_read_bridge_io(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
@@ -510,6 +459,57 @@ static void pci_read_bridge_mmio_pref(struct pci_bus *child)
 	}
 }
 
+static void pci_read_bridge_windows(struct pci_dev *bridge)
+{
+	u16 io;
+	u32 pmem, tmp;
+
+	pci_read_config_word(bridge, PCI_IO_BASE, &io);
+	if (!io) {
+		pci_write_config_word(bridge, PCI_IO_BASE, 0xe0f0);
+		pci_read_config_word(bridge, PCI_IO_BASE, &io);
+		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
+	}
+	if (io)
+		bridge->io_window = 1;
+
+	/*
+	 * DECchip 21050 pass 2 errata: the bridge may miss an address
+	 * disconnect boundary by one PCI data phase.  Workaround: do not
+	 * use prefetching on this device.
+	 */
+	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
+		return;
+
+	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+	if (!pmem) {
+		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
+					       0xffe0fff0);
+		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
+	}
+	if (!pmem)
+		return;
+
+	bridge->pref_window = 1;
+
+	if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
+
+		/*
+		 * Bridge claims to have a 64-bit prefetchable memory
+		 * window; verify that the upper bits are actually
+		 * writable.
+		 */
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &pmem);
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+				       0xffffffff);
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, pmem);
+		if (tmp)
+			bridge->pref_64_window = 1;
+	}
+}
+
 void pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
-- 
2.51.0

