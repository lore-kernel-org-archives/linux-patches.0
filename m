Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43261266583;
	Tue,  8 Apr 2025 11:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110514; cv=none; b=h6LLAR4WliXKcooyjOTGFO4Pyl40fC6PpyIjRxhKqCIT92MTn2D+2stxJU2pGQkXuDcaY+z0M42+FZ+7aQbuegIXLypcqwloCAMF0E9TKUwI7L4pqSIJZ7PYnWUeFyJDqNhTfdVxvwX7uzvEv/vo9LXVi4Gx793JTbBj1Hn3pnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110514; c=relaxed/simple;
	bh=8SEWoPCVaDN0hDX4yQZygJoebApe2iqgjZ5Jpq+jjzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljMZqCS5unktr3prLbxG1nUzoNxm5A//0H9r6MOXjLQpZ+kREAv2uXDstyaMrpf+QOuPySUZMHVLuljl+u0j1m/pwh5guoB3+eNZmWKboIy75fJU9aswMPrOtlcw9fUldGYeRe2A75RliL56dn0IgLrhxkyXinWnlz+lWOfTwxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5R9hLk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5R9hLk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C1FC4CEEC;
	Tue,  8 Apr 2025 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110514;
	bh=8SEWoPCVaDN0hDX4yQZygJoebApe2iqgjZ5Jpq+jjzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5R9hLk3FAwR2VKmHOa1PiLwNj1aGXc/coEh6S9zT/onXV3B5Ce8N4tXEUOtYHGAu
	 0HKOgYzwqOhmZ3bzo4J5hD4E4DZBx1P4Z2Y+fJQ4oo4laStOBCTHCs2zV9NF4Tyy8n
	 cKl5DrNcIFGYy3PGjmlN27QlGeZD/Un56ArdZLHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 093/731] md: ensure resync is prioritized over recovery
Date: Tue,  8 Apr 2025 12:39:50 +0200
Message-ID: <20250408104916.431290302@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 4b10a3bc67c1232f76aa1e04778ca26d6c0ddf7f ]

If a new disk is added during resync, the resync process is interrupted,
and recovery is triggered, causing the previous resync to be lost. In
reality, disk addition should not terminate resync, fix it.

Steps to reproduce the issue:
  mdadm -CR /dev/md0 -l1 -n3 -x1 /dev/sd[abcd]
  mdadm --fail /dev/md0 /dev/sdc

Fixes: 24dd469d728d ("[PATCH] md: allow a manual resync with md")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250213131530.3698600-1-linan666@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30b3dbbce2d2d..827646b3eb594 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9460,6 +9460,13 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
+	/* Check if resync is in progress. */
+	if (mddev->recovery_cp < MaxSector) {
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		return true;
+	}
+
 	/*
 	 * Remove any failed drives, then add spares if possible. Spares are
 	 * also removed and re-added, to allow the personality to fail the
@@ -9476,13 +9483,6 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
-	/* Check if recovery is in progress. */
-	if (mddev->recovery_cp < MaxSector) {
-		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		return true;
-	}
-
 	/* Delay to choose resync/check/repair in md_do_sync(). */
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		return true;
-- 
2.39.5



