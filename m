Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC4675801;
	Tue, 21 Jul 2026 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657562; cv=none; b=S8f1njfUJKt+65OLOUUNy4RZaBfA6TtbZhy8creN63KSpEeAWFuXVk4Ru3kTboP8yDXaAoUeIBHj6nUf9BwPq6Fo3vibI7zWC2gd8oGr9KAEnlBhK61/0yzbMYrAKzzsxJFA34Y4Bmxyfeu6ZPw04eELY0JVweEVAYWDkshrN4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657562; c=relaxed/simple;
	bh=4nilVRU6cHvjTov3Wkzn3dpiaylX7KrNtcwbJ6c2oFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW0OZc09i72LTNlMWsz7iAD0DeGfTuayVeJGSRDddWVqtBHg+UVCdcy+B0IPOryRhajkgHC/n6VIpwRHk6YG0JR3W3tV6+qYuL5SLlBs5LSem+T7gpiDY+Aob1cS9JX8c4L1f/1wpD3FFb3aZ8az5Ack8QcLDr9yoIVlpCvPTt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuGjmDiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuGjmDiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3486A1F00A3A;
	Tue, 21 Jul 2026 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657560;
	bh=bELTXo6i9Bsssh284QojfuFqZdgq3BnFEW5AwamPprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuGjmDiq+Wdb8K5QeScRLsO0BL449lIAoArjRvPrzdz+MmE4qN7oULvPHV9jXQCUi
	 pYBJW3QGmBcDLFxvjvN85BangrjlA1CW/uz7hmkigLXZMK72gyEsCcxlyVpxoEy3FE
	 bvAgklTMLWib/5YJ35mIAYMxTZw2yJAUwhIGlZ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ray Jui <ray.jui@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0811/1611] PCI: iproc: Restore .map_irq() for the platform bus driver
Date: Tue, 21 Jul 2026 17:15:27 +0200
Message-ID: <20260721152533.630933822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 3c2e6cc6affa8acdb99a580be1f8f297edf54204 ]

Commit b64aa11eb2dd ("PCI: Set bridge map_irq and swizzle_irq to default
functions") moved the assignment of default .map_irq() callback to
devm_of_pci_bridge_init() and removed the initialization of
'iproc_pcie::map_irq' in platform bus driver.  This led to the callback
getting assigned the NULL pointer for platform bus driver, thereby breaking
the INTx functionality, since 'iproc_pcie::map_irq' overrides the
'pci_host_bridge::map_irq' callback in iproc_pcie_setup().

This issue only affected the iproc platform bus driver as this driver
relies on the default callback for non-PAXC controllers. iproc-brcm driver
was already providing the custom mapping function, so it was unaffected.

Restore the original (and intended) behaviour to use the default map_irq
function by removing the local 'iproc_pcie::map_irq' pointer and directly
assigning the 'pci_host_bridge::map_irq' callback in iproc-bcma driver.
This ensures that the default 'map_irq' callback is used for platform bus
driver and only iproc-brcm driver overrides it with a custom one.

Fixes: b64aa11eb2dd ("PCI: Set bridge map_irq and swizzle_irq to default functions")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Link: https://patch.msgid.link/20260430021628.1343154-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-bcma.c     | 2 +-
 drivers/pci/controller/pcie-iproc-platform.c | 2 +-
 drivers/pci/controller/pcie-iproc.c          | 1 -
 drivers/pci/controller/pcie-iproc.h          | 2 --
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc-bcma.c b/drivers/pci/controller/pcie-iproc-bcma.c
index 99a99900444de1..593418c2bc3aa6 100644
--- a/drivers/pci/controller/pcie-iproc-bcma.c
+++ b/drivers/pci/controller/pcie-iproc-bcma.c
@@ -64,7 +64,7 @@ static int iproc_bcma_pcie_probe(struct bcma_device *bdev)
 	if (ret)
 		return ret;
 
-	pcie->map_irq = iproc_bcma_pcie_map_irq;
+	bridge->map_irq = iproc_bcma_pcie_map_irq;
 
 	bcma_set_drvdata(bdev, pcie);
 
diff --git a/drivers/pci/controller/pcie-iproc-platform.c b/drivers/pci/controller/pcie-iproc-platform.c
index 0cb78c583c7ea4..4c9a0c4bb923e6 100644
--- a/drivers/pci/controller/pcie-iproc-platform.c
+++ b/drivers/pci/controller/pcie-iproc-platform.c
@@ -98,7 +98,7 @@ static int iproc_pltfm_pcie_probe(struct platform_device *pdev)
 	switch (pcie->type) {
 	case IPROC_PCIE_PAXC:
 	case IPROC_PCIE_PAXC_V2:
-		pcie->map_irq = NULL;
+		bridge->map_irq = NULL;
 		break;
 	default:
 		break;
diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 22134e95574bd8..5aa677f81e4fa6 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1514,7 +1514,6 @@ int iproc_pcie_setup(struct iproc_pcie *pcie, struct list_head *res)
 
 	host->ops = &iproc_pcie_ops;
 	host->sysdata = pcie;
-	host->map_irq = pcie->map_irq;
 
 	ret = pci_host_probe(host);
 	if (ret < 0) {
diff --git a/drivers/pci/controller/pcie-iproc.h b/drivers/pci/controller/pcie-iproc.h
index 969ded03b8c2da..c4443f236ca3bb 100644
--- a/drivers/pci/controller/pcie-iproc.h
+++ b/drivers/pci/controller/pcie-iproc.h
@@ -61,7 +61,6 @@ struct iproc_msi;
  * @base_addr: PCIe host controller register base physical address
  * @mem: host bridge memory window resource
  * @phy: optional PHY device that controls the Serdes
- * @map_irq: function callback to map interrupts
  * @ep_is_internal: indicates an internal emulated endpoint device is connected
  * @iproc_cfg_read: indicates the iProc config read function should be used
  * @rej_unconfig_pf: indicates the root complex needs to detect and reject
@@ -91,7 +90,6 @@ struct iproc_pcie {
 	phys_addr_t base_addr;
 	struct resource mem;
 	struct phy *phy;
-	int (*map_irq)(const struct pci_dev *, u8, u8);
 	bool ep_is_internal;
 	bool iproc_cfg_read;
 	bool rej_unconfig_pf;
-- 
2.53.0



