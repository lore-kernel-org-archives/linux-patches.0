Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDF437FF60;
	Sat, 12 Sep 2026 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216470; cv=none; b=FFgO8m881dz8Z67NHqhyuj4MtyrvA2mb8WMz6xVrQLUGelKgGfDgU0N+6zqT/jHRmI/cncAxRW3RQR5YO1+iltZUjcXFZV//vjzQU6R/zGFj2j45xYH30eYf+URjZrrNF6gVuE5cFgdY3+F47kIrBJuTvuc6D9TNLl0ZQfEloIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216470; c=relaxed/simple;
	bh=LkuWF2VkYrG6KGCWwsrTqoBkv+IB/hy6kz6oppMvKyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHl2ZdLRhrGFhx5yU6uiwxvbvI83STjeQq2+yXBWDdD0BtGatoQrY5qPU/hWkq4cJ5yIwVNNOHd+zRx2RTQQu7DlPlQ4mG/pYvGamwkryhUnW39tt4QcabtHMPgOi1e2Nj6KkzdVpdKl427nzF25j17Q6TEja6SvwYZ1DanLjog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uakD2nTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uakD2nTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11381F000FF;
	Sat, 12 Sep 2026 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216469;
	bh=CG3ULqyjgasORQ9qQ25kCv1yGl/3IafHROwPEwevtng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uakD2nTGGMZDkdl7/6TQ+pA/YFFvJxWpkV1E1iK43BZrbkGCASCiHu91pChsPFjwI
	 PtahRoMjbDGAmGk+0bOZAkgGRbOcJdffCIWfdnTDGl0n0zn3o2nQJAAa65IFnPS6Ui
	 TK4fnDxcN85XYVt2b2oSLBtbtrUXnJkCncyzA08g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0741/1376] md: allow removing faulty rdev during resync
Date: Sat, 12 Sep 2026 08:52:47 +0200
Message-ID: <20260912065624.060426089@linuxfoundation.org>
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
Stable-dep-of: a47431dfb353 ("md/raid5: protect lockless recovery_offset accesses during reshape")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 90fe53d5bd818..a5ca93c0223a6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9424,17 +9424,11 @@ static bool md_spares_need_change(struct mddev *mddev)
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
@@ -9448,6 +9442,21 @@ static int remove_and_add_spares(struct mddev *mddev,
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
 
@@ -9490,6 +9499,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 	/* Check if resync is in progress. */
 	if (mddev->recovery_cp < MaxSector) {
+		remove_spares(mddev, NULL);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		return true;
-- 
2.53.0



