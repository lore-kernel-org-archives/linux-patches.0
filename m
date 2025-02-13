Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B67645;
	Thu, 13 Feb 2025 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459490; cv=none; b=CsEYVLFwUJxD963dV9yufE3gR8j0fjg2weYNHkajtUtwqM7xPcn8DbPftj3+Pu3adtnTisNUhesuvLOcFPxlCdJMIQ6L7dK2GFZ+kBYChKAB4VFB++zSKWrmmUAa01IysTPcerwOJJbRXbo9+H/EAkQlcvQnJTztomvUlOvBMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459490; c=relaxed/simple;
	bh=4aU66a+aFBBisyiD6IJY2NeJMWcjsqWSbliXKe9zHTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4mAaLSbxq0yL2knLaAn45eyKo92UYxIxKdU9/qarjl84q/P5JvSUvloWy2UlpQt21w8j9d41/IKJten8KLRHfSR95CEz0g7at67bNedgDK26ph+GS9jwFRxnDpJKW7YiU5mLszm6YePFQd6gkwhoseUag9QkwYFm3t3/uO+hBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doZRhIEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doZRhIEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1217C4CEE7;
	Thu, 13 Feb 2025 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459490;
	bh=4aU66a+aFBBisyiD6IJY2NeJMWcjsqWSbliXKe9zHTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doZRhIEzGhqbT0zCpPp+BN3+6B7H4f1CpZq8BiEfw2WsEvH1yu1qszHmglUokdQfJ
	 5YZyRKqINu2X/shlkmZPTeyPZkeHICSfDp77OwoAXgpXz0/s5Avpz5A1MBn6oCLOjA
	 vf7cP7HoC23C3q7fhZmInH6GEcpQEE7hESZDH/Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.13 273/443] PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1
Date: Thu, 13 Feb 2025 15:27:18 +0100
Message-ID: <20250213142451.143985111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


