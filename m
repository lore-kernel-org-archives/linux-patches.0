Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8282E405;
	Mon,  8 Apr 2024 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582576; cv=none; b=bLas0BB+n2LoK4SyIhlKXI/vuMiQQTOPqs20z7c9c4YuSzCkNupB0IdyEzx0rmZXQbX9KWCUb8Z1qVMmZ/WuTMI1juXbDoG52xmhTEX0o/+43RT3TS9+s90mvImFwWdIdc+Ssb3SN5IiFkW+kQgI47My0+7Pf/43iHW1Z4YB7fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582576; c=relaxed/simple;
	bh=dODMI4NtV5wyWD8R7uiQzWSq41hN/CaxNXu6WRAATX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4EzGqTuTUcN4g5JbPt2oxgBNDay9BwfwuVCozHPzuiUcM+VBI+3p/0BVmJbDxm++PsOTZYRwQRMt5/pcDak3WBW4FifOhCQspSul2hg0PLVWISzSlOR7NLUNqJKJigSUuC0EGBULrVAkRCBW8kUefK6BFo0XqVmNQPmvm910dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZmTot6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZmTot6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430D0C433F1;
	Mon,  8 Apr 2024 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582576;
	bh=dODMI4NtV5wyWD8R7uiQzWSq41hN/CaxNXu6WRAATX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZmTot6gwX8BCS7JGB+fnoXbrudRXEU5ZBDmG5uCatmmbG3p026d2mwOCf8J0O097
	 aQ7Fh3AcHmzqZ428GEH7epfQxsesHIZQlPs2aXak0jZCyv/EEwrc9GXtaJYR4jbrHV
	 45wDw1O/hl2sFiN+el7/AsnA0m/TMGeQ2yG+w410=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 117/138] driver core: Introduce device_link_wait_removal()
Date: Mon,  8 Apr 2024 14:58:51 +0200
Message-ID: <20240408125259.872703984@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 0462c56c290a99a7f03e817ae5b843116dfb575c upstream.

The commit 80dd33cf72d1 ("drivers: base: Fix device link removal")
introduces a workqueue to release the consumer and supplier devices used
in the devlink.
In the job queued, devices are release and in turn, when all the
references to these devices are dropped, the release function of the
device itself is called.

Nothing is present to provide some synchronisation with this workqueue
in order to ensure that all ongoing releasing operations are done and
so, some other operations can be started safely.

For instance, in the following sequence:
  1) of_platform_depopulate()
  2) of_overlay_remove()

During the step 1, devices are released and related devlinks are removed
(jobs pushed in the workqueue).
During the step 2, OF nodes are destroyed but, without any
synchronisation with devlink removal jobs, of_overlay_remove() can raise
warnings related to missing of_node_put():
  ERROR: memory leak, expected refcount 1 instead of 2

Indeed, the missing of_node_put() call is going to be done, too late,
from the workqueue job execution.

Introduce device_link_wait_removal() to offer a way to synchronize
operations waiting for the end of devlink removals (i.e. end of
workqueue jobs).
Also, as a flushing operation is done on the workqueue, the workqueue
used is moved from a system-wide workqueue to a local one.

Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20240325152140.198219-2-herve.codina@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c    |   26 +++++++++++++++++++++++---
 include/linux/device.h |    1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -56,6 +56,7 @@ static bool fw_devlink_is_permissive(voi
 static void __fw_devlink_link_to_consumers(struct device *dev);
 static bool fw_devlink_drv_reg_done;
 static bool fw_devlink_best_effort;
+static struct workqueue_struct *device_link_wq;
 
 /**
  * __fwnode_link_add - Create a link between two fwnode_handles.
@@ -585,12 +586,26 @@ static void devlink_dev_release(struct d
 	/*
 	 * It may take a while to complete this work because of the SRCU
 	 * synchronization in device_link_release_fn() and if the consumer or
-	 * supplier devices get deleted when it runs, so put it into the "long"
-	 * workqueue.
+	 * supplier devices get deleted when it runs, so put it into the
+	 * dedicated workqueue.
 	 */
-	queue_work(system_long_wq, &link->rm_work);
+	queue_work(device_link_wq, &link->rm_work);
 }
 
+/**
+ * device_link_wait_removal - Wait for ongoing devlink removal jobs to terminate
+ */
+void device_link_wait_removal(void)
+{
+	/*
+	 * devlink removal jobs are queued in the dedicated work queue.
+	 * To be sure that all removal jobs are terminated, ensure that any
+	 * scheduled work has run to completion.
+	 */
+	flush_workqueue(device_link_wq);
+}
+EXPORT_SYMBOL_GPL(device_link_wait_removal);
+
 static struct class devlink_class = {
 	.name = "devlink",
 	.owner = THIS_MODULE,
@@ -4132,9 +4147,14 @@ int __init devices_init(void)
 	sysfs_dev_char_kobj = kobject_create_and_add("char", dev_kobj);
 	if (!sysfs_dev_char_kobj)
 		goto char_kobj_err;
+	device_link_wq = alloc_workqueue("device_link_wq", 0, 0);
+	if (!device_link_wq)
+		goto wq_err;
 
 	return 0;
 
+ wq_err:
+	kobject_put(sysfs_dev_char_kobj);
  char_kobj_err:
 	kobject_put(sysfs_dev_block_kobj);
  block_kobj_err:
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1099,6 +1099,7 @@ void device_link_del(struct device_link
 void device_link_remove(void *consumer, struct device *supplier);
 void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
+void device_link_wait_removal(void);
 
 extern __printf(3, 4)
 int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);


