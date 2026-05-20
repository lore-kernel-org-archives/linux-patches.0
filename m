Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5643264EB;
	Wed, 20 May 2026 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297300; cv=none; b=BXGVLyv+8igofnaf2Wl/qIfa2eWyqN5bdtt4xXNtOsoHy98A9m7H/GMKpGMKabzFILQsq9kvdomF2DNW/bpudjrGbnH6bgQ5JsL/wzb0L9j0BWjAegLAU15kVc+ry8wYK9wb77NqZkLG3Peq1eLbldGdeITtSI7kTYR3bqPKaJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297300; c=relaxed/simple;
	bh=AEjltkYe/dvH+2Q1afqYNljooLVduQ30DKbnApRAcWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfKi2p7HPQv4QJC3rgD8QWBxfWFX6Vqnu/BXAAIjeubuRkXHsAQytnQbcx50bD4XTefoDAup24skY+ltP10joSE5Ya4mPOkvpxazobbHq7mWiRufx0421ueSyonfzHLEOuYqB38rzHIJ/WMVO1r5YtdwkWsbqU+snl/oWzkBV6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfjwW9jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfjwW9jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C466E1F00894;
	Wed, 20 May 2026 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297299;
	bh=5UkC8DslZ0J8KrnHAirCf5TMh/IiIiwSrvqZgvOwNrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfjwW9jgLD704J49gv48/nWRv5W26fUlyWi+D31Rq0i+rw3mG+Q9/+7x2uYz1JR67
	 DTfgvrB1JcxGgJ0RZJKEwaeMQDMFosjW7ZRiVQO5YV3Y1tGi6fJBb/zQJv9mV7rpqo
	 oeePGFAi9yMayJsSTSCZIkpU7rX/eBbVgkTWfDgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1125/1146] iommu: Fix pasid attach in pci_dev_reset_iommu_prepare/done()
Date: Wed, 20 May 2026 18:22:55 +0200
Message-ID: <20260520162213.705092494@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 1615e8896a8f6d7b2adf6495e538a81bf6cea3e0 upstream.

Now the helpers handle per-gdev resets. Replace __iommu_set_group_pasid()
with set_dev_pasid() accordingly, in the pci_dev_reset_iommu_done().

Also add max_pasids check as other callers.

Fixes: c279e83953d9 ("iommu: Introduce pci_dev_reset_iommu_prepare/done()")
Cc: stable@vger.kernel.org
Reported-by: Shuai Xue <xueshuai@linux.alibaba.com>
Closes: https://lore.kernel.org/all/ad858513-09fc-455e-bbc5-fe38a225cc78@linux.alibaba.com/
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -4044,9 +4044,14 @@ int pci_dev_reset_iommu_prepare(struct p
 	 * The pasid_array is mostly fenced by group->mutex, except one reader
 	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
 	 */
-	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
-		iommu_remove_dev_pasid(&pdev->dev, pasid,
-				       pasid_array_entry_to_domain(entry));
+	if (pdev->dev.iommu->max_pasids > 0) {
+		xa_for_each_start(&group->pasid_array, pasid, entry, 1) {
+			struct iommu_domain *pasid_dom =
+				pasid_array_entry_to_domain(entry);
+
+			iommu_remove_dev_pasid(&pdev->dev, pasid, pasid_dom);
+		}
+	}
 
 	group->recovery_cnt++;
 	return ret;
@@ -4113,10 +4118,16 @@ void pci_dev_reset_iommu_done(struct pci
 	 * The pasid_array is mostly fenced by group->mutex, except one reader
 	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
 	 */
-	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
-		WARN_ON(__iommu_set_group_pasid(
-			pasid_array_entry_to_domain(entry), group, pasid,
-			group->blocking_domain));
+	if (pdev->dev.iommu->max_pasids > 0) {
+		xa_for_each_start(&group->pasid_array, pasid, entry, 1) {
+			struct iommu_domain *pasid_dom =
+				pasid_array_entry_to_domain(entry);
+
+			WARN_ON(pasid_dom->ops->set_dev_pasid(
+				pasid_dom, &pdev->dev, pasid,
+				group->blocking_domain));
+		}
+	}
 
 	if (!WARN_ON(group->recovery_cnt == 0))
 		group->recovery_cnt--;


