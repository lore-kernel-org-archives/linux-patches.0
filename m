Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B3247127E;
	Tue, 21 Jul 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657623; cv=none; b=P0NZRBhdYbKA1XfWRirBr3F+2BS2jvGQTAjbfL4Je9BHgIJE++d+jqWwva8Jyx/4w9glmlDO0BPrY4fYQzNs4386fIXaD85/7QJJbUd25BuicpU7wSunhHveIurT03spYPWIPIIVFvHELHNnSYIjm/fuj4Zol29xJ64d0f6bss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657623; c=relaxed/simple;
	bh=b6X+QGN4unu71O4ZVSvx7dAXiykKpChC8WH0902yrYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DujqcPbFGiSfOSHg2UYSjQoM9s8lFMIwIrzmyc8FL38QOwed4HyKM82frS96/CtbHhbgc8BMftLYzJ/TpKrhYeRri4NDr2AdmIxq+svhTkWhoUlz+Rz/kyLdeiVjTb+0rNelulWz6SynudLkZ4FTwegVe8z271liQxuHc8f3RX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR59vW2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR59vW2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FB91F000E9;
	Tue, 21 Jul 2026 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657621;
	bh=9fDlfSZF5GzYmstIWEJBmgZakeTiV3GewEMeyDB5QYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LR59vW2czPoSbUdbmsULlZfTXeRTxIaSOuJ0CGUrMat1ZugNd/eVQMu2otO2KA2Jn
	 nGkFHgWefPJGB3fZ3XNr1ah0kojR9aisnBc8Ugt06Vy0d0TBjTyg/mMFsNw5/x1z/1
	 lZxLFgBU90djPJ6JHY2YVYZKtXYGY2UUwLNLFLrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0832/1611] md: merge mddev faillast_dev into mddev_flags
Date: Tue, 21 Jul 2026 17:15:48 +0200
Message-ID: <20260721152534.104208382@linuxfoundation.org>
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

[ Upstream commit 4f6d2e648cbe963b328cb8815290676da3866434 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-4-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: a286cb88ddb2 ("md/raid1: honor REQ_NOWAIT when waiting for behind writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c     | 10 ++++++----
 drivers/md/md.h     |  3 ++-
 drivers/md/raid0.c  |  3 ++-
 drivers/md/raid1.c  |  4 ++--
 drivers/md/raid10.c |  4 ++--
 drivers/md/raid5.c  |  5 ++++-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a26dde7bdecdd5..963ebe233022c6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5868,11 +5868,11 @@ __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
 
 static ssize_t fail_last_dev_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%d\n", mddev->fail_last_dev);
+	return sprintf(page, "%d\n", test_bit(MD_FAILLAST_DEV, &mddev->flags));
 }
 
 /*
- * Setting fail_last_dev to true to allow last device to be forcibly removed
+ * Setting MD_FAILLAST_DEV to allow last device to be forcibly removed
  * from RAID1/RAID10.
  */
 static ssize_t
@@ -5885,8 +5885,10 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (ret)
 		return ret;
 
-	if (value != mddev->fail_last_dev)
-		mddev->fail_last_dev = value;
+	if (value)
+		set_bit(MD_FAILLAST_DEV, &mddev->flags);
+	else
+		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
 
 	return len;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ce639f2b1d0a68..ef6e6924bf1300 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -341,6 +341,7 @@ struct md_cluster_operations;
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
+ * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -358,6 +359,7 @@ enum mddev_flags {
 	MD_DO_DELETE,
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
+	MD_FAILLAST_DEV,
 };
 
 enum mddev_sb_flags {
@@ -624,7 +626,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e443e478645adc..00d9fe37e7941c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -27,7 +27,8 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_JOURNAL_CLEAN) |	\
 	 (1L << MD_FAILFAST_SUPPORTED) |\
 	 (1L << MD_HAS_PPL) |		\
-	 (1L << MD_HAS_MULTIPLE_PPLS))
+	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
+	 (1L << MD_FAILLAST_DEV))
 
 /*
  * inform the user of the raid configuration
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index df01070eb0c296..7ed9e07a7e5d2b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1748,7 +1748,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -1761,7 +1761,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	    (conf->raid_disks - mddev->degraded) == 1) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			conf->recovery_disabled = mddev->recovery_disabled;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4a8814fd75cd0e..d6b174454b1ae6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1991,7 +1991,7 @@ static int enough(struct r10conf *conf, int ignore)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2003,7 +2003,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b9f0d01ce01cbc..2904e3661c21df 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -56,7 +56,10 @@
 #include "md-bitmap.h"
 #include "raid5-log.h"
 
-#define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
+#define UNSUPPORTED_MDDEV_FLAGS		\
+	((1L << MD_FAILFAST_SUPPORTED) |	\
+	 (1L << MD_FAILLAST_DEV))
+
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
-- 
2.53.0



