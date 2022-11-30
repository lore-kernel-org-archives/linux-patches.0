Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6920879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A9AC433D7;
	Wed, 30 Nov 2022 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834107;
	bh=e1+IPermuFw4Yw3pOuO4vGYU2ZVKupHQgopAVJll2vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1XQWC3sfxUNWnpd8K+mu5oPVpGlv6NxYs/TmEG7tki8CoZboAShGtC+//ca/ndCQ
	 eMA+UiI2e0IwIWBDBuxCgcxkf4icmns4TCMh7Zuf5PMSBTfZEnWesFKDMwRgXKbhKP
	 rjYkXaQIrKTtdkYNTWoDOk5IcCLvUNGVnG0GQ0VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ba92bd00d5093f7e371@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Svyatoslav Feldsherov <feldsherov@google.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 131/289] fs: do not update freeing inode i_io_list
Date: Wed, 30 Nov 2022 19:21:56 +0100
Message-Id: <20221130180547.109020051@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Svyatoslav Feldsherov <feldsherov@google.com>

[ Upstream commit 4e3c51f4e805291b057d12f5dda5aeb50a538dc4 ]

After commit cbfecb927f42 ("fs: record I_DIRTY_TIME even if inode
already has I_DIRTY_INODE") writeback_single_inode can push inode with
I_DIRTY_TIME set to b_dirty_time list. In case of freeing inode with
I_DIRTY_TIME set this can happen after deletion of inode from i_io_list
at evict. Stack trace is following.

evict
fat_evict_inode
fat_truncate_blocks
fat_flush_inodes
writeback_inode
sync_inode_metadata(inode, sync=0)
writeback_single_inode(inode, wbc) <- wbc->sync_mode == WB_SYNC_NONE

This will lead to use after free in flusher thread.

Similar issue can be triggered if writeback_single_inode in the
stack trace update inode->i_io_list. Add explicit check to avoid it.

Fixes: cbfecb927f42 ("fs: record I_DIRTY_TIME even if inode already has I_DIRTY_INODE")
Reported-by: syzbot+6ba92bd00d5093f7e371@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Svyatoslav Feldsherov <feldsherov@google.com>
Link: https://lore.kernel.org/r/20221115202001.324188-1-feldsherov@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 443f83382b9b..9958d4020771 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1712,18 +1712,26 @@ static int writeback_single_inode(struct inode *inode,
 	wb = inode_to_wb_and_lock_list(inode);
 	spin_lock(&inode->i_lock);
 	/*
-	 * If the inode is now fully clean, then it can be safely removed from
-	 * its writeback list (if any).  Otherwise the flusher threads are
-	 * responsible for the writeback lists.
+	 * If the inode is freeing, its i_io_list shoudn't be updated
+	 * as it can be finally deleted at this moment.
 	 */
-	if (!(inode->i_state & I_DIRTY_ALL))
-		inode_cgwb_move_to_attached(inode, wb);
-	else if (!(inode->i_state & I_SYNC_QUEUED)) {
-		if ((inode->i_state & I_DIRTY))
-			redirty_tail_locked(inode, wb);
-		else if (inode->i_state & I_DIRTY_TIME) {
-			inode->dirtied_when = jiffies;
-			inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
+	if (!(inode->i_state & I_FREEING)) {
+		/*
+		 * If the inode is now fully clean, then it can be safely
+		 * removed from its writeback list (if any). Otherwise the
+		 * flusher threads are responsible for the writeback lists.
+		 */
+		if (!(inode->i_state & I_DIRTY_ALL))
+			inode_cgwb_move_to_attached(inode, wb);
+		else if (!(inode->i_state & I_SYNC_QUEUED)) {
+			if ((inode->i_state & I_DIRTY))
+				redirty_tail_locked(inode, wb);
+			else if (inode->i_state & I_DIRTY_TIME) {
+				inode->dirtied_when = jiffies;
+				inode_io_list_move_locked(inode,
+							  wb,
+							  &wb->b_dirty_time);
+			}
 		}
 	}
 
-- 
2.35.1



