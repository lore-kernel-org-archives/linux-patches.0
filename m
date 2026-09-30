Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267573515C5;
	Wed, 30 Sep 2026 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794542; cv=none; b=F7JxvIWkjoGKMRmTZF+wLP9aaDdabONacGz7xrwUqu3GFMwXivRAd3F//jMsVwTQV8b0NvFaIRcONdzSJmCRTvxmblxOD0B2ph1V1RbgGvPv19L2SoWqlGpS9pPEQVst2lCY0+rbG8P4yJlWyXcbq02MxLQDoZVnSSy0bbkfEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794542; c=relaxed/simple;
	bh=rEhrdSiH5IQiawPnBzvP0kOWLfg76rkO3mmYmNp5Hdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgWfZLo4pSYkbFsaT90cp68xwNiZ4HrX++bTBDRNWKsa+LMj/g4r/UiIVcc/tZSv+o7Jx5O6TIg5BW+JQksxwRptcWiq1XplpUfVtcuT8cDescwbzyJ5jJEiki+Zf332D1lzxpQcMyurzjSe4tNlOeZS87733AyVn8+bBrqRegM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbV75+mS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbV75+mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FE41F000FF;
	Wed, 30 Sep 2026 18:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794540;
	bh=ojH1sCvBTQy+KRX4DK4bWX/u+ba3VfntqvpK4KMRL3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbV75+mS9W7kBl5vBQCu5wWd6mr3ZXDgxNAHM8enFaWsx9t2NXz8HZwt6tkkb+Isr
	 6gv5i8Q+F4Zal2FS3enpQCKGE6M0uxREu5KCBWSLXzr9QE89rx4UQZj0rn1kqioJ4l
	 kA+namGjDQJUkazmjzCp7iGl0QMVFqy9NN0S7hKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0247/1193] PCI: mediatek: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:31 +0200
Message-ID: <20260930152439.678280754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67c9f55c2f7ee..f8faec83323dc 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1174,8 +1174,10 @@ static void mtk_pcie_remove(struct platform_device *pdev)
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



