Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF617A30A;
	Sat, 12 Sep 2026 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219505; cv=none; b=sRFv7SBEMQqiNV+7/0fU9EATvsCJjnujUPenCooHhaifuromZgdysWYLrOjcWW9J70qvyjZj1lxICkp5YpvvAsZ5Nr2zggn7C5C5cFAFljG0K96stgrObgyixgocGOhn6vufVsgCLQFinkFFPIpxRKUKqsYS4hlBScm9DIXKzOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219505; c=relaxed/simple;
	bh=93nEj8WsbCOLkagcKQapjVUQXrmLxr1Ai0tsDpQ+Ur8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5ihwCUTxhPin6trXdJuY98D1nvBsZgaB/KDhPiFI4WG30HVPotnggAJMSQzTSyjkgiQTTczmEAxRH9KZTuCq0wqY2dJBQWqxtdqz2OTDug4UgGENxRVSwg0i7R6WX6uQv2GWS/Ri8hYQYZqmLZxVyeb31KBwN9R2fId7Ts5hhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slD8bO9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slD8bO9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AB11F000FF;
	Sat, 12 Sep 2026 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219503;
	bh=uMHaZzesPh9MaPt4AZ7M5bwNHgO//WiYb8AbAFII/CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slD8bO9zO0kNuFfZXlLultX6l+ylMfsxpb5aUhzpWpdfMCeTCK9AIL7Yk7h/pzCO8
	 ZyONHIuR+JmByv4XWQwjQ0ikncxytA8Lzymlr8/CTTR+aXE2J6IH1J0EHsOIYUkyEq
	 LfA62sTBLyuBqG6fSyReafXs9C7FvrURMzSH8IvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1364/1376] md: fix sync_action incorrect display during resync
Date: Sat, 12 Sep 2026 09:03:10 +0200
Message-ID: <20260912065637.933617116@linuxfoundation.org>
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

[ Upstream commit b7ee30f0efd12f42735ae233071015389407966c ]

During raid resync, if a disk becomes faulty, the operation is
briefly interrupted. The MD_RECOVERY_RECOVER flag triggered by
the disk failure causes sync_action to incorrectly show "recover"
instead of "resync". The same issue affects reshape operations.

Reproduction steps:
  mdadm -Cv /dev/md1 -l1 -n4 -e1.2 /dev/sd{a..d} // -> resync happened
  mdadm -f /dev/md1 /dev/sda                     // -> resync interrupted
  cat sync_action
  -> recover

Add progress checks in md_sync_action() for resync/recover/reshape
to ensure the interface correctly reports the actual operation type.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250816002534.1754356-3-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccfaf9f673c39..b3ba51d7da60f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4829,9 +4829,33 @@ static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
 	       rdev->recovery_offset < sectors;
 }
 
+static enum sync_action md_get_active_sync_action(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	bool is_recover = false;
+
+	if (mddev->resync_offset < MaxSector)
+		return ACTION_RESYNC;
+
+	if (mddev->reshape_position != MaxSector)
+		return ACTION_RESHAPE;
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev_needs_recovery(rdev, MaxSector)) {
+			is_recover = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
+	enum sync_action active_action;
 
 	/*
 	 * frozen has the highest priority, means running sync_thread will be
@@ -4855,8 +4879,17 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	    !test_bit(MD_RECOVERY_NEEDED, &recovery))
 		return ACTION_IDLE;
 
-	if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-	    mddev->reshape_position != MaxSector)
+	/*
+	 * Check if any sync operation (resync/recover/reshape) is
+	 * currently active. This ensures that only one sync operation
+	 * can run at a time. Returns the type of active operation, or
+	 * ACTION_IDLE if none are active.
+	 */
+	active_action = md_get_active_sync_action(mddev);
+	if (active_action != ACTION_IDLE)
+		return active_action;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 		return ACTION_RESHAPE;
 
 	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-- 
2.53.0



