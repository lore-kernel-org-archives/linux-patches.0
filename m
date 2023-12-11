Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E9FC06;
	Mon, 11 Dec 2023 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPYViLss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952E6C433C9;
	Mon, 11 Dec 2023 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320118;
	bh=RSf4dwaC+PecLSVRe8/N9KuXH1t9IxYoOujB3dLvbfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPYViLssSkeryO69h+HaZBUhUPs9vyYfnpueKhQwSLjTYEFCacgWW/DxmrH5+qPOE
	 TKiQxoA2ftinA4J2w9wNMnFQkRXh3QwwbCpBSCkGiILeV3+W2hLeMD1volDPMB93BZ
	 vjn45Q9pRDLSgqHqAi7n2Hzp2d5+8GSz8wJ0TJgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rob Herring <robh+dt@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/67] of/irq: Make of_msi_map_rid() PCI bus agnostic
Date: Mon, 11 Dec 2023 19:21:56 +0100
Message-ID: <20231211182015.619428264@linuxfoundation.org>
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

[ Upstream commit 2bcdd8f2c07f1aa1bfd34fa0dab8e06949e34846 ]

There is nothing PCI bus specific in the of_msi_map_rid()
implementation other than the requester ID tag for the input
ID space. Rename requester ID to a more generic ID so that
the translation code can be used by all busses that require
input/output ID translations.

No functional change intended.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200619082013.13661-11-lorenzo.pieralisi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: d79972789d17 ("of: dynamic: Fix of_reconfig_get_state_change() return value documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c       | 28 ++++++++++++++--------------
 drivers/pci/msi.c      |  2 +-
 include/linux/of_irq.h |  8 ++++----
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1005e4f349ef6..25d17b8a1a1aa 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -576,43 +576,43 @@ void __init of_irq_init(const struct of_device_id *matches)
 	}
 }
 
-static u32 __of_msi_map_rid(struct device *dev, struct device_node **np,
-			    u32 rid_in)
+static u32 __of_msi_map_id(struct device *dev, struct device_node **np,
+			    u32 id_in)
 {
 	struct device *parent_dev;
-	u32 rid_out = rid_in;
+	u32 id_out = id_in;
 
 	/*
 	 * Walk up the device parent links looking for one with a
 	 * "msi-map" property.
 	 */
 	for (parent_dev = dev; parent_dev; parent_dev = parent_dev->parent)
-		if (!of_map_id(parent_dev->of_node, rid_in, "msi-map",
-				"msi-map-mask", np, &rid_out))
+		if (!of_map_id(parent_dev->of_node, id_in, "msi-map",
+				"msi-map-mask", np, &id_out))
 			break;
-	return rid_out;
+	return id_out;
 }
 
 /**
- * of_msi_map_rid - Map a MSI requester ID for a device.
+ * of_msi_map_id - Map a MSI ID for a device.
  * @dev: device for which the mapping is to be done.
  * @msi_np: device node of the expected msi controller.
- * @rid_in: unmapped MSI requester ID for the device.
+ * @id_in: unmapped MSI ID for the device.
  *
  * Walk up the device hierarchy looking for devices with a "msi-map"
- * property.  If found, apply the mapping to @rid_in.
+ * property.  If found, apply the mapping to @id_in.
  *
- * Returns the mapped MSI requester ID.
+ * Returns the mapped MSI ID.
  */
-u32 of_msi_map_rid(struct device *dev, struct device_node *msi_np, u32 rid_in)
+u32 of_msi_map_id(struct device *dev, struct device_node *msi_np, u32 id_in)
 {
-	return __of_msi_map_rid(dev, &msi_np, rid_in);
+	return __of_msi_map_id(dev, &msi_np, id_in);
 }
 
 /**
  * of_msi_map_get_device_domain - Use msi-map to find the relevant MSI domain
  * @dev: device for which the mapping is to be done.
- * @rid: Requester ID for the device.
+ * @id: Device ID.
  * @bus_token: Bus token
  *
  * Walk up the device hierarchy looking for devices with a "msi-map"
@@ -625,7 +625,7 @@ struct irq_domain *of_msi_map_get_device_domain(struct device *dev, u32 id,
 {
 	struct device_node *np = NULL;
 
-	__of_msi_map_rid(dev, &np, id);
+	__of_msi_map_id(dev, &np, id);
 	return irq_find_matching_host(np, bus_token);
 }
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 392d2ecf7dc89..c4f4a8a3bf8fa 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1603,7 +1603,7 @@ u32 pci_msi_domain_get_msi_rid(struct irq_domain *domain, struct pci_dev *pdev)
 	pci_for_each_dma_alias(pdev, get_msi_id_cb, &rid);
 
 	of_node = irq_domain_get_of_node(domain);
-	rid = of_node ? of_msi_map_rid(&pdev->dev, of_node, rid) :
+	rid = of_node ? of_msi_map_id(&pdev->dev, of_node, rid) :
 			iort_msi_map_id(&pdev->dev, rid);
 
 	return rid;
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 7142a37227584..e8b78139f78c5 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -55,7 +55,7 @@ extern struct irq_domain *of_msi_map_get_device_domain(struct device *dev,
 							u32 id,
 							u32 bus_token);
 extern void of_msi_configure(struct device *dev, struct device_node *np);
-u32 of_msi_map_rid(struct device *dev, struct device_node *msi_np, u32 rid_in);
+u32 of_msi_map_id(struct device *dev, struct device_node *msi_np, u32 id_in);
 #else
 static inline int of_irq_count(struct device_node *dev)
 {
@@ -93,10 +93,10 @@ static inline struct irq_domain *of_msi_map_get_device_domain(struct device *dev
 static inline void of_msi_configure(struct device *dev, struct device_node *np)
 {
 }
-static inline u32 of_msi_map_rid(struct device *dev,
-				 struct device_node *msi_np, u32 rid_in)
+static inline u32 of_msi_map_id(struct device *dev,
+				 struct device_node *msi_np, u32 id_in)
 {
-	return rid_in;
+	return id_in;
 }
 #endif
 
-- 
2.42.0



