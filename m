Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FE7391E6D;
	Sat, 17 Oct 2026 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255215; cv=none; b=MtRyQuPuA1Fjp0TeNyvfPK5pt7VVKNXXJuPvi4MgJ07+MebS/x55PqfGOuNen5Hjwlgwjh7MR820ax4M0wg7bqFy+wFRl4bSEXkOTcAlp/QErJsqd3vvnhQAK2atxLlhEuDoQJXDDdbmN52iHjC0b5fNATAtzo7iG6C6OQN2+tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255215; c=relaxed/simple;
	bh=G4ViatX4H453VFdH9oRGh5rO5ioBDsNrn1t7OZuRrls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS8kNeVBQfpVWbFlQaZLrHvMKlCRZnT88qbwmr0fl0KAfX8OdKHDjyvuL7nUYWbfEk0/UNu9Q2QsmKAodfk567Xe95hZV4R7rR9I33wqB4jiFWoG7/8lUQ2Z3uSDyMS4jBap9iq1XP1vbZW7OBCHB7duoIQrTfEmhnOePaL5n24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0USoY5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0USoY5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DD91F000C4;
	Sat, 17 Oct 2026 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255212;
	bh=N6gP6XMUtIjAOeRTcqwH7M5ekYba7PX1O0zw5Labc3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0USoY5pTQNwp0VjzbvIyBiBL7L6DUiGy6qur6RnjiKdEWctvNHWZs/o7HT5+iPC2
	 lclVfY+97guwsDMmuhgFqXrZtXYl53PjhVvZLzxMVVy6gCWWxjMgkEyApFsgnF0BJx
	 2QvfpT0JSd2/uE6WUv7FB7n5FrNJ1FPqVxk8QFqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufan Chen <ericterminal@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 657/869] ocfs2/heartbeat: fix slot mapping rollback leaks on error paths
Date: Sat, 17 Oct 2026 17:58:18 +0200
Message-ID: <20261017160053.843641960@linuxfoundation.org>
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

From: Yufan Chen <ericterminal@gmail.com>

[ Upstream commit 5686459423d03d192134166f0ec45f98bb2d5d57 ]

o2hb_map_slot_data() allocates hr_tmp_block, hr_slots, hr_slot_data, and
pages in stages.  If a later allocation fails, the current code returns
without unwinding the earlier allocations.

o2hb_region_dev_store() also leaves slot mapping resources behind when
setup aborts, and it keeps hr_aborted_start/hr_node_deleted set across
retries.  That leaves stale state behind after a failed start.

Factor the slot cleanup into o2hb_unmap_slot_data(), use it from both
o2hb_map_slot_data() and o2hb_region_release(), and call it from the
dev_store() rollback after stopping a started heartbeat thread.  While
freeing pages, clear each hr_slot_data entry as it is released, and reset
the start state before each new setup attempt.

This closes the slot mapping leak on allocation/setup failure paths and
keeps failed setup attempts retryable.

Link: https://lkml.kernel.org/r/20260330153428.19586-1-yufan.chen@linux.dev
Signed-off-by: Yufan Chen <ericterminal@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 011291b70ba4 ("ocfs2: o2hb: quiesce negotiate handlers and timeout work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 83 ++++++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6170e202e56e3..806da7f2d37cc 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1531,33 +1531,45 @@ static struct o2hb_region *to_o2hb_region(struct config_item *item)
 	return item ? container_of(item, struct o2hb_region, hr_item) : NULL;
 }
 
-/* drop_item only drops its ref after killing the thread, nothing should
- * be using the region anymore.  this has to clean up any state that
- * attributes might have built up. */
-static void o2hb_region_release(struct config_item *item)
+static void o2hb_unmap_slot_data(struct o2hb_region *reg)
 {
 	int i;
 	struct page *page;
-	struct o2hb_region *reg = to_o2hb_region(item);
-
-	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
-
-	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
 			page = reg->hr_slot_data[i];
-			if (page)
+			if (page) {
 				__free_page(page);
+				reg->hr_slot_data[i] = NULL;
+			}
 		}
 		kfree(reg->hr_slot_data);
+		reg->hr_slot_data = NULL;
 	}
 
