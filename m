Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435BC43E066;
	Tue, 21 Jul 2026 22:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674674; cv=none; b=ER1xmAAIWw64V747Vk8234H4s38HaGM2YjEfWOYqIIEDEcjs+9D+G/JNlolCsDdD7xsJcmQYP5qJbxK7QYrU5/3szAtnLlIE8cJPZ7o16vEsiYwIQmSTpfGS5U2/DDiNxPk3nktaRoCE79Yix22koQhqVuh/AjMQNraee/8Ee8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674674; c=relaxed/simple;
	bh=iEts3p7yh0+Z68aENufTOICkQiOiMqNs5ZfwpDVAigk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diQ6hlXtL+gkmWnqE8OZ2mvTTmbRyAY4XGLhRDGJ643RaotcoxAc8KSmsqpSm1MYw68UclAxvwi6zYu9sDW8LJ8VFNlMXjobFPT0PHuWb/qUJXNAQLJZo1YuG6SomD8+V6QebNN1IWO4lOa5SQRoGdVWgC33IaiMhWPoBooGNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh5zeYTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh5zeYTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456ED1F00A3A;
	Tue, 21 Jul 2026 22:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674671;
	bh=pJrjEB7Z9uK+m15E1AsU/OX5AnGA1c+KQQVS0+ifUvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh5zeYTGIvgnc3KVbW4EAewXuXNZmUt1YUdh+lAuJOp0QiRLIsLsT1rUuRdjN5ksc
	 WC4sOvS1hPFMfthxOSwQZaGR1GygpyYiqyBshkUZnLgW7C7obrqijiCJnn284By2eS
	 eIoY9Y/Li9n9JxEqEL67+J0MvuXHD9dlgoRJ4Uak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 627/699] PCI: mediatek: Fix IRQ domain leak when port fails to enable
Date: Tue, 21 Jul 2026 17:26:26 +0200
Message-ID: <20260721152409.890203694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit f865a57896bd92d7662eb2818d8f48872e2cbbc7 ]

When mtk_pcie_enable_port() fails, mtk_pcie_port_free() removes the port
from pcie->ports and frees the port structure. However, the IRQ domains set
up earlier by mtk_pcie_init_irq_domain() are never freed.

Fix this by refactoring mtk_pcie_irq_teardown() into a per-port helper,
mtk_pcie_irq_teardown_port(), and calling it from mtk_pcie_setup() when
mtk_pcie_enable_port() fails. Since the IRQ teardown must only happen in
the probe error path (during resume, child devices may have active MSI
mappings and the NOIRQ context prohibits sleeping locks),
mtk_pcie_enable_port() is changed to return an error code so callers can
distinguish the two paths and act accordingly.

This issue was reported by Sashiko while reviewing the EcoNet EN7528 SoC
support series.

Fixes: b099631df160 ("PCI: mediatek: Add controller support for MT2712 and MT7622")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org # 5.10
Cc: Caleb James DeLisle <cjd@cjdns.fr>
Link: https://patch.msgid.link/20260521174617.17692-1-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mediatek.c |   67 ++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 25 deletions(-)

--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -541,25 +541,29 @@ static void mtk_pcie_enable_msi(struct m
 	writel(val, port->base + PCIE_INT_MASK);
 }
 
-static void mtk_pcie_irq_teardown(struct mtk_pcie *pcie)
+static void mtk_pcie_irq_teardown_port(struct mtk_pcie_port *port)
 {
-	struct mtk_pcie_port *port, *tmp;
+	irq_set_chained_handler_and_data(port->irq, NULL, NULL);
 
-	list_for_each_entry_safe(port, tmp, &pcie->ports, list) {
-		irq_set_chained_handler_and_data(port->irq, NULL, NULL);
+	if (port->irq_domain)
+		irq_domain_remove(port->irq_domain);
 
-		if (port->irq_domain)
-			irq_domain_remove(port->irq_domain);
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		if (port->msi_domain)
+			irq_domain_remove(port->msi_domain);
+		if (port->inner_domain)
+			irq_domain_remove(port->inner_domain);
+	}
 
-		if (IS_ENABLED(CONFIG_PCI_MSI)) {
-			if (port->msi_domain)
-				irq_domain_remove(port->msi_domain);
-			if (port->inner_domain)
-				irq_domain_remove(port->inner_domain);
-		}
+	irq_dispose_mapping(port->irq);
+}
 
