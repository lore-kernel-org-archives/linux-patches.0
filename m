Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211946;
	b=RAjibN0gVkRmr8YNAT7yAHUdSxQQzI5vx7yFnVWoW/2b3b30LizP64NRcXZFp5N4xHEm
	 x2YbTtCst7eeVje+E8vWzG/EkPwzUQFv4G+7tGv0gAiqeSsbJdg56fzPVF/yi3dlVejlJ
	 0ZNhXQUbGkfRlZ1IGSwqzv9C5DlKRrWagKdH8vi4BOIftCGVGZ0aptCte5Y/mibE6mvQv
	 0ecgUgvQWJRjaDZ2r2hzdq69TPR04NLLBkTKk/g0YNXyuE7Cvf2gCbH7ZNN9ZnjGeh+S6
	 DSxqIXJF19dyGxfoHzTMjUgjWg5p64KVr4ogZ33ecFC2Jm7RrjJYbk1tDX2nhMi0ESg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cp7hWUjpdzIVOw7C6ui5T6r8dehJh+/YE/8evXE1Rrg=;
	b=qNIlQNrXNArvhya6lFowXvsV+4wGA3gWQyTW9H7Vgy0KpT6BOAlhVJ8Ge+xbnddQR21P
	 wF2X5fVzU8twQTwf49xbTXi/OKZTLSXnPsvx7CF5f2iUOPeaB5HHplr3j/jpM4pOi1xHk
	 TROGIiWKLXaFau9DRnazM2L5rQDMm6g2WUQqRf/qYWf+1wvqApAomb6135o3RypoGGk4J
	 0EDbFjXFSTlw3Vitx3JEZ1kMFfK3yODZdlpos+T84WhZ8CrZDiCDxqy2p0T0aUsmAe+lC
	 DWxWKSlVwRLm8t4iKSgEHq+2ThnUWaznU9bxR6TVKDw8R1rs3WxXS8yqJOPLgrRvzzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSePreyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC0606A31D;
	Wed, 28 Oct 2026 18:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSePreyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956F31F01825;
	Wed, 28 Oct 2026 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211946;
	bh=Cp7hWUjpdzIVOw7C6ui5T6r8dehJh+/YE/8evXE1Rrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSePreyCoRUGinTJyrZuuy3O8j7nvQnZYUGkSORfRlFwU7rjf9NWlWFGkzrYYRG+a
	 Kh6E4cHyFZ58DHowrbuSCCQOjMmlcadAJ3CdwSugCFehwnxxuG9YAyeKwQSrc1e6Wg
	 rOUPeFIlst1Y5XdIEr8tERljmolM4vbtUTQHrKnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/571] md: move initialization and destruction of io_acct_set to md.c
Date: Wed, 28 Oct 2026 18:01:41 +0100
Message-ID: <20261028170021.182280732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c567c86b90d4715081adfe5eb812141a5b6b4883 ]

'io_acct_set' is only used for raid0 and raid456, prepare to use it for
raid1 and raid10, so that io accounting from different levels can be
consistent.

By the way, follow up patches will also use this io clone mechanism to
make sure 'active_io' represents in flight io, not io that is dispatching,
so that mddev_suspend will wait for io to be done as designed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230621165110.1498313-2-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c    | 28 +++++++++++-----------------
 drivers/md/md.h    |  2 --
 drivers/md/raid0.c | 16 ++--------------
 drivers/md/raid5.c | 41 +++++++++++------------------------------
 4 files changed, 24 insertions(+), 63 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a37a821830246..ab95d77ce8831 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5662,6 +5662,7 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -5949,6 +5950,13 @@ int md_run(struct mddev *mddev)
 			goto exit_bio_set;
 	}
 
+	if (!bioset_initialized(&mddev->io_acct_set)) {
+		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
+				  offsetof(struct md_io_acct, bio_clone), 0);
+		if (err)
+			goto exit_sync_set;
+	}
+
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
@@ -6124,6 +6132,8 @@ int md_run(struct mddev *mddev)
 	module_put(pers->owner);
 	md_bitmap_destroy(mddev);
 abort:
+	bioset_exit(&mddev->io_acct_set);
+exit_sync_set:
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
 	bioset_exit(&mddev->bio_set);
