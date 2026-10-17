Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237AD3A5E70;
	Sat, 17 Oct 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253607; cv=none; b=OhAlIv0HZgmVUKUEhpHI5DEDuhlvj9jWZ/fHRUao1SCP41K23Oiu2GocCJ6T1cRf2UPhHlBsVemA/SpVkyRnoqK/AxymR7Mm95oNlBtWpUszqoLaCrvbn/Mi50vSkvV4tWU/RFeijmUUIFyGAY4zekx69oqxemXKQat2T2ZbvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253607; c=relaxed/simple;
	bh=RzGAm6TSNiOT2s+PnvZVexE8xunDCw58TpRSqJmFAEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSr+EgP0fwOZz/+Y6z55ojZbjQeaYIlOZ41zHzviBaFrBpXLrRH/d8O/NvKvA+t0QvDU9MmV7WW+PPjcUVZzypt8KrWFFvXyIAkJRpWxoLfUKu2y8qYO+d5vNnjA5vdfz7ILptu//xX2fFKEEA+9+R465lZ3FNNWMgzOWs1s9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nslKrXD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nslKrXD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA67B1F000C5;
	Sat, 17 Oct 2026 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253604;
	bh=dGMVoDmR/t6ly4QdFtUcji3lxrhbdkZpBQ6Ohdcf0Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nslKrXD7PjihJCi/tXq/aofCyfgb1V1E7E2s+Jnf51hCe04v8ojYggIXrwWJ+xqKU
	 uDVSX5GZGCXxBmC+lIXijVZxN4r+Bv7OcfWmiXVqNHtbbuGRxpIZ1sO7+fjqwgUv5K
	 wUi0HI9gY6GMAyCKfu0CE7nmVEUXZ3snTTj3nxLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/869] md: init bioset in mddev_init
Date: Sat, 17 Oct 2026 17:49:57 +0200
Message-ID: <20261017160041.040115768@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 381a3ce1c0ffed647c9b913e142b099c7e9d5afc ]

IO operations may be needed before md_run(), such as updating metadata
after writing sysfs. Without bioset, this triggers a NULL pointer
dereference as below:

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 Call Trace:
  md_update_sb+0x658/0xe00
  new_level_store+0xc5/0x120
  md_attr_store+0xc9/0x1e0
  sysfs_kf_write+0x6f/0xa0
  kernfs_fop_write_iter+0x141/0x2a0
  vfs_write+0x1fc/0x5a0
  ksys_write+0x79/0x180
  __x64_sys_write+0x1d/0x30
  x64_sys_call+0x2818/0x2880
  do_syscall_64+0xa9/0x580
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Reproducer
```
  mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
  echo inactive > /sys/block/md0/md/array_state
  echo 10 > /sys/block/md0/md/new_level
```

mddev_init() can only be called once per mddev, no need to test if bioset
has been initialized anymore.

Link: https://lore.kernel.org/linux-raid/20251103125757.1405796-3-linan666@huaweicloud.com
Fixes: d981ed841930 ("md: Add new_level sysfs interface")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 66 +++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b3ba51d7da60f..a6f71253511cf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -665,6 +665,7 @@ static void no_op(struct percpu_ref *r) {}
 
 int mddev_init(struct mddev *mddev)
 {
+	int err = 0;
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
@@ -672,10 +673,23 @@ int mddev_init(struct mddev *mddev)
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		percpu_ref_exit(&mddev->active_io);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto exit_acitve_io;
 	}
 
+	err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (err)
+		goto exit_writes_pending;
+
+	err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (err)
+		goto exit_bio_set;
+
+	err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
+			  offsetof(struct md_io_clone, bio_clone), 0);
+	if (err)
+		goto exit_sync_set;
+
 	/* We want to start with the refcount at zero */
 	percpu_ref_put(&mddev->writes_pending);
 
@@ -705,11 +719,24 @@ int mddev_init(struct mddev *mddev)
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 
 	return 0;
+
+exit_sync_set:
+	bioset_exit(&mddev->sync_set);
+exit_bio_set:
+	bioset_exit(&mddev->bio_set);
+exit_writes_pending:
+	percpu_ref_exit(&mddev->writes_pending);
+exit_acitve_io:
+	percpu_ref_exit(&mddev->active_io);
+	return err;
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_clone_set);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6152,25 +6179,6 @@ int md_run(struct mddev *mddev)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
-
-	if (!bioset_initialized(&mddev->bio_set)) {
-		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (err)
-			return err;
-	}
-	if (!bioset_initialized(&mddev->sync_set)) {
-		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (err)
-			goto exit_bio_set;
-	}
-
-	if (!bioset_initialized(&mddev->io_clone_set)) {
-		err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
-				  offsetof(struct md_io_clone, bio_clone), 0);
-		if (err)
-			goto exit_sync_set;
-	}
-
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
@@ -6181,8 +6189,7 @@ int md_run(struct mddev *mddev)
 		else
 			pr_warn("md: personality for level %s is not loaded!\n",
 				mddev->clevel);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 	spin_unlock(&pers_lock);
 	if (mddev->level != pers->level) {
@@ -6195,8 +6202,7 @@ int md_run(struct mddev *mddev)
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
 		module_put(pers->owner);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (pers->sync_request) {
@@ -6323,12 +6329,6 @@ int md_run(struct mddev *mddev)
 	mddev->private = NULL;
 	module_put(pers->owner);
 	mddev->bitmap_ops->destroy(mddev);
-abort:
-	bioset_exit(&mddev->io_clone_set);
-exit_sync_set:
-	bioset_exit(&mddev->sync_set);
-exit_bio_set:
-	bioset_exit(&mddev->bio_set);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6544,10 +6544,6 @@ static void __md_stop(struct mddev *mddev)
 		mddev->to_remove = &md_redundancy_group;
 	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	bioset_exit(&mddev->io_clone_set);
 }
 
 void md_stop(struct mddev *mddev)
-- 
2.53.0



