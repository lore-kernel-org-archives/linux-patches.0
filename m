Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212B4F4042;
	Thu, 17 Sep 2026 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664646; cv=none; b=QrSth6PwnT0aNpkZp8+aYhdgr3SlAWYpQyI9+hFS1nMav7tad0q748DvjWgVglIpznZWIwKG5q0w2l9qfWQqOJlHsHgLrDT3vgtM/6bRSEhidQtZHw0RSmnssdbTffgnC1nGyONOXe4Q00iD/yNyp54w524oBDbc62oxmGCRdTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664646; c=relaxed/simple;
	bh=JkEOxT1YUBmovcL/UPY+Kq+k0qrDqZIOBoOzTVrpH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONAzsaAQHyXKxZKOj9Hp3Qcp/Yq6vnO+WeeregBA4Nqhq5Lu+AOKcZArSgH7Nzx4QJoY7TvDu6lgTwN/W8iVXGlr5BBjvTx6fddS7Y4J8CEzrMAw11uH+D6EWa3CTf0BK1x8luFBybzfnLiUbStmeGhhLuIbfkG987fPFx089Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvu+Ohoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvu+Ohoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957E91F000FF;
	Thu, 17 Sep 2026 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664645;
	bh=MsY8Bi9xHscNvnkb2e2ms1+d4yxrSUfZhAGvg1uGkUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nvu+Ohozn6FRf8MfuvTxMmk2SQcL6xnBaRfdExn/3qWKBPsh1tFtFKkg60IBZCasT
	 3YllJCqqfSpXT2QKcrEvIM65YsNNWUBsGtHiOfpYALtvw4qmp5r6nkG7MUKkjS/fcr
	 DoiVWMf9MUVSnpgzByOUKkniQCbL7vvZvlVyrp7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0442/1250] PCI: mediatek: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:03:57 +0100
Message-ID: <20260917151603.985927092@linuxfoundation.org>
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
index 6afce031523bd..ce2a3e04a953e 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1154,8 +1154,10 @@ static void mtk_pcie_remove(struct platform_device *pdev)
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



