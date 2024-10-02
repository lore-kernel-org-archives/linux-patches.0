Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045DA1D07B8;
	Wed,  2 Oct 2024 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876372; cv=none; b=isIUjxODoW6XCBqMbaYJqmCadfzqEiS9DYLikcptRrd3gasF5Mts3pyuTJJ2Okxcl6BrPiYAJk/mxrJfH/SWRuYFkGYJvl3EJnjMtMTkl88NKJt2uD6ESl3LfN8HMc4Qk8qUKxF0PN9tze7wiic6wxt6gaaT5sbgZSxAEzOcUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876372; c=relaxed/simple;
	bh=IqAgkI5UBWVsis+7LcqoINvMvqYqBDvEyuDvPUKjOoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=go/pZtwS7pMHwZxEZfk//QuizItieg8DQ2cdhwbJmF/1Stv3ttXRD7xDtyBDOPf3pHmkQSNSWMD7vipuuCWWgSuc7zOTzcwSrr/WiFKgjKZ5dcZxk83AH9KT9Ih1bYf8TH6gasqOFdNXtuPvdOlP5d6wc/bRPLEG+g7khjEO2c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/sk2+xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/sk2+xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422E6C4CED2;
	Wed,  2 Oct 2024 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876371;
	bh=IqAgkI5UBWVsis+7LcqoINvMvqYqBDvEyuDvPUKjOoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/sk2+xSJXwNJeaxz93hd0yUZh30ZA7rZU2V0h17q4p/+BC/51HgtS1gTrWWhkEC+
	 joDSyDupR4uqDYIaRGoLFRe4kDChHYOupyQ+ZrG84cCtukWT95F0eXNB35TC2Hprr6
	 ZZstljs6nbQWqM5G++S8/al4EndwVGrezmHNYZqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 420/695] PCI: qcom-ep: Enable controller resources like PHY only after refclk is available
Date: Wed,  2 Oct 2024 14:56:58 +0200
Message-ID: <20241002125839.219454857@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit d3745e3ae6c0eec517d431be926742b6e8b9b64a ]

qcom_pcie_enable_resources() is called by qcom_pcie_ep_probe() and it
enables the controller resources like clocks, regulator, PHY. On one of the
new unreleased Qcom SoC, PHY enablement depends on the active refclk. And
on all of the supported Qcom endpoint SoCs, refclk comes from the host
(RC). So calling qcom_pcie_enable_resources() without refclk causes the
NoC (Network On Chip) error in the endpoint SoC and in turn results in a
whole SoC crash and rebooting into EDL (Emergency Download) mode which is
an unrecoverable state.

But qcom_pcie_enable_resources() is already called by
qcom_pcie_perst_deassert() when PERST# is deasserted, and refclk is
available at that time.

Hence, remove the unnecessary call to qcom_pcie_enable_resources() from
qcom_pcie_ep_probe() to prevent the above mentioned crash.

It should be noted that this commit prevents the crash only under normal
working condition (booting endpoint before host), but the crash may also
occur if PERST# assert happens at the wrong time. For avoiding the crash
completely, it is recommended to use SRIS mode which allows the endpoint
SoC to generate its own refclk. The driver is not supporting SRIS mode
currently, but will be added in the future.

Fixes: 869bc5253406 ("PCI: dwc: ep: Fix DBI access failure for drivers requiring refclk from host")
Link: https://lore.kernel.org/linux-pci/20240830082319.51387-1-manivannan.sadhasivam@linaro.org
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index a9b263f749b6a..c8bb7cd89678f 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -858,21 +858,15 @@ static int qcom_pcie_ep_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = qcom_pcie_enable_resources(pcie_ep);
-	if (ret) {
-		dev_err(dev, "Failed to enable resources: %d\n", ret);
-		return ret;
-	}
-
 	ret = dw_pcie_ep_init(&pcie_ep->pci.ep);
 	if (ret) {
 		dev_err(dev, "Failed to initialize endpoint: %d\n", ret);
-		goto err_disable_resources;
+		return ret;
 	}
 
 	ret = qcom_pcie_ep_enable_irq_resources(pdev, pcie_ep);
 	if (ret)
-		goto err_disable_resources;
+		goto err_ep_deinit;
 
 	name = devm_kasprintf(dev, GFP_KERNEL, "%pOFP", dev->of_node);
 	if (!name) {
@@ -889,8 +883,8 @@ static int qcom_pcie_ep_probe(struct platform_device *pdev)
 	disable_irq(pcie_ep->global_irq);
 	disable_irq(pcie_ep->perst_irq);
 
-err_disable_resources:
-	qcom_pcie_disable_resources(pcie_ep);
+err_ep_deinit:
+	dw_pcie_ep_deinit(&pcie_ep->pci.ep);
 
 	return ret;
 }
-- 
2.43.0



