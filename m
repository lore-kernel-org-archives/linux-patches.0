Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07466239573;
	Tue, 26 Aug 2025 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207237; cv=none; b=dvMzI9Vn/r/BxIHiqQ7be2h5zvSdiPkVHE1RwUCssbCJs0hL0oUXhoDT9SpUlOV2b8llvAQDp1LWij/DouWqsV0b6u17v1+CjUavBySTkY+3/psDZP0jJ8XqWIEPJfpTxGZ9WMIISgqEHFcoNgg7Bbpizw+4k8c/titmFSPgFcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207237; c=relaxed/simple;
	bh=MjX4S3qrbV1PBVOj9UGLNjCZMR/QdwoEaKwtM7Uq7xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMQyp7a3wB120Z1wKHwnyHTSQdbt2mpWch/xSiOOif97DpF+Ya0fp45yCc5nUg5vi5fYc6ah4tRo1Wx2guKDwJSbzsyYWaxVXc8t1XPhQ4c4pQxZrK1AwTBn3yqPVhSc8KUvZx5H3lCMGFZ3TiseRLZxj/s0Ta39CHDNiFLaOKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/Vm87/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/Vm87/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BE4C4CEF1;
	Tue, 26 Aug 2025 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207236;
	bh=MjX4S3qrbV1PBVOj9UGLNjCZMR/QdwoEaKwtM7Uq7xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/Vm87/q6voKy4bnNpA6NidnKj5zpZujhVXjTyERVPrDwSLvVh7XldgyCgBZI3mai
	 Wf0tBqDAeFbRwoDELGJTg2UXw3S49FUuhl0vDe4O5Pgwp/h383eYSWWxUXPHS2wS70
	 JcT0PcHPq38Po5XwefQzLxkNthwX9k4n7DkTlIpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.16 103/457] PCI: imx6: Remove apps_reset toggling from imx_pcie_{assert/deassert}_core_reset
Date: Tue, 26 Aug 2025 13:06:27 +0200
Message-ID: <20250826110939.922523298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit d31eb217425591e100b475fad6360cd3da2073c6 upstream.

apps_reset corresponds to LTSSM_EN in i.MX7, i.MX8MQ, i.MX8MM and i.MX8MP
platforms. Since assertion/de-assertion of apps_reset is done in
imx_pcie_ltssm_enable() and imx_pcie_ltssm_disable(), remove it from
imx_pcie_assert_core_reset() and imx_pcie_deassert_core_reset().

This also fixes a failure in enumerating the PI7C9X2G608GP (hotplug) chip
reliably on i.MX8MM, as reported by Tim.

It should be noted that only i.MX7D, i.MX8MQ, i.MX8MM, and i.MX8MP
platforms have the apps_reset logic, so this change doesn't have any effect
on other platforms.

Fixes: ef61c7d8d032 ("PCI: imx6: Deassert apps_reset in imx_pcie_deassert_core_reset()")
Reported-by: Tim Harvey <tharvey@gateworks.com>
Closes: https://lore.kernel.org/all/CAJ+vNU3ohR2YKTwC4xoYrc1z-neDoH2TTZcMHDy+poj9=jSy+w@mail.gmail.com/
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded commit subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tim Harvey <tharvey@gateworks.com> # imx8mp-venice-gw74xx (i.MX8MP + hotplug capable switch)
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250709033722.2924372-2-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -860,7 +860,6 @@ static int imx95_pcie_core_reset(struct
 static void imx_pcie_assert_core_reset(struct imx_pcie *imx_pcie)
 {
 	reset_control_assert(imx_pcie->pciephy_reset);
-	reset_control_assert(imx_pcie->apps_reset);
 
 	if (imx_pcie->drvdata->core_reset)
 		imx_pcie->drvdata->core_reset(imx_pcie, true);
@@ -872,7 +871,6 @@ static void imx_pcie_assert_core_reset(s
 static int imx_pcie_deassert_core_reset(struct imx_pcie *imx_pcie)
 {
 	reset_control_deassert(imx_pcie->pciephy_reset);
-	reset_control_deassert(imx_pcie->apps_reset);
 
 	if (imx_pcie->drvdata->core_reset)
 		imx_pcie->drvdata->core_reset(imx_pcie, false);
@@ -1247,6 +1245,9 @@ static int imx_pcie_host_init(struct dw_
 		}
 	}
 
+	/* Make sure that PCIe LTSSM is cleared */
+	imx_pcie_ltssm_disable(dev);
+
 	ret = imx_pcie_deassert_core_reset(imx_pcie);
 	if (ret < 0) {
 		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);


