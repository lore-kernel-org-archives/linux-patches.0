Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1050E340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301087; cv=none; b=BA50H9V8B7aWEv2oWYQUAvMZexlyVnlWcYvTQRj685TKVUDDjzVTSF1hZW91ECULlSzYzU42YpvQ4Fw454DYrA56kmxS2U/h7DLR0EQOzmMicD4mfFrUK1qUGjl+dqAmDQQAgFty+ldIJim2J5XPVtjRAKpeMVjN96xrHnoZDuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301087; c=relaxed/simple;
	bh=Qe6oVHYQDHV1NO9+lVk2T4oGIaNH8nqDeXi7hq8ftyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soBTII1IIsAvQ11MR6Z6d6QU9yWZKuTtyAwmzC+R95siGe4+3aIrZ0MgypXjeheAERUzJd3r6fWnBIu0mxai/FMNAuRwY8MWaK8L6xUAhJkrDZo7wPqtIdC7C14FvG2jf7EkVCYORryqIdovYG8c43DYKcagJk8z7H7K6gegro4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZExRF2pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZExRF2pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69170C19423;
	Sat, 28 Feb 2026 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301086;
	bh=Qe6oVHYQDHV1NO9+lVk2T4oGIaNH8nqDeXi7hq8ftyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZExRF2pUbOgQ2IFF5rEh+8kTmMQ82UiV2tBVnGhAHlMQm8Nh2TdBP2gHwRLtSKo/8
	 7/D13iuXcieD+FC0xVksR86LoRAs2cngv7Md5JwO5y67ZqaIOiyD+VpXsQ+0a3aIIR
	 gWIwpOscvCp8gKEcalMirK/VQyr6/AXCRAsnPdeCxtJyqtcAqf8cRh0KlnFmR7W0he
	 Oy9MmSiEW/8cxsrcmkmpbF6LYMK5VbvVjk/21Sk0ZK4Yde3Z/EMDCemFcNbCB9RJTN
	 TrdKydejOEH49UJVaLkouJ3SGjUDdM3Cgt94VI/1HgtXP4t8qq2YRifjwQSp+g8OR6
	 VdiSVaHZr6dEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/752] PCI: dw-rockchip: Disable BAR 0 and BAR 1 for Root Port
Date: Sat, 28 Feb 2026 12:39:07 -0500
Message-ID: <20260228174750.1542406-236-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit b5d712e5b87fc56ff838684afb1bae359eb8069f ]

Some Rockchip PCIe Root Ports report bogus size of 1GiB for the BAR
memories and they cause below resource allocation issue during probe.

  pci 0000:00:00.0: [1d87:3588] type 01 class 0x060400 PCIe Root Port
  pci 0000:00:00.0: BAR 0 [mem 0x00000000-0x3fffffff]
  pci 0000:00:00.0: BAR 1 [mem 0x00000000-0x3fffffff]
  pci 0000:00:00.0: ROM [mem 0x00000000-0x0000ffff pref]
	...
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: assigned
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: can't assign; no space
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: failed to assign
  pci 0000:00:00.0: ROM [mem 0xf0200000-0xf020ffff pref]: assigned
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: releasing
  pci 0000:00:00.0: ROM [mem 0xf0200000-0xf020ffff pref]: releasing
  pci 0000:00:00.0: BAR 0 [mem 0x900000000-0x93fffffff]: assigned
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: can't assign; no space
  pci 0000:00:00.0: BAR 1 [mem size 0x40000000]: failed to assign

Since there is no use of the Root Port BAR memories, disable both of them.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
[mani: reworded the description and comment]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1766570461-138256-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 3e2752c7dd096..79e55b9833e4a 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -74,6 +74,8 @@
 #define  PCIE_LINKUP_MASK		GENMASK(17, 16)
 #define  PCIE_LTSSM_STATUS_MASK		GENMASK(5, 0)
 
+#define PCIE_TYPE0_HDR_DBI2_OFFSET      0x100000
+
 struct rockchip_pcie {
 	struct dw_pcie pci;
 	void __iomem *apb_base;
@@ -257,6 +259,8 @@ static int rockchip_pcie_host_init(struct dw_pcie_rp *pp)
 	if (irq < 0)
 		return irq;
 
+	pci->dbi_base2 = pci->dbi_base + PCIE_TYPE0_HDR_DBI2_OFFSET;
+
 	ret = rockchip_pcie_init_irq_domain(rockchip);
 	if (ret < 0)
 		dev_err(dev, "failed to init irq domain\n");
@@ -266,6 +270,10 @@ static int rockchip_pcie_host_init(struct dw_pcie_rp *pp)
 
 	rockchip_pcie_enable_l0s(pci);
 
+	/* Disable Root Ports BAR0 and BAR1 as they report bogus size */
+	dw_pcie_writel_dbi2(pci, PCI_BASE_ADDRESS_0, 0x0);
+	dw_pcie_writel_dbi2(pci, PCI_BASE_ADDRESS_1, 0x0);
+
 	return 0;
 }
 
-- 
2.51.0

