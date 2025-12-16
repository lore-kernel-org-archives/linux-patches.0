Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08752E9EB5;
	Tue, 16 Dec 2025 12:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887566; cv=none; b=M3YYTk72SCrK5n6C+/yKKIfSKoUh8uFXWfLQt80yi8Wh9AhB+Ruqij8IfBUvlor6qiaLArGNZg+EtVOsohKRsY9tFGzpU+10JfRuRGLh0HagC/mOt7Dnd4kQtXaPXgnUIacJTbMA0Q9b2XprJB9GE+XEeq0410xqTsDWSwCX5iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887566; c=relaxed/simple;
	bh=W2+D/RS+c/6hyeEDjXE8A5z5to2vgz+PYfeBjPofxtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC5bUMFVqTbcNsPo58VznI/IGFYwPMZSJf/Ha9zVNBcE3Lkf1NwqGvdn9dHfpA0UQYHhg45YAwFZDFAFg8Vs9fc8C/bxpjjwNRJ10vdrZ8rkr7uc2GXl6IY5/QnnDQ7HcoBoHRxXJWGuFQmyswwk6OQTS5Fi+dsPlwwhzyXmbks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qcd4yIIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qcd4yIIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19713C4CEF1;
	Tue, 16 Dec 2025 12:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887566;
	bh=W2+D/RS+c/6hyeEDjXE8A5z5to2vgz+PYfeBjPofxtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qcd4yIIuhcy1+t1qJKQb+qat19JX1MYxP1PZNSYIEbk211Y1uYsy/HjdSik5WDRSG
	 z4tDVdEXymXjbphuLR7p5SO79sFO+b3FWfcVfX2p+qG1wPb+rsMpN9HNgr5gbLXdKh
	 idzeVzbJi+3mk4vcT5ruMQ8MePqfQ1geEbY7FoTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/614] md: init bioset in mddev_init
Date: Tue, 16 Dec 2025 12:10:09 +0100
Message-ID: <20251216111410.135091746@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/md.c | 69 +++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b21eb1dbc533..cef5b2954ac5a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
+	int err = 0;
+
 	if (!IS_ENABLED(CONFIG_MD_BITMAP))
 		mddev->bitmap_id = ID_BITMAP_NONE;
 	else
@@ -741,10 +743,23 @@ int mddev_init(struct mddev *mddev)
 
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
 
@@ -773,11 +788,24 @@ int mddev_init(struct mddev *mddev)
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
@@ -6387,29 +6415,9 @@ int md_run(struct mddev *mddev)
 		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
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
 	pers = get_pers(mddev->level, mddev->clevel);
-	if (!pers) {
-		err = -EINVAL;
-		goto abort;
-	}
+	if (!pers)
+		return -EINVAL;
 	if (mddev->level != pers->head.id) {
 		mddev->level = pers->head.id;
 		mddev->new_level = pers->head.id;
@@ -6420,8 +6428,7 @@ int md_run(struct mddev *mddev)
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
 		put_pers(pers);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (pers->sync_request) {
@@ -6548,12 +6555,6 @@ int md_run(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	md_bitmap_destroy(mddev);
-abort:
-	bioset_exit(&mddev->io_clone_set);
-exit_sync_set:
-	bioset_exit(&mddev->sync_set);
-exit_bio_set:
-	bioset_exit(&mddev->bio_set);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6778,10 +6779,6 @@ static void __md_stop(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	bioset_exit(&mddev->io_clone_set);
 }
 
 void md_stop(struct mddev *mddev)
-- 
2.51.0



