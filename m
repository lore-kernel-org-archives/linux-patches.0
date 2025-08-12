Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7A222425B;
	Tue, 12 Aug 2025 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025377; cv=none; b=p3mJu/0brFVrLsyM/KiMGsdav9Ob70NOyNBBTHkw0ZZxBMVRBXfLZ4zhxej5SjxHXuMeqJiLTXaN5teAl7Q7/+mFzV27I9MuU297KPiYEr76DX48ga4U8AfIkRDZuY4IqHKMMVV/ux39MsEIF8dwFF4KFxWf9QEJSaNQ/znmNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025377; c=relaxed/simple;
	bh=HkdRaZ0l2dwR+KcvzSqaJMBbvkrSsBycj/CQZNdCQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASKzjV1nQXI2yInJurSFGx8qGcMBShkpf8VCYv+HkVzfy1z7Atol8cFF5sTDBw0xB/kOoUuxrGdwaymId0oTNv3J7/tsH2g01fShjQAS6Q57oLkp3epNZOSEPSb/lWOfFd02vetdoY7eAPmVmtV+Sf/MJeo56RRRGUvlblxoetU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSjvefbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSjvefbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF431C4CEF1;
	Tue, 12 Aug 2025 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025377;
	bh=HkdRaZ0l2dwR+KcvzSqaJMBbvkrSsBycj/CQZNdCQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSjvefbJP8DyOO49KvRQkGE4g3GbaWiyaJrt9ZBP2bRl1wcjaqJVZXL4dEMcuhrP5
	 OXv/MnNJy4rbYMU8OdKId+X/OB7Qs7pB0rDtQrhCE16xxdnLIY89bHJME17VONodCH
	 YAdzQtcPymWhlVd8TeuMGVe2XVWTWBnQdVI75VCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 023/480] md: allow removing faulty rdev during resync
Date: Tue, 12 Aug 2025 19:43:51 +0200
Message-ID: <20250812174358.261088737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit c0ffeb648000acdc932da7a9d33fd65e9263c54c ]

During RAID resync, faulty rdev cannot be removed and will result in
"Device or resource busy" error when attempting hot removal.

Reproduction steps:
  mdadm -Cv /dev/md0 -l1 -n3 -e1.2 /dev/sd{b..d}
  mdadm /dev/md0 -f /dev/sdb
  mdadm /dev/md0 -r /dev/sdb
  -> mdadm: hot remove failed for /dev/sdb: Device or resource busy

After commit 4b10a3bc67c1 ("md: ensure resync is prioritized over
recovery"), when a device becomes faulty during resync, the
md_choose_sync_action() function returns early without calling
remove_and_add_spares(), preventing faulty device removal.

This patch extracts a helper function remove_spares() to support
removing faulty devices during RAID resync operations.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250707075412.150301-1-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5fe33..0de87d451a47 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9380,17 +9380,11 @@ static bool md_spares_need_change(struct mddev *mddev)
 	return false;
 }
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this)
+static int remove_spares(struct mddev *mddev, struct md_rdev *this)
 {
 	struct md_rdev *rdev;
-	int spares = 0;
 	int removed = 0;
 
-	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		/* Mustn't remove devices when resync thread is running */
-		return 0;
-
 	rdev_for_each(rdev, mddev) {
 		if ((this == NULL || rdev == this) && rdev_removeable(rdev) &&
 		    !mddev->pers->hot_remove_disk(mddev, rdev)) {
@@ -9404,6 +9398,21 @@ static int remove_and_add_spares(struct mddev *mddev,
 	if (removed && mddev->kobj.sd)
 		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 
+	return removed;
+}
+
+static int remove_and_add_spares(struct mddev *mddev,
+				 struct md_rdev *this)
+{
+	struct md_rdev *rdev;
+	int spares = 0;
+	int removed = 0;
+
+	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		/* Mustn't remove devices when resync thread is running */
+		return 0;
+
+	removed = remove_spares(mddev, this);
 	if (this && removed)
 		goto no_add;
 
@@ -9446,6 +9455,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 	/* Check if resync is in progress. */
 	if (mddev->recovery_cp < MaxSector) {
+		remove_spares(mddev, NULL);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		return true;
-- 
2.39.5



