Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB81549A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65D9C433EF;
	Mon,  8 May 2023 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544729;
	bh=eKMaDKJ3qLYO7/IGZRGmIrcFA8WxyEx7wDOdy/wg8vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqHMKzz9+id3CDfPni54v8Ll1HaPqG4z/NnzWkXLHake1autJ5CEOQnRs6CkTDWEy
	 PsNQFplM3T8kVn8e8MThZgGZtS8DRx14d8iXjWIGDDdx9F3NRvAi1Aoz+yd3zqQTHI
	 K2welC5YVSFio0Z69mfSyfA/0NfpJju2Tbm2OMv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 505/694] PCI: imx6: Install the fault handler only on compatible match
Date: Mon,  8 May 2023 11:45:40 +0200
Message-Id: <20230508094450.502482454@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 5f5ac460dfe7f4e11f99de9870f240e39189cf72 ]

commit bb38919ec56e ("PCI: imx6: Add support for i.MX6 PCIe controller")
added a fault hook to this driver in the probe function. So it was only
installed if needed.

commit bde4a5a00e76 ("PCI: imx6: Allow probe deferral by reset GPIO")
moved it from probe to driver init which installs the hook unconditionally
as soon as the driver is compiled into a kernel.

When this driver is compiled as a module, the hook is not registered
until after the driver has been matched with a .compatible and
loaded.

commit 415b6185c541 ("PCI: imx6: Fix config read timeout handling")
extended the fault handling code.

commit 2d8ed461dbc9 ("PCI: imx6: Add support for i.MX8MQ")
added some protection for non-ARM architectures, but this does not
protect non-i.MX ARM architectures.

Since fault handlers can be triggered on any architecture for different
reasons, there is no guarantee that they will be triggered only for the
assumed situation, leading to improper error handling (i.MX6-specific
imx6q_pcie_abort_handler) on foreign systems.

I had seen strange L3 imprecise external abort messages several times on
OMAP4 and OMAP5 devices and couldn't make sense of them until I realized
they were related to this unused imx6q driver because I had
CONFIG_PCI_IMX6=y.

Note that CONFIG_PCI_IMX6=y is useful for kernel binaries that are designed
to run on different ARM SoC and be differentiated only by device tree
binaries. So turning off CONFIG_PCI_IMX6 is not a solution.

Therefore we check the compatible in the init function before registering
the fault handler.

Link: https://lore.kernel.org/r/e1bcfc3078c82b53aa9b78077a89955abe4ea009.1678380991.git.hns@goldelico.com
Fixes: bde4a5a00e76 ("PCI: imx6: Allow probe deferral by reset GPIO")
Fixes: 415b6185c541 ("PCI: imx6: Fix config read timeout handling")
Fixes: 2d8ed461dbc9 ("PCI: imx6: Add support for i.MX8MQ")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 55a0405b921d6..52906f999f2bb 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1566,6 +1566,13 @@ DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_SYNOPSYS, 0xabcd,
 static int __init imx6_pcie_init(void)
 {
 #ifdef CONFIG_ARM
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, imx6_pcie_of_match);
+	if (!np)
+		return -ENODEV;
+	of_node_put(np);
+
 	/*
 	 * Since probe() can be deferred we need to make sure that
 	 * hook_fault_code is not called after __init memory is freed
-- 
2.39.2



