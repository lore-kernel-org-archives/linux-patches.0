Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750BB3B4EAC;
	Tue, 21 Jul 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657626; cv=none; b=nXo/j81DVwCZXm9UZyFmc7C6SXU2QbuvesQQJITjuRvsTSCYMl5vPWdNLMZ1FB83uOyeh6TafjONPg/TW/dFnl8TJxAzG6c1CB+Co7RE3eb9XHlLn2ybgL6AK0FPb/gDjTXracIzjFc/uRxRFelvh2BtPF8X+f1wGMNkWniOoBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657626; c=relaxed/simple;
	bh=pob6EfhOkt+yKSKmjOgLAAAQzdqEOpBN2vrq59sb7DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzLmDebrtaYXgnDZrXAyiOOVC/wvPMGQkym6JkCRB1zkYBttV+tagRpEZX+JZGbUzwv9aUXnkJowoj9Qhy/mPSo/G8xFQhq5TISjy8IGUMEWW1AB3SylNLPr6Ompkf4deKalp91pcuEoQxZnc6IyW9ncvyl6l9ok6TSTE4t6bU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+86wiJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+86wiJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFD01F00A3A;
	Tue, 21 Jul 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657624;
	bh=9B+TW9w3N40+Y28L4QvhcjC+sGEGHt37I8pWxSsqkBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+86wiJJeGM8zgYoD7mnKoi0jp2hmP0ehgUqgeaugV4UvUygcdccyeMhdaBCerSq6
	 JFU/Cib8Lj5mENEpi9KUTZahDjz8nAaa4+Mv+NhEUl6EPwd8YL0UZKKox+3FFiHYHh
	 2o+ICxD04cUv0A8Mczw7+5BC9oShmmhmudbTXzKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0833/1611] md: merge mddev serialize_policy into mddev_flags
Date: Tue, 21 Jul 2026 17:15:49 +0200
Message-ID: <20260721152534.125877595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 10787568cc1f3f80afc510b2728751989dfa0ae6 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-5-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: a286cb88ddb2 ("md/raid1: honor REQ_NOWAIT when waiting for behind writes")
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
index 35943f5f683471..1edccebb2130de 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2086,7 +2086,7 @@ static void bitmap_destroy(struct mddev *mddev)
 		return;
 
 	bitmap_wait_behind_writes(mddev);
-	if (!mddev->serialize_policy)
+	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
 	mutex_lock(&mddev->bitmap_info.mutex);
@@ -2864,7 +2864,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
-		if (!mddev->serialize_policy)
+		if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 963ebe233022c6..7675246fa8e984 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -278,7 +278,8 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 
 		rdev_for_each(temp, mddev) {
 			if (!rdev) {
-				if (!mddev->serialize_policy ||
+				if (!test_bit(MD_SERIALIZE_POLICY,
+					      &mddev->flags) ||
 				    !rdev_need_serial(temp))
 					rdev_uninit_serial(temp);
 				else
@@ -5901,11 +5902,12 @@ static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 	if (mddev->pers == NULL || (mddev->pers->head.id != ID_RAID1))
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
@@ -5918,7 +5920,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 
-	if (value == mddev->serialize_policy)
+	if (value == test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		return len;
 
 	err = mddev_suspend_and_lock(mddev);
@@ -5930,11 +5932,13 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -6907,7 +6911,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		md_update_sb(mddev, 1);
 	}
 	/* disable policy to guarantee rdevs free resources for serialization */
-	mddev->serialize_policy = 0;
+	clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	mddev_destroy_serial_pool(mddev, NULL);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ef6e6924bf1300..2960a987476073 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -342,6 +342,7 @@ struct md_cluster_operations;
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
+ * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -360,6 +361,7 @@ enum mddev_flags {
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
+	MD_SERIALIZE_POLICY,
 };
 
 enum mddev_sb_flags {
@@ -625,8 +627,6 @@ struct mddev {
 
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
-
-	bool	serialize_policy:1;
 };
 
 enum recovery_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 00d9fe37e7941c..0bdba5944af94f 100644
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
index 7ed9e07a7e5d2b..6f2f065252e8c9 100644
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
@@ -1646,7 +1646,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (mddev->serialize_policy)
+			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2904e3661c21df..381f56c4b5e276 100644
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



