Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CAF15696E;
	Tue,  3 Dec 2024 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239151; cv=none; b=oc3OlKMt5/yyC8Hs7+3o8C2R2jQGJ/oA0v6UW6gcwl46Qk1E905+Og5gyWFnTucnXtoiB6fqa1SMnqES1G3KtmiWKcsZcWOp+T76iiQtyDBioHEEeweSwV9GnDAh5f5J1Xi5455TJag83gKonu1uxGmx+ymMTlPCQuvM6p0wIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239151; c=relaxed/simple;
	bh=7mUsL8sa9j4RKTNeEVLsnBOBrEGgd9pF9BsDISRmt1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CaHaNpWuDj0NIkY+VlR9yR2Fj59pFt2ku4wDOl6uFWaaReTxFzXqJ5xY/jb4SOusAlpDpP2q/CktPe9ZEl/cMyFZRi5NpUGeZ9Rqpk69BYBE1r3aCVfZzRj7YIicxoY1DLnMaP8iUvi4AEPx4j1KQ6E7sDcxDe3Vy7n6WlJlxhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLdGF5UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLdGF5UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B19C4CECF;
	Tue,  3 Dec 2024 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239151;
	bh=7mUsL8sa9j4RKTNeEVLsnBOBrEGgd9pF9BsDISRmt1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLdGF5URWz1XUSI5h1MArFqV/zS5rkicRfbr+bI7sMImkRgGSNT9v9NJY3og+0KJO
	 NeGzc3idhgnT3r9AVF6OObcGPiPSTEQHC8KxtCeLAyLhpC2UgKH+z1+DK4ezAPdHeP
	 J0TrckbKvIgrWgz1ahuDegvs/x63OGlpWpCDpEKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 519/817] PCI: j721e: Add suspend and resume support
Date: Tue,  3 Dec 2024 15:41:31 +0100
Message-ID: <20241203144016.152590846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit c538d40f365b5b6d7433d371710f58e8b266fb19 ]

Add suspend and resume support. Only the Root Complex mode is supported.

During the suspend stage PERST# is asserted, then deasserted during the
resume stage.

Link: https://lore.kernel.org/linux-pci/20240102-j7200-pcie-s2r-v7-7-a2f9156da6c3@bootlin.com
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
[kwilczynski: commit log, update references to the PCI SIG specification]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 98 ++++++++++++++++++++--
 1 file changed, 92 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 963b66b6a6832..d37e43dbc30b8 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -7,6 +7,8 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/container_of.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/io.h>
@@ -22,6 +24,8 @@
 #include "../../pci.h"
 #include "pcie-cadence.h"
 
+#define cdns_pcie_to_rc(p) container_of(p, struct cdns_pcie_rc, pcie)
+
 #define ENABLE_REG_SYS_2	0x108
 #define STATUS_REG_SYS_2	0x508
 #define STATUS_CLR_REG_SYS_2	0x708
@@ -534,12 +538,12 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		pcie->refclk = clk;
 
 		/*
-		 * "Power Sequencing and Reset Signal Timings" table in
-		 * PCI EXPRESS CARD ELECTROMECHANICAL SPECIFICATION, REV. 3.0
-		 * indicates PERST# should be deasserted after minimum of 100us
-		 * once REFCLK is stable. The REFCLK to the connector in RC
-		 * mode is selected while enabling the PHY. So deassert PERST#
-		 * after 100 us.
+		 * The "Power Sequencing and Reset Signal Timings" table of the
+		 * PCI Express Card Electromechanical Specification, Revision
+		 * 5.1, Section 2.9.2, Symbol "T_PERST-CLK", indicates PERST#
+		 * should be deasserted after minimum of 100us once REFCLK is
+		 * stable. The REFCLK to the connector in RC mode is selected
+		 * while enabling the PHY. So deassert PERST# after 100 us.
 		 */
 		if (gpiod) {
 			fsleep(PCIE_T_PERST_CLK_US);
@@ -591,6 +595,87 @@ static void j721e_pcie_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 }
 
+static int j721e_pcie_suspend_noirq(struct device *dev)
+{
+	struct j721e_pcie *pcie = dev_get_drvdata(dev);
+
+	if (pcie->mode == PCI_MODE_RC) {
+		gpiod_set_value_cansleep(pcie->reset_gpio, 0);
+		clk_disable_unprepare(pcie->refclk);
+	}
+
+	cdns_pcie_disable_phy(pcie->cdns_pcie);
+
+	return 0;
+}
+
+static int j721e_pcie_resume_noirq(struct device *dev)
+{
+	struct j721e_pcie *pcie = dev_get_drvdata(dev);
+	struct cdns_pcie *cdns_pcie = pcie->cdns_pcie;
+	int ret;
+
+	ret = j721e_pcie_ctrl_init(pcie);
+	if (ret < 0)
+		return ret;
+
+	j721e_pcie_config_link_irq(pcie);
+
+	/*
+	 * This is not called explicitly in the probe, it is called by
+	 * cdns_pcie_init_phy().
+	 */
+	ret = cdns_pcie_enable_phy(pcie->cdns_pcie);
+	if (ret < 0)
+		return ret;
+
+	if (pcie->mode == PCI_MODE_RC) {
+		struct cdns_pcie_rc *rc = cdns_pcie_to_rc(cdns_pcie);
+
+		ret = clk_prepare_enable(pcie->refclk);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * The "Power Sequencing and Reset Signal Timings" table of the
+		 * PCI Express Card Electromechanical Specification, Revision
+		 * 5.1, Section 2.9.2, Symbol "T_PERST-CLK", indicates PERST#
+		 * should be deasserted after minimum of 100us once REFCLK is
+		 * stable. The REFCLK to the connector in RC mode is selected
+		 * while enabling the PHY. So deassert PERST# after 100 us.
+		 */
+		if (pcie->reset_gpio) {
+			fsleep(PCIE_T_PERST_CLK_US);
+			gpiod_set_value_cansleep(pcie->reset_gpio, 1);
+		}
+
+		ret = cdns_pcie_host_link_setup(rc);
+		if (ret < 0) {
+			clk_disable_unprepare(pcie->refclk);
+			return ret;
+		}
+
+		/*
+		 * Reset internal status of BARs to force reinitialization in
+		 * cdns_pcie_host_init().
+		 */
+		for (enum cdns_pcie_rp_bar bar = RP_BAR0; bar <= RP_NO_BAR; bar++)
+			rc->avail_ib_bar[bar] = true;
+
+		ret = cdns_pcie_host_init(rc);
+		if (ret) {
+			clk_disable_unprepare(pcie->refclk);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static DEFINE_NOIRQ_DEV_PM_OPS(j721e_pcie_pm_ops,
+			       j721e_pcie_suspend_noirq,
+			       j721e_pcie_resume_noirq);
+
 static struct platform_driver j721e_pcie_driver = {
 	.probe  = j721e_pcie_probe,
 	.remove_new = j721e_pcie_remove,
@@ -598,6 +683,7 @@ static struct platform_driver j721e_pcie_driver = {
 		.name	= "j721e-pcie",
 		.of_match_table = of_j721e_pcie_match,
 		.suppress_bind_attrs = true,
+		.pm	= pm_sleep_ptr(&j721e_pcie_pm_ops),
 	},
 };
 builtin_platform_driver(j721e_pcie_driver);
-- 
2.43.0



