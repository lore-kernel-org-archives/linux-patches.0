Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2064F4D7D2D;
	Wed, 30 Sep 2026 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784001; cv=none; b=j8At3TqXwiOV5GePK8YTI+2GJUwmm8WErJtZ0iU9cDcRb+h3afeZNxckO/kDEYEw99bJPztA6ETRi4lJ4+6/+jqjlsF1o0KWQnI1sE3nrslcTa/v5wkdIPp0PWhAE/WLBvtsawL64Dxiu9ROGfl7BDRDJDWxytRHrBh9tKNZgf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784001; c=relaxed/simple;
	bh=696rfdTUkcaBEeujfiDwIjtIP5MYF4RsavpwtGHmAwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GID39RBfR7JwwtoBQ9fnoxiVpFBImO6gmXhsuqo7UAA/lceS9Z/djBAWJuL3XaH7MO9VUS2LmxJU7EXyv2vKGdq/2iR52IwS/2lJlmDk/VbLgYfmge2/OyGnBj0Sb+j8P76si+tO2SUUGqJpN2D+OE8ODNWWXcFk1D0/b86YCqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/O9smqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/O9smqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6461F000FF;
	Wed, 30 Sep 2026 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783997;
	bh=cPgiWZ2IG/VRnLmXVVIHLKJeP4R9WzMfSi+WF8UhDVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/O9smqHlLXbZTcjMqctldnH7INWb52VxBohyh9VXWc63arnG0SyX9O7aFBeO9mMS
	 Op3ISUlxctH5V2P+piVecUHnDjs++vKvSoHr2UF572buLNpN3LapMIqss9J7n5sKPQ
	 QBKGD01TdxPOCUaiz4mdfJWFXIWnC7ZImRxzRHEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Etienne <mikael1022bzh@gmail.com>,
	Arthur Husband <artmoty@gmail.com>,
	Alvin Lim <alvinwylim@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Laight <david.laight.linux@gmail.com>,
	John Smith <imjohnsmith4000@gmail.com>,
	Lennert Buytenhek <kernel@wantstofly.org>,
	Niklas Cassel <cassel@kernel.org>,
	Roland Waltersson <roland.waltersson@netinsight.net>
Subject: [PATCH 5.10 551/595] x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11
Date: Wed, 30 Sep 2026 17:27:24 +0200
Message-ID: <20260930152359.567357250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 4fde448225123442c5796f54b7a4400e2d3cbaf6 upstream.

Multiple users report data corruption during 64-bit DMA transfers on
systems with AMD NBIO 7.7 and 7.11 controllers.

This occurs when BIOS enables AMD "enhanced atomic operations" on PCIe Root
Ports. When enhanced atomics are enabled, any 64-bit DMA access may be
corrupted.

Disable enhanced atomics using SMN for NBIO 7.7 and 7.11 based models.

Reported-by: Mikael Etienne <mikael1022bzh@gmail.com>
Closes: https://lore.kernel.org/178789300872.392066.15963676631650361573@gmail.com/
Reported-by: Arthur Husband <artmoty@gmail.com>
Closes: https://lore.kernel.org/20260406222335.379935-1-artmoty@gmail.com/
Reported-by: Alvin Lim <alvinwylim@gmail.com>
Closes: https://lore.kernel.org/20260621100844.1224301-1-alvinwylim@gmail.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[bhelgaas: commit log, s/IOVA/DMA/ in comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Cc: John Smith <imjohnsmith4000@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Roland Waltersson <roland.waltersson@netinsight.net>
Link: https://patch.msgid.link/20260908190600.226485-2-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -844,4 +844,103 @@ static void quirk_clear_strap_no_soft_re
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+
+/*
+ * Enhanced atomic operations can cause corruption with 64-bit DMA
+ * on these devices.
+ */
+#define RX_ENH_ATOMIC_EN		BIT(8)
+
+static const u32 nbio_7_7_pcie_smn_addrs[] = {
+	0x111401d0,
+	0x111411d0,
+	0x111421d0,
+	0x111431d0,
+	0x111441d0,
+	0x112401d0,
+	0x112411d0,
+	0x112421d0,
+	0x112431d0,
+	0x112441d0,
+	0x112451d0,
+	0x113401d0,
+	0x114401d0,
+};
+
+static const u32 nbio_7_11_pcie_smn_addrs[] = {
+	0x112401d0,
+	0x112411d0,
+	0x112421d0,
+	0x112431d0,
+	0x112441d0,
+	0x112451d0,
+	0x113401d0,
+	0x113411d0,
+	0x113421d0,
+	0x113431d0,
+	0x113441d0,
+	0x113451d0,
+};
+
+static void quirk_amd_nbio_enhanced_atomic(struct pci_dev *host_bridge,
+					   const u32 *smn_addrs,
+					   size_t nr_smn_addrs)
+{
+	bool changed = false;
+	size_t i;
+	u32 data;
+	int ret;
+
+	for (i = 0; i < nr_smn_addrs; i++) {
+		ret = amd_smn_read(0, smn_addrs[i], &data);
+		if (ret)
+			continue;
+		if (!(data & RX_ENH_ATOMIC_EN))
+			continue;
+		data = data & ~RX_ENH_ATOMIC_EN;
+		ret = amd_smn_write(0, smn_addrs[i], data);
+		if (ret)
+			continue;
+		if (changed)
+			continue;
+		ret = amd_smn_read(0, smn_addrs[i], &data);
+		if (ret)
+			continue;
+		if (data & RX_ENH_ATOMIC_EN)
+			continue;
+		changed = true;
+	}
+
+	if (changed)
+		pci_info(host_bridge, "enhanced atomics disabled\n");
+}
+
+static void quirk_amd_nbio_7_7_disable_enhanced_atomic(struct pci_dev *dev)
+{
+	quirk_amd_nbio_enhanced_atomic(dev, nbio_7_7_pcie_smn_addrs,
+				       ARRAY_SIZE(nbio_7_7_pcie_smn_addrs));
+}
+
+static void quirk_amd_nbio_7_11_disable_enhanced_atomic(struct pci_dev *dev)
+{
+	quirk_amd_nbio_enhanced_atomic(dev, nbio_7_11_pcie_smn_addrs,
+				       ARRAY_SIZE(nbio_7_11_pcie_smn_addrs));
+}
+
+/* Phoenix, Hawk Point (NBIO 7.7) */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x14E8,
+			quirk_amd_nbio_7_7_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x14E8,
+			quirk_amd_nbio_7_7_disable_enhanced_atomic);
+
+/* Strix, Krackan, Strix Halo (NBIO 7.11) */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1507,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1507,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1122,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1122,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+
 #endif


