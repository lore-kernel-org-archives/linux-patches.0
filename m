Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E1E19754F;
	Thu,  6 Jun 2024 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683762; cv=none; b=uqhXvl56vfqmDX7UbmhAps1EiyC6Xke9xCAg9Fo1ihqJzmjAr+eVWO6xuCBADZGpCLACP+V6stCW0AGCJMaKlw/xcMxt4hRaRmGDkpQ7c0XuswRhmvPZ85n7TKW6eI0u3gzgTpriQLV+NV2ZN+QmNh7oeomlfofhrGYg3HpiS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683762; c=relaxed/simple;
	bh=C8Ouk9NdWoM2mKcf7nA4RRfDgyUdGxubhByPBPP4yRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjOYlgslv7dSmwg+9ArTaKhkeQWPfPfFJ4SOO/Utn5YjpZ4WJIS1ksWHdIctfOd+1/+EQXeojtzdtHL4YhuHJUhhFqNcVDGEwxWMfaWbFo4QRPgUeTkRhR/sbk4UznPXZgYM1lODne5S6wXWGSoTty0/lax4HJVX8DUOf/G7jqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv4yfRMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv4yfRMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B05DC2BD10;
	Thu,  6 Jun 2024 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683762;
	bh=C8Ouk9NdWoM2mKcf7nA4RRfDgyUdGxubhByPBPP4yRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lv4yfRMp4g0LGKqZusDkAjQNiqiIFFZj2NXScvvsdn9YCVHanFt7UkG+6Wze+6flI
	 Dg9I1o8rP7TfMnpnWBhfBXqficUEtRXRjMZ7Mj9YInMySDd2Qo1r/pl6dnfbOY0MVS
	 Li3Rv+w5VUludGIs9JUgZEDRADscpZ87XE2N8eec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Kaduk <mateusz.kaduk@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.6 740/744] x86/pci: Skip early E820 check for ECAM region
Date: Thu,  6 Jun 2024 16:06:52 +0200
Message-ID: <20240606131756.211722560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
@@ -527,7 +527,34 @@ pci_mmcfg_check_reserved(struct device *
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
@@ -563,16 +590,7 @@ pci_mmcfg_check_reserved(struct device *
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


