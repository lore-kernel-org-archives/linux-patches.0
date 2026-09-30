Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236751EE0E;
	Wed, 30 Sep 2026 18:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792873; cv=none; b=pxibnnz6Fo38xvMA1jAES1pNai5obty8+67EcWjBIsSwGjWh74fxqFP4cXmHn9XBS4SArOBXQ8+ii6WCWWlyALCa+2QqEy3KOymC0Tska1iWq9HJIgdp5oc1W17aDFOf5UErun0jk6gxAYPajte7+NfFn+le1D0bS3T6uHPjsyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792873; c=relaxed/simple;
	bh=kKfYqoGO/Rfx/ZH4sG6k4AprDvlS0SgFhHflNPYTpB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZO0EKHm+trDmZf2tHCvU893Vw1SQrYgRVREd95cdUbNlN5DOxB/a928DEdVVJg/apNz/7b/ZbQIlbKF0DKz88m8ujD11jRntNvlotG1CV/7slhZkGjYvffqtxXBOJILqzC891x3yti0jYLMWMTcOcaEmOIzXdiebwIxXtcyymg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9diufdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9diufdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482951F000FF;
	Wed, 30 Sep 2026 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792871;
	bh=zIG3E3b4QcwWs0yyMN2+cZZJb75BfwLPIFwQuCEwySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9diufdrlQxkWQ5zJjYWSpnUJD2cuYiwuNweLPRlRXEQpvKVjAOWVlSHHrydd+qhz
	 8sLx7K6pxAZrO68QSxyeRZ84omcftwiL2SF6pK/HtUTGI5dDz0GOtjo7xU+YYBa3oR
	 0JGpXBvozmW1CwZT50XM7pd2+54ELQqVN3FTSx8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/395] fs: avoid repeated scans in evict_inodes()
Date: Wed, 30 Sep 2026 17:25:17 +0200
Message-ID: <20260930152341.830093758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 7459c021874246c196f397686e100702f059b9e7 ]

We observed hung tasks when users attempted to unmount a filesystem
after its disk had been removed while still in use. During device
removal, fs_bdev_mark_dead() calls evict_inodes() while holding s_umount.

Each time evict_inodes() drops s_inode_list_lock to reschedule, it
restarts the walk from the head of s_inodes. With many referenced inodes
at the head of the list, these restarts repeatedly scan the same inodes
without reclaiming them. This can keep s_umount held for a long time,
blocking concurrent umount attempts and triggering hung-task reports.

Keep the current inode, already marked I_FREEING, out of the disposal
batch until s_inode_list_lock is reacquired. Resume the walk from this
inode and dispose of it in a later batch or at the end of the walk.

The zero-refcount and state checks under i_lock allow this walker to
claim the inode by setting I_FREEING and removing it from the LRU.
Other reclaimers skip the inode, leaving this walker responsible for
eviction. Only evict() removes it from s_inodes, so keeping it out of
the disposal batch ensures that it remains on the list while the lock
is dropped. After reacquiring the lock, reading its current next pointer
accounts for concurrent removal of following inodes.

The existing inode lifetime rules prohibit acquiring a reference to an
inode marked I_FREEING or I_WILL_FREE. __iget() requires its caller to
hold i_lock and establish that taking a reference is valid. Inode lookup
and igrab() check these flags under i_lock when acquiring a reference
from zero. ihold() requires an existing reference, which would keep
i_count nonzero and prevent this walker from claiming the inode. These
rules already allow iput_final() and the inode shrinker to release
i_lock after setting I_FREEING and before eviction completes.

A temporary __iget() reference would also keep the inode on the list,
but its release must preserve last-reference handling. Another user can
acquire a reference, update lazy timestamps and drop its reference while
the pin is held. If the pin becomes the last reference, dropping it with
atomic_dec_and_test() and evicting directly bypasses iput()'s lazytime
handling and can lose those timestamp updates.

Releasing the pin with iput() preserves that handling, but does not
guarantee eviction. fs_bdev_mark_dead() runs with SB_ACTIVE set, so iput()
may retain the inode in cache, whereas evict_inodes() must evict eligible
zero-reference inodes. The inode may also have been freed when iput()
returns, so the walker cannot then use it to force eviction. Using
I_FREEING preserves the existing eviction behavior without introducing
an additional last-reference transition.

The xfstests auto group passed on ext4 and XFS with known unrelated
failures excluded. No new issues were observed, and the previously
reproducible hung task no longer occurs with this patch.

Fixes: ac05fbb40062 ("inode: don't softlockup when evicting inodes")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20260915044912.3183440-1-sunjunchao@bytedance.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a931126398ced..44891fb7cd436 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -868,7 +868,6 @@ void evict_inodes(struct super_block *sb)
 	struct inode *inode;
 	LIST_HEAD(dispose);
 
-again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (icount_read(inode))
@@ -887,19 +886,19 @@ void evict_inodes(struct super_block *sb)
 		inode->i_state |= I_FREEING;
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
-		list_add(&inode->i_lru, &dispose);
 
 		/*
-		 * We can have a ton of inodes to evict at unmount time given
-		 * enough memory, check to see if we need to go to sleep for a
-		 * bit so we don't livelock.
+		 * Keep this inode out of dispose so it stays on s_inodes while
+		 * the list lock is dropped. I_FREEING prevents new references
+		 * and leaves eviction to us, so we can resume the walk from it.
 		 */
 		if (need_resched()) {
 			spin_unlock(&sb->s_inode_list_lock);
 			cond_resched();
 			dispose_list(&dispose);
-			goto again;
+			spin_lock(&sb->s_inode_list_lock);
 		}
+		list_add(&inode->i_lru, &dispose);
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-- 
2.53.0



