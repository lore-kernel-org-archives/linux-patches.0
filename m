Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1DF5102F;
	Mon, 11 Dec 2023 18:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUS388cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA69C433C7;
	Mon, 11 Dec 2023 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320168;
	bh=VLXFskl9Utu7bVPeV7N4l4hAsQH+OSl0oCdVqt/IeC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUS388cWgjjkvo9ngPII1BUVM9u/FyrTvq1NOA+3Ois3cyHP5UtioftU7rnzUEne8
	 lobJBBmAyfbeXV77G+e/xIzVqb11aa/q6v5BczrUGJI+EWIDyR4gkg3wUGkfINVbe3
	 HrBoaqNhKIGN9BmkJjlQJfEwTBnyr5AEcT+lXtsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Will Deacon <will@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/67] ACPI/IORT: Make iort_get_device_domain IRQ domain agnostic
Date: Mon, 11 Dec 2023 19:21:52 +0100
Message-ID: <20231211182015.431666946@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

[ Upstream commit d1718a1b7a86743b9c517bf9521695ba909c734f ]

iort_get_device_domain() is PCI specific but it need not be,
since it can be used to retrieve IRQ domain nexus of any kind
by adding an irq_domain_bus_token input to it.

Make it PCI agnostic by also renaming the requestor ID input
to a more generic ID name.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>   # pci/msi.c
Cc: Will Deacon <will@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Link: https://lore.kernel.org/r/20200619082013.13661-3-lorenzo.pieralisi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: d79972789d17 ("of: dynamic: Fix of_reconfig_get_state_change() return value documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 14 +++++++-------
 drivers/pci/msi.c         |  3 ++-
 include/linux/acpi_iort.h |  7 ++++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 09eb170f26d27..0428e74b6002b 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -503,7 +503,6 @@ static struct acpi_iort_node *iort_find_dev_node(struct device *dev)
 		node = iort_get_iort_node(dev->fwnode);
 		if (node)
 			return node;
-
 		/*
 		 * if not, then it should be a platform device defined in
 		 * DSDT/SSDT (with Named Component node in IORT)
@@ -594,13 +593,13 @@ static int __maybe_unused iort_find_its_base(u32 its_id, phys_addr_t *base)
 /**
  * iort_dev_find_its_id() - Find the ITS identifier for a device
  * @dev: The device.
- * @req_id: Device's requester ID
+ * @id: Device's ID
  * @idx: Index of the ITS identifier list.
  * @its_id: ITS identifier.
  *
  * Returns: 0 on success, appropriate error value otherwise
  */
-static int iort_dev_find_its_id(struct device *dev, u32 req_id,
+static int iort_dev_find_its_id(struct device *dev, u32 id,
 				unsigned int idx, int *its_id)
 {
 	struct acpi_iort_its_group *its;
@@ -610,7 +609,7 @@ static int iort_dev_find_its_id(struct device *dev, u32 req_id,
 	if (!node)
 		return -ENXIO;
 
-	node = iort_node_map_id(node, req_id, NULL, IORT_MSI_TYPE);
+	node = iort_node_map_id(node, id, NULL, IORT_MSI_TYPE);
 	if (!node)
 		return -ENXIO;
 
@@ -633,19 +632,20 @@ static int iort_dev_find_its_id(struct device *dev, u32 req_id,
  *
  * Returns: the MSI domain for this device, NULL otherwise
  */
-struct irq_domain *iort_get_device_domain(struct device *dev, u32 req_id)
+struct irq_domain *iort_get_device_domain(struct device *dev, u32 id,
+					  enum irq_domain_bus_token bus_token)
 {
 	struct fwnode_handle *handle;
 	int its_id;
 
-	if (iort_dev_find_its_id(dev, req_id, 0, &its_id))
+	if (iort_dev_find_its_id(dev, id, 0, &its_id))
 		return NULL;
 
 	handle = iort_find_domain_token(its_id);
 	if (!handle)
 		return NULL;
 
-	return irq_find_matching_fwnode(handle, DOMAIN_BUS_PCI_MSI);
+	return irq_find_matching_fwnode(handle, bus_token);
 }
 
 static void iort_set_device_domain(struct device *dev,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 715c85d4e688d..6336316c37932 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1626,7 +1626,8 @@ struct irq_domain *pci_msi_get_device_domain(struct pci_dev *pdev)
 	pci_for_each_dma_alias(pdev, get_msi_id_cb, &rid);
 	dom = of_msi_map_get_device_domain(&pdev->dev, rid);
 	if (!dom)
-		dom = iort_get_device_domain(&pdev->dev, rid);
+		dom = iort_get_device_domain(&pdev->dev, rid,
+					     DOMAIN_BUS_PCI_MSI);
 	return dom;
 }
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/include/linux/acpi_iort.h b/include/linux/acpi_iort.h
index 64f700254ca0f..6bf603a4e6d2c 100644
--- a/include/linux/acpi_iort.h
+++ b/include/linux/acpi_iort.h
@@ -30,7 +30,8 @@ struct fwnode_handle *iort_find_domain_token(int trans_id);
 #ifdef CONFIG_ACPI_IORT
 void acpi_iort_init(void);
 u32 iort_msi_map_rid(struct device *dev, u32 req_id);
-struct irq_domain *iort_get_device_domain(struct device *dev, u32 req_id);
+struct irq_domain *iort_get_device_domain(struct device *dev, u32 id,
+					  enum irq_domain_bus_token bus_token);
 void acpi_configure_pmsi_domain(struct device *dev);
 int iort_pmsi_get_dev_id(struct device *dev, u32 *dev_id);
 /* IOMMU interface */
@@ -41,8 +42,8 @@ int iort_iommu_msi_get_resv_regions(struct device *dev, struct list_head *head);
 static inline void acpi_iort_init(void) { }
 static inline u32 iort_msi_map_rid(struct device *dev, u32 req_id)
 { return req_id; }
-static inline struct irq_domain *iort_get_device_domain(struct device *dev,
-							u32 req_id)
+static inline struct irq_domain *iort_get_device_domain(
+	struct device *dev, u32 id, enum irq_domain_bus_token bus_token)
 { return NULL; }
 static inline void acpi_configure_pmsi_domain(struct device *dev) { }
 /* IOMMU interface */
-- 
2.42.0



