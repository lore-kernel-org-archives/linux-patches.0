Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2343E066;
	Tue, 21 Jul 2026 22:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672790; cv=none; b=JRIP2u1zMKotYy8FPaDQNoIF4hVtOOfiHPYUj+9c6wcR/WjkKm0xxJD6OlQRaYgsUaTvTxZE0vSP0xj/rkERBCIKDXmTMSxJ6IaVf+PJmT/2lmVI04ex253U9A2L5eAyaYIxL1olv4NuXEL0FWvzOOlziriWoKqyzc8K4wE0fo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672790; c=relaxed/simple;
	bh=li7+9j7uXruExY+QFXf4xx789IhoL0cD2DQQYBy+dTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mtp58jrY8ECFLTeFMIL0bsw7zTkM2lNOzezX7fyy39XOqf2VQFJpm1Lg0N6yFrhxuaowsRCrtNWpm7OL2ppLbnX+k7o1ju5SMHgkGumW6qdSaFnMfls3vb10FTZwDFLLA6cOYrZjx8ClaMXiCwVpr5X/ctCaDRmiM6cVX0pFKy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haYCeH/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haYCeH/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5E81F000E9;
	Tue, 21 Jul 2026 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672788;
	bh=GlNzGOY4hMx6ZuNa0HkPHVpdvL1NwHesgocJ7k0gbz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haYCeH/XYe3uPg8kIzNSd6a7EBGogCkFprwT1Y/MayZ2iv52ovFQ2L/pryNydqbMQ
	 YCElDGCire9rQyUCfGFeLthTxoOzS4Q60oFRb1/7AQhPkjA16UuT9ga359bdMTLewz
	 glp2S6GBVYEmqh8rqefeXvzRsaS4k8lWQuCXT6V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 756/843] PCI: controller: Use dev_fwnode() instead of of_fwnode_handle()
Date: Tue, 21 Jul 2026 17:26:31 +0200
Message-ID: <20260721152423.056469487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

[ Upstream commit a103d2dede5683dabbac2c3374bc24b6a9434478 ]

All irq_domain functions now accept fwnode instead of of_node. But many
PCI controllers still extract dev to of_node and then of_node to fwnode.

Instead, clean this up and simply use the dev_fwnode() helper to extract
fwnode directly from dev. Internally, it still does dev => of_node =>
fwnode steps, but it's now hidden from the users.

