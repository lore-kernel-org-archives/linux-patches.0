Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2171473C84;
	Fri,  7 Aug 2026 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117337; cv=none; b=kP2r/o1Bf66WkqPRycaWVCev1Y0FJG5QQI5mIc9BJkHOcA7pTP9VPjn/8YnoOGTaKABdKna9e+PsoPTi6W1n9Kk1cBn1uIGbhoJ6qMmIMqYi/AL+ld2oD2hjFya3/j+HBBAjOaFg+8gOPR3wyrqwr4e+is5SAX7GDK0eR0L6tOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117337; c=relaxed/simple;
	bh=+N/Hu/LHBkjK3YAntiokTU+geeIwaoERK9cgeveLbxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flBnghUA2kno3KH00DKwjwU1g57St/9zH60b/CeFgm7fWujqiYyS3RvkZdTjwCJgkXwwPlJmSU7Q+wNj8Us47wHHZBuK2llVLlwnWrI7y0zy0Xk6oEMwCLNk4r6zi/A3YpR8JGLX/hWN7kj5yl1A2XnTTVLpiQjl0Lyqt28KahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFP3piUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFP3piUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622D01F000E9;
	Fri,  7 Aug 2026 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117335;
	bh=cgd+tvREcDgorXI43Sim7+LNx6l7R1blN/O9msFIXMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFP3piUKVc5OErrudKY06LQyeYFrG1qa9xd6ln2rRBSgT9U3t097zNY1kfT2ZQ8Z5
	 imsrVa1Gx6JjpeKSnnsEvth5MmPPTBK1jcihDsQBKAEknSPcX5Y2fo4z3gLI9C9RPr
	 pJQ5dkIZJfbk/019miMTZVeKQpIGu0zPWHcnwhTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soeren Moch <smoch@web.de>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 7.1 283/438] PCI: imx6: Keep i.MX6 Root Port MSI/MSI-X Capabilities with iMSI-RX to work around hardware bug
Date: Fri,  7 Aug 2026 16:37:59 +0200
Message-ID: <20260807143434.013729744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Soeren Moch <smoch@web.de>

commit b4bee12ebeccfcd5959ace2c3a4af08f5a917d4c upstream.

On some NXP chipsets, disabling Root Port MSI/MSI-X Capabilities blocks
MSIs originating from Endpoints from reaching the iMSI-RX controller.

To address this hardware bug, commit 3a4e8302e72f ("PCI: imx6: Keep Root
Port MSI capability with iMSI-RX to work around hardware bug") preserves
Root Port MSI and MSI-X Capabilities on i.MX7D, i.MX8MM, and i.MX8MQ
when iMSI-RX is in use.

The same applies to i.MX6Q, i.MX6QP, and i.MX6SX, so preserve Root Port
MSI/MSI-X Capabilities there as well.

Note that preserving these Capabilities means Root Port-originated MSIs
such as AER and PME won't be received due to separate hardware limitations.
Users may need to use workarounds such as passing the 'pcie_pme=nomsi'
command-line parameter.

Fixes: f5cd8a929c825 ("PCI: dwc: Remove MSI/MSIX capability for Root Port if iMSI-RX is used as MSI controller")
Signed-off-by: Soeren Moch <smoch@web.de>
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: stable@vger.kernel.org # 7.0+
Link: https://patch.msgid.link/20260717033203.2965045-1-hongxing.zhu@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1884,7 +1884,8 @@ static const struct imx_pcie_drvdata drv
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
 			 IMX_PCIE_FLAG_BROKEN_SUSPEND |
-			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
+			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP,
 		.dbi_length = 0x200,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.ltssm_off = IOMUXC_GPR12,
@@ -1900,7 +1901,8 @@ static const struct imx_pcie_drvdata drv
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
 			 IMX_PCIE_FLAG_SKIP_L23_READY |
-			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
+			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.ltssm_off = IOMUXC_GPR12,
 		.ltssm_mask = IMX6Q_GPR12_PCIE_CTL_2,
@@ -1915,7 +1917,8 @@ static const struct imx_pcie_drvdata drv
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
 			 IMX_PCIE_FLAG_SKIP_L23_READY |
-			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
+			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP,
 		.dbi_length = 0x200,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.ltssm_off = IOMUXC_GPR12,


