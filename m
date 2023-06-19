Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B543C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA16C433C0;
	Mon, 19 Jun 2023 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171234;
	bh=Pul34P8CNk8cDA88LtbaaJpVxSTVfOkB1qKR617HdFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTdQYtP3sXG8q/s8nxKBwPb7xvWH1jpehPNIkGOb7cGCceVIkcfFAcaRBVKpOhkC9
	 EZQ/tmPRHTtxCm74G+tB90+DWyig9c6RSW+HgIzrfL3LhGg8iyXmqwB1KlDdJMpGvI
	 R5UcgJtAfrVqDDZKhvrAHNbzUNggPvUQMqyEnJcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 178/187] dm: dont lock fs when the map is NULL during suspend or resume
Date: Mon, 19 Jun 2023 12:29:56 +0200
Message-ID: <20230619102206.303958736@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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
index cc77cf3d41092..7d5c9c582ed2d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1168,13 +1168,10 @@ static int do_resume(struct dm_ioctl *param)
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
index dfde0088147a1..0a10e94a6db17 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2795,6 +2795,10 @@ int dm_suspend(struct mapped_device *md, unsigned int suspend_flags)
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