In the case of altera, this also removes an unused 'node' variable that is
only used when CONFIG_OF is enabled:

  drivers/pci/controller/pcie-altera.c: In function 'altera_pcie_init_irq_domain':
  drivers/pci/controller/pcie-altera.c:855:29: error: unused variable 'node' [-Werror=unused-variable]
    855 |         struct device_node *node = dev->of_node;

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>	# altera
[bhelgaas: squash together, rebase to precede msi-parent]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250521163329.2137973-1-arnd@kernel.org
Link: https://patch.msgid.link/20250611104348.192092-16-jirislaby@kernel.org
Link: https://patch.msgid.link/20250723065907.1841758-1-jirislaby@kernel.org
Stable-dep-of: f865a57896bd ("PCI: mediatek: Fix IRQ domain leak when port fails to enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c    |    2 +-
 drivers/pci/controller/mobiveil/pcie-mobiveil-host.c |    8 +++-----
 drivers/pci/controller/pcie-altera-msi.c             |    2 +-
 drivers/pci/controller/pcie-altera.c                 |    3 +--
 drivers/pci/controller/pcie-mediatek-gen3.c          |    2 +-
 drivers/pci/controller/pcie-mediatek.c               |    2 +-
 drivers/pci/controller/pcie-xilinx-nwl.c             |    2 +-
 7 files changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -232,7 +232,7 @@ static const struct irq_domain_ops dw_pc
 int dw_pcie_allocate_domains(struct pcie_port *pp)
 {
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
-	struct fwnode_handle *fwnode = of_node_to_fwnode(pci->dev->of_node);
+	struct fwnode_handle *fwnode = dev_fwnode(pci->dev);
 
 	pp->irq_domain = irq_domain_create_linear(fwnode, pp->num_vectors,
 					       &dw_pcie_msi_domain_ops, pp);
--- a/drivers/pci/controller/mobiveil/pcie-mobiveil-host.c
+++ b/drivers/pci/controller/mobiveil/pcie-mobiveil-host.c
@@ -445,7 +445,7 @@ static const struct irq_domain_ops msi_d
 static int mobiveil_allocate_msi_domains(struct mobiveil_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct fwnode_handle *fwnode = of_node_to_fwnode(dev->of_node);
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct mobiveil_msi *msi = &pcie->rp.msi;
 
 	mutex_init(&msi->lock);
@@ -471,13 +471,11 @@ static int mobiveil_allocate_msi_domains
 static int mobiveil_pcie_init_irq_domain(struct mobiveil_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *node = dev->of_node;
 	struct mobiveil_root_port *rp = &pcie->rp;
 
 	/* setup INTx */
-	rp->intx_domain = irq_domain_add_linear(node, PCI_NUM_INTX,
-						&intx_domain_ops, pcie);
-
+	rp->intx_domain = irq_domain_create_linear(dev_fwnode(dev), PCI_NUM_INTX, &intx_domain_ops,
+						   pcie);
 	if (!rp->intx_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
 		return -ENOMEM;
--- a/drivers/pci/controller/pcie-altera-msi.c
+++ b/drivers/pci/controller/pcie-altera-msi.c
@@ -171,7 +171,7 @@ static const struct irq_domain_ops msi_d
 
 static int altera_allocate_domains(struct altera_msi *msi)
 {
-	struct fwnode_handle *fwnode = of_node_to_fwnode(msi->pdev->dev.of_node);
+	struct fwnode_handle *fwnode = dev_fwnode(&msi->pdev->dev);
 
 	msi->inner_domain = irq_domain_add_linear(NULL, msi->num_of_vectors,
 					     &msi_domain_ops, msi);
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -670,10 +670,9 @@ static void altera_pcie_isr(struct irq_d
 static int altera_pcie_init_irq_domain(struct altera_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *node = dev->of_node;
 
 	/* Setup INTx */
-	pcie->irq_domain = irq_domain_add_linear(node, PCI_NUM_INTX,
+	pcie->irq_domain = irq_domain_create_linear(dev_fwnode(dev), PCI_NUM_INTX,
 					&intx_domain_ops, pcie);
 	if (!pcie->irq_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -607,7 +607,7 @@ static int mtk_pcie_init_irq_domains(str
 	/* Setup MSI */
 	mutex_init(&port->lock);
 
-	port->msi_bottom_domain = irq_domain_add_linear(node, PCIE_MSI_IRQS_NUM,
+	port->msi_bottom_domain = irq_domain_create_linear(dev_fwnode(dev), PCIE_MSI_IRQS_NUM,
 				  &mtk_msi_bottom_domain_ops, port);
 	if (!port->msi_bottom_domain) {
 		dev_err(dev, "failed to create MSI bottom domain\n");
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -503,7 +503,7 @@ static struct msi_domain_info mtk_msi_do
 
 static int mtk_pcie_allocate_msi_domains(struct mtk_pcie_port *port)
 {
-	struct fwnode_handle *fwnode = of_node_to_fwnode(port->pcie->dev->of_node);
+	struct fwnode_handle *fwnode = dev_fwnode(port->pcie->dev);
 
 	mutex_init(&port->lock);
 
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -505,7 +505,7 @@ static int nwl_pcie_init_msi_irq_domain(
 {
 #ifdef CONFIG_PCI_MSI
 	struct device *dev = pcie->dev;
-	struct fwnode_handle *fwnode = of_node_to_fwnode(dev->of_node);
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct nwl_msi *msi = &pcie->msi;
 
 	msi->dev_domain = irq_domain_add_linear(NULL, INT_PCI_MSI_NR,


