Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D9A2EF652;
	Thu, 28 May 2026 20:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000741; cv=none; b=jHCOnEr7wjcTk6zMrN3NUgaK7FYY5ZKImui3mSyotaFmeZ1TrVwlde7/DULVd+aG0B2g4M1FMevShpS15jXvGN3SZsk9kt98qYuYUE8tvHQeYzuwrwFNKTZeyRYKcKCFhYzDxyR0nTFCcTZwM9WOpWOlZUjHP5hsW3ZUFNby098=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000741; c=relaxed/simple;
	bh=JsWtXSFIWbw7C4LQIR5j9KLQG9GFOoU9s2ZWsDyVYpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM9t4z58GexiUbOwO3FAZIJOVeypqjfPU7YTOPdKb6lBDyId7b7l3qsP+HdcX/E5e0T46acU3tor921BMU6miZOTWjzbLGYmcpMIoAH6yS+dAdtA21C52qJQkgOePp8iLLT/L01Jh53D+cgwEitAa6BcHRmBkNGx69XexGSVMsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8q5WjUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8q5WjUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0FD1F000E9;
	Thu, 28 May 2026 20:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000739;
	bh=F/Ou1gz9O8hBoYY65DSTCSgvwHoP47Nkh3jS2HLOSFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8q5WjUv7D3YBR/zGTJpSmf0wQpudDGEe0DSYpaPJ90K9nGYc5UGqdSo0uG2xLcJr
	 Ahsr7XmuWTU3G/Wl/fCI+qgeqOyilvD17NE6kjS3zXKrLjjzpecJipJsxy6PqZmN/r
	 6r1Ax5mQrc+WwSCeX1xjLion9tb345XWzcelee24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/272] firmware: arm_ffa: Allow multiple UUIDs per partition to register SRI callback
Date: Thu, 28 May 2026 21:48:46 +0200
Message-ID: <20260528194633.620789979@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit be61da938576671c664382a059f961d7b4b2fc41 ]

A partition can implement multiple UUIDs and currently we successfully
register each UUID service as a FF-A device. However when adding the
same partition info to the XArray which tracks the SRI callbacks more
than once, it fails.

In order to allow multiple UUIDs per partition to register SRI callbacks
the partition information stored in the XArray needs to be extended to
a listed list.

