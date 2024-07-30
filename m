Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132E18B47F;
	Tue, 30 Jul 2024 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359229; cv=none; b=DGTRWjzLgE2hjBPtbKtWFb+qLPY0dbEuV/gSQuQjUAYhkc6jE56M2Bgmw3mG6rb3yM6PSVeTTFz/6t6YsMsmxDLv1yyhktO4YqFoh3UPnN+djNX0gLPe91AjBliJFTxlQXvtMn/q7kvX92c25U7UcYeoOKGzm//thMK+cDAiFxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359229; c=relaxed/simple;
	bh=R8eXtc+hTApHEhAz6Xjt+BFcYGMVXM4zVpA17VWuJCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EpqonU2RL7QaqsxfbZ+nCOKKP5EBtPA4kWiiUFyEisxOB6Ntzbz0jQ7AmPxYshtj+b1RfygN+nWobLmeQos71VnhZQxQXMoqdOQm1+eMXg1m6/myugGYl9FWB1cOuwkqttV9WUJKnhMKP1sktLNcxviUuF/fqf1NKU0Ejmq+u8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8XWlRGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8XWlRGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112F4C32782;
	Tue, 30 Jul 2024 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359229;
	bh=R8eXtc+hTApHEhAz6Xjt+BFcYGMVXM4zVpA17VWuJCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8XWlRGWo0Z0Z5kHbbv+vx2AkXobdsaB5KJsSkIxuBBklf7WYJLqHynLQ8/9GmAB/
	 MuoE3EmmMoxnCGBpqkqwYJGk0Tkh+h8nHmn2l3jJ8n6X8GJbdaG7LpYQSefRdemYW0
	 i1XIJ2yslUyjfYv1Hcsq207i3RXC5BVhvUQX1jwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 454/809] PCI: qcom-ep: Disable resources unconditionally during PERST# assert
Date: Tue, 30 Jul 2024 17:45:30 +0200
Message-ID: <20240730151742.653066186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 912315715d7b74f7abdb6f063ebace44ee288af9 ]

All EP specific resources are enabled during PERST# deassert. As a counter
operation, all resources should be disabled during PERST# assert. There is
no point in skipping that if the link was not enabled.

This will also result in enablement of the resources twice if PERST# got
deasserted again. So remove the check from qcom_pcie_perst_assert() and
disable all the resources unconditionally.

Fixes: f55fee56a631 ("PCI: qcom-ep: Add Qualcomm PCIe Endpoint controller driver")
Link: https://lore.kernel.org/linux-pci/20240430-pci-epf-rework-v4-1-22832d0d456f@linaro.org
Tested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index 2fb8c15e7a911..50b1635e3cbb1 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -500,12 +500,6 @@ static int qcom_pcie_perst_deassert(struct dw_pcie *pci)
 static void qcom_pcie_perst_assert(struct dw_pcie *pci)
 {
 	struct qcom_pcie_ep *pcie_ep = to_pcie_ep(pci);
-	struct device *dev = pci->dev;
-
-	if (pcie_ep->link_status == QCOM_PCIE_EP_LINK_DISABLED) {
-		dev_dbg(dev, "Link is already disabled\n");
-		return;
-	}
 
 	dw_pcie_ep_cleanup(&pci->ep);
 	qcom_pcie_disable_resources(pcie_ep);
-- 
2.43.0



