Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FD71974EC;
	Thu,  6 Jun 2024 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683088; cv=none; b=Leg84ajO9Iv7g4P9dq2goe36SIfGaZAk40qHC0+yvu4G7CFnPHjVG1EllA7OuJx3diJNo1dxKMP+E4MRYrnfkaRgt+Z3l+xxeCQ4yR7L77Zk2yZNhYwbCd9lerW7rWuaw6IZ5vZor3k5SMMwKA3a8oNfnC4T3ljjZXry24umkLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683088; c=relaxed/simple;
	bh=incpsdWh2AC8wQSUhSGld4CCmNDPGBRGl9fjP6MrZcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/1b5R/0gaJAlI23sV+uZQocX8JGUEmwAafp2lm7QmBFsdxqV9DmsI1WI6URfnD0M4qbz8/0mqFwwnkggYue/yuY9CG7p8gOYMDUv//+B1gUJx9iJhKq2DnGfw6p2ObPcWhM9MZMhVF1HKKjLnrvMrqY6r8gFM8aAJZyEPMOrOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hbv0YI71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hbv0YI71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647CAC32786;
	Thu,  6 Jun 2024 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683088;
	bh=incpsdWh2AC8wQSUhSGld4CCmNDPGBRGl9fjP6MrZcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hbv0YI7124XHSMazfVbrHoeARy72FpmyRl1uujqXJjhpQXNdu8S+dUV3U7MSjD7fb
	 u8SmHc6c4d8M9PSYunrKcz1zPYsk2FfmBXlAoPjwyf++PEVXvnNKZl48+6GmIdygnk
	 y4/KitgPSr4LIvSOhVB8RU9b/++CnxMJCoW3VWfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Kaduk <mateusz.kaduk@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.9 369/374] x86/pci: Skip early E820 check for ECAM region
Date: Thu,  6 Jun 2024 16:05:48 +0200
Message-ID: <20240606131704.240746512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 199f968f1484a14024d0d467211ffc2faf193eb4 upstream.

Arul, Mateusz, Imcarneiro91, and Aman reported a regression caused by
07eab0901ede ("efi/x86: Remove EfiMemoryMappedIO from E820 map").  On the
Lenovo Legion 9i laptop, that commit removes the ECAM area from E820, which
means the early E820 validation fails, which means we don't enable ECAM in
the "early MCFG" path.

The static MCFG table describes ECAM without depending on the ACPI
interpreter.  Many Legion 9i ACPI methods rely on that, so they fail when
PCI config access isn't available, resulting in the embedded controller,
PS/2, audio, trackpad, and battery devices not being detected.  The _OSC
method also fails, so Linux can't take control of the PCIe hotplug, PME,
and AER features:

  # pci_mmcfg_early_init()

  PCI: ECAM [mem 0xc0000000-0xce0fffff] (base 0xc0000000) for domain 0000 [bus 00-e0]
  PCI: not using ECAM ([mem 0xc0000000-0xce0fffff] not reserved)

  ACPI Error: AE_ERROR, Returned by Handler for [PCI_Config] (20230628/evregion-300)
  ACPI: Interpreter enabled
  ACPI: Ignoring error and continuing table load
  ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.RP01._SB.PC00], AE_NOT_FOUND (20230628/dswload2-162)
  ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20230628/psobject-220)
  ACPI: Skipping parse of AML opcode: OpcodeName unavailable (0x0010)
  ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.RP01._SB.PC00], AE_NOT_FOUND (20230628/dswload2-162)
  ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20230628/psobject-220)
  ...
  ACPI Error: Aborting method \_SB.PC00._OSC due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
  acpi PNP0A08:00: _OSC: platform retains control of PCIe features (AE_NOT_FOUND)

  # pci_mmcfg_late_init()

  PCI: ECAM [mem 0xc0000000-0xce0fffff] (base 0xc0000000) for domain 0000 [bus 00-e0]
  PCI: [Firmware Info]: ECAM [mem 0xc0000000-0xce0fffff] not reserved in ACPI motherboard resources
  PCI: ECAM [mem 0xc0000000-0xce0fffff] is EfiMemoryMappedIO; assuming valid
  PCI: ECAM [mem 0xc0000000-0xce0fffff] reserved to work around lack of ACPI motherboard _CRS

Per PCI Firmware r3.3, sec 4.1.2, ECAM space must be reserved by a PNP0C02
resource, but there's no requirement to mention it in E820, so we shouldn't
look at E820 to validate the ECAM space described by MCFG.

In 2006, 946f2ee5c731 ("[PATCH] i386/x86-64: Check that MCFG points to an
e820 reserved area") added a sanity check of E820 to work around buggy MCFG
tables, but that over-aggressive validation causes failures like this one.

Keep the E820 validation check for machines older than 2016, an arbitrary
ten years after 946f2ee5c731, so machines that depend on it don't break.

Skip the early E820 check for 2016 and newer BIOSes since there's no
requirement to describe ECAM in E820.

Link: https://lore.kernel.org/r/20240417204012.215030-2-helgaas@kernel.org
Fixes: 07eab0901ede ("efi/x86: Remove EfiMemoryMappedIO from E820 map")
Reported-by: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218444
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/mmconfig-shared.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -518,7 +518,34 @@ static bool __ref pci_mmcfg_reserved(str
 {
 	struct resource *conflict;
 
-	if (!early && !acpi_disabled) {
+	if (early) {
+
+		/*
+		 * Don't try to do this check unless configuration type 1
+		 * is available.  How about type 2?
+		 */
+
+		/*
+		 * 946f2ee5c731 ("Check that MCFG points to an e820
+		 * reserved area") added this E820 check in 2006 to work
+		 * around BIOS defects.
+		 *
+		 * Per PCI Firmware r3.3, sec 4.1.2, ECAM space must be
+		 * reserved by a PNP0C02 resource, but it need not be
+		 * mentioned in E820.  Before the ACPI interpreter is
+		 * available, we can't check for PNP0C02 resources, so
+		 * there's no reliable way to verify the region in this
+		 * early check.  Keep it only for the old machines that
+		 * motivated 946f2ee5c731.
+		 */
+		if (dmi_get_bios_year() < 2016 && raw_pci_ops)
+			return is_mmconf_reserved(e820__mapped_all, cfg, dev,
+						  "E820 entry");
+
+		return true;
+	}
+
+	if (!acpi_disabled) {
 		if (is_mmconf_reserved(is_acpi_reserved, cfg, dev,
 				       "ACPI motherboard resource"))
 			return true;
@@ -551,16 +578,7 @@ static bool __ref pci_mmcfg_reserved(str
 	 * For MCFG information constructed from hotpluggable host bridge's
 	 * _CBA method, just assume it's reserved.
 	 */
-	if (pci_mmcfg_running_state)
-		return true;
-
-	/* Don't try to do this check unless configuration
-	   type 1 is available. how about type 2 ?*/
-	if (raw_pci_ops)
-		return is_mmconf_reserved(e820__mapped_all, cfg, dev,
-					  "E820 entry");
-
-	return false;
+	return pci_mmcfg_running_state;
 }
 
 static void __init pci_mmcfg_reject_broken(int early)


