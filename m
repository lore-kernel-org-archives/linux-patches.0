Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D2B27B355;
	Mon, 18 Aug 2025 12:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521730; cv=none; b=IqLMc7IzzUZW3evHEk602Pw6zY36pIk5jpJRUICo7jythrhw2JeY1TfGPffu2ESM0qUyeB92KN1HqozcQQ2f4K2QGvN+cVLiSzTvjnmLFoI+VV5gZU2r0X/dzcXgDYb+oItRHTpD9u52JVSQjwSJ8S+h0hPaGHrEMkr/KAVPa2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521730; c=relaxed/simple;
	bh=F5TwsKvMcU4mGxW0PB+kOBBrdZXEYcv/gPW0U4xLsoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl37YP4IA0dcAukyo0qIrEsQXHdom48wdjSiEpUAcoBmO47HHloqbSDhNo8XWiEUx9FgIujEm1Wo2F3XDmM7lOQhDwColSRnqEzUec9elhjIR4Bppagg2kd/orbEbN+VKtcCPVUOs5MmdT8IPzzFl42tdxeYa4pIs+PfB9gjpZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7VxE/nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7VxE/nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CD4C4CEEB;
	Mon, 18 Aug 2025 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521730;
	bh=F5TwsKvMcU4mGxW0PB+kOBBrdZXEYcv/gPW0U4xLsoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7VxE/nH7LosSZQ2mhOW6Sm5cB0+soxKcy3eCMyJ+LgYkYkD/IBHt459+hvkoZBQO
	 0Glyzn51tO6d/se/VaciSSlOQC9TgDVyajX4xmzN9BHIHrs1a4HGjyD4/3CItU4KnA
	 QZNZcTBQDxbXSWNVZr2zprwKDxhnOntd+PsBy4zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/444] md: call del_gendisk in control path
Date: Mon, 18 Aug 2025 14:41:44 +0200
Message-ID: <20250818124451.874614965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 9e59d609763f70a992a8f3808dabcce60f14eb5c ]

Now del_gendisk and put_disk are called asynchronously in workqueue work.
The asynchronous way has a problem that the device node can still exist
after mdadm --stop command returns in a short window. So udev rule can
open this device node and create the struct mddev in kernel again. So put
del_gendisk in control path and still leave put_disk in md_kobj_release
to avoid uaf of gendisk.

Function del_gendisk can't be called with reconfig_mutex. If it's called
with reconfig mutex, a deadlock can happen. del_gendisk waits all sysfs
files access to finish and sysfs file access waits reconfig mutex. So
put del_gendisk after releasing reconfig mutex.

But there is still a window that sysfs can be accessed between mddev_unlock
and del_gendisk. So some actions (add disk, change level, .e.g) can happen
which lead unexpected results. MD_DELETED is used to resolve this problem.
MD_DELETED is set before releasing reconfig mutex and it should be checked
for these sysfs access which need reconfig mutex. For sysfs access which
don't need reconfig mutex, del_gendisk will wait them to finish.

But it doesn't need to do this in function mddev_lock_nointr. There are
ten places that call it.
* Five of them are in dm raid which we don't need to care. MD_DELETED is
only used for md raid.
* stop_sync_thread, md_do_sync and md_start_sync are related sync request,
and it needs to wait sync thread to finish before stopping an array.
* md_ioctl: md_open is called before md_ioctl, so ->openers is added. It
will fail to stop the array. So it doesn't need to check MD_DELETED here
* md_set_readonly:
It needs to call mddev_set_closing_and_sync_blockdev when setting readonly
or read_auto. So it will fail to stop the array too because MD_CLOSING is
already set.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20250611073108.25463-2-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 33 +++++++++++++++++++++++----------
 drivers/md/md.h | 26 ++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4b3291723670..91cece996250 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -619,9 +619,6 @@ static void __mddev_put(struct mddev *mddev)
 	    mddev->ctime || mddev->hold_active)
 		return;
 
-	/* Array is not configured at all, and not held active, so destroy it */
-	set_bit(MD_DELETED, &mddev->flags);
-
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
@@ -856,6 +853,16 @@ void mddev_unlock(struct mddev *mddev)
 		kobject_del(&rdev->kobj);
 		export_rdev(rdev, mddev);
 	}
+
+	/* Call del_gendisk after release reconfig_mutex to avoid
+	 * deadlock (e.g. call del_gendisk under the lock and an
+	 * access to sysfs files waits the lock)
+	 * And MD_DELETED is only used for md raid which is set in
+	 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
+	 * doesn't need to check MD_DELETED when getting reconfig lock
+	 */
+	if (test_bit(MD_DELETED, &mddev->flags))
+		del_gendisk(mddev->gendisk);
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
 
@@ -5720,19 +5727,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
 	struct mddev *mddev = container_of(kobj, struct mddev, kobj);
 	ssize_t rv;
+	struct kernfs_node *kn = NULL;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
+
+	if (entry->store == array_state_store && cmd_match(page, "clear"))
+		kn = sysfs_break_active_protection(kobj, attr);
+
 	spin_lock(&all_mddevs_lock);
 	if (!mddev_get(mddev)) {
 		spin_unlock(&all_mddevs_lock);
+		if (kn)
+			sysfs_unbreak_active_protection(kn);
 		return -EBUSY;
 	}
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
+
+	if (kn)
+		sysfs_unbreak_active_protection(kn);
+
 	return rv;
 }
 
@@ -5740,12 +5758,6 @@ static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
-	if (mddev->sysfs_state)
-		sysfs_put(mddev->sysfs_state);
-	if (mddev->sysfs_level)
-		sysfs_put(mddev->sysfs_level);
-
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6601,8 +6613,9 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		mddev->bitmap_info.offset = 0;
 
 		export_array(mddev);
-
 		md_clean(mddev);
+		set_bit(MD_DELETED, &mddev->flags);
+
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8826dce9717d..cf06a9de6f19 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -669,11 +669,26 @@ static inline bool reshape_interrupted(struct mddev *mddev)
 
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
-	return mutex_lock_interruptible(&mddev->reconfig_mutex);
+	int ret;
+
+	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
+
+	/* MD_DELETED is set in do_md_stop with reconfig_mutex.
+	 * So check it here.
+	 */
+	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = -ENODEV;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
+
+	return ret;
 }
 
 /* Sometimes we need to take the lock in a situation where
  * failure due to interrupts is not acceptable.
+ * It doesn't need to check MD_DELETED here, the owner which
+ * holds the lock here can't be stopped. And all paths can't
+ * call this function after do_md_stop.
  */
 static inline void mddev_lock_nointr(struct mddev *mddev)
 {
@@ -682,7 +697,14 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
 
 static inline int mddev_trylock(struct mddev *mddev)
 {
-	return mutex_trylock(&mddev->reconfig_mutex);
+	int ret;
+
+	ret = mutex_trylock(&mddev->reconfig_mutex);
+	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = -ENODEV;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
+	return ret;
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-- 
2.39.5



