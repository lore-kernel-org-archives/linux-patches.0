Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7761D0B8F;
	Wed,  2 Oct 2024 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878344; cv=none; b=hAcRymrxsPPbOc/M+W0FB16LbA9W3RuiGorvGOXA3CW0JQa6iiIMZOhcghuj2RXXuknHDG6ewsEt+9FeEpcdvOgjPEh+hLp0umocGDA+hWOyGs7dmZkb+8NkH1I3KQiH19BYevN10rep/krHuJIq7XJKmrj87T9Yffr93TuwPvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878344; c=relaxed/simple;
	bh=eA6VavolARTXhUf1Q/DlXGHHTAJZ6Z/BalCU92MrkDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNPOsRO8YZNU8v4QGMys8/4nZpq9PGLDy3DIEqp3xwJfPrNmG+ouQnMe0ZCMqGybvgyz0lPK+glrEWf+JuCA0YnaiZ3Yw31G3nd+o/GHWlL57pJoSCsipxcaoSUlfIyaqjQfr9Cj7yV9aqxTHFCEb1pxPJPH2ZAfOZ5qbpgHOn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ5VdRsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ5VdRsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577A0C4CEC2;
	Wed,  2 Oct 2024 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878343;
	bh=eA6VavolARTXhUf1Q/DlXGHHTAJZ6Z/BalCU92MrkDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ5VdRsa++2WPYVhaY28gHOte/v3BQpbPamY0bA2VJJzJFm8ScfjBtjpCpIA2giX3
	 lf2IztFtJP2Pt7DEfaTQujzO8PJ+Gc3QpkTEdE5SAf+pOv33iPULx3sFDii0cICJym
	 8RXFlbaCtODWe9AbPwaiRzFtaWRHnDnRu2ND4MX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 382/634] PCI: qcom-ep: Enable controller resources like PHY only after refclk is available
Date: Wed,  2 Oct 2024 14:58:02 +0200
Message-ID: <20241002125826.179767015@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index 50b1635e3cbb1..26cab226bccf4 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -816,21 +816,15 @@ static int qcom_pcie_ep_probe(struct platform_device *pdev)
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
@@ -847,8 +841,8 @@ static int qcom_pcie_ep_probe(struct platform_device *pdev)
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



