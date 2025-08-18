Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2F2322A04;
	Mon, 18 Aug 2025 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523176; cv=none; b=fpPmCAWmD/xfpiIZo/0ArWpQx2WI04G73HXBNJt9gG4tiA4F3BfQDn4z9DaL9UvGFsjdNJ6lSzN615SHyy84vP+NuSbB7MtYv1QeOVINf0XLgfU2xVwu3t6R4BO20aPU8SVvKhHc0/xRn+Q2ei3lK751S8fwSmt+DhKvYFV+y7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523176; c=relaxed/simple;
	bh=KpdscQr6fIbrXQGoDTV6pgRWH9/BB4E2DvvhZu+djsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2sqEclSWp+K9stpd4cK2jzQsi6eeDeKrP+PU4rUNR34H355NHM5Vx9viIMlgqjZixE4gl2Nh3zwMg5VqjsieknbYVGLE3jwRR5Yu5Qco3hJdYv/9mYg4fLtm6EzRYynufPTxzDpYesJ581OV0HdPG+jYhkfQnOG3GmXsRRXvNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEyjDk7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEyjDk7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8786DC4CEEB;
	Mon, 18 Aug 2025 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523176;
	bh=KpdscQr6fIbrXQGoDTV6pgRWH9/BB4E2DvvhZu+djsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEyjDk7WrXKUkCV7SvoPB+BanG7IOIXV0x8LTK22KkitAXwbSL3nw6D64T6jjN5yj
	 RlDiCXF8fA33uf7uM/05ijFNpO5gviviB5sP5ONjTB4bcNkqSEQWP+om/vByRphU0f
	 Ds9fYGzxM/oI/syRr9j01BMPrKj6HGdvjZ5cYbdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 094/515] md: call del_gendisk in control path
Date: Mon, 18 Aug 2025 14:41:20 +0200
Message-ID: <20250818124502.004214961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47f3253c4757..aa053bb818bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -613,9 +613,6 @@ static void __mddev_put(struct mddev *mddev)
 	    mddev->ctime || mddev->hold_active)
 		return;
 
-	/* Array is not configured at all, and not held active, so destroy it */
-	set_bit(MD_DELETED, &mddev->flags);
-
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
@@ -850,6 +847,16 @@ void mddev_unlock(struct mddev *mddev)
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
 
@@ -5721,19 +5728,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
 
@@ -5741,12 +5759,6 @@ static void md_kobj_release(struct kobject *ko)
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
 
@@ -6593,8 +6605,9 @@ static int do_md_stop(struct mddev *mddev, int mode)
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
index 1cf00a04bcdd..b851fc0dc085 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -697,11 +697,26 @@ static inline bool reshape_interrupted(struct mddev *mddev)
 
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
@@ -710,7 +725,14 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
 
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



