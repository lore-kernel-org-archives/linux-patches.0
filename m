Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4547ACFB;
	Sat, 12 Sep 2026 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216560; cv=none; b=jfJ/1rL/zRF2BF892kI7nEfwW0P3LX403a1NzN23z3Bi5e7Fm1LZlBMnG0s5BKJusf9xmOuZcjxn/6u4kOrsG+psPwDZ19QenhKQVdy18tCeDEFB4o+48oIckOfWgQUi1X4gX963HqCZ+B00WM7MLvOk7seUKoVb3D95IsfDJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216560; c=relaxed/simple;
	bh=CsmPIlgI2qz+P6WEKOYPR45tHRuegQXxt7X5upvphoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPM4uYfLyHGN8uASw7DDcWS1kKL1rF7kZGxkU/5FGGFgNyA4lJb8xFibmuVH9ODvnzAp20E2yCn1g3QzmK3PQjBk2pfWMHQv3mSPMj22MCsL30ccY9KP/GuNu8rBAGhbO3iILsp5dbhiKNc72tObLpTByydWPRiwV+6aal7AEeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCQZxrPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCQZxrPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF4C1F00893;
	Sat, 12 Sep 2026 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216559;
	bh=9WYAVwGKIaqxWS5cgl17pbthFXLZyS06n/S1YuKh/n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCQZxrPzB5st0BvVk3jUkE3tXLcBdNZEryJ6SKoXCBllggkByc+B8cjznl4n/g9/A
	 fM7pDcDlUn1qGwqbjbRC3MyTDA76po3AWhwb1AFrZ/ALPDR/dJdBhMegUHKyRNA1K5
	 YwUCSszFqQQvf1KtMU3pc+wzrxBKz5jU98IUTB8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0744/1376] md/raid5: protect lockless recovery_offset accesses during reshape
Date: Sat, 12 Sep 2026 08:52:50 +0200
Message-ID: <20260912065624.126655930@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit a47431dfb3538a1485f65b68a0605a05307b5b2d ]

During reshape:
- reshape_request() advances rdev->recovery_offset for non-In_sync
  devices locklessly.
- analyse_stripe() reads rdev->recovery_offset locklessly to decide:
    a. use a replacement device to read ?
    b. a device can already be treated as in-sync for the current
       stripe ?

one possible scenario is:

CPU1                            CPU2
reshape_request()
-> mddev->curr_resync_completed = sector_nr
-> if (!mddev->reshape_backwards)
-> rdev->recovery_offset = sector_nr
                                analyse_stripe(sh)
                                -> rdev = conf->disks[i].replacement
                                -> if (rdev->recovery_offset >=
                                      sh->sector + stripe_sectors)
                                   set_bit(R5_ReadRepl)
                                -> or
                                -> if (sh->sector + stripe_sectors <=
                                      rdev->recovery_offset)
                                   set_bit(R5_Insync)

And it could be:

- reading from a replacement before it is recovered far enough; or
- treating a not-yet-recovered device as in-sync for the current stripe.

Fixes: db0505d32066 ("md: be cautious about using ->curr_resync_completed for ->recovery_offset")

The race report:
==================================================================
BUG: KCSAN: data-race in ops_run_io / reshape_request

write to 0xffff8bdee168b270 of 8 bytes by task 1704 on cpu 10:
 reshape_request+0x1292/0x17b0
 raid5_sync_request+0x815/0xa00
 md_do_sync.cold+0xf8d/0x1516
 [......]

read to 0xffff8bdee168b270 of 8 bytes by task 1696 on cpu 9:
 ops_run_io+0xc25/0x1960
 handle_stripe+0x2273/0x4570
 handle_active_stripes.isra.0+0x6e0/0xa50
 raid5d+0x7d5/0xb90
 [......]

value changed: 0x0000000000091a00 -> 0x0000000000091b00
==================================================================

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260627102519.136940-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 50 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bcff3e9bcd749..1daf043a5e524 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3744,11 +3744,10 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 	int rv = 0;
 
 	rdev = sh->raid_conf->disks[disk_idx].replacement;
-	if (rdev
-	    && !test_bit(Faulty, &rdev->flags)
-	    && !test_bit(In_sync, &rdev->flags)
-	    && (rdev->recovery_offset <= sh->sector
-		|| rdev->mddev->resync_offset <= sh->sector))
+	if (rdev && !test_bit(Faulty, &rdev->flags) &&
+	    !test_bit(In_sync, &rdev->flags) &&
+	    (READ_ONCE(rdev->recovery_offset) <= sh->sector ||
+	     rdev->mddev->resync_offset <= sh->sector))
 		rv = 1;
 	return rv;
 }
