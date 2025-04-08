Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758A0214205;
	Tue,  8 Apr 2025 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110703; cv=none; b=B28Puq8R18FCfOq3ffYVPSfhrABaGcq7WvqWatnKNxiAWkhd1J42R9h381HtOmk5kgBduzsuw0PTHtEZNofp0QjBK09vN0+FgOl7A/Yp3rCty9eJPrvGPOPWEsXAOZNvxwtSyUT0Mpf+SQa4pcL9Eaqsyf1yXUKjMnxJcrC/Sa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110703; c=relaxed/simple;
	bh=BDNfXrDKbKmecv/jFDG9xIXKJIOzpCeglh1k0aGJwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz9MEYA7jEiOoLRfm/QOQu1BbItg1leWypzFnkmnCjKWttFhKHSP9/TLE/sMjhDPAg02wiX3fuMIUhUn4Ipp218Po01484aG6MH41r3JUSHZrXo1StpW8AgzS3jKvrg/iOpISQBoGaqpkELJ05Lv22/u+tP5fijoDnIxV3m5lYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv/go58/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv/go58/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E54C4CEE7;
	Tue,  8 Apr 2025 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110703;
	bh=BDNfXrDKbKmecv/jFDG9xIXKJIOzpCeglh1k0aGJwyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wv/go58/wzGO1v6FtaDNpPS2nWwdgt9fQt0xxatjSO2/7RH7TtLEPFX0zhNs/bDDS
	 qJWK0IiI9CGV4TML9FBNTO5MUISpLMcNAFNghrmvKTCt7HvlNu3zyo1PVsU4voREmr
	 eKbMFuxCp7T5hd2caFT4cMHOLhqsmMKmU/VlXzCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 161/731] badblocks: return boolean from badblocks_set() and badblocks_clear()
Date: Tue,  8 Apr 2025 12:40:58 +0200
Message-ID: <20250408104918.020604273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit c8775aefba959cdfbaa25408a84d3dd15bbeb991 ]

Change the return type of badblocks_set() and badblocks_clear()
from int to bool, indicating success or failure. Specifically:

- _badblocks_set() and _badblocks_clear() functions now return
true for success and false for failure.
- All calls to these functions are updated to handle the new
boolean return type.
- This change improves code clarity and ensures a more consistent
handling of success and failure states.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Acked-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/20250227075507.151331-11-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d301f164c3fb ("badblocks: use sector_t instead of int to avoid truncation of badblocks length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c             | 41 +++++++++++++++++------------------
 drivers/block/null_blk/main.c | 14 ++++++------
 drivers/md/md.c               | 35 +++++++++++++++---------------
 drivers/nvdimm/badrange.c     |  2 +-
 include/linux/badblocks.h     |  6 ++---
 5 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index f84a35d683b1f..753250a04c3fa 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -836,8 +836,8 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
 }
 
 /* Do exact work to set bad block range into the bad block table */
-static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			  int acknowledged)
+static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+			   int acknowledged)
 {
 	int len = 0, added = 0;
 	struct badblocks_context bad;
@@ -847,11 +847,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
-		return 1;
+		return false;
 
 	if (sectors == 0)
 		/* Invalid sectors number */
-		return 1;
+		return false;
 
 	if (bb->shift) {
 		/* round the start down, and the end up */
@@ -981,7 +981,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
-	return sectors;
+	return sectors == 0;
 }
 
 /*
@@ -1052,21 +1052,20 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
 }
 
 /* Do the exact work to clear bad block range from the bad block table */
-static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
 	int len = 0, cleared = 0;
-	int rv = 0;
 	u64 *p;
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
-		return 1;
+		return false;
 
 	if (sectors == 0)
 		/* Invalid sectors number */
-		return 1;
+		return false;
 
 	if (bb->shift) {
 		sector_t target;
@@ -1186,9 +1185,9 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	write_sequnlock_irq(&bb->lock);
 
 	if (!cleared)
-		rv = 1;
+		return false;
 
-	return rv;
+	return true;
 }
 
 /* Do the exact work to check bad blocks range from the bad block table */
@@ -1342,12 +1341,12 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  * decide how best to handle it.
  *
  * Return:
- *  0: success
- *  other: failed to set badblocks (out of space). Parital setting will be
+ *  true: success
+ *  false: failed to set badblocks (out of space). Parital setting will be
  *  treated as failure.
  */
-int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			int acknowledged)
+bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+		   int acknowledged)
 {
 	return _badblocks_set(bb, s, sectors, acknowledged);
 }
