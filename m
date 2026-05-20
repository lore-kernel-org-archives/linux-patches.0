Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC25F3FA5D5;
	Wed, 20 May 2026 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300634; cv=none; b=TD7NPZ5AqjVcATKZg0t6iDxe8lmwt/bROwhEJSIFd+6RXb8yW4YsWVSNYBR9sCINbwivdcsGKgBcGa5bEUeaoi+50QWOiF4L5HdJu1rmu9hntF41m8BP//ZO0KifeGU97QlAj0W4zY+3jxIfSi/bxMoAQp0CuyqJw6SaSNKUquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300634; c=relaxed/simple;
	bh=ix2qMB6yeoNO8N+Iah5x3mxeGUf/s3mDO2I2UBtm6iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvLjUGyQQoC4Kg1FTxhCgKYXEfAZf7Jd5a94qIRuYwcP8ax2EgYlTY5d5LFO3pqStXUfq2eLtb8LLbZqBvqpryt1W+gul4Yy4d71coKITD6qXEbwFVCHzRQXNe5oy+RKgaXbZpZo8n5+tHW9EYcf70tD/btw7CERj6kS3xIZqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZkFPF+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZkFPF+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8EE1F000E9;
	Wed, 20 May 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300632;
	bh=hNoOZ1zpYsFFladlpb6HneGjHpmTJ2uc2/KjUQtX5/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZkFPF+zy9W4TrD5S1RIm9frSd25BhtNoa7Ticnz85Z9VqQFjFDtjWC7yEWMMWPwS
	 sbHWp5/dyjQ1j+dSoRfAJedK3ygxSUCxO8W10h7ZWxE2nos2ObLEX/NN0tuh3/8ZwJ
	 skcfWCHTdjsrtpSAd2fgMPCIxfxumztoaZX02foQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/666] iommu/amd: Rearrange attach device code
Date: Wed, 20 May 2026 18:17:03 +0200
Message-ID: <20260520162115.800814324@linuxfoundation.org>
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

[ Upstream commit 4b18ef8491b06e353e8801705092cc292582cb7a ]

attach_device() is just holding lock and calling do_attach(). There is
not need to have another function. Just move do_attach() code to
attach_device(). Similarly move do_detach() code to detach_device().

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-9-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 91 ++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3ac8f64a21475..4d59832ed6f81 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2118,12 +2118,24 @@ static void pdom_detach_iommu(struct amd_iommu *iommu,
 	spin_unlock_irqrestore(&pdom->lock, flags);
 }
 
-static int do_attach(struct iommu_dev_data *dev_data,
-		     struct protection_domain *domain)
+/*
+ * If a device is not yet associated with a domain, this function makes the
+ * device visible in the domain
+ */
+static int attach_device(struct device *dev,
+			 struct protection_domain *domain)
 {
+	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	int ret = 0;
 
+	spin_lock(&dev_data->lock);
+
+	if (dev_data->domain != NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
@@ -2131,67 +2143,17 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	/* Do reference counting */
 	ret = pdom_attach_iommu(iommu, domain);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Setup GCR3 table */
 	if (pdom_is_sva_capable(domain)) {
 		ret = init_gcr3_table(dev_data, domain);
 		if (ret) {
 			pdom_detach_iommu(iommu, domain);
-			return ret;
+			goto out;
 		}
 	}
 
-	return ret;
-}
-
-static void do_detach(struct iommu_dev_data *dev_data)
-{
-	struct protection_domain *domain = dev_data->domain;
-	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
-	unsigned long flags;
-
-	/* Clear DTE and flush the entry */
-	dev_update_dte(dev_data, false);
-
-	/* Flush IOTLB and wait for the flushes to finish */
-	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_all(domain);
-	spin_unlock_irqrestore(&domain->lock, flags);
-
-	/* Clear GCR3 table */
-	if (pdom_is_sva_capable(domain))
-		destroy_gcr3_table(dev_data, domain);
-
-	/* Update data structures */
-	dev_data->domain = NULL;
-	list_del(&dev_data->list);
-
-	/* decrease reference counters - needs to happen after the flushes */
-	pdom_detach_iommu(iommu, domain);
-}
-
-/*
- * If a device is not yet associated with a domain, this function makes the
- * device visible in the domain
- */
-static int attach_device(struct device *dev,
-			 struct protection_domain *domain)
-{
-	struct iommu_dev_data *dev_data;
-	int ret = 0;
-
-	dev_data = dev_iommu_priv_get(dev);
-
-	spin_lock(&dev_data->lock);
-
-	if (dev_data->domain != NULL) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ret = do_attach(dev_data, domain);
-
 out:
 	spin_unlock(&dev_data->lock);
 
@@ -2205,7 +2167,9 @@ static void detach_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	struct protection_domain *domain = dev_data->domain;
 	bool ppr = dev_data->ppr;
+	unsigned long flags;
 
 	spin_lock(&dev_data->lock);
 
@@ -2225,7 +2189,24 @@ static void detach_device(struct device *dev)
 		dev_data->ppr = false;
 	}
 
-	do_detach(dev_data);
+	/* Clear DTE and flush the entry */
+	dev_update_dte(dev_data, false);
+
+	/* Flush IOTLB and wait for the flushes to finish */
+	spin_lock_irqsave(&domain->lock, flags);
+	amd_iommu_domain_flush_all(domain);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	/* Clear GCR3 table */
+	if (pdom_is_sva_capable(domain))
+		destroy_gcr3_table(dev_data, domain);
+
+	/* Update data structures */
+	dev_data->domain = NULL;
+	list_del(&dev_data->list);
+
+	/* decrease reference counters - needs to happen after the flushes */
+	pdom_detach_iommu(iommu, domain);
 
 out:
 	spin_unlock(&dev_data->lock);
-- 
2.53.0



