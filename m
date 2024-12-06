Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DD51494D9;
	Fri,  6 Dec 2024 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496158; cv=none; b=aRVE1cc2qosA/RGp5TpbQZQS9jhF9A2meKv3PPMljU+Jz171YytzMkZoZx9a/htZ2b74uQHIRrn3P3L2s3w4xiFGsTqHxFgZwY/QEiEGX76tsciJRWyRW7QS9t2hsB7ciZkGqaKJmvqNgEsBFsiAcuC+VCzCjQToSV60EDitMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496158; c=relaxed/simple;
	bh=UhlEQk0FTTeiunQOB0fAUIZrWh6xMcbYGb2SlwYZVsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZOzkILucu0YAq0G3ZFUGUcOPIwfaJFYA8mdKB8VDb99xK5/6aDsKI2zMVXzzamT27zUiNeEFdkzvXpqjULunTCm4vz8MkSsT1aAWUSXPEuziY2CaAqu66DAQ89qjMxvkWSEC7tHoYbBRhRIDM6PEVi2UkouTDFshtXAImJ3zYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzvuwdlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzvuwdlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C261CC4CED1;
	Fri,  6 Dec 2024 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496158;
	bh=UhlEQk0FTTeiunQOB0fAUIZrWh6xMcbYGb2SlwYZVsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzvuwdlN253Fqk3RixSQtuNU8+GsF7qRMCRGnVNEAVacIvmvCm4UO5gwV93eV6sUh
	 wfARr6Yx7oPJ9W6Y37xXju74dmWx0vGKGftVLD/xu5o8K2x39qhrbqXpKKdYEzVmQe
	 su82LKJtx1ASuy/r2pZ8WGXRpCnwVo/o1Zo7xhjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Richard Zhu <hongxing.zhu@nxp.com>
Subject: [PATCH 6.12 068/146] PCI: imx6: Fix suspend/resume support on i.MX6QDL
Date: Fri,  6 Dec 2024 15:36:39 +0100
Message-ID: <20241206143530.284540605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 0a726f542d7c8cc0f9c5ed7df5a4bd4b59ac21b3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   57 +++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 11 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -82,6 +82,11 @@ enum imx_pcie_variants {
 #define IMX_PCIE_FLAG_HAS_SERDES		BIT(6)
 #define IMX_PCIE_FLAG_SUPPORT_64BIT		BIT(7)
 #define IMX_PCIE_FLAG_CPU_ADDR_FIXUP		BIT(8)
+/*
+ * Because of ERR005723 (PCIe does not support L2 power down) we need to
+ * workaround suspend resume on some devices which are affected by this errata.
+ */
+#define IMX_PCIE_FLAG_BROKEN_SUSPEND		BIT(9)
 
 #define imx_check_flag(pci, val)	(pci->drvdata->flags & val)
 
@@ -1237,9 +1242,19 @@ static int imx_pcie_suspend_noirq(struct
 		return 0;
 
 	imx_pcie_msi_save_restore(imx_pcie, true);
-	imx_pcie_pm_turnoff(imx_pcie);
-	imx_pcie_stop_link(imx_pcie->pci);
-	imx_pcie_host_exit(pp);
+	if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_BROKEN_SUSPEND)) {
+		/*
+		 * The minimum for a workaround would be to set PERST# and to
+		 * set the PCIE_TEST_PD flag. However, we can also disable the
+		 * clock which saves some power.
+		 */
+		imx_pcie_assert_core_reset(imx_pcie);
+		imx_pcie->drvdata->enable_ref_clk(imx_pcie, false);
+	} else {
+		imx_pcie_pm_turnoff(imx_pcie);
+		imx_pcie_stop_link(imx_pcie->pci);
+		imx_pcie_host_exit(pp);
+	}
 
 	return 0;
 }
@@ -1253,14 +1268,32 @@ static int imx_pcie_resume_noirq(struct
 	if (!(imx_pcie->drvdata->flags & IMX_PCIE_FLAG_SUPPORTS_SUSPEND))
 		return 0;
 
-	ret = imx_pcie_host_init(pp);
-	if (ret)
-		return ret;
-	imx_pcie_msi_save_restore(imx_pcie, false);
-	dw_pcie_setup_rc(pp);
+	if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_BROKEN_SUSPEND)) {
+		ret = imx_pcie->drvdata->enable_ref_clk(imx_pcie, true);
+		if (ret)
+			return ret;
+		ret = imx_pcie_deassert_core_reset(imx_pcie);
+		if (ret)
+			return ret;
+		/*
+		 * Using PCIE_TEST_PD seems to disable MSI and powers down the
+		 * root complex. This is why we have to setup the rc again and
+		 * why we have to restore the MSI register.
+		 */
+		ret = dw_pcie_setup_rc(&imx_pcie->pci->pp);
+		if (ret)
+			return ret;
+		imx_pcie_msi_save_restore(imx_pcie, false);
+	} else {
+		ret = imx_pcie_host_init(pp);
+		if (ret)
+			return ret;
+		imx_pcie_msi_save_restore(imx_pcie, false);
+		dw_pcie_setup_rc(pp);
 
-	if (imx_pcie->link_is_up)
-		imx_pcie_start_link(imx_pcie->pci);
+		if (imx_pcie->link_is_up)
+			imx_pcie_start_link(imx_pcie->pci);
+	}
 
 	return 0;
 }
@@ -1485,7 +1518,9 @@ static const struct imx_pcie_drvdata drv
 	[IMX6Q] = {
 		.variant = IMX6Q,
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
-			 IMX_PCIE_FLAG_IMX_SPEED_CHANGE,
+			 IMX_PCIE_FLAG_IMX_SPEED_CHANGE |
+			 IMX_PCIE_FLAG_BROKEN_SUSPEND |
+			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.dbi_length = 0x200,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.clk_names = imx6q_clks,


