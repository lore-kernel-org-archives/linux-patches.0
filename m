Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41809745D6;
	Tue, 23 Jan 2024 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975468; cv=none; b=YNJgJwXyqHe4L2ERp9xZeaWgQRWnyLClYcXZEMHn50MzSr+Ikvsjw3ZsCb05yXpfXtFrq7IPnC1WPE0U9L/JqHp0fZ1bhsv3aFiovyAOl72lUcea7bA4RBZSPej3D+92yY5kWsvDSzrBiS2PW0O2dAROZgmfMjKIBqjiWOBKaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975468; c=relaxed/simple;
	bh=CF1Iklns0f7s2QXse2H+mGEaNPbTB/2rDmyPt1MqfBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5hHUsUJIbsh5quYSlLTcoIy2ZcbAJyQm/1PqhLSbJaaVSKDIgFLNrM3fXFhxix/XatmEqdTnj8UU34mvyVM1cCxnEpylMDzQ9gZZhdZ02hkOkkLLzwgucV0Z/GXWmWnj/t9sxrgbyOlG7Bu9NuYt4fQmAmGkXYkJhPx9XwQ0j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5r7AEw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5r7AEw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D958AC433F1;
	Tue, 23 Jan 2024 02:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975468;
	bh=CF1Iklns0f7s2QXse2H+mGEaNPbTB/2rDmyPt1MqfBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5r7AEw9zL6XAEsyPqh0VbgRaE4jNzy8n1z7P6oRl0ZMJr2LBuRlree0RlXFIUCk5
	 +R5PXsAMc76eyXV2jnLkgiugMY8bBQCirszEmxvU+A3Od48EzZW5qNoudFzMUoWCXd
	 CNv32BVTpQAs3gslHgD7MloGq77G4u63g5HuPUnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Pala <gotar@polanet.pl>,
	Sebastian Manciulea <manciuleas@protonmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 424/583] x86/pci: Reserve ECAM if BIOS didnt include it in PNP0C02 _CRS
Date: Mon, 22 Jan 2024 15:57:55 -0800
Message-ID: <20240122235824.959762250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


