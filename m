Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D814831F;
	Tue, 30 Jul 2024 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357825; cv=none; b=HTDsiHZyFtea25U5Yy0Zmpvauh8qFb62bqbX6WextcdvMeLp5/jDKHglnLhNadMTHe+SFIrBRniX16Ryj/l2+6b1XoIXzvr6WxVaHOMkjqSrGEt37aJKKJgY7/wMYrt7rWM7F8oS3LfBBWx7sJh8/NOuovR31bk3lSZJbGGVkLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357825; c=relaxed/simple;
	bh=47E639oBYYaRzYhoauc7ceLOmhCxuOgglcwLsyBBcVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PF4S3h96zMK5plSLs0Xe++H/8/jOJdK0R22Hp+Y8mMxUqHzl2vwMBa9hefvhOL6ji0AvqF5CSMEv1P7S/32gRdBORARxGWbnuVyWW1v8FOoGXN2xeapcmIMjwBmpuq4dO97JEAkoD5zOtaxt7G4aUSulAB8aSalHTPBpeeud1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RouBJIzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RouBJIzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98250C32782;
	Tue, 30 Jul 2024 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357825;
	bh=47E639oBYYaRzYhoauc7ceLOmhCxuOgglcwLsyBBcVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RouBJIzEjVXPB6YZyeP/Gkc5ak7ERLjnrpTjjDG0A9yc6Pam+C/1Ozbr0zKc0fGoS
	 MMbFCv25cFxWTp82bW6hceRSdhi9qHmQWUCIM3XyglxV5wOEGWDixggQNl3gnGIdvP
	 GmmfzUp4sxQagR3dVKbbcTRHzxfVoeyh2V7XWQU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/568] PCI: qcom-ep: Disable resources unconditionally during PERST# assert
Date: Tue, 30 Jul 2024 17:46:42 +0200
Message-ID: <20240730151651.407789021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b62ee6992f0e..66e080c99d5df 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -519,12 +519,6 @@ static int qcom_pcie_perst_deassert(struct dw_pcie *pci)
 static void qcom_pcie_perst_assert(struct dw_pcie *pci)
 {
 	struct qcom_pcie_ep *pcie_ep = to_pcie_ep(pci);
-	struct device *dev = pci->dev;
-
-	if (pcie_ep->link_status == QCOM_PCIE_EP_LINK_DISABLED) {
-		dev_dbg(dev, "Link is already disabled\n");
-		return;
-	}
 
 	qcom_pcie_disable_resources(pcie_ep);
 	pcie_ep->link_status = QCOM_PCIE_EP_LINK_DISABLED;
-- 
2.43.0



