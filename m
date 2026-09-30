Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC984EA39C;
	Wed, 30 Sep 2026 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782702; cv=none; b=Qxs9Y5FFFjpYKEz6W8yuI3i62Zi7yRiUYIcPnp4q2hCQkl5fhdxeDyHFe8dsB6d0wDb0GXfTP6IeavgiX9xkygKD9VXuQj9uZRHZKmPuRVIhsOztoNbbdv0c79NXFu+sYA++tyjQU+O1wkUvporDN4HeCfFd1fpPi3ITv+YByvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782702; c=relaxed/simple;
	bh=9hm/QbxKqUlTy/apbEdWiurixXjwWuyrnFZG/um6w+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efd62Psc3Upvmy8zVjQjhtqRWFs6Kzz6vSxdDYSJgf1nU9X6x59kqUqeNX1Lq5nyK5MZb+xfomOd4WW4+vIsuHfxvT1XE2NUgzc5NnqXMUu+0t4SCIXZG7GiX3KgZ6CKWNi/d095NLKilMxhemjJIpPVsGfGWnATLTpdyt4BSs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iInjEjdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iInjEjdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888721F0089B;
	Wed, 30 Sep 2026 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782695;
	bh=+vCfwbFKab8gLiMKbnk1tigXblxlD6eyiQNXhY4TDIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iInjEjdUW+P2+9/o0HAKePoR65AYQklYQlEO1xNXCEnrZcneXjtreEMQGE2QXKCKL
	 GZePDhL7peeW1HnjRtp0MAr5jQM56eX12AERcYLMjE3vkXLzX6cEYP4XORUz0mbzbJ
	 /jt3VelhBy6E4iBjHyCGt2P8G24oa6JZ0nOn68BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/595] PCI: iproc: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:30 +0200
Message-ID: <20260930152350.682809877@linuxfoundation.org>
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
index cc5b7823edeb7..fcde897557bbf 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1556,8 +1556,10 @@ int iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0



