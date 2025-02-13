Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBDD26B0A5;
	Thu, 13 Feb 2025 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459848; cv=none; b=k069fPFBxkzoH4E/ToTsHSc8vpW4WItZhW/b6vKXCA+VBq4jRJlBuyYNUoeCvlJ/lC3AA2oHF3E3fABjQW74Q0fV4FHlpYyUtxK45bLTAHFHiOS+B72jqha3q/QyQI1rW5bhGOrgN3IdQbH/0w6SpazNolvOMUlqQS9nsaMC1ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459848; c=relaxed/simple;
	bh=Yq14Rgd66o7NvqhP0z3cUr2QRwpS1+sezXzvKQCeJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV0fSmIxZ/7kSKds/bAM85pzM6lhOjxGhFz+ZfEItDzzD22v8angZT7fGE9oOKRHXuM9DyVR/yE4I7mMYzletNVoHvUMfZil01vJVe7+t7rcicN6IzGFl3xao9Ws1UbnnAZapnV1WiKexTSOWemgwRke5+7TB9gmOi+v+LCZ/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QamMJPbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QamMJPbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5556DC4CEE4;
	Thu, 13 Feb 2025 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459848;
	bh=Yq14Rgd66o7NvqhP0z3cUr2QRwpS1+sezXzvKQCeJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QamMJPbZjSpKb+lBUEM+AngMRWQ2nlMLFf35AOk0H1+mROuoJ964/u34QwOmaOs8H
	 cbuCUl6XRkxNXb7ByildCQ0VxXZQR+manQOQabUw9kyPoRfcB84Fu0DL8mGrx/yHfC
	 Mky+bb1X4iYAkFylBmmh7C5pyf4Mk2aF7dlWsN/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.13 350/443] iommufd/fault: Use a separate spinlock to protect fault->deliver list
Date: Thu, 13 Feb 2025 15:28:35 +0100
Message-ID: <20250213142454.125857959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 3d49020a327cd7d069059317c11df24e407ccfa3 upstream.

The fault->mutex serializes the fault read()/write() fops and the
iommufd_fault_auto_response_faults(), mainly for fault->response. Also, it
was conveniently used to fence the fault->deliver in poll() fop and
iommufd_fault_iopf_handler().

However, copy_from/to_user() may sleep if pagefaults are enabled. Thus,
they could take a long time to wait for user pages to swap in, blocking
iommufd_fault_iopf_handler() and its caller that is typically a shared IRQ
handler of an IOMMU driver, resulting in a potential global DOS.

Instead of reusing the mutex to protect the fault->deliver list, add a
separate spinlock, nested under the mutex, to do the job.
iommufd_fault_iopf_handler() would no longer be blocked by
copy_from/to_user().

Add a free_list in iommufd_auto_response_faults(), so the spinlock can
simply fence a fast list_for_each_entry_safe routine.

Provide two deliver list helpers for iommufd_fault_fops_read() to use:
 - Fetch the first iopf_group out of the fault->deliver list
 - Restore an iopf_group back to the head of the fault->deliver list

