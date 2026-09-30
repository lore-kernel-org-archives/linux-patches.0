Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1236A033;
	Wed, 30 Sep 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791049; cv=none; b=dmGTYExoSB+3kvAi9zVPrU/A3x/AKezFgdiDBJoYkrEqVx4cYg1M+uUK5QlNMNNsszrw3K/R1ctU0MmXGqyp8givmdch2bbU88ibq2TIIHFtS8315ueL0CAEPsYL2T5Han3C0giZ+N4JRKWJ331Y88e7R7HHyZGbb7bsfXaCb+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791049; c=relaxed/simple;
	bh=H50+c1n4r1cBTDirNN9DFmFg/HwL9IVqdmZ3FNemGm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFitIXLQt59CDqAxTSvUJYSkGsHGfD2gyBA/4mxI4rJCmu72ZAtPwUQJXqA0P0EeZA670mXd/hYIDxYg1EarzEP/V0rlAJvPz1jMcuFEH1w89pzaDlJC7rURLD/oOFkpe1wlFnSmRSKlngLVgYVZoLoTsU3CWvRaHnjLjWm86Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOuSEPJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOuSEPJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED16C1F000FF;
	Wed, 30 Sep 2026 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791048;
	bh=bCZ/tWmPQnd4yKk1OBVDad81bsl/0tTscCnvXYQhohM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOuSEPJ0gEjmXmwxHazzr7iYfgKFfRhDoGzqDRjeNmtpD+xsRmBpaiagFpv88bUQz
	 vdM+TwsfWyE2A0RFHU1KigPiD0vL3quNUoerHQAhBJ8ZgEtPxVngFS/E2zN4MBSheh
	 iZFXcO5A9l+jggA9YiF9aHX0WG4S0D46/bSRXcR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/752] PCI: rockchip: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:35 +0200
Message-ID: <20260930152401.770286594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 0bd9611587bb494c33566d825fe34b2705e4b167 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-8-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 9e9e90e7c0fe3..d2fbf73ddd648 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1018,8 +1018,10 @@ static int rockchip_pcie_remove(struct platform_device *pdev)
 	struct rockchip_pcie *rockchip = dev_get_drvdata(dev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(rockchip);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	irq_domain_remove(rockchip->irq_domain);
 
 	rockchip_pcie_deinit_phys(rockchip);
-- 
2.53.0



