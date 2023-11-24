Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA52FC4E;
	Fri, 24 Nov 2023 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4OfZWXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72454C433C7;
	Fri, 24 Nov 2023 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851246;
	bh=cbsUtBvH7kOFSu/kwFbhAgUzXaDmGP1afYQLPC1a0IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4OfZWXGUMnIiTNtgbuC0B9O+JWLpRD/p7bjGBNeuSnLd8akPEBqwwjVG6uOsyEbk
	 qiJXgVwHh6izEr6jtOiVAA+sr1Q8MeODxV5P/KxrvuYqa9Hm1BXmHx1IGw0iKCWKdp
	 DsqFA9+faEb2Jtv3CMs2tuUo84pjfA2BdhCC5FGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 371/491] PCI: Add quirks to generate device tree node for Xilinx Alveo U50
Date: Fri, 24 Nov 2023 17:50:07 +0000
Message-ID: <20231124172035.731921863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit ae9813db1dc5ac987a09889791155a7b8c527f8d ]

The Xilinx Alveo U50 PCI card exposes multiple hardware peripherals on
its PCI BAR. The card firmware provides a flattened device tree to
describe the hardware peripherals on its BARs. This allows U50 driver to
load the flattened device tree and generate the device tree node for
hardware peripherals underneath.

To generate device tree node for U50 card, add PCI quirks to call
of_pci_make_dev_node() for U50.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/1692120000-46900-4-git-send-email-lizhi.hou@amd.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: c9260693aa0c ("PCI: Lengthen reset delay for VideoPropulsion Torrent QN16e card")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9fa3c9225bb30..3ec7bcfbf4dc0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6161,3 +6161,14 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
 #endif
+
+/*
+ * For a PCI device with multiple downstream devices, its driver may use
+ * a flattened device tree to describe the downstream devices.
+ * To overlay the flattened device tree, the PCI device and all its ancestor
+ * devices need to have device tree nodes on system base device tree. Thus,
+ * before driver probing, it might need to add a device tree node as the final
+ * fixup.
+ */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_XILINX, 0x5020, of_pci_make_dev_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_XILINX, 0x5021, of_pci_make_dev_node);
-- 
2.42.0



