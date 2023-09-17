Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928C4746E
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C237CC433CB;
	Sun, 17 Sep 2023 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982308;
	bh=m/zTwq/Fbl9tsy6UFI5hrZOv7YRQgdS0eZebnldAMlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgGIwjzHf07QdyNpH70/qUerJio/+VfhrDNIJyJz+F8DdeAoWHtycKdZ5+V26ubs9
	 r7jqfBNyoUZibY2FguFgRoaK7M08pCYc33IyXqzrhpUMHHOiyn6zz1J5jsQZgpi4SM
	 UpbOzn8n0XXFp2Dr/tiSDBxhW+CQRKp7zWfVuLKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/511] md: add error_handlers for raid0 and linear
Date: Sun, 17 Sep 2023 21:10:13 +0200
Message-ID: <20230917191118.318162577@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

[ Upstream commit c31fea2f8e2a72c817f318016bbc327095175a9f ]

After the commit 9631abdbf406c("md: Set MD_BROKEN for RAID1 and RAID10")
MD_BROKEN must be set if array is failed because state_store() checks it.
If it is set then -EBUSY is returned to userspace.

For raid0 and linear MD_BROKEN is not set by error_handler(). As a result
mdadm is unable to trigger clean-up actions. It is a regression.

This patch adds appropriate error_handler for raid0 and linear. The
error handler sets MD_BROKEN for this device.

Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com
Stable-dep-of: 319ff40a5427 ("md/raid0: Fix performance regression for large sequential writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-linear.c | 14 +++++++++++++-
 drivers/md/md.c        |  3 +++
 drivers/md/md.h        | 10 ++--------
 drivers/md/raid0.c     | 14 +++++++++++++-
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 1ff51647a6822..c33cd28f1dba0 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
 
-	if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
+	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
+		md_error(mddev, tmp_dev->rdev);
 		bio_io_error(bio);
 		return true;
 	}
@@ -281,6 +282,16 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 
+static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/linear%s: Disk failure on %pg detected, failing array.\n",
+			md_name, rdev->bdev);
+	}
+}
+
 static void linear_quiesce(struct mddev *mddev, int state)
 {
 }
@@ -297,6 +308,7 @@ static struct md_personality linear_personality =
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
 	.quiesce	= linear_quiesce,
+	.error_handler	= linear_error,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a6e855cbf3946..b585b642a0763 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7987,6 +7987,9 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		return;
 	mddev->pers->error_handler(mddev, rdev);
 
+	if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
+		return;
+
 	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 0e0cc5d7921bd..99780e89531e5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -772,15 +772,9 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
-static inline bool is_mddev_broken(struct md_rdev *rdev, const char *md_type)
+static inline bool is_rdev_broken(struct md_rdev *rdev)
 {
-	if (!disk_live(rdev->bdev->bd_disk)) {
-		if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
-			pr_warn("md: %s: %s array has a missing/failed member\n",
-				mdname(rdev->mddev), md_type);
-		return true;
-	}
-	return false;
+	return !disk_live(rdev->bdev->bd_disk);
 }
 
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index dca912387ec19..6917d72c18132 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -628,8 +628,9 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		return true;
 	}
 
-	if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
+	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
+		md_error(mddev, tmp_dev);
 		return true;
 	}
 
@@ -652,6 +653,16 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 	return;
 }
 
+static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/raid0%s: Disk failure on %pg detected, failing array.\n",
+			md_name, rdev->bdev);
+	}
+}
+
 static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
@@ -827,6 +838,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.error_handler	= raid0_error,
 };
 
 static int __init raid0_init (void)
-- 
2.40.1



