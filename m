Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABD2450902;
	Sat, 28 Feb 2026 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301424; cv=none; b=cpgGmn5VcYWg4qpwPl5/BuzQTjzIAG1rv5uPMcqGoGj1JSrWnWYIw7FtRLcRrxlLzFWd5pIWitxWTIiJ7lyIERCWgAHLvaxGdVCLCWOLb9i7sEezdTqul/9nD+Ny0GfJHJPh/jn++iEA9WSgXkKBZiIoXpEdlsDPf8i6Q0E1vFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301424; c=relaxed/simple;
	bh=uywr7CSIBVJdzBj0/d7eb/WIoGhpGFKanqhG09sqgeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH/+0tEtgAUgzizeDL3bcxrsEEGJfRWQ1sSNOrwyZwOaZmCQxJHntUdufIGjUnOgm53rVNqFSXivVe4f689oeGGBDxO2wDvVIde+OrVGys8dA5py0x7ON8izMC+FcJtp+MplkMquSmAjjgojualrudKwsciaRUwkbIG715CS49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWnd9j+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWnd9j+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7C5C19424;
	Sat, 28 Feb 2026 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301424;
	bh=uywr7CSIBVJdzBj0/d7eb/WIoGhpGFKanqhG09sqgeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWnd9j+NEgcLj/+s6xv1hWJoYLc7V9COOAGSYmx7zFD4yy57PWal8P13qheeJPhEs
	 Fd5bhzC6+DHVvImCNH4BkVzH0Xy2I9Xt1rbJQ4HxsG6C5ERuSoYcmRyuRF2C71zexz
	 ApQyymYM36Lb85egrpCGOkB+/UAopO4S8BZtyZtT7X9+AtElduwFaU8ujrXSEfe8hB
	 BcWKHYpO2jPrD1TxFcSe4ybnTffUNt2SdHxDTe3bnUGiGAjIPYT78otWWVJEX8cFPg
	 f2nhzUJP6rmSoY/yE3l0iri1ldHy5iJnRO3zBohIpgz9y6puSwansDi01uU27K/Ajn
	 zqqJ9kAYC3kiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 614/752] PCI: endpoint: Fix swapped parameters in pci_{primary/secondary}_epc_epf_unlink() functions
Date: Sat, 28 Feb 2026 12:45:25 -0500
Message-ID: <20260228174750.1542406-614-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit 8754dd7639ab0fd68c3ab9d91c7bdecc3e5740a8 ]

struct configfs_item_operations callbacks are defined like the following:

  int (*allow_link)(struct config_item *src, struct config_item *target);
  void (*drop_link)(struct config_item *src, struct config_item *target);

While pci_primary_epc_epf_link() and pci_secondary_epc_epf_link() specify
the parameters in the correct order, pci_primary_epc_epf_unlink() and
pci_secondary_epc_epf_unlink() specify the parameters in the wrong order,
leading to the below kernel crash when using the unlink command in
configfs:

  Unable to handle kernel paging request at virtual address 0000000300000857
  Mem abort info:
  ...
  pc : string+0x54/0x14c
  lr : vsnprintf+0x280/0x6e8
  ...
  string+0x54/0x14c
  vsnprintf+0x280/0x6e8
  vprintk_default+0x38/0x4c
  vprintk+0xc4/0xe0
  pci_epf_unbind+0xdc/0x108
  configfs_unlink+0xe0/0x208+0x44/0x74
  vfs_unlink+0x120/0x29c
  __arm64_sys_unlinkat+0x3c/0x90
  invoke_syscall+0x48/0x134
  do_el0_svc+0x1c/0x30prop.0+0xd0/0xf0

Fixes: e85a2d783762 ("PCI: endpoint: Add support in configfs to associate two EPCs with EPF")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[mani: cced stable, changed commit message as per https://lore.kernel.org/linux-pci/aV9joi3jF1R6ca02@ryzen]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260108062747.1870669-1-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-ep-cfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/endpoint/pci-ep-cfs.c b/drivers/pci/endpoint/pci-ep-cfs.c
index 43feb6139fa36..8b392a8363bb1 100644
--- a/drivers/pci/endpoint/pci-ep-cfs.c
+++ b/drivers/pci/endpoint/pci-ep-cfs.c
@@ -68,8 +68,8 @@ static int pci_secondary_epc_epf_link(struct config_item *epf_item,
 	return 0;
 }
 
-static void pci_secondary_epc_epf_unlink(struct config_item *epc_item,
-					 struct config_item *epf_item)
+static void pci_secondary_epc_epf_unlink(struct config_item *epf_item,
+					 struct config_item *epc_item)
 {
 	struct pci_epf_group *epf_group = to_pci_epf_group(epf_item->ci_parent);
 	struct pci_epc_group *epc_group = to_pci_epc_group(epc_item);
@@ -132,8 +132,8 @@ static int pci_primary_epc_epf_link(struct config_item *epf_item,
 	return 0;
 }
 
-static void pci_primary_epc_epf_unlink(struct config_item *epc_item,
-				       struct config_item *epf_item)
+static void pci_primary_epc_epf_unlink(struct config_item *epf_item,
+				       struct config_item *epc_item)
 {
 	struct pci_epf_group *epf_group = to_pci_epf_group(epf_item->ci_parent);
 	struct pci_epc_group *epc_group = to_pci_epc_group(epc_item);
-- 
2.51.0

