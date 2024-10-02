Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908471CDFBC;
	Wed,  2 Oct 2024 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876650; cv=none; b=ZN0aZXeEmp9S/ATkLMul+gczCF5BG3y0skTJOtht7KL7wrHt87zis6Xnh6DxhH0w5ou5qrZnvm3MYPJEIAmB+mK7lUswhXhekdMk1u0IctHzpt0gkLYGmaTstWMIwKlOiRAP7eMIUlLYtRKzVQMq0r19bby71LZd4z3dphKHrPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876650; c=relaxed/simple;
	bh=yNrn1SfjPWeblUVovbyvhnBaUS8Z5cQirwa25RaIWyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFAbMQNFRcT2yqYUxTjHAyBNa0lFCIsAlQdI8cH/52ZcNFpjLiRV6njVF2fPJ/2VszUrPJp2o9wOCQ5sWKIgyl9vaYVAnaCVZRGimsMZ4fsOJIJ8Eep18PiHs+VabCBY8bby9pMBHvifQXlLHfBLoZDJ034AaIAb8LOzZ0yVoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJfPqMFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJfPqMFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C9C4CEC5;
	Wed,  2 Oct 2024 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876650;
	bh=yNrn1SfjPWeblUVovbyvhnBaUS8Z5cQirwa25RaIWyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJfPqMFbRFK1iDjeyTxJ5JLdzAliRcwN7KDs6clFGnmklFPSPC39HKnQte0293FSE
	 VemMwVm4kstfTzDpgKCb/rTzjamgb5LKB9bpC9RNSgEKkt6zIY7KyPrJBPJlao68TB
	 YkuQ26tyhv6BNPXCrHi/8xuxcFDq9vtPTDXdjxyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.11 516/695] PCI: imx6: Fix establish link failure in EP mode for i.MX8MM and i.MX8MP
Date: Wed,  2 Oct 2024 14:58:34 +0200
Message-ID: <20241002125843.079924345@linuxfoundation.org>
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

commit 5214ff221a14cadab1e2ee29499750fd5e884feb upstream.

Add IMX6_PCIE_FLAG_HAS_APP_RESET flag to IMX8MM_EP and IMX8MP_EP drvdata.

This flag was overlooked during code restructuring. It is crucial to
release the app-reset from the System Reset Controller before initiating
LTSSM to rectify the issue.

Fixes: 0c9651c21f2a ("PCI: imx6: Simplify reset handling by using *_FLAG_HAS_*_RESET")
Link: https://lore.kernel.org/linux-pci/20240729-pci2_upstream-v8-1-b68ee5ef2b4d@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org> # 6.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1563,7 +1563,8 @@ static const struct imx6_pcie_drvdata dr
 	},
 	[IMX8MM_EP] = {
 		.variant = IMX8MM_EP,
-		.flags = IMX6_PCIE_FLAG_HAS_PHYDRV,
+		.flags = IMX6_PCIE_FLAG_HAS_APP_RESET |
+			 IMX6_PCIE_FLAG_HAS_PHYDRV,
 		.mode = DW_PCIE_EP_TYPE,
 		.gpr = "fsl,imx8mm-iomuxc-gpr",
 		.clk_names = imx8mm_clks,
@@ -1574,7 +1575,8 @@ static const struct imx6_pcie_drvdata dr
 	},
 	[IMX8MP_EP] = {
 		.variant = IMX8MP_EP,
-		.flags = IMX6_PCIE_FLAG_HAS_PHYDRV,
+		.flags = IMX6_PCIE_FLAG_HAS_APP_RESET |
+			 IMX6_PCIE_FLAG_HAS_PHYDRV,
 		.mode = DW_PCIE_EP_TYPE,
 		.gpr = "fsl,imx8mp-iomuxc-gpr",
 		.clk_names = imx8mm_clks,


