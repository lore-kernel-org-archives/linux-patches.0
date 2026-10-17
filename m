Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C0317BED0;
	Sat, 17 Oct 2026 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253460; cv=none; b=SE1uP1gwsOiX45ETjPNGAYRJWUdo4u8P3exs0QD35hfZnOmkNtEBJWuZ/P0w7Y5r6DBwO5CpIugPMlzMWW657eW2RhuIFNj0z1HEYnumwe25pYI/4JSXgc/4h1y1Tn84GBIVKYUl1gMlGrgkmW4S7O5/vrMFPth0kuED89joGMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253460; c=relaxed/simple;
	bh=BkKWJVVEDqLfRyq3JqfPwJxZhEeIe3FJngflzw4EdM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv/TMX3HoGw1GZuM8SUhyZmJHLwBfPuNpC0ZMGnIFiDGVqEoeVMZ0dCYzMRkhtI60OazYa5a4qS5lzgP08XyuFyzRvvolMK1kaLN13Q3GvIZ7+1T/y/w/d/W4vAdsh31IMCC0MhTefjB3pgFtaqZz8xPKqfSpTgYG+OX4zRX/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZgvZPtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZgvZPtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6132A1F000C4;
	Sat, 17 Oct 2026 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253459;
	bh=cD3CYsdq2E1pNGOPOoupdtGX5Ja+lelu0uHpdveGuMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZgvZPtSSoxX0r3OYgdbfyTM/jF4bty3gckD8BssE0dnlcr6FaQGY9FwVlvKFFLdl
	 w7v650vxDnYuxFGXKfktBwdcpTia7z8rBBvP8zVYGL6FOteGf2s3wj2PM0MbobNNLi
	 IUWUHNxZSmnKVF3HBlnDyvywu0t8YLx0Q+CTag58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/869] iommu/s390: set appropriate IOTA region type
Date: Sat, 17 Oct 2026 17:49:27 +0200
Message-ID: <20261017160040.270314390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 83c1aec21064c762a2ee475f0fd19f5241de25bc ]

When registering the I/O Translation Anchor, use the current table type
stored in the s390_domain to set the appropriate region type
indication.  For the moment, the table type will always be stored as
region third.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Link: https://lore.kernel.org/r/20250411202433.181683-2-mjrosato@linux.ibm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 9ffaf5229055 ("iommu/s390: Make attach succeed when the device was surprise removed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/s390-iommu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 007ccfdad4954..3df6b3e322271 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -31,6 +31,7 @@ struct s390_domain {
 	unsigned long		*dma_table;
 	spinlock_t		list_lock;
 	struct rcu_head		rcu;
+	u8			origin_type;
 };
 
 static struct iommu_domain blocking_domain;
@@ -345,6 +346,7 @@ static struct iommu_domain *s390_domain_alloc_paging(struct device *dev)
 	s390_domain->domain.geometry.force_aperture = true;
 	s390_domain->domain.geometry.aperture_start = 0;
 	s390_domain->domain.geometry.aperture_end = ZPCI_TABLE_SIZE_RT - 1;
+	s390_domain->origin_type = ZPCI_TABLE_TYPE_RTX;
 
 	spin_lock_init(&s390_domain->list_lock);
 	INIT_LIST_HEAD_RCU(&s390_domain->devices);
@@ -381,6 +383,21 @@ static void zdev_s390_domain_update(struct zpci_dev *zdev,
 	spin_unlock_irqrestore(&zdev->dom_lock, flags);
 }
 
+static u64 get_iota_region_flag(struct s390_domain *domain)
+{
+	switch (domain->origin_type) {
+	case ZPCI_TABLE_TYPE_RTX:
+		return ZPCI_IOTA_RTTO_FLAG;
+	case ZPCI_TABLE_TYPE_RSX:
+		return ZPCI_IOTA_RSTO_FLAG;
+	case ZPCI_TABLE_TYPE_RFX:
+		return ZPCI_IOTA_RFTO_FLAG;
+	default:
+		WARN_ONCE(1, "Invalid IOMMU table (%x)\n", domain->origin_type);
+		return 0;
+	}
+}
+
 static int s390_iommu_domain_reg_ioat(struct zpci_dev *zdev,
 				      struct iommu_domain *domain, u8 *status)
 {
@@ -399,7 +416,7 @@ static int s390_iommu_domain_reg_ioat(struct zpci_dev *zdev,
 	default:
 		s390_domain = to_s390_domain(domain);
 		iota = virt_to_phys(s390_domain->dma_table) |
-		       ZPCI_IOTA_RTTO_FLAG;
+		       get_iota_region_flag(s390_domain);
 		rc = zpci_register_ioat(zdev, 0, zdev->start_dma,
 					zdev->end_dma, iota, status);
 	}
-- 
2.53.0



