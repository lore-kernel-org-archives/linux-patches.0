Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD0039934B;
	Sat, 17 Oct 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257906; cv=none; b=u+f2+5N1eIn2d4HOwIbvW8Hh7t/sW9j0CwohTf8IayrpRrpBt3cJUNaitBaSOFSMKZIZnnSg3d1+k0/KOY7ZhzTWV8hW15ZappPUmlsRFzbsUi73hUDFp6HOe2j6Ih/mRDrSaHtS4vsgd6CI+hwECAHeDVfF0nkJ0wgHNvZGnlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257906; c=relaxed/simple;
	bh=Mw5fa962op8j/tcmwJelyo+ESq359CFDdUHBNvVhh9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LnOBg8vA7lJdVwKa4q35ggggaq1b4R00513OMLFNRrkU+C9DUf2qOIarfDwyZe7+STZGMkvmy4eBFJgH9suGv1Cnq2hGlEgitBWadCKqc77exLDi1lPRR3K2PodulBm14FXOLx8F3l1wcnRQq9kTGcP/7m0zi9XUBnJBFLlESJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDiqSEO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDiqSEO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5B81F000C4;
	Sat, 17 Oct 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257904;
	bh=LtvAwAxx0xHqwIjVCtAFZ9xMUg6ONTaC3WMPScZ1pG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDiqSEO5G0QTA+b0gTNffEj/d6s481gAh7Vfo7Vy4zF5VlsRCEw9/DYnIMY4o+xwM
	 tLw5E6H65MVBN/t6kNWH60hPgyQYERz2UyXlc4Ns/IHmrVR3Je7EkB0sNuin6nx4/u
	 HexGIQvtaKXyTMkk2LrHHtp13pLV42wSWJLWoXhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0666/1674] PCI: imx6: Fix suspend/resume support on i.MX6QDL
Date: Sat, 17 Oct 2026 17:48:58 +0200
Message-ID: <20261017160448.203268357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit 0a726f542d7c8cc0f9c5ed7df5a4bd4b59ac21b3 ]

The suspend/resume functionality is currently broken on the i.MX6QDL
platform, as documented in the NXP errata (ERR005723):

  https://www.nxp.com/docs/en/errata/IMX6DQCE.pdf

This patch addresses the issue by sharing most of the suspend/resume
sequences used by other i.MX devices, while avoiding modifications to
critical registers that disrupt the PCIe functionality. It targets the
same problem as the following downstream commit:

  https://github.com/nxp-imx/linux-imx/commit/4e92355e1f79d225ea842511fcfd42b343b32995

Unlike the downstream commit, this patch also resets the connected PCIe
device if possible. Without this reset, certain drivers, such as ath10k
or iwlwifi, will crash on resume. The device reset is also done by the
driver on other i.MX platforms, making this patch consistent with
existing practices.

Upon resuming, the kernel will hang and display an error. Here's an
example of the error encountered with the ath10k driver:

  ath10k_pci 0000:01:00.0: Unable to change power state from D3hot to D0, device inaccessible
  Unhandled fault: imprecise external abort (0x1406) at 0x0106f944

Without this patch, suspend/resume will fail on i.MX6QDL devices if a
PCIe device is connected.

Link: https://lore.kernel.org/r/20241030103250.83640-1-eichest@gmail.com
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
[kwilczynski: commit log, added tag for stable releases]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 57 +++++++++++++++++++++------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index c438cf888ad57..20ffa27ec9829 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -60,6 +60,11 @@ enum imx6_pcie_variants {
 #define IMX6_PCIE_FLAG_IMX6_PHY			BIT(0)
 #define IMX6_PCIE_FLAG_IMX6_SPEED_CHANGE	BIT(1)
 #define IMX6_PCIE_FLAG_SUPPORTS_SUSPEND		BIT(2)
+/*
+ * Because of ERR005723 (PCIe does not support L2 power down) we need to
+ * workaround suspend resume on some devices which are affected by this errata.
+ */
+#define IMX6_PCIE_FLAG_BROKEN_SUSPEND		BIT(9)
 
 #define IMX6_PCIE_MAX_CLKS       6
 
@@ -1171,9 +1176,19 @@ static int imx6_pcie_suspend_noirq(struct device *dev)
 		return 0;
 
 	imx6_pcie_msi_save_restore(imx6_pcie, true);
-	imx6_pcie_pm_turnoff(imx6_pcie);
-	imx6_pcie_stop_link(imx6_pcie->pci);
-	imx6_pcie_host_exit(pp);
+	if (imx6_pcie->drvdata->flags & IMX6_PCIE_FLAG_BROKEN_SUSPEND) {
+		/*
+		 * The minimum for a workaround would be to set PERST# and to
+		 * set the PCIE_TEST_PD flag. However, we can also disable the
+		 * clock which saves some power.
+		 */
+		imx6_pcie_assert_core_reset(imx6_pcie);
+		imx6_pcie_disable_ref_clk(imx6_pcie);
+	} else {
+		imx6_pcie_pm_turnoff(imx6_pcie);
+		imx6_pcie_stop_link(imx6_pcie->pci);
+		imx6_pcie_host_exit(pp);
+	}
 
 	return 0;
 }
@@ -1187,14 +1202,32 @@ static int imx6_pcie_resume_noirq(struct device *dev)
 	if (!(imx6_pcie->drvdata->flags & IMX6_PCIE_FLAG_SUPPORTS_SUSPEND))
 		return 0;
 
-	ret = imx6_pcie_host_init(pp);
-	if (ret)
-		return ret;
-	imx6_pcie_msi_save_restore(imx6_pcie, false);
-	dw_pcie_setup_rc(pp);
+	if (imx6_pcie->drvdata->flags & IMX6_PCIE_FLAG_BROKEN_SUSPEND) {
+		ret = imx6_pcie_enable_ref_clk(imx6_pcie);
+		if (ret)
+			return ret;
+		ret = imx6_pcie_deassert_core_reset(imx6_pcie);
+		if (ret)
+			return ret;
+		/*
+		 * Using PCIE_TEST_PD seems to disable MSI and powers down the
+		 * root complex. This is why we have to setup the rc again and
+		 * why we have to restore the MSI register.
+		 */
+		ret = dw_pcie_setup_rc(&imx6_pcie->pci->pp);
+		if (ret)
+			return ret;
+		imx6_pcie_msi_save_restore(imx6_pcie, false);
+	} else {
+		ret = imx6_pcie_host_init(pp);
+		if (ret)
+			return ret;
+		imx6_pcie_msi_save_restore(imx6_pcie, false);
+		dw_pcie_setup_rc(pp);
 
-	if (imx6_pcie->link_is_up)
-		imx6_pcie_start_link(imx6_pcie->pci);
+		if (imx6_pcie->link_is_up)
+			imx6_pcie_start_link(imx6_pcie->pci);
+	}
 
 	return 0;
 }
@@ -1418,7 +1451,9 @@ static const struct imx6_pcie_drvdata drvdata[] = {
 	[IMX6Q] = {
 		.variant = IMX6Q,
 		.flags = IMX6_PCIE_FLAG_IMX6_PHY |
-			 IMX6_PCIE_FLAG_IMX6_SPEED_CHANGE,
+			 IMX6_PCIE_FLAG_IMX6_SPEED_CHANGE |
+			 IMX6_PCIE_FLAG_BROKEN_SUSPEND |
+			 IMX6_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.dbi_length = 0x200,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.clk_names = imx6q_clks,
-- 
2.53.0



