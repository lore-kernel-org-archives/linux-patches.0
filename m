Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E51D0412;
	Wed,  2 Oct 2024 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876653; cv=none; b=ElNVYHFEL8FOvj3mUck8pDoB5fnxyd47t+/AzQCNEPrGuazZphT72CkhGy80rcEg+T4nx3M0cd0VgG2nCZsYor+9bNgJnYKkAGu79FIlX4amBiasXL0Vkhih6Hl+Vt9FURMDCM9ndy+7PuR5BIFbOv/lffKqIIwzGK2wtAhln0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876653; c=relaxed/simple;
	bh=1WOv6excxy63ntWVUC9QNp1Q1eT+rGJlzGJK1Ho3OT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUSxUmvI2xe8ARXhM0jNujXs+6SOEmQ1s5SqS13zsdMuUpTCmY9EeG4cfl3+e2jRZWOD8JjH55Ph4/U2S1PhjyOxhy0YaXhzZhWCNF8xUmMM1h2AWKSqjc5M7C6bffrgds/obEAUPP58aLub6nTz8Gjky7wItxcld+zAVHgr2PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnI2LpDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnI2LpDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D61C4CEC5;
	Wed,  2 Oct 2024 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876653;
	bh=1WOv6excxy63ntWVUC9QNp1Q1eT+rGJlzGJK1Ho3OT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnI2LpDUmbJ1H8yr9kKatwYrwCs2mPg7YOUqyAu+0NQLv9oEIoOfP4crdVvpQ13tR
	 Sqi2icYAo8O8b1vF6hqgDl4L6C/41WGPEDjtY+pWCMNGlwDOc3LCrBPJesoMfb5nde
	 T6YE6JAISdXPtkTLNSPGofPQfS/KUcxhjnVbocS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jason Liu <jason.hui.liu@nxp.com>
Subject: [PATCH 6.11 517/695] PCI: imx6: Fix i.MX8MP PCIe EPs occasional failure to trigger MSI
Date: Wed,  2 Oct 2024 14:58:35 +0200
Message-ID: <20241002125843.121293269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit 5cb3aa92c7cf182940ae575c3f450d3708af087c upstream.

Correct occasional MSI triggering failures in i.MX8MP PCIe EP by applying
the correct hardware outbound alignment requirement.

The i.MX platform has a restriction about outbound address translation. The
pci-epc-mem uses page_size to manage it. Set the correct page_size for i.MX
platform to meet the hardware requirement, which is the same as inbound
address alignment.

Thus, align it with epc_features::align.

Fixes: 1bd0d43dcf3b ("PCI: imx6: Clean up addr_space retrieval code")
Link: https://lore.kernel.org/linux-pci/20240729-pci2_upstream-v8-2-b68ee5ef2b4d@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Jason Liu <jason.hui.liu@nxp.com>
Cc: <stable@vger.kernel.org> # 6.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1114,6 +1114,8 @@ static int imx6_add_pcie_ep(struct imx6_
 	if (imx6_check_flag(imx6_pcie, IMX6_PCIE_FLAG_SUPPORT_64BIT))
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 
+	ep->page_size = imx6_pcie->drvdata->epc_features->align;
+
 	ret = dw_pcie_ep_init(ep);
 	if (ret) {
 		dev_err(dev, "failed to initialize endpoint\n");


