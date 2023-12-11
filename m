Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1508DFC06;
	Mon, 11 Dec 2023 18:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEMivbtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B204C433C7;
	Mon, 11 Dec 2023 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320171;
	bh=iJ2arQ6Q2R6JBDoPK95eAry7LS2JTqhzhgNDmJjrbdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEMivbtusjgAXvwrEzOeEsiC0xUwUis5Vqw0zWnqDF1arSHORG06j4bCgxyiicZY6
	 LGLO7wKp51PFjYg5M3p5dYZPrGhJ5Yvx48F0TcOT8gmBLXHeQFykX4La/NYPfFIPya
	 DBnd0wNGUrDkCUPoEHgkJUTjsd6R5DDe5tqFd7jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Will Deacon <will@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/67] ACPI/IORT: Make iort_msi_map_rid() PCI agnostic
Date: Mon, 11 Dec 2023 19:21:53 +0100
Message-ID: <20231211182015.483516586@linuxfoundation.org>
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

[ Upstream commit 39c3cf566ceafa7c1ae331a5f26fbb685d670001 ]

There is nothing PCI specific in iort_msi_map_rid().

Rename the function using a bus protocol agnostic name,
iort_msi_map_id(), and convert current callers to it.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Link: https://lore.kernel.org/r/20200619082013.13661-4-lorenzo.pieralisi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: d79972789d17 ("of: dynamic: Fix of_reconfig_get_state_change() return value documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 12 ++++++------
 drivers/pci/msi.c         |  2 +-
 include/linux/acpi_iort.h |  6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 0428e74b6002b..13ae2ce9f50dd 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -521,22 +521,22 @@ static struct acpi_iort_node *iort_find_dev_node(struct device *dev)
 }
 
 /**
- * iort_msi_map_rid() - Map a MSI requester ID for a device
+ * iort_msi_map_id() - Map a MSI input ID for a device
  * @dev: The device for which the mapping is to be done.
- * @req_id: The device requester ID.
+ * @input_id: The device input ID.
  *
- * Returns: mapped MSI RID on success, input requester ID otherwise
+ * Returns: mapped MSI ID on success, input ID otherwise
  */
-u32 iort_msi_map_rid(struct device *dev, u32 req_id)
+u32 iort_msi_map_id(struct device *dev, u32 input_id)
 {
 	struct acpi_iort_node *node;
 	u32 dev_id;
 
 	node = iort_find_dev_node(dev);
 	if (!node)
-		return req_id;
+		return input_id;
 
-	iort_node_map_id(node, req_id, &dev_id, IORT_MSI_TYPE);
+	iort_node_map_id(node, input_id, &dev_id, IORT_MSI_TYPE);
 	return dev_id;
 }
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6336316c37932..cc863cdd5cc74 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1604,7 +1604,7 @@ u32 pci_msi_domain_get_msi_rid(struct irq_domain *domain, struct pci_dev *pdev)
 
 	of_node = irq_domain_get_of_node(domain);
 	rid = of_node ? of_msi_map_rid(&pdev->dev, of_node, rid) :
-			iort_msi_map_rid(&pdev->dev, rid);
+			iort_msi_map_id(&pdev->dev, rid);
 
 	return rid;
 }
diff --git a/include/linux/acpi_iort.h b/include/linux/acpi_iort.h
index 6bf603a4e6d2c..cce2cbd4f3018 100644
--- a/include/linux/acpi_iort.h
+++ b/include/linux/acpi_iort.h
@@ -29,7 +29,7 @@ void iort_deregister_domain_token(int trans_id);
 struct fwnode_handle *iort_find_domain_token(int trans_id);
 #ifdef CONFIG_ACPI_IORT
 void acpi_iort_init(void);
-u32 iort_msi_map_rid(struct device *dev, u32 req_id);
+u32 iort_msi_map_id(struct device *dev, u32 id);
 struct irq_domain *iort_get_device_domain(struct device *dev, u32 id,
 					  enum irq_domain_bus_token bus_token);
 void acpi_configure_pmsi_domain(struct device *dev);
@@ -40,8 +40,8 @@ const struct iommu_ops *iort_iommu_configure(struct device *dev);
 int iort_iommu_msi_get_resv_regions(struct device *dev, struct list_head *head);
 #else
 static inline void acpi_iort_init(void) { }
-static inline u32 iort_msi_map_rid(struct device *dev, u32 req_id)
-{ return req_id; }
+static inline u32 iort_msi_map_id(struct device *dev, u32 id)
+{ return id; }
 static inline struct irq_domain *iort_get_device_domain(
 	struct device *dev, u32 id, enum irq_domain_bus_token bus_token)
 { return NULL; }
-- 
2.42.0



