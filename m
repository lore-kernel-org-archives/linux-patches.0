Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D53280018;
	Mon, 13 Oct 2025 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369368; cv=none; b=hwUdN57/PsQYLBYu+nhNliuDbshoYDETBDDrtsYhx5ye1VFv0ucqaFPTmJVcJKUc6pkC7i4XUCZXQhZKnfBoYfqCUbxKlaNVhxzTAZoIjKpRZJVpbSwznvT4J+g3XEtCk5uqf9DBxjr0BBWLUrEdb9JYb9E14thmcB9vWt7oNQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369368; c=relaxed/simple;
	bh=qC6lm2IVaGZzbW+ZH2c5gmNVuur+4Zl8vbeeziyhBMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCqWYVIvLVetMmm6K5Dm9ppL3B+KlpTjXiEx4+zVaCJIGALvOrmx+ZW19y7z73yk+udvkQQJUgV3DmD9EglSOLpuGNCbymRTetKTQeoP627p6wbh9KhSNIN1fHPZ55XyTEv+QMsaXdG2Hqq2ClbGyJRnxex0Bv/7XkpcXmoTX9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grxEKqmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grxEKqmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C65C4CEE7;
	Mon, 13 Oct 2025 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369368;
	bh=qC6lm2IVaGZzbW+ZH2c5gmNVuur+4Zl8vbeeziyhBMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grxEKqmfK3wEbIkwRiQK0rwkkL5Gpe2JSfzuBXvUW5HDd1+3748v8clMFG/Gp10vM
	 y25vb3H8e1w7MKIsng5oHNCYnItWq1DSkdINXapTstR/SdcUMjlFwHdC62t4mu/IcI
	 QC6nz4xkwcALQ11bSVKZj15qt8HpNlrm9xpWbqj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 221/563] PCI: endpoint: pci-ep-msi: Fix NULL vs IS_ERR() check in pci_epf_write_msi_msg()
Date: Mon, 13 Oct 2025 16:41:22 +0200
Message-ID: <20251013144419.288759907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 57a75fa9d56e310e883e4377205690e88c05781b ]

The pci_epc_get() function returns error pointers. It never returns NULL.
Update the check to match.

Fixes: 1c3b002c6bf6 ("PCI: endpoint: Add RC-to-EP doorbell support using platform MSI controller")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/aIzCdV8jyBeql-Oa@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-ep-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/pci-ep-msi.c b/drivers/pci/endpoint/pci-ep-msi.c
index 9ca89cbfec15d..1b58357b905fa 100644
--- a/drivers/pci/endpoint/pci-ep-msi.c
+++ b/drivers/pci/endpoint/pci-ep-msi.c
@@ -24,7 +24,7 @@ static void pci_epf_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 	struct pci_epf *epf;
 
 	epc = pci_epc_get(dev_name(msi_desc_to_dev(desc)));
-	if (!epc)
+	if (IS_ERR(epc))
 		return;
 
 	epf = list_first_entry_or_null(&epc->pci_epf, struct pci_epf, list);
-- 
2.51.0



