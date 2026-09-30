Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7759023ABBE;
	Wed, 30 Sep 2026 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794530; cv=none; b=WDWtqSSfVB7L2cAAw0vl3mrhtU5zrtuuIPJQ7naUr4vTiyU2+qnmYTlByDBTs3UIpJXSKPZPKwTIHiGqCmWuCsa/Fa3u42YgEJ09O7h6mlyBvNbR2azp+VCDyh31tx0TbHkQdsfLVJ2Iqq0HYlWhYXv/yGs/PCiJ/U29c0jWXto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794530; c=relaxed/simple;
	bh=/KetgQ8NBIJzb2u7Pd5mbtXVzVB6HdjePA5K7fU2wh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuM+YEmTnlC2mPiUXan1wcLg37FOD3gV13STmKAwzCzYHRSC5Slgnt83a3GSppMdxLLPaLO7Hg/hrc+d521EFZrQ2LUWQkfBYcRbrnYK13+M8bUUiJuq02Nl7Mscb49DQmqwOSkST/5m8qWH5p5Xy4abNllag1quykKnxGKO0N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeJ+4IdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeJ+4IdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E8C1F000FF;
	Wed, 30 Sep 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794529;
	bh=D8myar4EzT8hCF6cIo9fnsexO0NQQJhpCZ5wSgSlJ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeJ+4IdZ7F8qqImKG2y14McitrVuYbUcfi74h4yLpMQb6aI/KgkBpvGPkCw4i7Dys
	 Xjsk9SWet/4zfp+nzU8dLLOgYk622LAuzLfonWDdd/Z+uMUbyH0BnzaPcJUOKjDrh7
	 SX464k5J28QOyTHdmHbdY+W37pcZeWhqp13VOYNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0244/1193] PCI: iproc: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:28 +0200
Message-ID: <20260930152439.613166237@linuxfoundation.org>
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

[ Upstream commit a6a64e150f12ad5391e0a0d60f6a3d119b06ce50 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-6-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 49f127a2e123f..fa3539d1f570e 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1540,8 +1540,10 @@ void iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0