@@ -4665,7 +4664,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		 */
 		rdev = conf->disks[i].replacement;
 		if (rdev && !test_bit(Faulty, &rdev->flags) &&
-		    rdev->recovery_offset >= sh->sector + RAID5_STRIPE_SECTORS(conf) &&
+		    READ_ONCE(rdev->recovery_offset) >=
+		    sh->sector + RAID5_STRIPE_SECTORS(conf) &&
 		    !rdev_has_badblock(rdev, sh->sector,
 				       RAID5_STRIPE_SECTORS(conf)))
 			set_bit(R5_ReadRepl, &dev->flags);
@@ -4708,7 +4708,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
 		else if (sh->sector + RAID5_STRIPE_SECTORS(conf) <=
-			 rdev->recovery_offset) {
+			 READ_ONCE(rdev->recovery_offset)) {
 			/*
 			 * in sync if:
 			 *  - normal IO, or
@@ -5441,13 +5441,13 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 
 	rdev = conf->disks[dd_idx].replacement;
 	if (!rdev || test_bit(Faulty, &rdev->flags) ||
-	    rdev->recovery_offset < end_sector) {
+	    READ_ONCE(rdev->recovery_offset) < end_sector) {
 		rdev = conf->disks[dd_idx].rdev;
 		if (!rdev)
 			return 0;
 		if (test_bit(Faulty, &rdev->flags) ||
 		    !(test_bit(In_sync, &rdev->flags) ||
-		      rdev->recovery_offset >= end_sector))
+		      READ_ONCE(rdev->recovery_offset) >= end_sector))
 			return 0;
 	}
 
@@ -6376,8 +6376,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Journal, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
-				    rdev->recovery_offset < sector_nr)
-					rdev->recovery_offset = sector_nr;
+				    READ_ONCE(rdev->recovery_offset) < sector_nr)
+					WRITE_ONCE(rdev->recovery_offset, sector_nr);
 
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
@@ -6485,8 +6485,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Journal, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
-				    rdev->recovery_offset < sector_nr)
-					rdev->recovery_offset = sector_nr;
+				    READ_ONCE(rdev->recovery_offset) < sector_nr)
+					WRITE_ONCE(rdev->recovery_offset, sector_nr);
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
@@ -7996,9 +7996,9 @@ static int raid5_run(struct mddev *mddev)
 		/* Hack because v0.91 doesn't store recovery_offset properly. */
 		if (mddev->major_version == 0 &&
 		    mddev->minor_version > 90)
-			rdev->recovery_offset = reshape_offset;
+			WRITE_ONCE(rdev->recovery_offset, reshape_offset);
 
-		if (rdev->recovery_offset < reshape_offset) {
+		if (READ_ONCE(rdev->recovery_offset) < reshape_offset) {
 			/* We need to check old and new layout */
 			if (!only_parity(rdev->raid_disk,
 					 conf->algorithm,
@@ -8149,10 +8149,10 @@ static int raid5_spare_active(struct mddev *mddev)
 	for (i = 0; i < conf->raid_disks; i++) {
 		rdev = conf->disks[i].rdev;
 		replacement = conf->disks[i].replacement;
-		if (replacement
-		    && replacement->recovery_offset == MaxSector
-		    && !test_bit(Faulty, &replacement->flags)
-		    && !test_and_set_bit(In_sync, &replacement->flags)) {
+		if (replacement &&
+		    READ_ONCE(replacement->recovery_offset) == MaxSector &&
+		    !test_bit(Faulty, &replacement->flags) &&
+		    !test_and_set_bit(In_sync, &replacement->flags)) {
 			/* Replacement has just become active. */
 			if (!rdev
 			    || !test_and_clear_bit(In_sync, &rdev->flags))
@@ -8167,10 +8167,10 @@ static int raid5_spare_active(struct mddev *mddev)
 					rdev->sysfs_state);
 			}
 			sysfs_notify_dirent_safe(replacement->sysfs_state);
-		} else if (rdev
-		    && rdev->recovery_offset == MaxSector
-		    && !test_bit(Faulty, &rdev->flags)
-		    && !test_and_set_bit(In_sync, &rdev->flags)) {
+		} else if (rdev &&
+			   READ_ONCE(rdev->recovery_offset) == MaxSector &&
+			   !test_bit(Faulty, &rdev->flags) &&
+			   !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		}
@@ -8540,7 +8540,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 					    >= conf->previous_raid_disks)
 						set_bit(In_sync, &rdev->flags);
 					else
-						rdev->recovery_offset = 0;
+						WRITE_ONCE(rdev->recovery_offset, 0);
 
 					/* Failure here is OK */
 					sysfs_link_rdev(mddev, rdev);
@@ -8592,7 +8592,7 @@ static void end_reshape(struct r5conf *conf)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Journal, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags))
-				rdev->recovery_offset = MaxSector;
+				WRITE_ONCE(rdev->recovery_offset, MaxSector);
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_reshape);
 
-- 
2.53.0



