Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612251A156;
	Wed, 30 Sep 2026 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784727; cv=none; b=jaO7HMQSMAcXgWOTuk6YPKBHwgQbjYsIT2i6vdKOEMe7NMV65TypESUBAvDF/a4gmqmFZRwYH6IDPEBcrlm4rvzXNDCpANpsDq3GPcmegcQ0sEx/GhMxLokjlsgDTVT65YaPhJXHAKaQeNZ6Wk+wfjIrZPY278lJU+e/CZhuX4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784727; c=relaxed/simple;
	bh=qadzrBIFbIi2Wx0t6YZJ0VNhxfFk31HfMkJ5OiuFoRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Db0aotGgtFyqVAdkjOpD8wG5NNtwGMPrhHSHlfecWFX2F9rTtIIReQIY8y2V9EUkKfl0LDxEode2GTKls+UA8rDp9oejGneMopQn9gw9hWtUKcOe57L/nTF2Lp4yfbO1s4Cpn26riBMLyridwiwR3v5NgUdRpYf521QLo9YLQM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVLxSyTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVLxSyTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528961F00899;
	Wed, 30 Sep 2026 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784722;
	bh=/BZzYi2CbLgtjYzJfS7dFJIt2H+WnQw7V40FnEOhyQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVLxSyTWFyxK3Ku+a/m2O9ustlfrPYIRpJz8BJ25x98t1kseiM1YU2wXrIrsCCVTp
	 i8jG7l365IjC+JN6lWgrUlS1MMVz/AGjHuBNJ1sjrN1qj9F7e1wUwyw7OLGjaheJg0
	 ewWvjBnlC/a+i9pAoEss80azOgFVacp1/DhvPZwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/982] PCI: rockchip: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:47 +0200
Message-ID: <20260930152421.340613330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32b82e916b57d..de521ad927c40 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1021,8 +1021,10 @@ static int rockchip_pcie_remove(struct platform_device *pdev)
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



