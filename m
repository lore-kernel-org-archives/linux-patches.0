Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47E317A30A;
	Sat, 12 Sep 2026 13:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219500; cv=none; b=c93AQ0jHs2utgP51dgWO++VSdvNATeQATuct680qDuShxp41vq+6fLrbSU5g3wP5nyOnJaUs1CwH+iABRamsu8ZX2+fexrFJS4MYm0fMHVgMMvRtpDfa5XVrcJbBN10DmhkMfodFTgq+nhYNMM3q3fdHg6PA704nGbngcvDgA0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219500; c=relaxed/simple;
	bh=6gEHPDnv8y8DwnjGiWb5GaQGUxVLnbkiL4QysLlBzMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7l+Krcjc7FJuSYRH8BhyQfaiQvhEY4zGShBT17JCCQtQFoKOpRn4Xu30Pq9Tw6ne3f9yt/p+Nt7JTPUpoF+pTHa/XGzNK555EoicM5sKlT1FrsiY50r5bYEQX5RRCTMGa+5Ign3XESZfTxN6ejS5lrAVl6aisx1gk6iX8SqdbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylzdTza+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylzdTza+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A346F1F000FF;
	Sat, 12 Sep 2026 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219498;
	bh=4J2iBLgK4aNuhnkZf8UebYXOb9KdwJ9dzZo2nDrsdq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylzdTza+uXPScec3jS38aZZedeDGW2y2DppOIpnna4vHlnbX4SwYZ48oVvzfjeoGr
	 K97aIn4pzUkrAK4xJD7U9qAwLEhoQejW61Lqtb4R+WozZfzjUdJ3i8OgOHRgl9OBpd
	 /19eLsk04NhqikKHoqw6OIAiAu+ZdEi7PyYST8fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1363/1376] md: add helper rdev_needs_recovery()
Date: Sat, 12 Sep 2026 09:03:09 +0200
Message-ID: <20260912065637.911824095@linuxfoundation.org>
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

[ Upstream commit cb0780ad4333040a98e10f014b593ef738a3f31e ]

Add a helper for checking if an rdev needs recovery.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250816002534.1754356-2-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: b7ee30f0efd1 ("md: fix sync_action incorrect display during resync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f51ad1c84ef30..ccfaf9f673c39 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4820,6 +4820,15 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
+{
+	return rdev->raid_disk >= 0 &&
+	       !test_bit(Journal, &rdev->flags) &&
+	       !test_bit(Faulty, &rdev->flags) &&
+	       !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < sectors;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
@@ -8989,11 +8998,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 		start = MaxSector;
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < start)
+			if (rdev_needs_recovery(rdev, start))
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
@@ -9347,12 +9352,8 @@ void md_do_sync(struct md_thread *thread)
 			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 				rcu_read_lock();
 				rdev_for_each_rcu(rdev, mddev)
-					if (rdev->raid_disk >= 0 &&
-					    mddev->delta_disks >= 0 &&
-					    !test_bit(Journal, &rdev->flags) &&
-					    !test_bit(Faulty, &rdev->flags) &&
-					    !test_bit(In_sync, &rdev->flags) &&
-					    rdev->recovery_offset < mddev->curr_resync)
+					if (mddev->delta_disks >= 0 &&
+					    rdev_needs_recovery(rdev, mddev->curr_resync))
 						rdev->recovery_offset = mddev->curr_resync;
 				rcu_read_unlock();
 			}
-- 
2.53.0



