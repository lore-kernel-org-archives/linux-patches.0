Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AA471D03;
	Sat, 12 Sep 2026 12:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216889; cv=none; b=JFeyBkTDzKgYlxu56u+BuDkddg08N21+fiPYMl+koVN1dzLGK8q4QHlG8ZKZ1NIU/bibX+asKQMGg1aRRzsB9htFT322hUWOpI1bGM/Ob8053+3KrYlRUGXV8+JOsuP83iW08BFgXFsIcMQYQsrK0olpbsruYCsGr4CbvG9ogpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216889; c=relaxed/simple;
	bh=yrXu4qzLvFtBN8uy92ghExtjbk+kDdNeyApa71xanJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9zj2zhnlH7h9bCALbXwf/ckFMnYdQ2h4me2YRy2feBIjXYWbyzjr58djeR9E9mIuB+TJ3RhsKNgVvoDX5GIIr+nFMqpu2UHdXiFHe9yMr27vDnV9nrxyi29SYDRsfCIx+ac4SNl2vjfbRJmv8hR0IBX/EQqEA+H5bTVzLmODGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psZYSz2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psZYSz2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAAD1F000FF;
	Sat, 12 Sep 2026 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216887;
	bh=UdWw7YKUtmValtL7fIyPSpnbCmwy6mYYg/q9dHK5QaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psZYSz2fz8EfNCsia1N792WbcJ4IiU/un/zmzrFRANh9DYZW2E6jhzxRwMcc2xKV1
	 TpfBbWTewDev1CdQNLoYsqKqr5hqLnB36w6sFA3k5S2N+UljtEMURIoV19CiMNCPZg
	 QXmuC5OCv19imDfz06Ke817ucQNiz29gD+lWiRrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0791/1376] md: merge mddev faillast_dev into mddev_flags
Date: Sat, 12 Sep 2026 08:53:37 +0200
Message-ID: <20260912065625.166213012@linuxfoundation.org>
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

[ Upstream commit 4f6d2e648cbe963b328cb8815290676da3866434 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-4-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: 140234b2380f ("md/raid1: create serial pool adding rdev to array with serialize_policy=1")
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
index 6d0ab9a471316..dc168f45cfb02 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5582,11 +5582,11 @@ __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
 
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
@@ -5599,8 +5599,10 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
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
index e5b37aafc0591..4a410683a788e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -313,6 +313,7 @@ struct md_cluster_info;
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
+ * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -329,6 +330,7 @@ enum mddev_flags {
 	MD_BROKEN,
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
+	MD_FAILLAST_DEV,
 };
 
 enum mddev_sb_flags {
@@ -589,7 +591,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d02f5f0614663..b88ad9c2423c0 100644
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
index a6ee8d3c01cec..7bb28732a2e8f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1741,7 +1741,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -1754,7 +1754,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	    (conf->raid_disks - mddev->degraded) == 1) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			conf->recovery_disabled = mddev->recovery_disabled;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e45008b01c41e..06189fa95490b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1994,7 +1994,7 @@ static int enough(struct r10conf *conf, int ignore)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2006,7 +2006,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 78f3f2d4d1dcb..d631ab8be69b4 100644
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