A function to remove the list of partition information in the XArray
is not added as there are no users at the time. All the partitions are
added at probe/initialisation and removed at cleanup stage.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-18-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 6d3daa9b8d31 ("firmware: arm_ffa: Unregister bus notifier on teardown for FF-A v1.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 159 ++++++++++++++++++++++--------
 1 file changed, 117 insertions(+), 42 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index eaaebb841b782..6961cb44194a1 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -871,27 +871,32 @@ struct ffa_dev_part_info {
 	ffa_sched_recv_cb callback;
 	void *cb_data;
 	rwlock_t rw_lock;
+	struct ffa_device *dev;
+	struct list_head node;
 };
 
 static void __do_sched_recv_cb(u16 part_id, u16 vcpu, bool is_per_vcpu)
 {
-	struct ffa_dev_part_info *partition;
+	struct ffa_dev_part_info *partition = NULL, *tmp;
 	ffa_sched_recv_cb callback;
+	struct list_head *phead;
 	void *cb_data;
 
-	partition = xa_load(&drv_info->partition_info, part_id);
-	if (!partition) {
+	phead = xa_load(&drv_info->partition_info, part_id);
+	if (!phead) {
 		pr_err("%s: Invalid partition ID 0x%x\n", __func__, part_id);
 		return;
 	}
 
-	read_lock(&partition->rw_lock);
-	callback = partition->callback;
-	cb_data = partition->cb_data;
-	read_unlock(&partition->rw_lock);
+	list_for_each_entry_safe(partition, tmp, phead, node) {
+		read_lock(&partition->rw_lock);
+		callback = partition->callback;
+		cb_data = partition->cb_data;
+		read_unlock(&partition->rw_lock);
 
-	if (callback)
-		callback(vcpu, is_per_vcpu, cb_data);
+		if (callback)
+			callback(vcpu, is_per_vcpu, cb_data);
+	}
 }
 
 /*
@@ -1101,18 +1106,29 @@ struct notifier_cb_info {
 	enum notify_type type;
 };
 
-static int ffa_sched_recv_cb_update(u16 part_id, ffa_sched_recv_cb callback,
-				    void *cb_data, bool is_registration)
+static int
+ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
+			 void *cb_data, bool is_registration)
 {
-	struct ffa_dev_part_info *partition;
+	struct ffa_dev_part_info *partition = NULL, *tmp;
+	struct list_head *phead;
 	bool cb_valid;
 
 	if (ffa_notifications_disabled())
 		return -EOPNOTSUPP;
 
-	partition = xa_load(&drv_info->partition_info, part_id);
+	phead = xa_load(&drv_info->partition_info, dev->vm_id);
+	if (!phead) {
+		pr_err("%s: Invalid partition ID 0x%x\n", __func__, dev->vm_id);
+		return -EINVAL;
+	}
+
+	list_for_each_entry_safe(partition, tmp, phead, node)
+		if (partition->dev == dev)
+			break;
+
 	if (!partition) {
-		pr_err("%s: Invalid partition ID 0x%x\n", __func__, part_id);
+		pr_err("%s: No such partition ID 0x%x\n", __func__, dev->vm_id);
 		return -EINVAL;
 	}
 
@@ -1134,12 +1150,12 @@ static int ffa_sched_recv_cb_update(u16 part_id, ffa_sched_recv_cb callback,
 static int ffa_sched_recv_cb_register(struct ffa_device *dev,
 				      ffa_sched_recv_cb cb, void *cb_data)
 {
-	return ffa_sched_recv_cb_update(dev->vm_id, cb, cb_data, true);
+	return ffa_sched_recv_cb_update(dev, cb, cb_data, true);
 }
 
 static int ffa_sched_recv_cb_unregister(struct ffa_device *dev)
 {
-	return ffa_sched_recv_cb_update(dev->vm_id, NULL, NULL, false);
+	return ffa_sched_recv_cb_update(dev, NULL, NULL, false);
 }
 
 static int ffa_notification_bind(u16 dst_id, u64 bitmap, u32 flags)
@@ -1420,37 +1436,101 @@ static struct notifier_block ffa_bus_nb = {
 	.notifier_call = ffa_bus_notifier,
 };
 
-static int ffa_xa_add_partition_info(int vm_id)
+static int ffa_xa_add_partition_info(struct ffa_device *dev)
 {
 	struct ffa_dev_part_info *info;
-	int ret;
+	struct list_head *head, *phead;
+	int ret = -ENOMEM;
+
+	phead = xa_load(&drv_info->partition_info, dev->vm_id);
+	if (phead) {
+		head = phead;
+		list_for_each_entry(info, head, node) {
+			if (info->dev == dev) {
+				pr_err("%s: duplicate dev %p part ID 0x%x\n",
+				       __func__, dev, dev->vm_id);
+				return -EEXIST;
+			}
+		}
+	}
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-		return -ENOMEM;
+		return ret;
 
 	rwlock_init(&info->rw_lock);
-	ret = xa_insert(&drv_info->partition_info, vm_id, info, GFP_KERNEL);
-	if (ret) {
-		pr_err("%s: failed to save partition ID 0x%x - ret:%d. Abort.\n",
-		       __func__, vm_id, ret);
-		kfree(info);
+	info->dev = dev;
+
+	if (!phead) {
+		phead = kzalloc(sizeof(*phead), GFP_KERNEL);
+		if (!phead)
+			goto free_out;
+
+		INIT_LIST_HEAD(phead);
+
+		ret = xa_insert(&drv_info->partition_info, dev->vm_id, phead,
+				GFP_KERNEL);
+		if (ret) {
+			pr_err("%s: failed to save part ID 0x%x Ret:%d\n",
+			       __func__, dev->vm_id, ret);
+			goto free_out;
+		}
 	}
+	list_add(&info->node, phead);
+	return 0;
+
+free_out:
+	kfree(phead);
+	kfree(info);
+	return ret;
+}
+
+static int ffa_setup_host_partition(int vm_id)
+{
+	struct ffa_partition_info buf = { 0 };
+	struct ffa_device *ffa_dev;
+	int ret;
+
+	buf.id = vm_id;
+	ffa_dev = ffa_device_register(&buf, &ffa_drv_ops);
+	if (!ffa_dev) {
+		pr_err("%s: failed to register host partition ID 0x%x\n",
+		       __func__, vm_id);
+		return -EINVAL;
+	}
+
+	ret = ffa_xa_add_partition_info(ffa_dev);
+	if (ret)
+		return ret;
+
+	if (ffa_notifications_disabled())
+		return 0;
+
+	ret = ffa_sched_recv_cb_update(ffa_dev, ffa_self_notif_handle,
+				       drv_info, true);
+	if (ret)
+		pr_info("Failed to register driver sched callback %d\n", ret);
 
 	return ret;
 }
 
 static void ffa_partitions_cleanup(void)
 {
-	struct ffa_dev_part_info *info;
+	struct list_head *phead;
 	unsigned long idx;
 
 	/* Clean up/free all registered devices */
 	ffa_devices_unregister();
 
-	xa_for_each(&drv_info->partition_info, idx, info) {
+	xa_for_each(&drv_info->partition_info, idx, phead) {
+		struct ffa_dev_part_info *info, *tmp;
+
 		xa_erase(&drv_info->partition_info, idx);
-		kfree(info);
+		list_for_each_entry_safe(info, tmp, phead, node) {
+			list_del(&info->node);
+			kfree(info);
+		}
+		kfree(phead);
 	}
 
 	xa_destroy(&drv_info->partition_info);
@@ -1493,7 +1573,7 @@ static int ffa_setup_partitions(void)
 		    !(tpbuf->properties & FFA_PARTITION_AARCH64_EXEC))
 			ffa_mode_32bit_set(ffa_dev);
 
-		if (ffa_xa_add_partition_info(ffa_dev->vm_id)) {
+		if (ffa_xa_add_partition_info(ffa_dev)) {
 			ffa_device_unregister(ffa_dev);
 			continue;
 		}
@@ -1501,12 +1581,16 @@ static int ffa_setup_partitions(void)
 
 	kfree(pbuf);
 
-	/* Check if the host is already added as part of partition info */
+	/*
+	 * Check if the host is already added as part of partition info
+	 * No multiple UUID possible for the host, so just checking if
+	 * there is an entry will suffice
+	 */
 	if (xa_load(&drv_info->partition_info, drv_info->vm_id))
 		return 0;
 
 	/* Allocate for the host */
-	ret = ffa_xa_add_partition_info(drv_info->vm_id);
+	ret = ffa_setup_host_partition(drv_info->vm_id);
 	if (ret)
 		ffa_partitions_cleanup();
 
@@ -1815,19 +1899,10 @@ static int __init ffa_init(void)
 	ffa_notifications_setup();
 
 	ret = ffa_setup_partitions();
-	if (ret) {
-		pr_err("failed to setup partitions\n");
-		goto cleanup_notifs;
-	}
-
-	ret = ffa_sched_recv_cb_update(drv_info->vm_id, ffa_self_notif_handle,
-				       drv_info, true);
-	if (ret)
-		pr_info("Failed to register driver sched callback %d\n", ret);
-
-	return 0;
+	if (!ret)
+		return ret;
 
-cleanup_notifs:
+	pr_err("failed to setup partitions\n");
 	ffa_notifications_cleanup();
 	ffa_rxtx_unmap();
 free_pages:
-- 
2.53.0



