Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FFE472F98;
	Fri,  7 Aug 2026 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117107; cv=none; b=dyK5NRO5NywONn/ldKTKqM9h/6MFkUThuVEYqhjOBPNy9mfLdAT9PNnpnD9m6pvp0IP4dNSkRBGV/rQzbKv9zn5I1oLyc8p+bP+C/5GcpcB/R62pqn5wRWMkDqmz0DjaOtkt1JMJMXbcNUVs8RZw5Gpz+4ZyxAQPucNkx5RiThw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117107; c=relaxed/simple;
	bh=QsddlOW9AA4/ahU3k380WV5ZY+WArOdhzF+wNy1h+7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwhOQcZc9uDZSuUQfSQBy13A4Usx03gOnWO8KCBrwr14Pa5qI4gsrBFx4hSBEj95DIyIXIFx8sVYZ1l26G40nab7kdhrm21XDm4ofJMX32JDibPXXwW25cU1l0QH1SAm2clnI3uwSDnvhmVZNt+8Qydvj7TO1omEkglFbKp8SyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYMO+Obj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYMO+Obj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5332E1F000E9;
	Fri,  7 Aug 2026 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117105;
	bh=m+LIZCnmDId24EUeAMg9QeClct4lvqzn2XU0gOIC48Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYMO+ObjrynIgICfKYP2nu3lyLbMqoMkVvnJTuGXQK68TolkxNDBnh391DLN2q9oz
	 MZ6hZIhDp+E9Bu1d4/KIsdFdurQmXynrEKHwjluRVOb81rNZXu2e0/By6zgv6w9DxG
	 YQTD86b+/5T+N2WNYCQsLwVXoAllIvq5Bg6NlL5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 201/438] iommu/iommufd: Fix IOPF group ownership UAF
Date: Fri,  7 Aug 2026 16:36:37 +0200
Message-ID: <20260807143432.306584560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 738e6f32e61d80b554e37015ecb7bc620b88001c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgfault.c     |   24 +++++++++++++++++++-----
 drivers/iommu/iommufd/eventq.c |    2 ++
 include/linux/iommu.h          |    5 +++++
 3 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -332,17 +332,31 @@ void iopf_group_response(struct iopf_gro
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
 
 /**
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
+/**
  * iopf_queue_discard_partial - Remove all pending partial fault
  * @queue: the queue whose partial faults need to be discarded
  *
--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -484,6 +484,8 @@ int iommufd_fault_iopf_handler(struct io
 	hwpt = group->attach_handle->domain->iommufd_hwpt;
 	fault = hwpt->fault;
 
+	iopf_group_dequeue(group);
+
 	spin_lock(&fault->common.lock);
 	list_add_tail(&group->node, &fault->common.deliver);
 	spin_unlock(&fault->common.lock);
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1676,6 +1676,7 @@ void iopf_free_group(struct iopf_group *
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 void iopf_group_response(struct iopf_group *group,
 			 enum iommu_page_response_code status);
+void iopf_group_dequeue(struct iopf_group *group);
 #else
 static inline int
 iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
@@ -1721,5 +1722,9 @@ static inline void iopf_group_response(s
 				       enum iommu_page_response_code status)
 {
 }
+
+static inline void iopf_group_dequeue(struct iopf_group *group)
+{
+}
 #endif /* CONFIG_IOMMU_IOPF */
 #endif /* __LINUX_IOMMU_H */