Lastly, move the mutex closer to the response in the fault structure,
and update its kdoc accordingly.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/20250117192901.79491-1-nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c           |   34 ++++++++++++++++++++------------
 drivers/iommu/iommufd/iommufd_private.h |   29 +++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 14 deletions(-)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -103,15 +103,23 @@ static void iommufd_auto_response_faults
 {
 	struct iommufd_fault *fault = hwpt->fault;
 	struct iopf_group *group, *next;
+	struct list_head free_list;
 	unsigned long index;
 
 	if (!fault)
 		return;
+	INIT_LIST_HEAD(&free_list);
 
 	mutex_lock(&fault->mutex);
+	spin_lock(&fault->lock);
 	list_for_each_entry_safe(group, next, &fault->deliver, node) {
 		if (group->attach_handle != &handle->handle)
 			continue;
+		list_move(&group->node, &free_list);
+	}
+	spin_unlock(&fault->lock);
+
+	list_for_each_entry_safe(group, next, &free_list, node) {
 		list_del(&group->node);
 		iopf_group_response(group, IOMMU_PAGE_RESP_INVALID);
 		iopf_free_group(group);
@@ -266,17 +274,19 @@ static ssize_t iommufd_fault_fops_read(s
 		return -ESPIPE;
 
 	mutex_lock(&fault->mutex);
-	while (!list_empty(&fault->deliver) && count > done) {
-		group = list_first_entry(&fault->deliver,
-					 struct iopf_group, node);
-
-		if (group->fault_count * fault_size > count - done)
+	while ((group = iommufd_fault_deliver_fetch(fault))) {
+		if (done >= count ||
+		    group->fault_count * fault_size > count - done) {
+			iommufd_fault_deliver_restore(fault, group);
 			break;
+		}
 
 		rc = xa_alloc(&fault->response, &group->cookie, group,
 			      xa_limit_32b, GFP_KERNEL);
-		if (rc)
+		if (rc) {
+			iommufd_fault_deliver_restore(fault, group);
 			break;
+		}
 
 		idev = to_iommufd_handle(group->attach_handle)->idev;
 		list_for_each_entry(iopf, &group->faults, list) {
@@ -285,13 +295,12 @@ static ssize_t iommufd_fault_fops_read(s
 						      group->cookie);
 			if (copy_to_user(buf + done, &data, fault_size)) {
 				xa_erase(&fault->response, group->cookie);
+				iommufd_fault_deliver_restore(fault, group);
 				rc = -EFAULT;
 				break;
 			}
 			done += fault_size;
 		}
-
-		list_del(&group->node);
 	}
 	mutex_unlock(&fault->mutex);
 
@@ -349,10 +358,10 @@ static __poll_t iommufd_fault_fops_poll(
 	__poll_t pollflags = EPOLLOUT;
 
 	poll_wait(filep, &fault->wait_queue, wait);
-	mutex_lock(&fault->mutex);
+	spin_lock(&fault->lock);
 	if (!list_empty(&fault->deliver))
 		pollflags |= EPOLLIN | EPOLLRDNORM;
-	mutex_unlock(&fault->mutex);
+	spin_unlock(&fault->lock);
 
 	return pollflags;
 }
@@ -394,6 +403,7 @@ int iommufd_fault_alloc(struct iommufd_u
 	INIT_LIST_HEAD(&fault->deliver);
 	xa_init_flags(&fault->response, XA_FLAGS_ALLOC1);
 	mutex_init(&fault->mutex);
+	spin_lock_init(&fault->lock);
 	init_waitqueue_head(&fault->wait_queue);
 
 	filep = anon_inode_getfile("[iommufd-pgfault]", &iommufd_fault_fops,
@@ -442,9 +452,9 @@ int iommufd_fault_iopf_handler(struct io
 	hwpt = group->attach_handle->domain->fault_data;
 	fault = hwpt->fault;
 
-	mutex_lock(&fault->mutex);
+	spin_lock(&fault->lock);
 	list_add_tail(&group->node, &fault->deliver);
-	mutex_unlock(&fault->mutex);
+	spin_unlock(&fault->lock);
 
 	wake_up_interruptible(&fault->wait_queue);
 
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -443,14 +443,39 @@ struct iommufd_fault {
 	struct iommufd_ctx *ictx;
 	struct file *filep;
 
-	/* The lists of outstanding faults protected by below mutex. */
-	struct mutex mutex;
+	spinlock_t lock; /* protects the deliver list */
 	struct list_head deliver;
+	struct mutex mutex; /* serializes response flows */
 	struct xarray response;
 
 	struct wait_queue_head wait_queue;
 };
 
+/* Fetch the first node out of the fault->deliver list */
+static inline struct iopf_group *
+iommufd_fault_deliver_fetch(struct iommufd_fault *fault)
+{
+	struct list_head *list = &fault->deliver;
+	struct iopf_group *group = NULL;
+
+	spin_lock(&fault->lock);
+	if (!list_empty(list)) {
+		group = list_first_entry(list, struct iopf_group, node);
+		list_del(&group->node);
+	}
+	spin_unlock(&fault->lock);
+	return group;
+}
+
+/* Restore a node back to the head of the fault->deliver list */
+static inline void iommufd_fault_deliver_restore(struct iommufd_fault *fault,
+						 struct iopf_group *group)
+{
+	spin_lock(&fault->lock);
+	list_add(&group->node, &fault->deliver);
+	spin_unlock(&fault->lock);
+}
+
 struct iommufd_attach_handle {
 	struct iommu_attach_handle handle;
 	struct iommufd_device *idev;


