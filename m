Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918351448EF;
	Thu, 11 Apr 2024 10:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830266; cv=none; b=BVRZYRTfv/AIxVx1JRdafsCozX1YYBaC4X/IBPow+FThC5rzJCtWlzfKm7L/Atl7Nu8uWmfjQQRgFoqJi+X1qaaniVsqXmGmURfGLfAsZVEakuT6uKOW33v1f++OyVnDIvFMhO3sMnJ1Yy9msgfZ/I3KDRvA2GvyHhp3ejgpoiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830266; c=relaxed/simple;
	bh=K65XCc5ZHxy4sYqdPI7bBeILt5nbT1WcNKNsqSi0AoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJjMBwtJalXPW4xqwSz1UFUzn05Kwht3lctMgVnASJzz4kLlNTHQ9Ojg6iLW8XO9PsPEmn0Dlr4yt2hBgiWC2aJrSF7quLv9OxcQasPy4tUZk2tJCceAL15L7k+eH0t6QpLxf8o3QPFsBBxFnbkcELUKudl/ylEceLALKpAy69w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykuJBNHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykuJBNHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A16C433F1;
	Thu, 11 Apr 2024 10:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830266;
	bh=K65XCc5ZHxy4sYqdPI7bBeILt5nbT1WcNKNsqSi0AoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykuJBNHOYO6JAQFdmh5XL1qH5UbE+GPfSPQwP5FlI/QZ4b6p2OecQDOY/a8l357Ke
	 gjzlpltc59pAv2dFOuePvzBiL0UpH9VtSnUj+jaCNbthFsKXeGyy9ii7dHD3/Dgu7r
	 Ynjf0ICeRLA721VanBWVUFMJDlWXbUu/he1yDgyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Drake <drake@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jian-Hong Pan <jhp@endlessos.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 090/143] PCI: Disable D3cold on Asus B1400 PCI-NVMe bridge
Date: Thu, 11 Apr 2024 11:55:58 +0200
Message-ID: <20240411095423.618553264@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <drake@endlessos.org>

[ Upstream commit cdea98bf1faef23166262825ce44648be6ebff42 ]

The Asus B1400 with original shipped firmware versions and VMD disabled
cannot resume from suspend: the NVMe device becomes unresponsive and
inaccessible.

This appears to be an untested D3cold transition by the vendor; Intel
socwatch shows that Windows leaves the NVMe device and parent bridge in D0
during suspend, even though these firmware versions have StorageD3Enable=1.

The NVMe device and parent PCI bridge both share the same "PXP" ACPI power
resource, which gets turned off as both devices are put into D3cold during
suspend. The _OFF() method calls DL23() which sets a L23E bit at offset
0xe2 into the PCI configuration space for this root port.  This is the
specific write that the _ON() routine is unable to recover from. This
register is not documented in the public chipset datasheet.

Disallow D3cold on the PCI bridge to enable successful suspend/resume.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215742
Link: https://lore.kernel.org/r/20240228075316.7404-1-drake@endlessos.org
Signed-off-by: Daniel Drake <drake@endlessos.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jian-Hong Pan <jhp@endlessos.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index f347c20247d30..b33afb240601b 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -907,6 +907,54 @@ static void chromeos_fixup_apl_pci_l1ss_capability(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x5ad6, chromeos_save_apl_pci_l1ss_capability);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL, 0x5ad6, chromeos_fixup_apl_pci_l1ss_capability);
 
+/*
+ * Disable D3cold on Asus B1400 PCI-NVMe bridge
+ *
+ * On this platform with VMD off, the NVMe device cannot successfully power
+ * back on from D3cold. This appears to be an untested transition by the
+ * vendor: Windows leaves the NVMe and parent bridge in D0 during suspend.
+ *
+ * We disable D3cold on the parent bridge for simplicity, and the fact that
+ * both parent bridge and NVMe device share the same power resource.
+ *
+ * This is only needed on BIOS versions before 308; the newer versions flip
+ * StorageD3Enable from 1 to 0.
+ */
+static const struct dmi_system_id asus_nvme_broken_d3cold_table[] = {
+	{
+		.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_BIOS_VERSION, "B1400CEAE.304"),
+		},
+	},
+	{
+		.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_BIOS_VERSION, "B1400CEAE.305"),
+		},
+	},
+	{
+		.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_BIOS_VERSION, "B1400CEAE.306"),
+		},
+	},
+	{
+		.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_BIOS_VERSION, "B1400CEAE.307"),
+		},
+	},
+	{}
+};
+
+static void asus_disable_nvme_d3cold(struct pci_dev *pdev)
+{
+	if (dmi_check_system(asus_nvme_broken_d3cold_table) > 0)
+		pci_d3cold_disable(pdev);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x9a09, asus_disable_nvme_d3cold);
+
 #ifdef CONFIG_SUSPEND
 /*
  * Root Ports on some AMD SoCs advertise PME_Support for D3hot and D3cold, but
-- 
2.43.0



