Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A186059B72;
	Tue, 23 Jan 2024 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969816; cv=none; b=WEdNmhXGzQ79VmxvGyaHFiEuHjH1lLp9eqrOa2RpgOXXI+O/NsOTR/Fcs6r4v6x3L5Bcp9uq1OEpzpjDAlIxvxp7HnHpkJkMz16Xf9DMQCHtpy/sVrkYNUKpKSCzWubhItmCZ0c/xDFHg2mSWJcHrrGB9zXKOQCIA6xL2+E7Vus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969816; c=relaxed/simple;
	bh=JEpFw82jCYfkl3WtR/Aff1P8rng/eiEVYfmPdOmprV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY37OqZzCk0LCM1hweBShMMWCUdF+rvxko5gNPnJophxcbM0QuOwDmFEHih2w/VUbFcwwL2Ir5zbnV+6vbSlbHnBK4L2zxxXZcIuNbmTIcLEV5I/9lmEPICBj8tKjHZFPz1TNP//X6B2kv23Tx9FtiF7FQTElZceeu1FT0yCZ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR5MsUH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR5MsUH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59119C43390;
	Tue, 23 Jan 2024 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969816;
	bh=JEpFw82jCYfkl3WtR/Aff1P8rng/eiEVYfmPdOmprV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR5MsUH3gdUu3oXgo1QfCqMz3pzt6y4VmtrdHBGgeEHPfC+wLlJ/+vdY/U7gI03bC
	 9e/18jqAVZ64Bu/tcCcKZsE7xSQ5tYwcec4wqHXGSmuAuSd58d2xsgGcb4J50TGrRC
	 GBbCHs1zdX2i01kY7PNVtxMrqfxucSxdKmIEcwO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Pala <gotar@polanet.pl>,
	Sebastian Manciulea <manciuleas@protonmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.7 467/641] x86/pci: Reserve ECAM if BIOS didnt include it in PNP0C02 _CRS
Date: Mon, 22 Jan 2024 15:56:11 -0800
Message-ID: <20240122235832.659154916@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 070909e56a7d65fd0b4aad6e808966b7c634befe upstream.

Tomasz, Sebastian, and some Proxmox users reported problems initializing
ixgbe NICs.

I think the problem is that ECAM space described in the ACPI MCFG table is
not reserved via a PNP0C02 _CRS method as required by the PCI Firmware spec
(r3.3, sec 4.1.2), but it *is* included in the PNP0A03 host bridge _CRS as
part of the MMIO aperture.

If we allocate space for a PCI BAR, we're likely to allocate it from that
ECAM space, which obviously cannot work.

This could happen for any device, but in the ixgbe case it happens because
it's an SR-IOV device and the BIOS didn't allocate space for the VF BARs,
so Linux reallocated the bridge window leading to ixgbe and put it on top
of the ECAM space.  From Tomasz' system:

  PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
  PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
  pci_bus 0000:00: root bus resource [mem 0x80000000-0xfbffffff window]

  pci 0000:00:01.1: PCI bridge to [bus 02-03]
  pci 0000:00:01.1:   bridge window [mem 0xfb900000-0xfbbfffff]
  pci 0000:02:00.0: [8086:10fb] type 00 class 0x020000  # ixgbe
  pci 0000:02:00.0: reg 0x10: [mem 0xfba80000-0xfbafffff 64bit]
  pci 0000:02:00.0: VF(n) BAR0 space: [mem 0x00000000-0x000fffff 64bit] (contains BAR0 for 64 VFs)
  pci 0000:02:00.0: BAR 7: no space for [mem size 0x00100000 64bit]   # VF BAR 0

  pci_bus 0000:00: No. 2 try to assign unassigned res
  pci 0000:00:01.1: resource 14 [mem 0xfb900000-0xfbbfffff] released
  pci 0000:00:01.1: BAR 14: assigned [mem 0x80000000-0x806fffff]
  pci 0000:02:00.0: BAR 0: assigned [mem 0x80000000-0x8007ffff 64bit]
  pci 0000:02:00.0: BAR 7: assigned [mem 0x80204000-0x80303fff 64bit] # VF BAR 0

Fixes: 07eab0901ede ("efi/x86: Remove EfiMemoryMappedIO from E820 map")
Fixes: fd3a8cff4d4a ("x86/pci: Treat EfiMemoryMappedIO as reservation of ECAM space")
Reported-by: Tomasz Pala <gotar@polanet.pl>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218050
Reported-by: Sebastian Manciulea <manciuleas@protonmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218107
Link: https://forum.proxmox.com/threads/proxmox-8-kernel-6-2-16-4-pve-ixgbe-driver-fails-to-load-due-to-pci-device-probing-failure.131203/
Link: https://lore.kernel.org/r/20231121183643.249006-2-helgaas@kernel.org
Tested-by: Tomasz Pala <gotar@polanet.pl>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v6.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/mmconfig-shared.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -525,6 +525,8 @@ static bool __ref is_mmconf_reserved(che
 static bool __ref
 pci_mmcfg_check_reserved(struct device *dev, struct pci_mmcfg_region *cfg, int early)
 {
+	struct resource *conflict;
+
 	if (!early && !acpi_disabled) {
 		if (is_mmconf_reserved(is_acpi_reserved, cfg, dev,
 				       "ACPI motherboard resource"))
@@ -542,8 +544,17 @@ pci_mmcfg_check_reserved(struct device *
 			       &cfg->res);
 
 		if (is_mmconf_reserved(is_efi_mmio, cfg, dev,
-				       "EfiMemoryMappedIO"))
+				       "EfiMemoryMappedIO")) {
+			conflict = insert_resource_conflict(&iomem_resource,
+							    &cfg->res);
+			if (conflict)
+				pr_warn("MMCONFIG %pR conflicts with %s %pR\n",
+					&cfg->res, conflict->name, conflict);
+			else
+				pr_info("MMCONFIG %pR reserved to work around lack of ACPI motherboard _CRS\n",
+					&cfg->res);
 			return true;
+		}
 	}
 
 	/*


