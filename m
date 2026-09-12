Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0348C47987B;
	Sat, 12 Sep 2026 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216506; cv=none; b=bkNwxIPPFV+A1K3jy3RaPwGNIKZR6mCsDSden11mwLzbs46of2D9rCrHE/CoAFBvSwwEtOmDsxnTfT+D7bkM8ybzLvF3cwYJKrtUA5HLl6Lb40mlwDVUV/tBF+Ubn2dvgNHqDEowTbGjjVhIZ5Y6/U5QhimWQ/OX/6kDOdnkNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216506; c=relaxed/simple;
	bh=YpozJHAedqMwHJcNT17kgA950G2UgawI0ZhpHLLGXNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPpLrPwcjc0MGqiaZH3tooH9cl+PVrQhprmxuifQrpmc58t+wnb8ZIHF2umK2TO/e0XxN6XpP5g1aWKwQ40GoOStgn/YuzxGxFckiHv5a1YeyeL3yqk9FbXUAtRIat86McZ3RRrBe3XBtTIYL4Hm/sUKG7GZMWzlubaoEQA/PsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwaSr6uP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwaSr6uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17DC1F000FF;
	Sat, 12 Sep 2026 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216504;
	bh=6RRN5Xgxk0W3//CtcptZE748nV7Sv5R1bulXNAl00jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwaSr6uPIKANt8SFRQmpyQyPK0m1aWzCUJ8pUQXRy7ms+ZjZC3VWYX0W0aJCiESBQ
	 zRUOXE5CMRvk+BFKZY9T2H6gAjltDl98yFZj1BfYvVYvYtAWe1UcE4PSw+DHSM/APA
	 sMe+mAEjMVrnB8kVIz7qTe551MyvvCuTdFbk6eBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0743/1376] md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
Date: Sat, 12 Sep 2026 08:52:49 +0200
Message-ID: <20260912065624.103886533@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c951ccf0bf2df4f39b45dc77998dd71da7a85369 ]

This flag is used by llbitmap in later patches to skip raid456 initial
recover and delay building initial xor data to first write.

https: //lore.kernel.org/linux-raid/20250829080426.1441678-10-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: a47431dfb353 ("md/raid5: protect lockless recovery_offset accesses during reshape")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h    |  2 ++
 drivers/md/raid5.c | 19 +++++++++++++++----
 3 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b6b9168aa5bff..889711a24b1cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8907,6 +8907,39 @@ static sector_t md_sync_max_sectors(struct mddev *mddev,
 	}
 }
 
+/*
+ * If lazy recovery is requested and all rdevs are in sync, select the rdev with
+ * the higest index to perfore recovery to build initial xor data, this is the
+ * same as old bitmap.
+ */
+static bool mddev_select_lazy_recover_rdev(struct mddev *mddev)
+{
+	struct md_rdev *recover_rdev = NULL;
+	struct md_rdev *rdev;
+	bool ret = false;
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev->raid_disk < 0)
+			continue;
+
+		if (test_bit(Faulty, &rdev->flags) ||
+		    !test_bit(In_sync, &rdev->flags))
+			break;
+
+		if (!recover_rdev || recover_rdev->raid_disk < rdev->raid_disk)
+			recover_rdev = rdev;
+	}
+
+	if (recover_rdev) {
+		clear_bit(In_sync, &recover_rdev->flags);
+		ret = true;
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+
 static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 {
 	sector_t start = 0;
@@ -8942,6 +8975,14 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
+		/*
+		 * If there are no spares, and raid456 lazy initial recover is
+		 * requested.
+		 */
+		if (test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery) &&
+		    start == MaxSector && mddev_select_lazy_recover_rdev(mddev))
+			start = 0;
+
 		/* If there is a bitmap, we need to make sure all
 		 * writes that started before we added a spare
 		 * complete before we start doing a recovery.
@@ -9494,6 +9535,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 		return true;
 	}
 
@@ -9502,6 +9544,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		remove_spares(mddev, NULL);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 		return true;
 	}
 
@@ -9511,7 +9554,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * re-add.
 	 */
 	*spares = remove_and_add_spares(mddev, NULL);
-	if (*spares) {
+	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
@@ -9724,6 +9767,7 @@ void md_check_recovery(struct mddev *mddev)
 			}
 
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 
@@ -9834,6 +9878,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 	/*
 	 * We call md_cluster_ops->update_size here because sync_size could
 	 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is cleared,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c4554b89d4fe9..22a1ec3aa18d6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -634,6 +634,8 @@ enum recovery_flags {
 	MD_RECOVERY_RESHAPE,
 	/* remote node is running resync thread */
 	MD_RESYNCING_REMOTE,
+	/* raid456 lazy initial recover */
+	MD_RECOVERY_LAZY_RECOVER,
 };
 
 enum md_ro_state {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d658259691f89..bcff3e9bcd749 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4707,10 +4707,21 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			}
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else if (sh->sector + RAID5_STRIPE_SECTORS(conf) <= rdev->recovery_offset)
-			/* in sync if before recovery_offset */
-			set_bit(R5_Insync, &dev->flags);
-		else if (test_bit(R5_UPTODATE, &dev->flags) &&
+		else if (sh->sector + RAID5_STRIPE_SECTORS(conf) <=
+			 rdev->recovery_offset) {
+			/*
+			 * in sync if:
+			 *  - normal IO, or
+			 *  - resync IO that is not lazy recovery
+			 *
+			 * For lazy recovery, we have to mark the rdev without
+			 * In_sync as failed, to build initial xor data.
+			 */
+			if (!test_bit(STRIPE_SYNCING, &sh->state) ||
+			    !test_bit(MD_RECOVERY_LAZY_RECOVER,
+				      &conf->mddev->recovery))
+				set_bit(R5_Insync, &dev->flags);
+		} else if (test_bit(R5_UPTODATE, &dev->flags) &&
 			 test_bit(R5_Expanded, &dev->flags))
 			/* If we've reshaped into here, we assume it is Insync.
 			 * We will shortly update recovery_offset to make
-- 
2.53.0



