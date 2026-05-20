Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5587C39B483;
	Wed, 20 May 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299633; cv=none; b=VqOB5wK2VgLno5k0TBRu12ULEEd5mQM7DJZTa6feHsclHShdfYGzOH9hNzALUWutyDqQKPU1Xr2bnX+QynP7fazDiK0gQiiZLZzmkHNZ+vhGaHEbeBtRDln26Netkyjq0kSDA96lkaxrczyE/E4J1I7hzpPYUFFqyPI73qMEv5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299633; c=relaxed/simple;
	bh=Y1wpM5kIazpydffhqTPj+z/bN0vQm5ZPuJIe9sXOgUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uR3q45cLMzs2isKktbghH0rpVrFobxud/DUIbJjEmE/Fr5B0AnIAmBbF1ZUDUdDMVQNWNQSXYpW4dFcetAYcUPWL9S9aDdeq5aGpAxQMQYnNdid6HEtd7Scy4rglDmJDPPDBFWRGpJhDg5JJL104bjvMYHfYdU71nsEgVLU8N5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zisBDZgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zisBDZgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD291F000E9;
	Wed, 20 May 2026 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299632;
	bh=9ORD673BQ9tu6lPqsatCrKnRk6gEznRy4/3hdBib3XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zisBDZgzIcQGWjAApLYTMZEhRgwetcBQxA8N/dBUrX57xpYISliewMpwEd5D8+JHt
	 nqvjxW4Unuxy5NxlSk0iVdJ2W2owivHYeuLKWZ0bv1WID855yajXQSLvRb9jHDVA4L
	 cgiAghn2LUQ3OOhk+diLTzmzDomGqZYDBVYvcFJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 795/957] md/md-bitmap: add a none backend for bitmap grow
Date: Wed, 20 May 2026 18:21:18 +0200
Message-ID: <20260520162151.803920565@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit f2926a533d03fe70d753b512b713e06a2aa174af ]

Add a real none bitmap backend that exposes the common bitmap sysfs
group and use it to keep bitmap/location available when an array has no
bitmap.

Then switch the bitmap location sysfs path to move only between none
and the classic bitmap backend, using the no-sysfs bitmap helpers while
merging or unmerging the internal bitmap sysfs group.

This restores mdadm --grow bitmap addition through bitmap/location.

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Reviewed-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/r/20260425024615.1696892-4-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 108 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.c        |  42 +++++++++++++---
 drivers/md/md.h        |   3 ++
 3 files changed, 137 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7a96600949139..35943f5f68347 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -216,6 +216,7 @@ struct bitmap {
 };
 
 static struct workqueue_struct *md_bitmap_wq;
+static struct attribute_group md_bitmap_internal_group;
 
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
@@ -2581,6 +2582,30 @@ static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 	return __bitmap_resize(bitmap, blocks, chunksize, false);
 }
 
+static bool bitmap_none_enabled(void *data, bool flush)
+{
+	return false;
+}
+
+static int bitmap_none_create(struct mddev *mddev)
+{
+	return 0;
+}
+
+static int bitmap_none_load(struct mddev *mddev)
+{
+	return 0;
+}
+
+static void bitmap_none_destroy(struct mddev *mddev)
+{
+}
+
+static int bitmap_none_get_stats(void *data, struct md_bitmap_stats *stats)
+{
+	return -ENOENT;
+}
+
 static ssize_t
 location_show(struct mddev *mddev, char *page)
 {
@@ -2619,7 +2644,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		bitmap_destroy(mddev);
+		sysfs_unmerge_group(&mddev->kobj, &md_bitmap_internal_group);
+		md_bitmap_destroy_nosysfs(mddev);
+		mddev->bitmap_id = ID_BITMAP_NONE;
+		if (!mddev_set_bitmap_ops_nosysfs(mddev))
+			goto none_err;
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2655,16 +2684,25 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap_info.offset = offset;
-			rv = bitmap_create(mddev);
+			md_bitmap_destroy_nosysfs(mddev);
+			mddev->bitmap_id = ID_BITMAP;
+			if (!mddev_set_bitmap_ops_nosysfs(mddev))
+				goto bitmap_err;
+
+			rv = md_bitmap_create_nosysfs(mddev);
 			if (rv)
-				goto out;
+				goto create_err;
 
-			rv = bitmap_load(mddev);
+			rv = mddev->bitmap_ops->load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				bitmap_destroy(mddev);
-				goto out;
+				goto load_err;
 			}
+
+			rv = sysfs_merge_group(&mddev->kobj,
+					       &md_bitmap_internal_group);
+			if (rv)
+				goto merge_err;
 		}
 	}
 	if (!mddev->external) {
@@ -2680,6 +2718,22 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	if (rv)
 		return rv;
 	return len;
+
+merge_err:
+	mddev->bitmap_info.offset = 0;
+load_err:
+	md_bitmap_destroy_nosysfs(mddev);
+create_err:
+	mddev->bitmap_info.offset = 0;
+	mddev->bitmap_id = ID_BITMAP_NONE;
+	if (!mddev_set_bitmap_ops_nosysfs(mddev))
+		rv = -ENOENT;
+	goto out;
+bitmap_err:
+	rv = -ENOENT;
+none_err:
+	mddev->bitmap_info.offset = 0;
+	goto out;
 }
 
 static struct md_sysfs_entry bitmap_location =
@@ -2988,6 +3042,27 @@ static const struct attribute_group *bitmap_groups[] = {
 	NULL,
 };
 
