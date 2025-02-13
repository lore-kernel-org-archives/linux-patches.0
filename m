Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3E51411DE;
	Thu, 13 Feb 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460599; cv=none; b=sGz1DOVj/DcN5SkeqXTKSfKCkt7YBXtZJNFsO91S2NNGUcnmxf04zqGbqBRcb12Iqj+OxytgvL4n6DRy8Dg7v927S14CYAdOvL5LK+YocIk/Pe9Kgd2D2MCq1VRzBYdpw5DLyOBE+0y1ayQAOP+WOytxJsRhipcqn67w7Kp7x7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460599; c=relaxed/simple;
	bh=mE6ArpyM59SPsNAspxDNj3xXP+srfqJlbSCgW5Q/KcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q4s8JNrPPfIdX0POvbTbe0zwldgyAWHNc26gOHNk5zoEYvS2NitXFcI75qsjsjsAxuVRab3z7/634rnLQm4p7aBPBOaL+x9Ku1IHyW1ijrLssXusS886Dy3sZraaX1Nkp8guhUZBLCAbdl0mXugBZ6NQ2J55oQoqTNiuslVyIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o12zisSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o12zisSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3CCC4CED1;
	Thu, 13 Feb 2025 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460599;
	bh=mE6ArpyM59SPsNAspxDNj3xXP+srfqJlbSCgW5Q/KcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o12zisSb0HdZt4pl36rYiBAb3NnCMK8oDAzwZo2dY+MMw5Y4sAL/R8TO7059Mf9xN
	 2kl73u83eYTHS4XJsEUBPfmdUADRWev2VHQ8Vki+OphykKtuvKq6LFRhqeG6GhpUBg
	 FyNzmMNvf+YzBS2aL9P7meF0lfaqrXKdj7XrKEq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 158/273] PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1
Date: Thu, 13 Feb 2025 15:28:50 +0100
Message-ID: <20250213142413.579480463@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit b1049f2d68693c80a576c4578d96774a68df2bad upstream.

commit 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend") sets the
policy that all PCIe ports are allowed to use D3.  When the system is
suspended if the port is not power manageable by the platform and won't be
used for wakeup via a PME this sets up the policy for these ports to go
into D3hot.

This policy generally makes sense from an OSPM perspective but it leads to
problems with wakeup from suspend on the TUXEDO Sirius 16 Gen 1 with a
specific old BIOS. This manifests as a system hang.

On the affected Device + BIOS combination, add a quirk for the root port of
the problematic controller to ensure that these root ports are not put into
D3hot at suspend.

This patch is based on

  https://lore.kernel.org/linux-pci/20230708214457.1229-2-mario.limonciello@amd.com

but with the added condition both in the documentation and in the code to
apply only to the TUXEDO Sirius 16 Gen 1 with a specific old BIOS and only
the affected root ports.

Fixes: 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend")
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250114222436.1075456-1-wse@tuxedocomputers.com
Co-developed-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -1010,4 +1010,34 @@ DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_resume);
 DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_suspend);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_resume);
+
+/*
+ * Putting PCIe root ports on Ryzen SoCs with USB4 controllers into D3hot
+ * may cause problems when the system attempts wake up from s2idle.
+ *
+ * On the TUXEDO Sirius 16 Gen 1 with a specific old BIOS this manifests as
+ * a system hang.
+ */
+static const struct dmi_system_id quirk_tuxeo_rp_d3_dmi_table[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "APX958"),
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "V1.00A00_20240108"),
+		},
+	},
+	{}
+};
+
+static void quirk_tuxeo_rp_d3(struct pci_dev *pdev)
+{
+	struct pci_dev *root_pdev;
+
+	if (dmi_check_system(quirk_tuxeo_rp_d3_dmi_table)) {
+		root_pdev = pcie_find_root_port(pdev);
+		if (root_pdev)
+			root_pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1502, quirk_tuxeo_rp_d3);
 #endif /* CONFIG_SUSPEND */


