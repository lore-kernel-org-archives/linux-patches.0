Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD818657
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EB1C433C8;
	Wed, 20 Sep 2023 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210716;
	bh=azFpPDNZYFFbhaWd/vs5kJPbY3W3AyQC9wFIt1XsDgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCN155mp6Mlkiz0s4oAcb8HH/5cJ53pQuGgOTD0Fj/azv0T5lvQjn0KxvFI3nRH0U
	 8mWpvqjJxpOJvMRmXEElW2ObIgLwzcKw85EX15wSlaV21mGnRY8I0eB6HYWM+PRnst
	 ZQ+lpiASCVn54KFf5IKLEcstgMse1VDyXUSlMo4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.5 178/211] dm: fix a race condition in retrieve_deps
Date: Wed, 20 Sep 2023 13:30:22 +0200
Message-ID: <20230920112851.396519013@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f6007dce0cd35d634d9be91ef3515a6385dcee16 upstream.

There's a race condition in the multipath target when retrieve_deps
races with multipath_message calling dm_get_device and dm_put_device.
retrieve_deps walks the list of open devices without holding any lock
but multipath may add or remove devices to the list while it is
running. The end result may be memory corruption or use-after-free
memory access.

See this description of a UAF with multipath_message():
https://listman.redhat.com/archives/dm-devel/2022-October/052373.html

Fix this bug by introducing a new rw semaphore "devices_lock". We grab
devices_lock for read in retrieve_deps and we grab it for write in
dm_get_device and dm_put_device.

Reported-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Tested-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h  |    1 +
 drivers/md/dm-ioctl.c |    7 ++++++-
 drivers/md/dm-table.c |   32 ++++++++++++++++++++++++--------
 3 files changed, 31 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -214,6 +214,7 @@ struct dm_table {
 
 	/* a list of devices used by this table */
 	struct list_head devices;
+	struct rw_semaphore devices_lock;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *data);
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1630,6 +1630,8 @@ static void retrieve_deps(struct dm_tabl
 	struct dm_dev_internal *dd;
 	struct dm_target_deps *deps;
 
+	down_read(&table->devices_lock);
+
 	deps = get_result_buffer(param, param_size, &len);
 
 	/*
@@ -1644,7 +1646,7 @@ static void retrieve_deps(struct dm_tabl
 	needed = struct_size(deps, dev, count);
 	if (len < needed) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
-		return;
+		goto out;
 	}
 
 	/*
@@ -1656,6 +1658,9 @@ static void retrieve_deps(struct dm_tabl
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
+
+out:
+	up_read(&table->devices_lock);
 }
 
 static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_size)
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -135,6 +135,7 @@ int dm_table_create(struct dm_table **re
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
+	init_rwsem(&t->devices_lock);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -359,16 +360,20 @@ int __ref dm_get_device(struct dm_target
 	if (dev == disk_devt(t->md->disk))
 		return -EINVAL;
 
+	down_write(&t->devices_lock);
+
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
 		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-		if (!dd)
-			return -ENOMEM;
+		if (!dd) {
+			r = -ENOMEM;
+			goto unlock_ret_r;
+		}
 
 		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
 		if (r) {
 			kfree(dd);
-			return r;
+			goto unlock_ret_r;
 		}
 
 		refcount_set(&dd->count, 1);
@@ -378,12 +383,17 @@ int __ref dm_get_device(struct dm_target
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
-			return r;
+			goto unlock_ret_r;
 	}
 	refcount_inc(&dd->count);
 out:
+	up_write(&t->devices_lock);
 	*result = dd->dm_dev;
 	return 0;
+
+unlock_ret_r:
+	up_write(&t->devices_lock);
+	return r;
 }
 EXPORT_SYMBOL(dm_get_device);
 
@@ -419,9 +429,12 @@ static int dm_set_device_limits(struct d
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
 	int found = 0;
-	struct list_head *devices = &ti->table->devices;
+	struct dm_table *t = ti->table;
+	struct list_head *devices = &t->devices;
 	struct dm_dev_internal *dd;
 
+	down_write(&t->devices_lock);
+
 	list_for_each_entry(dd, devices, list) {
 		if (dd->dm_dev == d) {
 			found = 1;
@@ -430,14 +443,17 @@ void dm_put_device(struct dm_target *ti,
 	}
 	if (!found) {
 		DMERR("%s: device %s not in table devices list",
-		      dm_device_name(ti->table->md), d->name);
-		return;
+		      dm_device_name(t->md), d->name);
+		goto unlock_ret;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+		dm_put_table_device(t->md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
+
+unlock_ret:
+	up_write(&t->devices_lock);
 }
 EXPORT_SYMBOL(dm_put_device);
 


