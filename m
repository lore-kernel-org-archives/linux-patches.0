Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCF5C8E8
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2C6C433C0;
	Mon, 19 Jun 2023 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172510;
	bh=ERqVmWdpMJU1thQQ/nOlfnOZhQz6BrPisq2C5hvVqrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD0IRstvdjPN0+QtMAFi+a3yw6FSSgXr8uJaH2Iy46bwtW7KWBZdtgY5ErcGPhjQk
	 vOBKfcEEGUY5XUfqhDxQYrgX79vpWqUhPNFb3KCXc6apOUFrdFlZVd2ezSXy61kjCJ
	 8pSK42zzUdNbN4WUNH9zToU+U4ylVOXyLM0EPDck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/107] dm: dont lock fs when the map is NULL during suspend or resume
Date: Mon, 19 Jun 2023 12:31:19 +0200
Message-ID: <20230619102145.895702780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 2760904d895279f87196f0fa9ec570c79fe6a2e4 ]

As described in commit 38d11da522aa ("dm: don't lock fs when the map is
NULL in process of resume"), a deadlock may be triggered between
do_resume() and do_mount().

This commit preserves the fix from commit 38d11da522aa but moves it to
where it also serves to fix a similar deadlock between do_suspend()
and do_mount().  It does so, if the active map is NULL, by clearing
DM_SUSPEND_LOCKFS_FLAG in dm_suspend() which is called by both
do_suspend() and do_resume().

Fixes: 38d11da522aa ("dm: don't lock fs when the map is NULL in process of resume")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 5 +----
 drivers/md/dm.c       | 4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 438c0b77bb48c..815c41e1ebdb8 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1145,13 +1145,10 @@ static int do_resume(struct dm_ioctl *param)
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
-		int srcu_idx;
 
 		/* Suspend if it isn't already suspended */
-		old_map = dm_get_live_table(md, &srcu_idx);
-		if ((param->flags & DM_SKIP_LOCKFS_FLAG) || !old_map)
+		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
-		dm_put_live_table(md, srcu_idx);
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended_md(md))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8bc121d394471..d6285a23dc3ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2526,6 +2526,10 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	}
 
 	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	if (!map) {
+		/* avoid deadlock with fs/namespace.c:do_mount() */
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+	}
 
 	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE, DMF_SUSPENDED);
 	if (r)
-- 
2.39.2



