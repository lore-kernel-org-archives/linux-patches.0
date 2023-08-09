Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828B91773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B1EC433C8;
	Wed,  9 Aug 2023 11:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579926;
	bh=tXN2i4iaFDpDRoWkt5TKaGFKaH4DQHSeWpZsFdu8oRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qio5Yz8ljprIMiwuVWGt+JtngsZxsbgqAPUxaTPI5woOANTn22yqrVv8bZ1K0V6Kn
	 MmY+QFRwV5uH4SDMvK9mtnlVgYDTLA6EDWk1aEKIo+QiL9Xf6PKZ7w+LhMkL0L2b3Y
	 C/rmCgZilhd1So1cssFFVpia11H+ZmgONl6UvesQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 4.19 164/323] PCI: rockchip: Write PCI Device ID to correct register
Date: Wed,  9 Aug 2023 12:40:02 +0200
Message-ID: <20230809103705.657012610@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

commit 1f1c42ece18de365c976a060f3c8eb481b038e3a upstream.

Write PCI Device ID (DID) to the correct register. The Device ID was not
updated through the correct register. Device ID was written to a read-only
register and therefore did not work. The Device ID is now set through the
correct register. This is documented in the RK3399 TRM section 17.6.6.1.1

Link: https://lore.kernel.org/r/20230418074700.1083505-3-rick.wertenbroek@gmail.com
Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c |    6 ++++--
 drivers/pci/controller/pcie-rockchip.h    |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -124,6 +124,7 @@ static void rockchip_pcie_prog_ep_ob_atu
 static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn,
 					 struct pci_epf_header *hdr)
 {
+	u32 reg;
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 
@@ -136,8 +137,9 @@ static int rockchip_pcie_ep_write_header
 				    PCIE_CORE_CONFIG_VENDOR);
 	}
 
-	rockchip_pcie_write(rockchip, hdr->deviceid << 16,
-			    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) + PCI_VENDOR_ID);
+	reg = rockchip_pcie_read(rockchip, PCIE_EP_CONFIG_DID_VID);
+	reg = (reg & 0xFFFF) | (hdr->deviceid << 16);
+	rockchip_pcie_write(rockchip, reg, PCIE_EP_CONFIG_DID_VID);
 
 	rockchip_pcie_write(rockchip,
 			    hdr->revid |
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -132,6 +132,8 @@
 #define PCIE_RC_RP_ATS_BASE		0x400000
 #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
 #define PCIE_RC_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
 #define PCIE_RC_CONFIG_RID_CCR		(PCIE_RC_CONFIG_BASE + 0x08)
 #define   PCIE_RC_CONFIG_SCC_SHIFT		16
 #define PCIE_RC_CONFIG_DCR		(PCIE_RC_CONFIG_BASE + 0xc4)


