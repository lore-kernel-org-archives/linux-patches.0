Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923464EFFD7;
	Thu, 17 Sep 2026 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664643; cv=none; b=jhWRRLrGHuqHzElTrnkw9qvYj6hSfeYkATwfa3oPEHj3vLBVTi01ZrCVkNZvlZQJCQsKf35cop2DqADbugtzAcNFiYDJp3wkvmxRqZ1bD0hAp4gOilwOTdenKICXqu9wdUEZC+q9uEdb9MgYkBsUr8+nxn8A7eub+d4lu53w7XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664643; c=relaxed/simple;
	bh=3qHC1xxs8BkUEfMwFs4p2c+erLhRFLQh2D1wdI4RosM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACQ2M/qyu9xFNKDVj0AJ+8OGD5xY7DP8fhKayaenb1tiy1xodDkP1pg0ZbJMIvkFMYL0ASBDvI7XSR3/gNJFlZbqWdqCi4IUUW2W6BE9xjE/+nKo+KzxzDbAKrCmoj4Z2wIOexgH00tcnDutmmRDctFIA6nvjpWv6WnAEJeyu2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkiMaXrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkiMaXrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CEB1F000FF;
	Thu, 17 Sep 2026 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664642;
	bh=eN9121qfo7DWOlcjwb9ajvzXdMVsUT0NgWgvGN+0Hh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkiMaXrvGAxwchuxTHCKx+GjqxWz5WSjmPHkFmeTQTwfl3+2jAsaxZOsqViCRbH5L
	 AbP+WGKtwRSe8BOZSLyzHODq2vtSUvsLjtUsT5uVstnslWRfzFSKja0vM0/U9X4mgn
	 6HlGgeicoiduyQskor29FlLIyBayHlOHy+NdA79c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0441/1250] PCI: rockchip: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:03:56 +0100
Message-ID: <20260917151603.960181638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index ee1822ca01db3..d203c4876d304 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1012,8 +1012,10 @@ static void rockchip_pcie_remove(struct platform_device *pdev)
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