+static const struct attribute_group *bitmap_none_groups[] = {
+	&md_bitmap_common_group,
+	NULL,
+};
+
+static struct bitmap_operations bitmap_none_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_BITMAP_NONE,
+		.name	= "none",
+	},
+
+	.enabled		= bitmap_none_enabled,
+	.create			= bitmap_none_create,
+	.load			= bitmap_none_load,
+	.destroy		= bitmap_none_destroy,
+	.get_stats		= bitmap_none_get_stats,
+
+	.groups			= bitmap_none_groups,
+};
+
 static struct bitmap_operations bitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -3034,16 +3109,33 @@ static struct bitmap_operations bitmap_ops = {
 
 int md_bitmap_init(void)
 {
+	int err;
+
 	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
 				       0);
 	if (!md_bitmap_wq)
 		return -ENOMEM;
 
-	return register_md_submodule(&bitmap_ops.head);
+	err = register_md_submodule(&bitmap_none_ops.head);
+	if (err)
+		goto err_wq;
+
+	err = register_md_submodule(&bitmap_ops.head);
+	if (err)
+		goto err_none;
+
+	return 0;
+
+err_none:
+	unregister_md_submodule(&bitmap_none_ops.head);
+err_wq:
+	destroy_workqueue(md_bitmap_wq);
+	return err;
 }
 
 void md_bitmap_exit(void)
 {
-	destroy_workqueue(md_bitmap_wq);
 	unregister_md_submodule(&bitmap_ops.head);
+	unregister_md_submodule(&bitmap_none_ops.head);
+	destroy_workqueue(md_bitmap_wq);
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 213221abc44c3..b7d47c018a12f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -712,7 +712,7 @@ static void md_bitmap_sysfs_del(struct mddev *mddev)
 	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->groups[0]);
 }
 
-static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
+bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
 {
 	struct md_submodule_head *head;
 
@@ -4274,7 +4274,7 @@ bitmap_type_show(struct mddev *mddev, char *page)
 
 	xa_lock(&md_submodule);
 	xa_for_each(&md_submodule, i, head) {
-		if (head->type != MD_BITMAP)
+		if (head->type != MD_BITMAP || head->id == ID_BITMAP_NONE)
 			continue;
 
 		if (mddev->bitmap_id == head->id)
@@ -6408,7 +6408,7 @@ static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
 	return id;
 }
 
-static int md_bitmap_create_nosysfs(struct mddev *mddev)
+int md_bitmap_create_nosysfs(struct mddev *mddev)
 {
 	enum md_submodule_id orig_id = mddev->bitmap_id;
 	enum md_submodule_id sb_id;
@@ -6417,8 +6417,10 @@ static int md_bitmap_create_nosysfs(struct mddev *mddev)
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
-	if (!mddev_set_bitmap_ops_nosysfs(mddev))
+	if (!mddev_set_bitmap_ops_nosysfs(mddev)) {
+		mddev->bitmap_id = orig_id;
 		return -ENOENT;
+	}
 
 	err = mddev->bitmap_ops->create(mddev);
 	if (!err)
@@ -6432,8 +6434,10 @@ static int md_bitmap_create_nosysfs(struct mddev *mddev)
 	mddev->bitmap_ops = NULL;
 
 	sb_id = md_bitmap_get_id_from_sb(mddev);
-	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
+	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id) {
+		mddev->bitmap_id = orig_id;
 		return err;
+	}
 
 	pr_info("md: %s: bitmap version mismatch, switching from %d to %d\n",
 		mdname(mddev), orig_id, sb_id);
@@ -6467,7 +6471,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	return 0;
 }
 
-static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
+void md_bitmap_destroy_nosysfs(struct mddev *mddev)
 {
 	if (!md_bitmap_registered(mddev))
 		return;
@@ -6485,6 +6489,16 @@ static void md_bitmap_destroy(struct mddev *mddev)
 	md_bitmap_destroy_nosysfs(mddev);
 }
 
+static void md_bitmap_set_none(struct mddev *mddev)
+{
+	mddev->bitmap_id = ID_BITMAP_NONE;
+	if (!mddev_set_bitmap_ops_nosysfs(mddev))
+		return;
+
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->groups)
+		md_bitmap_sysfs_add(mddev);
+}
+
 int md_run(struct mddev *mddev)
 {
 	int err;
@@ -6694,6 +6708,10 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
+	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file &&
+	    !mddev->bitmap_info.offset)
+		md_bitmap_set_none(mddev);
+
 	md_new_event();
 	return 0;
 
@@ -7638,7 +7656,8 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 {
 	int err = 0;
 
-	if (!md_bitmap_registered(mddev))
+	if (!md_bitmap_registered(mddev) ||
+	    mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
 	if (mddev->pers) {
@@ -7703,10 +7722,12 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 
 			if (err) {
 				md_bitmap_destroy(mddev);
+				md_bitmap_set_none(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
 			md_bitmap_destroy(mddev);
+			md_bitmap_set_none(mddev);
 		}
 	}
 
@@ -8013,12 +8034,16 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
+			mddev->bitmap_id = ID_BITMAP;
 			rv = md_bitmap_create(mddev);
 			if (!rv)
 				rv = mddev->bitmap_ops->load(mddev);
 
-			if (rv)
+			if (rv) {
 				md_bitmap_destroy(mddev);
+				mddev->bitmap_info.offset = 0;
+				md_bitmap_set_none(mddev);
+			}
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -8046,6 +8071,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			}
 			md_bitmap_destroy(mddev);
 			mddev->bitmap_info.offset = 0;
+			md_bitmap_set_none(mddev);
 		}
 	}
 	md_update_sb(mddev, 1);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9d66afb8cc6e6..da312d4692858 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -932,6 +932,9 @@ extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(struct mddev *mddev);
+bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev);
+int md_bitmap_create_nosysfs(struct mddev *mddev);
+void md_bitmap_destroy_nosysfs(struct mddev *mddev);
 extern int md_integrity_register(struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
-- 
2.53.0



