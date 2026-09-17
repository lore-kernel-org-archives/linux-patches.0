Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1386C502560;
	Thu, 17 Sep 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668167; cv=none; b=aqcOduTXgzmCYFNshFn7ZBSyp3GPReAmmVoZWIR6hSpdxYriyI/SuyhhUDDlb0yA0qXU5AufvNfliE6D2C6weDazhBGs33B/pi82q9y0M7y3sLDGmbjCzU5jEd+xHI/gtzIFw/Ehmbr2pRhYwqeQJ8KIoSR0DyiNAgqfoWfFOu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668167; c=relaxed/simple;
	bh=sDDxz5hSfXtdRZAyTpD0f4oj880+QdcwbIUFRZipIiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hauHx+Un54wDtGG5Yx67dTu+qKTVA2QOoP1jxlJUcJ9B5auRazGgkQ3ZYbGSZc159cbGoISkAnxrCm4LbCCTJNDPiMjrKhCDKBiZeI/SF62KfwLW5KuG4RIvgItkNSg6OveJAK2x8KGe5oYPwvqE4O2ly8ZfPB19VPcgigUK91Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTsFEVMH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTsFEVMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3DD1F000FF;
	Thu, 17 Sep 2026 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668166;
	bh=4Dec0LpLTUX14p+GF3SsMSvJ1Qn6yhT8wBr5pjg5CuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTsFEVMHOweMTzkNqkJKPuj0D/7GxA3G3HtFQu8Jx0QT/qo9b2i0Owy2qlJyW851w
	 LNlKGpoUdoXnP/4kprEvomb/bFZVu7GJO/r21l+ZsuqNJyuX6BRvuoB4UNAwfnBT89
	 buyPPYkGIFJryD1hkVwfleYZ4EaYJEVZu0hldBz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0336/1102] PCI: rockchip: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:04:39 +0100
Message-ID: <20260917151548.070222878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index ea1df03edc2e4..5e17a728f0bd2 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1021,8 +1021,10 @@ static void rockchip_pcie_remove(struct platform_device *pdev)
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



