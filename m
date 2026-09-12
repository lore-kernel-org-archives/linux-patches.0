Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4230DEA6;
	Sat, 12 Sep 2026 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216920; cv=none; b=MB+Iu6ah5fIpm/Ee62mQgdz6zkvh8sWmgBj63IjXHyzQSWkbU1sZSxM+aPGUaQn/4I7wxpon5ccfC43OCi5qLj1hYV7+dil5Sg5X/SRaHlnwqQYTMGoHAGZpDMN0KTCb9vGlCnl0H6ByXNnphymr2K4onKBFQMu2anCszCY8/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216920; c=relaxed/simple;
	bh=nEC+6FRMh1gjXKIs8QnmQySsK0eUwHHKUhCd0g5/kmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJHbE1j4yrLBONjAR7CQeX7Mrg6g089VIGMKd8BUrUw+26EIcpJav8LVQJwfk6/D7gJ59NmTcKtIPjN+rPXOo5WRPgZkNwocAweFi2433036LuxhOVXoyCQJT6LHTgl/6nlR9VFMfKKpZDBffeqWIBYWogxdWm+91+qvlIxiHwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqYOLyol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqYOLyol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E491F000FF;
	Sat, 12 Sep 2026 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216919;
	bh=V7uhZ4gd51joMbC7dRP36AbJUp+dt+mEuuHx9O0Qv1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqYOLyolcJvdXtn0l4FFqY0dv8NRVPHJpUWX7a/hNCfZNBBVkXGKwAvukohQSCFWm
	 d0TuxB/37A4BrEwovLKzLhHLnq+pHC+TSADvD+rfDJHuOPPxiI8YyQvJnWeipjeJ5t
	 R5GeIpZmdm/MRzyWTBJ+AuSGs+gFwt6P3tnu3Byw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0792/1376] md: merge mddev serialize_policy into mddev_flags
Date: Sat, 12 Sep 2026 08:53:38 +0200
Message-ID: <20260912065625.188206124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 10787568cc1f3f80afc510b2728751989dfa0ae6 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-5-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: 140234b2380f ("md/raid1: create serial pool adding rdev to array with serialize_policy=1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c |  4 ++--
 drivers/md/md.c        | 20 ++++++++++++--------
 drivers/md/md.h        |  4 ++--
 drivers/md/raid0.c     |  3 ++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid5.c     |  3 ++-
 6 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b0bd83ba237d7..61271053e8ba0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2097,7 +2097,7 @@ static void bitmap_destroy(struct mddev *mddev)
 		return;
 
 	bitmap_wait_behind_writes(mddev);
-	if (!mddev->serialize_policy)
+	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
 	mutex_lock(&mddev->bitmap_info.mutex);
@@ -2826,7 +2826,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
-		if (!mddev->serialize_policy)
+		if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index dc168f45cfb02..1f3322dfc1220 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -270,7 +270,8 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 
 		rdev_for_each(temp, mddev) {
 			if (!rdev) {
-				if (!mddev->serialize_policy ||
+				if (!test_bit(MD_SERIALIZE_POLICY,
+					      &mddev->flags) ||
 				    !rdev_need_serial(temp))
 					rdev_uninit_serial(temp);
 				else
@@ -5615,11 +5616,12 @@ static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 	if (mddev->pers == NULL || (mddev->pers->level != 1))
 		return sprintf(page, "n/a\n");
 	else
-		return sprintf(page, "%d\n", mddev->serialize_policy);
+		return sprintf(page, "%d\n",
+			       test_bit(MD_SERIALIZE_POLICY, &mddev->flags));
 }
 
 /*
- * Setting serialize_policy to true to enforce write IO is not reordered
+ * Setting MD_SERIALIZE_POLICY enforce write IO is not reordered
  * for raid1.
  */
 static ssize_t
@@ -5632,7 +5634,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 
-	if (value == mddev->serialize_policy)
+	if (value == test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		return len;
 
 	err = mddev_suspend_and_lock(mddev);
@@ -5644,11 +5646,13 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		goto unlock;
 	}
 
-	if (value)
+	if (value) {
 		mddev_create_serial_pool(mddev, NULL);
-	else
+		set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+	} else {
 		mddev_destroy_serial_pool(mddev, NULL);
-	mddev->serialize_policy = value;
+		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+	}
 unlock:
 	mddev_unlock_and_resume(mddev);
 	return err ?: len;
@@ -6453,7 +6457,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		md_update_sb(mddev, 1);
 	}
 	/* disable policy to guarantee rdevs free resources for serialization */
-	mddev->serialize_policy = 0;
+	clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	mddev_destroy_serial_pool(mddev, NULL);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4a410683a788e..bd5d95b1bac74 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -314,6 +314,7 @@ struct md_cluster_info;
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
+ * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -331,6 +332,7 @@ enum mddev_flags {
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
+	MD_SERIALIZE_POLICY,
 };
 
 enum mddev_sb_flags {
@@ -590,8 +592,6 @@ struct mddev {
 
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
-
-	bool	serialize_policy:1;
 };
 
 enum recovery_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b88ad9c2423c0..efff5c4629c19 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -28,7 +28,8 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_FAILFAST_SUPPORTED) |\
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
-	 (1L << MD_FAILLAST_DEV))
+	 (1L << MD_FAILLAST_DEV) |	\
+	 (1L << MD_SERIALIZE_POLICY))
 
 /*
  * inform the user of the raid configuration
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7bb28732a2e8f..c6ad1f97cdace 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -542,7 +542,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (rdev->mddev->serialize_policy)
+	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1637,7 +1637,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (mddev->serialize_policy)
+			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d631ab8be69b4..ef1a1a8507792 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -58,7 +58,8 @@
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_FAILFAST_SUPPORTED) |	\
-	 (1L << MD_FAILLAST_DEV))
+	 (1L << MD_FAILLAST_DEV) |		\
+	 (1L << MD_SERIALIZE_POLICY))
 
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
-- 
2.53.0



