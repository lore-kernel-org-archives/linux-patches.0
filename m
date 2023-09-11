Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AAA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E352C433C8;
	Mon, 11 Sep 2023 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441354;
	bh=TzBkiPHFs/yysApHpx7gcGxzQzYTgETlWtZt8j30BHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqimNo81GH6577c9odjwXPKiw99yLgKeDkmkpXbYUE9Z31xfKY+K6vtm51C6bbHlo
	 Eg7mKcD1nV4PazyarTrFmuwwvpa8kUeJFa8fTy8mav/l77rx8UictVzgs3CLBHrK9/
	 WdDBsjpacqxlZGhskuKg5qGgkcbpCaJpQpTKKURw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 384/739] PCI: qcom-ep: Switch MHI bus master clock off during L1SS
Date: Mon, 11 Sep 2023 15:43:03 +0200
Message-ID: <20230911134701.918630771@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit b9cbc06049cb6b7a322d708c2098195fb9fdcc4c ]

Currently, as part of the qcom_pcie_perst_deassert() function, instead
of writing the updated value to clear PARF_MSTR_AXI_CLK_EN, the variable
"val" is re-read.

This must be fixed to ensure that the master clock supplied to the MHI
bus is correctly gated during L1.1/L1.2 to save power.

Thus, replace the line that re-reads "val" with a line that writes the
updated value to the register to clear PARF_MSTR_AXI_CLK_EN.

[kwilczynski: commit log]
Fixes: c457ac029e44 ("PCI: qcom-ep: Gate Master AXI clock to MHI bus during L1SS")
Link: https://lore.kernel.org/linux-pci/20230627141036.11600-1-manivannan.sadhasivam@linaro.org
Reported-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index 0fe7f06f21026..267e1247d548f 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -415,7 +415,7 @@ static int qcom_pcie_perst_deassert(struct dw_pcie *pci)
 	/* Gate Master AXI clock to MHI bus during L1SS */
 	val = readl_relaxed(pcie_ep->parf + PARF_MHI_CLOCK_RESET_CTRL);
 	val &= ~PARF_MSTR_AXI_CLK_EN;
-	val = readl_relaxed(pcie_ep->parf + PARF_MHI_CLOCK_RESET_CTRL);
+	writel_relaxed(val, pcie_ep->parf + PARF_MHI_CLOCK_RESET_CTRL);
 
 	dw_pcie_ep_init_notify(&pcie_ep->pci.ep);
 
-- 
2.40.1



