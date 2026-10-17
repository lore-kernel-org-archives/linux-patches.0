Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1238E100;
	Sat, 17 Oct 2026 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254572; cv=none; b=EvGlDPIzXOvJrwZMHs3IMmv+8z+Sm0/Gcs5tHOvIxws6quoCPCykZTPKVAYF8dP2kEwsa3iTDXfCnpH7fviDVL7hBeP+T1WICTMf3A0yRBsVDwCVqdR57RuL5aTNwcFIGeTtutLjSIGTQXe7QM8ijuSDvOAmT7bEO6LkeW3go9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254572; c=relaxed/simple;
	bh=JgbaNINiRnCx2Dpo/0pj31x/elhaqIJxkPPOxF3mxos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw3JFgIQ1P0t161/zlIp5XQ8mFtsgwnWu1y9dee46BNN3X7LhfuvIbmj0LZ5HNxYOsKmhrxjoPo0RLq48x78qgyROkVqkI5oIUBfVMrH79g4fdYbiU4EamtCzZD3NdF506HRnGBAM6qk5ecEdo7Z+Rz6/Ct7aopVvYj5mUaDOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a56YRmQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a56YRmQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725AA1F000C4;
	Sat, 17 Oct 2026 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254570;
	bh=Yz1RSOfmNH+RFrDATcEM6l0mjvyFVOt0IdW7rZZhFNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a56YRmQyyEMRUGd094Ta1FbRYw0wJ5fTFsea2SaC3ssn7vNEA23xf5vXxtVaBHw8k
	 pIt7a4d6283gNhzH4/KryMf+DGgHpeXdWEIQlyZdoFfOFZnvGAMAzPeQgso3S3LF+5
	 HxrXxIGlgG+NSgg9qWSVReQCI33qWMyxgYsWKf3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/869] iommu/iommufd: Fix IOPF group ownership UAF
Date: Sat, 17 Oct 2026 17:55:32 +0200
Message-ID: <20261017160049.700874392@linuxfoundation.org>
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

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

[ Upstream commit 738e6f32e61d80b554e37015ecb7bc620b88001c ]

iopf_group_alloc() links each last-page IOPF group into the generic IOPF
pending list before invoking the domain fault handler.
iommufd_fault_iopf_handler() also queued an accepted group in the
IOMMUFD deliver list without removing it from the generic pending list.

When detach or HWPT replacement drops the device's IOPF reference count
to zero, an IOMMU driver may call iopf_queue_remove_device(). That
function responds to and frees groups through the generic pending list
without removing the same groups from IOMMUFD's deliver list or response
xarray. A later read, response, or cleanup can then access the freed
group and cause a UAF.

Fix this by dequeuing an accepted group from the generic pending list
before IOMMUFD queues it for userspace response.
Make iopf_group_response() send a response regardless of pending-list
membership, so the dequeued group can still be completed by IOMMUFD.

Link: https://patch.msgid.link/r/3CFD314D0FE4D7EC+20260720085017.3998878-2-peiyang_he@smail.nju.edu.cn
Closes: https://lore.kernel.org/all/B4F28798E2E784CA+d29f723c-b2b5-4b67-8d1c-4f7b9b0b27cb@smail.nju.edu.cn/
Fixes: 34765cbc679c ("iommufd: Associate fault object with iommufd_hw_pgtable")
Cc: stable@vger.kernel.org
Tested-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgfault.c    | 24 +++++++++++++++++++-----
 drivers/iommu/iommufd/fault.c |  2 ++
 include/linux/iommu.h         |  5 +++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 8b5926c1452ed..afe977235d72f 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -332,16 +332,30 @@ void iopf_group_response(struct iopf_group *group,
 		.code = status,
 	};
 
-	/* Only send response if there is a fault report pending */
 	mutex_lock(&fault_param->lock);
-	if (!list_empty(&group->pending_node)) {
-		ops->page_response(dev, &group->last_fault, &resp);
-		list_del_init(&group->pending_node);
-	}
+	ops->page_response(dev, &group->last_fault, &resp);
+	list_del_init(&group->pending_node);
 	mutex_unlock(&fault_param->lock);
 }
 EXPORT_SYMBOL_GPL(iopf_group_response);
 
+/**
+ * iopf_group_dequeue - Dequeue a page fault group from the pending list
+ * @group: the group to dequeue
+ *
+ * The fault handler is responsible for responding to the group after
+ * this function returns.
+ */
+void iopf_group_dequeue(struct iopf_group *group)
+{
+	struct iommu_fault_param *fault_param = group->fault_param;
+
+	mutex_lock(&fault_param->lock);
+	list_del_init(&group->pending_node);
+	mutex_unlock(&fault_param->lock);
+}
+EXPORT_SYMBOL_GPL(iopf_group_dequeue);
+
 /**
  * iopf_queue_discard_partial - Remove all pending partial fault
  * @queue: the queue whose partial faults need to be discarded
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index 74e3c93bce6ea..bdaecb6e1f7a3 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -454,6 +454,8 @@ int iommufd_fault_iopf_handler(struct iopf_group *group)
 	hwpt = group->attach_handle->domain->fault_data;
 	fault = hwpt->fault;
 
+	iopf_group_dequeue(group);
+
 	spin_lock(&fault->lock);
 	list_add_tail(&group->node, &fault->deliver);
 	spin_unlock(&fault->lock);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index dc7ceb9406eda..929b9d0d90cde 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1566,6 +1566,7 @@ void iopf_free_group(struct iopf_group *group);
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 void iopf_group_response(struct iopf_group *group,
 			 enum iommu_page_response_code status);
+void iopf_group_dequeue(struct iopf_group *group);
 #else
 static inline int
 iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
@@ -1611,5 +1612,9 @@ static inline void iopf_group_response(struct iopf_group *group,
 				       enum iommu_page_response_code status)
 {
 }
+
+static inline void iopf_group_dequeue(struct iopf_group *group)
+{
+}
 #endif /* CONFIG_IOMMU_IOPF */
 #endif /* __LINUX_IOMMU_H */
-- 
2.53.0



