Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435F93F54D1;
	Wed, 20 May 2026 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300652; cv=none; b=MfHQhRuvT0NWpK6xWkmY492Vt1Dtz/jbYSCYA2Y0eMGl9A7b4zDlOHM4LAFyp8iDe05xyFwkUjIqXcWjyG7XAcYJEq2f2FfcWvPE0C8YmRVffp8Rf0RRVciXz6HE/NSy9QKtKboSNGuvyLENEdCsebOeYe2MDog9Kz2unuWIAwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300652; c=relaxed/simple;
	bh=/G6B9+9cpwbYrTWBj6L2lpfWGcVaIz0OV3Ffz0jjdyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyphkq34bVx5W8wEZlPSYnJO9iCNAuv1IKjigH6I5oiUsYhJAnvsKt6uoMCfcWOrMz7JmNEQZGxrYmp1ACTrIC28ctNBDQfPJLU8k4qy091dAomlkOoz6m8KnRGzn1oCL39Qxuf4r0CXsuR+6GxBAdQDhz5rQWvRxXVrbWy4k9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJIyOeHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJIyOeHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84741F000E9;
	Wed, 20 May 2026 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300651;
	bh=DdI76JqD67D2metYncayb+tSFjMCa+CZ1/CZ8MsMTQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJIyOeHtkOzfq5T9HSd6ohPVsuZlSYe1DiWqrc1uDeSJ1EjFsCPr3epK/lPgNWANe
	 2uF1RTiJpfQzTmgsB1Ik+p5PbHjgWamqRyeJaoAEZSqqIwMuFljwHuO7yz8MGM9Wcb
	 2d/ZToyuz/ykGlBnue05LmJTmVZToaiHc5oa6k8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/666] iommu/amd: Introduce helper function get_dte256()
Date: Wed, 20 May 2026 18:17:06 +0200
Message-ID: <20260520162115.868583764@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit a2ce608a1eb65c2af99c58b63eae557165a0da87 ]

And use it in clone_alias() along with update_dte256().
Also use get_dte256() in dump_dte_entry().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20241118054937.5203-7-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 62 ++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e5c6cf57439c9..3e28aefdc6a02 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -79,6 +79,8 @@ static void set_dte_entry(struct amd_iommu *iommu,
 
 static void iommu_flush_dte_sync(struct amd_iommu *iommu, u16 devid);
 
+static struct iommu_dev_data *find_dev_data(struct amd_iommu *iommu, u16 devid);
+
 /****************************************************************************
  *
  * Helper functions
@@ -196,6 +198,21 @@ static void update_dte256(struct amd_iommu *iommu, struct iommu_dev_data *dev_da
 	spin_unlock_irqrestore(&dev_data->dte_lock, flags);
 }
 
+static void get_dte256(struct amd_iommu *iommu, struct iommu_dev_data *dev_data,
+		      struct dev_table_entry *dte)
+{
+	unsigned long flags;
+	struct dev_table_entry *ptr;
+	struct dev_table_entry *dev_table = get_dev_table(iommu);
+
+	ptr = &dev_table[dev_data->devid];
+
+	spin_lock_irqsave(&dev_data->dte_lock, flags);
+	dte->data128[0] = ptr->data128[0];
+	dte->data128[1] = ptr->data128[1];
+	spin_unlock_irqrestore(&dev_data->dte_lock, flags);
+}
+
 static inline bool pdom_is_v2_pgtbl_mode(struct protection_domain *pdom)
 {
 	return (pdom && (pdom->pd_mode == PD_MODE_V2));
@@ -367,9 +384,11 @@ static struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid
 
 static int clone_alias(struct pci_dev *pdev, u16 alias, void *data)
 {
+	struct dev_table_entry new;
 	struct amd_iommu *iommu;
-	struct dev_table_entry *dev_table;
+	struct iommu_dev_data *dev_data, *alias_data;
 	u16 devid = pci_dev_id(pdev);
+	int ret = 0;
 
 	if (devid == alias)
 		return 0;
@@ -378,13 +397,27 @@ static int clone_alias(struct pci_dev *pdev, u16 alias, void *data)
 	if (!iommu)
 		return 0;
 
-	amd_iommu_set_rlookup_table(iommu, alias);
-	dev_table = get_dev_table(iommu);
-	memcpy(dev_table[alias].data,
-	       dev_table[devid].data,
-	       sizeof(dev_table[alias].data));
+	/* Copy the data from pdev */
+	dev_data = dev_iommu_priv_get(&pdev->dev);
+	if (!dev_data) {
+		pr_err("%s : Failed to get dev_data for 0x%x\n", __func__, devid);
+		ret = -EINVAL;
+		goto out;
+	}
+	get_dte256(iommu, dev_data, &new);
 
-	return 0;
+	/* Setup alias */
+	alias_data = find_dev_data(iommu, alias);
+	if (!alias_data) {
+		pr_err("%s : Failed to get alias dev_data for 0x%x\n", __func__, alias);
+		ret = -EINVAL;
+		goto out;
+	}
+	update_dte256(iommu, alias_data, &new);
+
+	amd_iommu_set_rlookup_table(iommu, alias);
+out:
+	return ret;
 }
 
 static void clone_aliases(struct amd_iommu *iommu, struct device *dev)
@@ -657,6 +690,12 @@ static int iommu_init_device(struct amd_iommu *iommu, struct device *dev)
 		return -ENOMEM;
 
 	dev_data->dev = dev;
+
+	/*
+	 * The dev_iommu_priv_set() needes to be called before setup_aliases.
+	 * Otherwise, subsequent call to dev_iommu_priv_get() will fail.
+	 */
+	dev_iommu_priv_set(dev, dev_data);
 	setup_aliases(iommu, dev);
 
 	/*
@@ -670,8 +709,6 @@ static int iommu_init_device(struct amd_iommu *iommu, struct device *dev)
 		dev_data->flags = pdev_get_caps(to_pci_dev(dev));
 	}
 
-	dev_iommu_priv_set(dev, dev_data);
-
 	return 0;
 }
 
@@ -718,10 +755,13 @@ static void amd_iommu_uninit_device(struct device *dev)
 static void dump_dte_entry(struct amd_iommu *iommu, u16 devid)
 {
 	int i;
-	struct dev_table_entry *dev_table = get_dev_table(iommu);
+	struct dev_table_entry dte;
+	struct iommu_dev_data *dev_data = find_dev_data(iommu, devid);
+
+	get_dte256(iommu, dev_data, &dte);
 
 	for (i = 0; i < 4; ++i)
-		pr_err("DTE[%d]: %016llx\n", i, dev_table[devid].data[i]);
+		pr_err("DTE[%d]: %016llx\n", i, dte.data[i]);
 }
 
 static void dump_command(unsigned long phys_addr)
-- 
2.53.0



