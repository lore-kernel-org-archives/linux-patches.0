Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF03502560;
	Wed, 30 Sep 2026 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782708; cv=none; b=YuzpTkpr5RUUxyy9cwikS+BUgseX7orYgYbEW05nRXk0rs8mmi5w/siATvNg2/agVBF7RYVi6D0HDJwb33Kas95iuZHkhlsIYGVouyhEMZd/rWv+xMvKXJbbmPWiVsdDDryCVxKrbt6jkDSiLvbFrQCXNmR19GfOsK5rd6gtuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782708; c=relaxed/simple;
	bh=6CaQxNklmnI3IS14ewyqSBp4NXg2O5ZApm3y90ErcDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJHPFBdrX2H+JUzrKx/r3KlCQDB9CFiP5W9UTqiFe5+loPpCWf/VP94cUM5CXC998Gml83F6OyxV53J0plmu0kWVi9XhmZyQOiPfDQPdvpIuvzEcG3Mw9UflyrjYbzr9oIFnaAaoeR4JdfZ3wu0oZHgKoTq0OcG7peXYQWC33WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA2HyhQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA2HyhQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB8F1F00893;
	Wed, 30 Sep 2026 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782703;
	bh=uWzMXOJ6lWe6WVbtYm/ZlJG83YAKiDRJdlVIhnxA5jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sA2HyhQPf3zmGX52o/+mYgekqXL9S+TMysNfHphC1u9GrCBPn1KonhZC4+FWUCqeW
	 mgLulPCu+CfxuHBHD1tVgxa+c117QpVg49h2Vqu/1hNVU01QpX2u4wgBZJ003qRZp5
	 KuNXFIF9S+ZO2VyG5LhA2CC2VdyJEN+zrricMXrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/595] PCI: mediatek: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:33 +0200
Message-ID: <20260930152350.745636261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit a29812a55da8d0dbeb071b26ac428c338e3fc389 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-7-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index d2aa0a6819672..b7e6ee250e1a7 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1155,8 +1155,10 @@ static int mtk_pcie_remove(struct platform_device *pdev)
 	struct mtk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 	mtk_pcie_free_resources(pcie);
 
 	mtk_pcie_irq_teardown(pcie);
-- 
2.53.0



