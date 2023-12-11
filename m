Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0731D696;
	Mon, 11 Dec 2023 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qN1+tcA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F6CC433C7;
	Mon, 11 Dec 2023 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320115;
	bh=T86tbj5s9xUJcLdssQN7h6/NX0YSeU7p2ZotsVPV1X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qN1+tcA+0LP9sqh2GvR1QJPnoaw99XVJK8beBHxN27x1J2nHGC4mhapCMRr8Yfb02
	 ukYYSvASN4XBo9qpiQAX87tC0OfsMmen19Z+JmXz+lHrjLU0NgEbb6jTI5X9TDqlco
	 8cvGnzOkQeWu5hs3ZYzvGJp5GbFyiNBeS6ndaCzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diana Craciun <diana.craciun@oss.nxp.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rob Herring <robh+dt@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/67] of/irq: make of_msi_map_get_device_domain() bus agnostic
Date: Mon, 11 Dec 2023 19:21:55 +0100
Message-ID: <20231211182015.571003692@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diana Craciun <diana.craciun@oss.nxp.com>

[ Upstream commit 6f881aba01109a01a43e4f135673c19190f61133 ]

of_msi_map_get_device_domain() is PCI specific but it need not be and
can be easily changed to be bus agnostic in order to be used by other
busses by adding an IRQ domain bus token as an input parameter.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>   # pci/msi.c
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200619082013.13661-10-lorenzo.pieralisi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: d79972789d17 ("of: dynamic: Fix of_reconfig_get_state_change() return value documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c       | 8 +++++---
 drivers/pci/msi.c      | 2 +-
 include/linux/of_irq.h | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index d632bc5b3a2de..1005e4f349ef6 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -613,18 +613,20 @@ u32 of_msi_map_rid(struct device *dev, struct device_node *msi_np, u32 rid_in)
  * of_msi_map_get_device_domain - Use msi-map to find the relevant MSI domain
  * @dev: device for which the mapping is to be done.
  * @rid: Requester ID for the device.
+ * @bus_token: Bus token
  *
  * Walk up the device hierarchy looking for devices with a "msi-map"
  * property.
  *
  * Returns: the MSI domain for this device (or NULL on failure)
  */
-struct irq_domain *of_msi_map_get_device_domain(struct device *dev, u32 rid)
+struct irq_domain *of_msi_map_get_device_domain(struct device *dev, u32 id,
+						u32 bus_token)
 {
 	struct device_node *np = NULL;
 
-	__of_msi_map_rid(dev, &np, rid);
-	return irq_find_matching_host(np, DOMAIN_BUS_PCI_MSI);
+	__of_msi_map_rid(dev, &np, id);
+	return irq_find_matching_host(np, bus_token);
 }
 
 /**
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index cc863cdd5cc74..392d2ecf7dc89 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1624,7 +1624,7 @@ struct irq_domain *pci_msi_get_device_domain(struct pci_dev *pdev)
 	u32 rid = pci_dev_id(pdev);
 
 	pci_for_each_dma_alias(pdev, get_msi_id_cb, &rid);
-	dom = of_msi_map_get_device_domain(&pdev->dev, rid);
+	dom = of_msi_map_get_device_domain(&pdev->dev, rid, DOMAIN_BUS_PCI_MSI);
 	if (!dom)
 		dom = iort_get_device_domain(&pdev->dev, rid,
 					     DOMAIN_BUS_PCI_MSI);
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 1214cabb22479..7142a37227584 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -52,7 +52,8 @@ extern struct irq_domain *of_msi_get_domain(struct device *dev,
 					    struct device_node *np,
 					    enum irq_domain_bus_token token);
 extern struct irq_domain *of_msi_map_get_device_domain(struct device *dev,
-						       u32 rid);
+							u32 id,
+							u32 bus_token);
 extern void of_msi_configure(struct device *dev, struct device_node *np);
 u32 of_msi_map_rid(struct device *dev, struct device_node *msi_np, u32 rid_in);
 #else
@@ -85,7 +86,7 @@ static inline struct irq_domain *of_msi_get_domain(struct device *dev,
 	return NULL;
 }
 static inline struct irq_domain *of_msi_map_get_device_domain(struct device *dev,
-							      u32 rid)
+						u32 id, u32 bus_token)
 {
 	return NULL;
 }
-- 
2.42.0



