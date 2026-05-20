Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D062F363F;
	Wed, 20 May 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300647; cv=none; b=FAkoZdYHuL00pbHUsk9yDcqwWuNa5hhdTZWqMUDjH2jU1ONDqROuN2T0GerFBW4Bg9XEQPGiuntmXma3Md6WD1fuH11ie18v1O4bXVOoaNdgfmTLZU1eolnLDymZ7lPHleVmawOGAZx8Lgykb53jW+ndcfYntyZvUUsy4eCBDPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300647; c=relaxed/simple;
	bh=NsPHGr//pU7EB1xgxPxWLPgYiqlNGSa6RIymAxUQOGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxJJJZ3DGmaQuc7x+M6tmavL3lPetF9jEks0ZKKmc1d37ybF/SPFY+22B90a95bjaQcSAzWcoIEVSQMF9pVxPxAfVAqZSpB7E+O+7qJWX+20q7OMVxd4irMjG02YYLmIEnDHKoFIGFhdPSxoFBWR9LUuifWzgsRygW4Opva6XQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXORmmxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXORmmxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F761F000E9;
	Wed, 20 May 2026 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300645;
	bh=bsh+izPjYqz0WovleBpNPdbQjcS1+y+9N5dnjMN+u0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXORmmxpOVjIPJVoDTgBKZX6Plg5RwwNpx7GDaIqcvU0fklKohEx5A4ZxAWULQfOr
	 UTQGINuW61RcxYL57B2UBnIoXNBsYpdUc7XYAThF1QU7SNKZxRSgEnzQdqJ0ifKkVx
	 NVxt8yZpFRvjix5HZESHwUa8uhtCCl1fJPCJCpYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/666] iommu/amd: Convert dev_data lock from spinlock to mutex
Date: Wed, 20 May 2026 18:17:04 +0200
Message-ID: <20260520162115.823997782@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit e843aedbeb82b17a5fe6172449bff133fc8b68a1 ]

Currently in attach device path it takes dev_data->spinlock. But as per
design attach device path can sleep. Also if device is PRI capable then
it adds device to IOMMU fault handler queue which takes mutex. Hence
currently PRI enablement is done outside dev_data lock.

Covert dev_data lock from spinlock to mutex so that it follows the
design and also PRI enablement can be done properly.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-10-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  2 +-
 drivers/iommu/amd/iommu.c           | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index f99a4b1349287..eadb4379cb4a1 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -838,7 +838,7 @@ struct devid_map {
  */
 struct iommu_dev_data {
 	/*Protect against attach/detach races */
-	spinlock_t lock;
+	struct mutex mutex;
 
 	struct list_head list;		  /* For domain->dev_list */
 	struct llist_node dev_data_list;  /* For global dev_data_list */
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4d59832ed6f81..2a2b9e3e3be7e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -225,7 +225,7 @@ static struct iommu_dev_data *alloc_dev_data(struct amd_iommu *iommu, u16 devid)
 	if (!dev_data)
 		return NULL;
 
-	spin_lock_init(&dev_data->lock);
+	mutex_init(&dev_data->mutex);
 	dev_data->devid = devid;
 	ratelimit_default_init(&dev_data->rs);
 
@@ -2129,7 +2129,7 @@ static int attach_device(struct device *dev,
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	int ret = 0;
 
-	spin_lock(&dev_data->lock);
+	mutex_lock(&dev_data->mutex);
 
 	if (dev_data->domain != NULL) {
 		ret = -EBUSY;
@@ -2155,7 +2155,7 @@ static int attach_device(struct device *dev,
 	}
 
 out:
-	spin_unlock(&dev_data->lock);
+	mutex_unlock(&dev_data->mutex);
 
 	return ret;
 }
@@ -2171,7 +2171,7 @@ static void detach_device(struct device *dev)
 	bool ppr = dev_data->ppr;
 	unsigned long flags;
 
-	spin_lock(&dev_data->lock);
+	mutex_lock(&dev_data->mutex);
 
 	/*
 	 * First check if the device is still attached. It might already
@@ -2209,7 +2209,7 @@ static void detach_device(struct device *dev)
 	pdom_detach_iommu(iommu, domain);
 
 out:
-	spin_unlock(&dev_data->lock);
+	mutex_unlock(&dev_data->mutex);
 
 	/* Remove IOPF handler */
 	if (ppr)
@@ -2486,9 +2486,9 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 		detach_device(dev);
 
 	/* Clear DTE and flush the entry */
-	spin_lock(&dev_data->lock);
+	mutex_lock(&dev_data->mutex);
 	dev_update_dte(dev_data, false);
-	spin_unlock(&dev_data->lock);
+	mutex_unlock(&dev_data->mutex);
 
 	return 0;
 }
-- 
2.53.0



