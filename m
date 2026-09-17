Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3759653A39F;
	Thu, 17 Sep 2026 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664637; cv=none; b=I59lfgEoeAitSdGoXMCvQYSLTPA3d0gwAJxNaZoeix1wJ4MPQ45upOrbu69ZtPQRNhlbek9oYW2BXDSyiOuPHiVsQN1Y2G0AThKwQtrWY5iJo2slQFyZ/E6V2SGChWTkHc4LwdZii8smxWvYy6Sf91eR+JzI4GSyX8nsXMk+saY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664637; c=relaxed/simple;
	bh=mXmgKlcyN+ivyBAHTmoWZqzh/MnkskCXSZbZ/EnZ6Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAh2wAVLqqaU4wUKuhYbx6zjzseU5fDi5huQrj9aeTRT00oElK8X6E+j394fPlRjpcaVBHYkq3rtVxlZab6oO++lJOgyJxUptJZ15DNYsGlzhSWusqiXmi0cY7DBBO4ovdNuwTDZVWxCoCVMj6czF6sF+TzRFey1n9074bEqVp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd87ZI9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd87ZI9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDEB1F000FF;
	Thu, 17 Sep 2026 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664636;
	bh=0ZCr7p9smhxbyspM6xBInp5NLEMebMLm+iVYiqsqylU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wd87ZI9tKmg3BAyPyQJTUk7KaQ3H0sfHHsBAwUN2VhuRcl9mKYmPOtXuSqWtJwS5K
	 T57tEBol1JNJFSonu67UTtojc9lVNTGKkUxTvMcP+b6b2Q4tylszATVD9AuZTO/YXJ
	 Kk2ynPBZx2CZYV4BwOJi0Qi61/BsiGH3d8tsCVug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0439/1250] PCI: iproc: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:03:54 +0100
Message-ID: <20260917151603.909690439@linuxfoundation.org>
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
index 5aa677f81e4fa..61dcb232757fb 100644
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



