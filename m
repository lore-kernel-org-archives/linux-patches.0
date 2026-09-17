Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C904F3916;
	Thu, 17 Sep 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664640; cv=none; b=hOH//AtZUeB7PMCqoSZHpn1fb7WzebyID4VydOe0EJOMSdBknQy5Uj2pDAZOy4P0ouRTBmrm39PdVefi82ExcKLsmlhWA6bKMeLAONCxnhYaKv8mojBiXioXW00/5GN+su6feIywpmfjbPxH8iZWhO+Qa1icCCODxe5td5AuQvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664640; c=relaxed/simple;
	bh=VwN/qeBeBaEJrt7uMh4HLveinsHVFo11RJd003k40GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC4E1SKhXkwuCwbuQXxVTz94JaIqHykCYlsYcDabIkmDO8KjWdGTrnCDLR6SdECltFuG+cV0lAo4Mjl4G5CtMJTTN5/t/1XSlOS7dKqF6x0opRoKNNJ2RZEm6wmqg2Lw6TbR2IAA/Zq0824A2mg1G6kNB8F1HQ81zUv0sSuiSGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXKeziVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXKeziVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4FF1F000FF;
	Thu, 17 Sep 2026 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664639;
	bh=JRWgudZA4lB6azTDtIFRApte5blLKQlSpPTCcyzOrAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXKeziVj3H4NUQ5HE6AYTcHt5UlkT0MBSAWfFKvZ71NWWNWj6CUfWvxS9RT5bb2/E
	 Jz3+U8glcIH2M7q4bN/WZQMnmxspjmnfiQ9VIQiTb3GJwd4mwFITt8JiIFUT8QVJP9
	 4XU1HbyF9JP7w9fQDb829wBQzVTk/CVBOlDavrXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0440/1250] PCI: altera: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:03:55 +0100
Message-ID: <20260917151603.933955327@linuxfoundation.org>
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

[ Upstream commit a8759c8ac48c0419f5899e95a6ffc611b07c965b ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-4-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-altera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-altera.c b/drivers/pci/controller/pcie-altera.c
index 76f3823d96139..8ef56e2fabcfb 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -1075,8 +1075,10 @@ static void altera_pcie_remove(struct platform_device *pdev)
 	struct altera_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	altera_pcie_irq_teardown(pcie);
 }
 
-- 
2.53.0



