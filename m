Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF979F0;
	Mon,  8 Apr 2024 13:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583602; cv=none; b=C9tEM4HZDhb/lMbb/O7EYqJEXesZgGvf/yx1hYVX1hqgJ8hEaw3IMch054vs7m27DDryoVYoDh4PdtkdgIlYz9n810zw0PBT0F+KmnWo4QIkI4xsjdzKr+l7BXr2wcKRS8Ge8VGSi5Q9IMVdCvOyotCUWmRslW7wGYOommv3i6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583602; c=relaxed/simple;
	bh=UQDujH7IJfUKK3aiHmjTGtROBZsrnmlon+IiHGAtbLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFDuiGxMazPKUH+TPyuE3i5DQUJrXfQ0Yu0wtBqSGLXlIAQmSgvfTip+uFiwkTPH0g6rnUMoOzW5CupgHKjDArctunyHQvGwjVBRXYKrWKKQ2BQy9TajcEB5vZSxjwEQHimFyUqAT3CKBaK9zid/+SFt1BgkpBdDggjZzDHWthQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2naLb8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2naLb8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA59C433C7;
	Mon,  8 Apr 2024 13:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583602;
	bh=UQDujH7IJfUKK3aiHmjTGtROBZsrnmlon+IiHGAtbLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2naLb8+MqexSEk463uoBXHnOLmlvMGoGdPwgYtmZTnLkrWq9Iwx1sSJCBUkdRagF
	 rJ3rLHU6vFkLjbQ4x3tffj4bElbfgJkCn8CkjPU6hbkodpdbB/cqO3qBIC52Wo6bDS
	 hGGK9pFrL044LL0whscw9qVI5YOMt5yK8zttxAbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.6 214/252] driver core: Introduce device_link_wait_removal()
Date: Mon,  8 Apr 2024 14:58:33 +0200
Message-ID: <20240408125313.304077656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,6 +44,7 @@ static bool fw_devlink_is_permissive(voi
 static void __fw_devlink_link_to_consumers(struct device *dev);
 static bool fw_devlink_drv_reg_done;
 static bool fw_devlink_best_effort;
+static struct workqueue_struct *device_link_wq;
 
 /**
  * __fwnode_link_add - Create a link between two fwnode_handles.
@@ -531,12 +532,26 @@ static void devlink_dev_release(struct d
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
 	.dev_groups = devlink_groups,
@@ -4090,9 +4105,14 @@ int __init devices_init(void)
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
@@ -1250,6 +1250,7 @@ void device_link_del(struct device_link
 void device_link_remove(void *consumer, struct device *supplier);
 void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
+void device_link_wait_removal(void);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \


