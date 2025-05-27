Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AAC27FD63;
	Tue, 27 May 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364932; cv=none; b=K2u5gbRNWUKo1vf9f8VXxVo/dKJs4etE9wEPZA/Ds2KNN6c4Pb3iu8t3flZQlItrW3nWsGtG6hrgLYnqOn9qfrAeJHWPxoaRz4ewsW1nYbR+UO5OE/F2Pq4UgmaV1tMVyOKMvkrzzqmgNEe4AavpnvzvBUGMMn3+819Hp8PLUwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364932; c=relaxed/simple;
	bh=d5ZXn9vvUxChhdQNKBSo0zKrNDeVpOUmLROWbqKyaMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwpPPEptIuniOxsS4BS9HgJbaLE3G8u98cSFvtCB7+sBfTitAFW7DUcdalr42hSatHf9erag+e60ADEaKkNwCetstZYSTuVhpWNupkxFPlwJ6NzAt4tLsAqs2MYBvS+tislRygqB0C944USeYXAxCsxXCfuqsw2s067SCxidNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5GARyzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5GARyzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98D1C4CEE9;
	Tue, 27 May 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364932;
	bh=d5ZXn9vvUxChhdQNKBSo0zKrNDeVpOUmLROWbqKyaMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5GARyzGDfUsBdfLVCZw9PBtpueDhfaoFC3JQ5kMMVFXBw/xl2kxoM9E43EH45KSH
	 O/U9ZU3QzhZBqBIvyivE7k/BSsk4ZVgJnMw8YJho9ha8kGLpdGgR6FZgnscOegA+5L
	 JEDA9z8WWQHaeOMAh0TsIxtjH1cNNrqsdeDaH1jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/626] iommu: Keep dev->iommu state consistent
Date: Tue, 27 May 2025 18:21:15 +0200
Message-ID: <20250527162452.405162989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 3832862eb9c4dfa0e80b2522bfaedbc8a43de97d ]

At the moment, if of_iommu_configure() allocates dev->iommu itself via
iommu_fwspec_init(), then suffers a DT parsing failure, it cleans up the
fwspec but leaves the empty dev_iommu hanging around. So far this is
benign (if a tiny bit wasteful), but we'd like to be able to reason
about dev->iommu having a consistent and unambiguous lifecycle. Thus
make sure that the of_iommu cleanup undoes precisely whatever it did.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/d219663a3f23001f23d520a883ac622d70b4e642.1740753261.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-priv.h | 2 ++
 drivers/iommu/iommu.c      | 2 +-
 drivers/iommu/of_iommu.c   | 6 +++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
index de5b54eaa8bf1..a5913c0b02a0a 100644
--- a/drivers/iommu/iommu-priv.h
+++ b/drivers/iommu/iommu-priv.h
@@ -17,6 +17,8 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 	return dev->iommu->iommu_dev->ops;
 }
 
+void dev_iommu_free(struct device *dev);
+
 const struct iommu_ops *iommu_ops_from_fwnode(const struct fwnode_handle *fwnode);
 
 static inline const struct iommu_ops *iommu_fwspec_ops(struct iommu_fwspec *fwspec)
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cac3dce111689..879009adef407 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -347,7 +347,7 @@ static struct dev_iommu *dev_iommu_get(struct device *dev)
 	return param;
 }
 
-static void dev_iommu_free(struct device *dev)
+void dev_iommu_free(struct device *dev)
 {
 	struct dev_iommu *param = dev->iommu;
 
diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index e7a6a1611d193..e3fcab925a547 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -118,6 +118,7 @@ static void of_pci_check_device_ats(struct device *dev, struct device_node *np)
 int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		       const u32 *id)
 {
+	bool dev_iommu_present;
 	int err;
 
 	if (!master_np)
@@ -129,6 +130,7 @@ int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		mutex_unlock(&iommu_probe_device_lock);
 		return 0;
 	}
+	dev_iommu_present = dev->iommu;
 
 	/*
 	 * We don't currently walk up the tree looking for a parent IOMMU.
@@ -149,8 +151,10 @@ int of_iommu_configure(struct device *dev, struct device_node *master_np,
 		err = of_iommu_configure_device(master_np, dev, id);
 	}
 
-	if (err)
+	if (err && dev_iommu_present)
 		iommu_fwspec_free(dev);
+	else if (err && dev->iommu)
+		dev_iommu_free(dev);
 	mutex_unlock(&iommu_probe_device_lock);
 
 	if (!err && dev->bus)
-- 
2.39.5



