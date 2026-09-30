Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF947A0DD;
	Wed, 30 Sep 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789378; cv=none; b=Bw2b3v5Eqyr5+Qtn08yjmk5xfLlG+1RLEToLDcE4LvmQPeh2z2QGcithFl0gXegCKKyVrW/A2+5Ng5IKO4wmvK3/GZZTIOssChgS20Vyjgc8MQS6HT0W3qcn9dhnbxOBPQauTSlCfzXzWnXyPMpY8YA35woHgSMvhL3qUdjZKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789378; c=relaxed/simple;
	bh=WJ+ISjs0UZY97Ggy1G6+VQ+Y98+cqsiLmR4JCo0Wpw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5HZjFeersOOmquy0V6SOQgrVvF7aOl3MYHB1Tegyfft1mWeUI65nlf4voqlWk4dNcbTsugWDvIJpf833Ha8Bm8OdoTtaCmGxb8bL17Yjpv0W+i9AdF5M2Xr5cJzq9EVeSPj3/avJMmfmYW1Mdlp3OdG8nFpIXu/jMEZ+vhlyX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTV6R8Iu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTV6R8Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC031F00898;
	Wed, 30 Sep 2026 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789377;
	bh=bNc2Qr9h2biAa03QDJ46BKrSKlYvuNJLyPUoKmPoqpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTV6R8IumHl4e6Rvuc4mNp6AbigXR1dO9fsOXtZ6MB+QpTf8Cp8U1dLOpDqrfiWbc
	 euoMQTscnkPqcjTi9Yal3vNJd71yWK3wDqw6aGgH7BJlcnlQ0OFpaU3PYQWRoYb/cw
	 B17yGuUGMD5ohbd1o1BMqznvK8HH7Xd/mzqzrw88=
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
Subject: [PATCH 6.12 457/877] x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11
Date: Wed, 30 Sep 2026 17:22:48 +0200
Message-ID: <20260930152424.540571160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -846,6 +846,105 @@ static void quirk_clear_strap_no_soft_re
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
 
 /*