@@ -6361,6 +6371,7 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
@@ -8674,23 +8685,6 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
-int acct_bioset_init(struct mddev *mddev)
-{
-	int err = 0;
-
-	if (!bioset_initialized(&mddev->io_acct_set))
-		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
-			offsetof(struct md_io_acct, bio_clone), 0);
-	return err;
-}
-EXPORT_SYMBOL_GPL(acct_bioset_init);
-
-void acct_bioset_exit(struct mddev *mddev)
-{
-	bioset_exit(&mddev->io_acct_set);
-}
-EXPORT_SYMBOL_GPL(acct_bioset_exit);
-
 static void md_end_io_acct(struct bio *bio)
 {
 	struct md_io_acct *md_io_acct = bio->bi_private;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 99780e89531e5..1c84daba6bb7e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -729,8 +729,6 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
-int acct_bioset_init(struct mddev *mddev);
-void acct_bioset_exit(struct mddev *mddev);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2290307e0910f..ba046c41b34a6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -381,7 +381,6 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	struct r0conf *conf = priv;
 
 	free_conf(mddev, conf);
-	acct_bioset_exit(mddev);
 }
 
 static int raid0_run(struct mddev *mddev)
@@ -396,16 +395,11 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	if (acct_bioset_init(mddev)) {
-		pr_err("md/raid0:%s: alloc acct bioset failed.\n", mdname(mddev));
-		return -ENOMEM;
-	}
-
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
 		if (ret < 0)
-			goto exit_acct_set;
+			return ret;
 		mddev->private = conf;
 	}
 	conf = mddev->private;
@@ -445,15 +439,9 @@ static int raid0_run(struct mddev *mddev)
 
 	ret = md_integrity_register(mddev);
 	if (ret)
-		goto free;
+		free_conf(mddev, conf);
 
 	return ret;
-
-free:
-	free_conf(mddev, conf);
-exit_acct_set:
-	acct_bioset_exit(mddev);
-	return ret;
 }
 
 /*
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 901d1c8218746..95d72dcc40fbd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7472,19 +7472,12 @@ static int raid5_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
 	sector_t reshape_offset = 0;
-	int i, ret = 0;
+	int i;
 	long long min_offset_diff = 0;
 	int first = 1;
 
-	if (acct_bioset_init(mddev)) {
-		pr_err("md/raid456:%s: alloc acct bioset failed.\n", mdname(mddev));
+	if (mddev_init_writes_pending(mddev) < 0)
 		return -ENOMEM;
-	}
-
-	if (mddev_init_writes_pending(mddev) < 0) {
-		ret = -ENOMEM;
-		goto exit_acct_set;
-	}
 
 	if (mddev->recovery_cp != MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
@@ -7515,8 +7508,7 @@ static int raid5_run(struct mddev *mddev)
 	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
 		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
 			  mdname(mddev));
-		ret = -EINVAL;
-		goto exit_acct_set;
+		return -EINVAL;
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -7541,15 +7533,13 @@ static int raid5_run(struct mddev *mddev)
 		if (journal_dev) {
 			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 
 		if (mddev->new_level != mddev->level) {
 			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
 		/* reshape_position must be on a new-stripe boundary, and one
@@ -7565,8 +7555,7 @@ static int raid5_run(struct mddev *mddev)
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
 			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		reshape_offset = here_new * chunk_sectors;
 		/* here_new is the stripe we will write to */
@@ -7588,8 +7577,7 @@ static int raid5_run(struct mddev *mddev)
 			else if (mddev->ro == 0) {
 				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
 					mdname(mddev));
-				ret = -EINVAL;
-				goto exit_acct_set;
+				return -EINVAL;
 			}
 		} else if (mddev->reshape_backwards
 		    ? (here_new * chunk_sectors + min_offset_diff <=
@@ -7599,8 +7587,7 @@ static int raid5_run(struct mddev *mddev)
 			/* Reading from the same stripe as writing to - bad */
 			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
@@ -7624,10 +7611,8 @@ static int raid5_run(struct mddev *mddev)
 	else
 		conf = mddev->private;
 
-	if (IS_ERR(conf)) {
-		ret = PTR_ERR(conf);
-		goto exit_acct_set;
-	}
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		if (!journal_dev) {
@@ -7827,10 +7812,7 @@ static int raid5_run(struct mddev *mddev)
 	free_conf(conf);
 	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
-	ret = -EIO;
-exit_acct_set:
-	acct_bioset_exit(mddev);
-	return ret;
+	return -EIO;
 }
 
 static void raid5_free(struct mddev *mddev, void *priv)
@@ -7838,7 +7820,6 @@ static void raid5_free(struct mddev *mddev, void *priv)
 	struct r5conf *conf = priv;
 
 	free_conf(conf);
-	acct_bioset_exit(mddev);
 	mddev->to_remove = &raid5_attrs_group;
 }
 
-- 
2.53.0



