Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DA125FA04;
	Tue,  8 Apr 2025 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110868; cv=none; b=DginPEiNR+kIaR4SDeMsFNgAPgYQANg6yZPMbn9x4pnbblJwDisNEFAYoRSdsGuWIWPW5MTiuEN889n/HlL5Q6nEQTZ+Mb6cBWBrzJTUUBhAzlGpqolOv35lvG/YSv8W/jFN9e1uZb+hTb0QNpfHriMzMDGrMJYAUf89ia6W/iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110868; c=relaxed/simple;
	bh=xwCy25e1b7gDf0nrQWW+1AnxU+FAClrpvHXz3EU9KI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by5THo9udzT3aA3TmX3Xe2W7NgRulGInlIFF6qlP/31YP/oCImBCBVaqvZeRilhbaPSrKSVzEoLrK2YRjg9ilJLiSQwy6gRM1/C2x6svd+bLU0jp4FLLd1k8FxLI3z7eowi5AtcTjlDVM71TI3kIsDw/PBMdmoNWb5AJLqzOMnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPC/KDds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPC/KDds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FB1C4CEE5;
	Tue,  8 Apr 2025 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110868;
	bh=xwCy25e1b7gDf0nrQWW+1AnxU+FAClrpvHXz3EU9KI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPC/KDds/iei+XtQ14ntAxF3iR+FBYhrbGp+uM8BS17bzLaYCeVyP9hSbbzUZIwSe
	 Uev9TWr8eKkc7hKx75MLoOEsulACwqurhfJfwZz0x+lCRf3lkbetkmwvDAi7DDMABI
	 sCgAt4vhAN0nL5CQVcsjW6tgn3AzeIOeuoU1EBkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 225/731] nvmet: pci-epf: Always configure BAR0 as 64-bit
Date: Tue,  8 Apr 2025 12:42:02 +0200
Message-ID: <20250408104919.513924693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 1cf0184c0ac4f1e936bb3b089894bbeb0a9eb2bc ]

NVMe PCIe Transport Specification 1.1, section 2.1.10, claims that the
BAR0 type is Implementation Specific.

However, in NVMe 1.1, the type is required to be 64-bit.

Thus, to make our PCI EPF work on as many host systems as possible,
always configure the BAR0 type to be 64-bit.

In the rare case that the underlying PCI EPC does not support configuring
BAR0 as 64-bit, the call to pci_epc_set_bar() will fail, and we will
return a failure back to the user.

This should not be a problem, as most PCI EPCs support configuring a BAR
as 64-bit (and those EPCs with .only_64bit set to true in epc_features
only support configuring the BAR as 64-bit).

Tested-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index b1e31483f1574..99563648c318f 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2129,8 +2129,15 @@ static int nvmet_pci_epf_configure_bar(struct nvmet_pci_epf *nvme_epf)
 		return -ENODEV;
 	}
 
-	if (epc_features->bar[BAR_0].only_64bit)
-		epf->bar[BAR_0].flags |= PCI_BASE_ADDRESS_MEM_TYPE_64;
+	/*
+	 * While NVMe PCIe Transport Specification 1.1, section 2.1.10, claims
+	 * that the BAR0 type is Implementation Specific, in NVMe 1.1, the type
+	 * is required to be 64-bit. Thus, for interoperability, always set the
+	 * type to 64-bit. In the rare case that the PCI EPC does not support
+	 * configuring BAR0 as 64-bit, the call to pci_epc_set_bar() will fail,
+	 * and we will return failure back to the user.
+	 */
+	epf->bar[BAR_0].flags |= PCI_BASE_ADDRESS_MEM_TYPE_64;
 
 	/*
 	 * Calculate the size of the register bar: NVMe registers first with
-- 
2.39.5



