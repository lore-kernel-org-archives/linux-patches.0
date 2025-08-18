Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5083203AD;
	Mon, 18 Aug 2025 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525924; cv=none; b=iDvWyx4qIBdSfCA/D84ic4Qq+Hv0F9UqYyyR3SdNx6Eqzp1gTFD8M6vIx3ixkRPA8RogNxhEyQuHK9jvZ6MnglH7Ssnz+RX0alh+Auu1tnGbMjkaL29eA/DqDNZS7VqdkgTWtGtug98Ul+KVzB40TY6rbUSaAZ/W/090t9FNUjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525924; c=relaxed/simple;
	bh=fIouvtC3ZIggp8fp21i5ugGfwUQiGMwDX/NIGzF7a3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmuwbG242zBbmh6UYbx5wpqVukB2p54GwxWDKFtLH79Mq9tctvwfUwpx3FBW7jGCt+YA6TvJWlENG7FlYsWma+ZKYSB2mrnsGf/SHwtJkBazDzkR1oBt5ZoGkFtIiGrD0qSdK3hGHgtpy3NEGWDOtCr+fMko3D+KSc49KlD6ir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/YDXvR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/YDXvR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D24C4CEEB;
	Mon, 18 Aug 2025 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525924;
	bh=fIouvtC3ZIggp8fp21i5ugGfwUQiGMwDX/NIGzF7a3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/YDXvR/PXaFJxTGW3FBhHNyg/tfGhQJ2uT5WQ229ZjJfKGD/CrHGOQdTPKKRmAuE
	 sRSsRt4sugrPF225imgA2Ia+NNtV+MjmFi6C1la1i05aKAWIVA9w8n4e2eVwASBmnw
	 iylx+j/QuVIeELIlW0/c2s41NZM7twN7PUCgNljk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 405/570] PCI: dw-rockchip: Delay link training after hot reset in EP mode
Date: Mon, 18 Aug 2025 14:46:32 +0200
Message-ID: <20250818124521.451446633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

[ Upstream commit c0b93754547dde16c8370b8fdad5f396e7786647 ]

RK3588 TRM, section "11.6.1.3.3 Hot Reset and Link-Down Reset" states that:

  If you want to delay link re-establishment (after reset) so that you can
  reprogram some registers through DBI, you must set app_ltssm_enable =0
  immediately after core_rst_n as shown in above. This can be achieved by
  enable the app_dly2_en, and end-up the delay by assert app_dly2_done.

I.e. setting app_dly2_en will automatically deassert app_ltssm_enable on
a hot reset, and setting app_dly2_done will re-assert app_ltssm_enable,
re-enabling link training.

When receiving a hot reset/link-down IRQ when running in EP mode, we will
call dw_pcie_ep_linkdown(), which may update registers through DBI. Unless
link training is inhibited, these register updates race with the link
training.

To avoid the race, set PCIE_LTSSM_APP_DLY2_EN so the controller never
automatically trains the link after a link-down or hot reset interrupt.
That way any DBI updates done in the dw_pcie_ep_linkdown() path will happen
while the link is still down.  Then allow link training by setting
PCIE_LTSSM_APP_DLY2_DONE

Co-developed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250613101908.2182053-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 108d30637920..b5f5eee5a50e 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -58,6 +58,8 @@
 
 /* Hot Reset Control Register */
 #define PCIE_CLIENT_HOT_RESET_CTRL	0x180
+#define  PCIE_LTSSM_APP_DLY2_EN		BIT(1)
+#define  PCIE_LTSSM_APP_DLY2_DONE	BIT(3)
 #define  PCIE_LTSSM_ENABLE_ENHANCE	BIT(4)
 
 /* LTSSM Status Register */
@@ -475,7 +477,7 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	struct rockchip_pcie *rockchip = arg;
 	struct dw_pcie *pci = &rockchip->pci;
 	struct device *dev = pci->dev;
-	u32 reg;
+	u32 reg, val;
 
 	reg = rockchip_pcie_readl_apb(rockchip, PCIE_CLIENT_INTR_STATUS_MISC);
 	rockchip_pcie_writel_apb(rockchip, reg, PCIE_CLIENT_INTR_STATUS_MISC);
@@ -486,6 +488,10 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	if (reg & PCIE_LINK_REQ_RST_NOT_INT) {
 		dev_dbg(dev, "hot reset or link-down reset\n");
 		dw_pcie_ep_linkdown(&pci->ep);
+		/* Stop delaying link training. */
+		val = HIWORD_UPDATE_BIT(PCIE_LTSSM_APP_DLY2_DONE);
+		rockchip_pcie_writel_apb(rockchip, val,
+					 PCIE_CLIENT_HOT_RESET_CTRL);
 	}
 
 	if (reg & PCIE_RDLH_LINK_UP_CHGED) {
@@ -567,8 +573,11 @@ static int rockchip_pcie_configure_ep(struct platform_device *pdev,
 		return ret;
 	}
 
-	/* LTSSM enable control mode */
-	val = HIWORD_UPDATE_BIT(PCIE_LTSSM_ENABLE_ENHANCE);
+	/*
+	 * LTSSM enable control mode, and automatically delay link training on
+	 * hot reset/link-down reset.
+	 */
+	val = HIWORD_UPDATE_BIT(PCIE_LTSSM_ENABLE_ENHANCE | PCIE_LTSSM_APP_DLY2_EN);
 	rockchip_pcie_writel_apb(rockchip, val, PCIE_CLIENT_HOT_RESET_CTRL);
 
 	rockchip_pcie_writel_apb(rockchip, PCIE_CLIENT_EP_MODE,
-- 
2.39.5