@@ -1364,10 +1363,10 @@ EXPORT_SYMBOL_GPL(badblocks_set);
  * drop the remove request.
  *
  * Return:
- *  0: success
- *  1: failed to clear badblocks
+ *  true: success
+ *  false: failed to clear badblocks
  */
-int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	return _badblocks_clear(bb, s, sectors);
 }
@@ -1489,10 +1488,10 @@ ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
 		return -EINVAL;
 	}
 
-	if (badblocks_set(bb, sector, length, !unack))
+	if (!badblocks_set(bb, sector, length, !unack))
 		return -ENOSPC;
-	else
-		return len;
+
+	return len;
 }
 EXPORT_SYMBOL_GPL(badblocks_store);
 
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index cca278f1d2ce7..f2a5f65abbf8b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -561,14 +561,14 @@ static ssize_t nullb_device_badblocks_store(struct config_item *item,
 		goto out;
 	/* enable badblocks */
 	cmpxchg(&t_dev->badblocks.shift, -1, 0);
-	if (buf[0] == '+')
-		ret = badblocks_set(&t_dev->badblocks, start,
-			end - start + 1, 1);
-	else
-		ret = badblocks_clear(&t_dev->badblocks, start,
-			end - start + 1);
-	if (ret == 0)
+	if (buf[0] == '+') {
+		if (badblocks_set(&t_dev->badblocks, start,
+				  end - start + 1, 1))
+			ret = count;
+	} else if (badblocks_clear(&t_dev->badblocks, start,
+				   end - start + 1)) {
 		ret = count;
+	}
 out:
 	kfree(orig);
 	return ret;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f501bc5f68f1a..ef859ccb03661 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1754,7 +1754,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
 				break;
-			if (badblocks_set(&rdev->badblocks, sector, count, 1))
+			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
 	} else if (sb->bblog_offset != 0)
@@ -9850,7 +9850,6 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		       int is_new)
 {
 	struct mddev *mddev = rdev->mddev;
-	int rv;
 
 	/*
 	 * Recording new badblocks for faulty rdev will force unnecessary
@@ -9866,33 +9865,35 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
-	if (rv == 0) {
-		/* Make sure they get written out promptly */
-		if (test_bit(ExternalBbl, &rdev->flags))
-			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
-		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		set_mask_bits(&mddev->sb_flags, 0,
-			      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
-		md_wakeup_thread(rdev->mddev->thread);
-		return 1;
-	} else
+
+	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
 		return 0;
+
+	/* Make sure they get written out promptly */
+	if (test_bit(ExternalBbl, &rdev->flags))
+		sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
+	sysfs_notify_dirent_safe(rdev->sysfs_state);
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
+	md_wakeup_thread(rdev->mddev->thread);
+	return 1;
 }
 EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 
 int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
-	int rv;
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	rv = badblocks_clear(&rdev->badblocks, s, sectors);
-	if ((rv == 0) && test_bit(ExternalBbl, &rdev->flags))
+
+	if (!badblocks_clear(&rdev->badblocks, s, sectors))
+		return 0;
+
+	if (test_bit(ExternalBbl, &rdev->flags))
 		sysfs_notify_dirent_safe(rdev->sysfs_badblocks);
-	return rv;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index a002ea6fdd842..ee478ccde7c6c 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -167,7 +167,7 @@ static void set_badblock(struct badblocks *bb, sector_t s, int num)
 	dev_dbg(bb->dev, "Found a bad range (0x%llx, 0x%llx)\n",
 			(u64) s * 512, (u64) num * 512);
 	/* this isn't an error as the hardware will still throw an exception */
-	if (badblocks_set(bb, s, num, 1))
+	if (!badblocks_set(bb, s, num, 1))
 		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
 				__func__, (u64) s);
 }
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index 670f2dae692fb..8764bed9ff167 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -50,9 +50,9 @@ struct badblocks_context {
 
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
-int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			int acknowledged);
-int badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
+bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+		   int acknowledged);
+bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
 void ack_all_badblocks(struct badblocks *bb);
 ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
 ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
-- 
2.39.5



