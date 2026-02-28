Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3144747CC8F;
	Sat, 28 Feb 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301394; cv=none; b=aQyAiAsv8EGyV0VhuX3qql8d2YH/OKShd6iRp4BjlxPjeKRZwEkFpAJuCKelCKTyFo8m6Z9AvfQ1KHYFVmRPZYCmHth0E/WsVZpEODA/Xeya0NPT+BGoKhsHG3q3lmFtsKEz4vvAG0gZcl1TM6N0ZbMnGbLCMCdYJ77MIDQlwDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301394; c=relaxed/simple;
	bh=Yn8aPSK44wcQBVlLgN1ww1KzhXsniWmDfVEhhgbIoSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy36ydIVYuriS7fWpcwYrTv3onuxe0ZgcNZdOKaBVQu3/rGSJf1o/ZreVIFjkJ0aiCGVMlMVFldnEtLvHjNfdNzw4FWrUDLGvnE0fyZQQkBFofF8NAMCR185Bs6Zl20y3G2DX21LZadVFt6wsNNR2FfU4YvF6j+alkoYWxbyBsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRFqLfn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRFqLfn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBFEC19423;
	Sat, 28 Feb 2026 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301394;
	bh=Yn8aPSK44wcQBVlLgN1ww1KzhXsniWmDfVEhhgbIoSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRFqLfn7GwRIEYvm2UY0/17VUeHombAoh5IJnCIl3JuENF9BtRSKcpN214P4oGVAv
	 qbShoYowri5VO7jiuD+y20gX0G/gUSishtWNr5AS+0S9KlspEYS8flU1FFF/Oudwsy
	 TySXIi9jZKmc2N/hE9YBwugDXfCxED4V8WGZoOwxo999dpqDxU4kFZ3m5TCJMMA7iz
	 YkbkvYxGMbB27FCwJJtGwkuYF+DbSyHBYe5LbOra8qprM6nbG59LJDjkS/oQgXnknC
	 2/6QO13xYPgwCKi9CbRkuDE7EpG+4KRsN40Qo6kD+00E2VbPsnxsSZkydSkVr0JiYK
	 jzJY4yX6drdjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/752] PCI: dwc: Skip waiting for L2/L3 Ready if dw_pcie_rp::skip_l23_wait is true
Date: Sat, 28 Feb 2026 12:44:53 -0500
Message-ID: <20260228174750.1542406-582-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 58a17b2647ba5aac47e3ffafd0a9b92bf4a9bcbe ]

In NXP i.MX6QP and i.MX7D SoCs, LTSSM registers are not accessible once
PME_Turn_Off message is broadcasted to the link. So there is no way to
verify whether the link has entered L2/L3 Ready state or not.

Hence, add a new flag 'dw_pcie_rp::skip_l23_ready' and set it to 'true' for
the above mentioned SoCs. This flag when set, will allow the DWC core to
skip polling for L2/L3 Ready state and just wait for 10ms as recommended in
the PCIe spec r6.0, sec 5.3.3.2.1.

Fixes: a528d1a72597 ("PCI: imx6: Use DWC common suspend resume method")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: renamed flag to skip_l23_ready and reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260114083300.3689672-2-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c             |  5 +++++
 drivers/pci/controller/dwc/pcie-designware-host.c | 10 ++++++++++
 drivers/pci/controller/dwc/pcie-designware.h      |  1 +
 3 files changed, 16 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 34f8f69ddfae9..a42164c870548 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -116,6 +116,7 @@ enum imx_pcie_variants {
 #define IMX_PCIE_FLAG_BROKEN_SUSPEND		BIT(9)
 #define IMX_PCIE_FLAG_HAS_LUT			BIT(10)
 #define IMX_PCIE_FLAG_8GT_ECN_ERR051586		BIT(11)
+#define IMX_PCIE_FLAG_SKIP_L23_READY		BIT(12)
 
 #define imx_check_flag(pci, val)	(pci->drvdata->flags & val)
 
@@ -1795,6 +1796,8 @@ static int imx_pcie_probe(struct platform_device *pdev)
 		 */
 		imx_pcie_add_lut_by_rid(imx_pcie, 0);
 	} else {
+		if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_SKIP_L23_READY))
+			pci->pp.skip_l23_ready = true;
 		pci->pp.use_atu_msg = true;
 		ret = dw_pcie_host_init(&pci->pp);
 		if (ret < 0)
@@ -1856,6 +1859,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.variant = IMX6QP,
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
+			 IMX_PCIE_FLAG_SKIP_L23_READY |
 			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.dbi_length = 0x200,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
@@ -1872,6 +1876,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.variant = IMX7D,
 		.flags = IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
 			 IMX_PCIE_FLAG_HAS_APP_RESET |
+			 IMX_PCIE_FLAG_SKIP_L23_READY |
 			 IMX_PCIE_FLAG_HAS_PHY_RESET,
 		.gpr = "fsl,imx7d-iomuxc-gpr",
 		.mode_off[0] = IOMUXC_GPR12,
diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 60fadaa1c0bd2..03d01d051e9b0 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1161,6 +1161,16 @@ int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 			return ret;
 	}
 
+	/*
+	 * Some SoCs do not support reading the LTSSM register after
+	 * PME_Turn_Off broadcast. For those SoCs, skip waiting for L2/L3 Ready
+	 * state and wait 10ms as recommended in PCIe spec r6.0, sec 5.3.3.2.1.
+	 */
+	if (pci->pp.skip_l23_ready) {
+		mdelay(PCIE_PME_TO_L2_TIMEOUT_US/1000);
+		goto stop_link;
+	}
+
 	ret = read_poll_timeout(dw_pcie_get_ltssm, val,
 				val == DW_PCIE_LTSSM_L2_IDLE ||
 				val <= DW_PCIE_LTSSM_DETECT_WAIT,
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 7c56146b95f6b..96e89046614da 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -430,6 +430,7 @@ struct dw_pcie_rp {
 	struct pci_config_window *cfg;
 	bool			ecam_enabled;
 	bool			native_ecam;
+	bool                    skip_l23_ready;
 };
 
 struct dw_pcie_ep_ops {
-- 
2.51.0