-		irq_dispose_mapping(port->irq);
-	}
+static void mtk_pcie_irq_teardown(struct mtk_pcie *pcie)
+{
+	struct mtk_pcie_port *port, *tmp;
+
+	list_for_each_entry_safe(port, tmp, &pcie->ports, list)
+		mtk_pcie_irq_teardown_port(port);
 }
 
 static int mtk_pcie_intx_map(struct irq_domain *domain, unsigned int irq,
@@ -836,7 +840,7 @@ static int mtk_pcie_startup_port(struct
 	return 0;
 }
 
-static void mtk_pcie_enable_port(struct mtk_pcie_port *port)
+static int mtk_pcie_enable_port(struct mtk_pcie_port *port)
 {
 	struct mtk_pcie *pcie = port->pcie;
 	struct device *dev = pcie->dev;
@@ -845,7 +849,7 @@ static void mtk_pcie_enable_port(struct
 	err = clk_prepare_enable(port->sys_ck);
 	if (err) {
 		dev_err(dev, "failed to enable sys_ck%d clock\n", port->slot);
-		goto err_sys_clk;
+		return err;
 	}
 
 	err = clk_prepare_enable(port->ahb_ck);
@@ -893,11 +897,15 @@ static void mtk_pcie_enable_port(struct
 		goto err_phy_on;
 	}
 
-	if (!pcie->soc->startup(port))
-		return;
+	err = pcie->soc->startup(port);
+	if (err) {
+		dev_info(dev, "Port%d link down\n", port->slot);
+		goto err_soc_startup;
+	}
 
-	dev_info(dev, "Port%d link down\n", port->slot);
+	return 0;
 
+err_soc_startup:
 	phy_power_off(port->phy);
 err_phy_on:
 	phy_exit(port->phy);
@@ -913,8 +921,8 @@ err_aux_clk:
 	clk_disable_unprepare(port->ahb_ck);
 err_ahb_clk:
 	clk_disable_unprepare(port->sys_ck);
-err_sys_clk:
-	mtk_pcie_port_free(port);
+
+	return err;
 }
 
 static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
@@ -1077,8 +1085,13 @@ static int mtk_pcie_setup(struct mtk_pci
 		return err;
 
 	/* enable each port, and then check link status */
-	list_for_each_entry_safe(port, tmp, &pcie->ports, list)
-		mtk_pcie_enable_port(port);
+	list_for_each_entry_safe(port, tmp, &pcie->ports, list) {
+		err = mtk_pcie_enable_port(port);
+		if (err) {
+			mtk_pcie_irq_teardown_port(port);
+			mtk_pcie_port_free(port);
+		}
+	}
 
 	/* power down PCIe subsys if slots are all empty (link down) */
 	if (list_empty(&pcie->ports))
@@ -1181,14 +1194,18 @@ static int __maybe_unused mtk_pcie_resum
 {
 	struct mtk_pcie *pcie = dev_get_drvdata(dev);
 	struct mtk_pcie_port *port, *tmp;
+	int err;
 
 	if (list_empty(&pcie->ports))
 		return 0;
 
 	clk_prepare_enable(pcie->free_ck);
 
-	list_for_each_entry_safe(port, tmp, &pcie->ports, list)
-		mtk_pcie_enable_port(port);
+	list_for_each_entry_safe(port, tmp, &pcie->ports, list) {
+		err = mtk_pcie_enable_port(port);
+		if (err)
+			mtk_pcie_port_free(port);
+	}
 
 	/* In case of EP was removed while system suspend. */
 	if (list_empty(&pcie->ports))


