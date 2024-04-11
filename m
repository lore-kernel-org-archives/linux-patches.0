Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C61474B0;
	Thu, 11 Apr 2024 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831680; cv=none; b=K6z+iyDbJtT7SNLxcXTl1RkxJ8IxldM7OokOfYnLMXbdaFyHwhAfpO1t5ft9t3vmgV+yGU0hwOE881VMX98FdkTNNAyKdjIE6fyZYGA4UO8pIczgmpKzwQN8KdDFkBLauJcl8GmGuLgQrlAHCgLL7U9d/1K5hnMgokZ6X8aFqM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831680; c=relaxed/simple;
	bh=OaSAt0mPncQPE0pngTTVCZYIqZrtcR1DfXGq8Ly5z5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e55SLW+aPngwNfrkrOysRlmj9eOapX+9fi2U/rwPqz6mcoGmsCKeHTTq2s3H+y7vZLFqKXoMFs/IjoBvjHPV9KVtiYANTjIrotNLsLm9W94Ys54lBGf7XEsxDUD73hN+ytSNjjLXDXPrCptgJdpQErgYFLY14cHoQeHIulOJsLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCFYg77g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCFYg77g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA765C433F1;
	Thu, 11 Apr 2024 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831680;
	bh=OaSAt0mPncQPE0pngTTVCZYIqZrtcR1DfXGq8Ly5z5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCFYg77g+QtJB9V5p+LLKSCJWR4jvQk1f2HkkLvEVfQkbgCz74voWXZWPbZSY2Us8
	 /9snLCb34w31454ltGcaUyLxNN2H15S/E4YVpZwlyK/+JADbKbHTCnJAr7H4kg/b/0
	 2n24dxfC0q8cf8f54djKVqqbCySqS2wo+FGfI6QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/294] PCI: Work around Intel I210 ROM BAR overlap defect
Date: Thu, 11 Apr 2024 11:53:46 +0200
Message-ID: <20240411095437.588151353@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 500b55b05d0a21c4adddf4c3b29ee6f32b502046 ]

Per PCIe r5, sec 7.5.1.2.4, a device must not claim accesses to its
Expansion ROM unless both the Memory Space Enable and the Expansion ROM
Enable bit are set.  But apparently some Intel I210 NICs don't work
correctly if the ROM BAR overlaps another BAR, even if the Expansion ROM is
disabled.

Michael reported that on a Kontron SMARC-sAL28 ARM64 system with U-Boot
v2021.01-rc3, the ROM BAR overlaps BAR 3, and networking doesn't work at
all:

  BAR 0: 0x40000000 (32-bit, non-prefetchable) [size=1M]
  BAR 3: 0x40200000 (32-bit, non-prefetchable) [size=16K]
  ROM:   0x40200000 (disabled) [size=1M]

  NETDEV WATCHDOG: enP2p1s0 (igb): transmit queue 0 timed out
  Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
  igb 0002:01:00.0 enP2p1s0: Reset adapter

Previously, pci_std_update_resource() wrote the assigned ROM address to the
BAR only when the ROM was enabled.  This meant that the I210 ROM BAR could
be left with an address assigned by firmware, which might overlap with
other BARs.

Quirk these I210 devices so pci_std_update_resource() always writes the
assigned address to the ROM BAR, whether or not the ROM is enabled.

Link: https://lore.kernel.org/r/20211223163754.GA1267351@bhelgaas
Link: https://lore.kernel.org/r/20201230185317.30915-1-michael@walle.cc
Link: https://bugzilla.kernel.org/show_bug.cgi?id=211105
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c    | 10 ++++++++++
 drivers/pci/setup-res.c |  8 ++++++--
 include/linux/pci.h     |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 646807a443e2d..d7c4149855eb6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5852,3 +5852,13 @@ static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 	pdev->dev_flags |= PCI_DEV_FLAGS_HAS_MSI_MASKING;
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0ab8, nvidia_ion_ahci_fixup);
+
+static void rom_bar_overlap_defect(struct pci_dev *dev)
+{
+	pci_info(dev, "working around ROM BAR overlap defect\n");
+	dev->rom_bar_overlap = 1;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1533, rom_bar_overlap_defect);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1536, rom_bar_overlap_defect);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1537, rom_bar_overlap_defect);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1538, rom_bar_overlap_defect);
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 875d50c16f19d..b492e67c3d871 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -75,12 +75,16 @@ static void pci_std_update_resource(struct pci_dev *dev, int resno)
 		 * as zero when disabled, so don't update ROM BARs unless
 		 * they're enabled.  See
 		 * https://lore.kernel.org/r/43147B3D.1030309@vc.cvut.cz/
+		 * But we must update ROM BAR for buggy devices where even a
+		 * disabled ROM can conflict with other BARs.
 		 */
-		if (!(res->flags & IORESOURCE_ROM_ENABLE))
+		if (!(res->flags & IORESOURCE_ROM_ENABLE) &&
+		    !dev->rom_bar_overlap)
 			return;
 
 		reg = dev->rom_base_reg;
-		new |= PCI_ROM_ADDRESS_ENABLE;
+		if (res->flags & IORESOURCE_ROM_ENABLE)
+			new |= PCI_ROM_ADDRESS_ENABLE;
 	} else
 		return;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 75f29838d25cf..5b24a6fbfa0be 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -454,6 +454,7 @@ struct pci_dev {
 	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
 	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
 	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
+	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
2.43.0