+	kfree(reg->hr_slots);
+	reg->hr_slots = NULL;
+
+	kfree(reg->hr_tmp_block);
+	reg->hr_tmp_block = NULL;
+}
+
+/* drop_item only drops its ref after killing the thread, nothing should
+ * be using the region anymore.  this has to clean up any state that
+ * attributes might have built up.
+ */
+static void o2hb_region_release(struct config_item *item)
+{
+	struct o2hb_region *reg = to_o2hb_region(item);
+
+	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
+
+	o2hb_unmap_slot_data(reg);
+
 	if (reg->hr_bdev_file)
 		fput(reg->hr_bdev_file);
 
-	kfree(reg->hr_slots);
-
 	debugfs_remove_recursive(reg->hr_debug_dir);
 	kfree(reg->hr_db_livenodes);
 	kfree(reg->hr_db_regnum);
@@ -1708,6 +1720,7 @@ static void o2hb_init_region_params(struct o2hb_region *reg)
 static int o2hb_map_slot_data(struct o2hb_region *reg)
 {
 	int i, j;
+	int ret = -ENOMEM;
 	unsigned int last_slot;
 	unsigned int spp = reg->hr_slots_per_page;
 	struct page *page;
@@ -1715,15 +1728,15 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_slot *slot;
 
 	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
-	if (reg->hr_tmp_block == NULL)
-		return -ENOMEM;
+	if (!reg->hr_tmp_block)
+		goto out;
 
 	reg->hr_slots = kcalloc(reg->hr_blocks,
 				sizeof(struct o2hb_disk_slot), GFP_KERNEL);
-	if (reg->hr_slots == NULL)
-		return -ENOMEM;
+	if (!reg->hr_slots)
+		goto out;
 
-	for(i = 0; i < reg->hr_blocks; i++) {
+	for (i = 0; i < reg->hr_blocks; i++) {
 		slot = &reg->hr_slots[i];
 		slot->ds_node_num = i;
 		INIT_LIST_HEAD(&slot->ds_live_item);
@@ -1738,12 +1751,12 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	reg->hr_slot_data = kcalloc(reg->hr_num_pages, sizeof(struct page *),
 				    GFP_KERNEL);
 	if (!reg->hr_slot_data)
-		return -ENOMEM;
+		goto out;
 
-	for(i = 0; i < reg->hr_num_pages; i++) {
+	for (i = 0; i < reg->hr_num_pages; i++) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
-			return -ENOMEM;
+			goto out;
 
 		reg->hr_slot_data[i] = page;
 
@@ -1763,6 +1776,10 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	}
 
 	return 0;
+
+out:
+	o2hb_unmap_slot_data(reg);
+	return ret;
 }
 
 /* Read in all the slots available and populate the tracking
@@ -1854,9 +1871,11 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		     "blocksize %u incorrect for device, expected %d",
 		     reg->hr_block_bytes, sectsize);
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
+	reg->hr_aborted_start = 0;
+	reg->hr_node_deleted = 0;
 	o2hb_init_region_params(reg);
 
 	/* Generation of zero is invalid */
@@ -1868,13 +1887,13 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ret = o2hb_map_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	ret = o2hb_populate_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
@@ -1905,7 +1924,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	spin_lock(&o2hb_live_lock);
@@ -1922,12 +1941,12 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 
 	if (reg->hr_aborted_start) {
 		ret = -EIO;
-		goto out3;
+		goto out;
 	}
 
 	if (reg->hr_node_deleted) {
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
@@ -1946,8 +1965,18 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%pg)\n",
 		       config_item_name(&reg->hr_item), reg_bdev(reg));
 
-out3:
+out:
 	if (ret < 0) {
+		spin_lock(&o2hb_live_lock);
+		hb_task = reg->hr_task;
+		reg->hr_task = NULL;
+		spin_unlock(&o2hb_live_lock);
+
+		if (hb_task)
+			kthread_stop(hb_task);
+
+		o2hb_unmap_slot_data(reg);
+
 		fput(reg->hr_bdev_file);
 		reg->hr_bdev_file = NULL;
 	}
-- 
2.53.0



