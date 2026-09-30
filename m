Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43736E467;
	Wed, 30 Sep 2026 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787093; cv=none; b=MlbvuaQBz38oRefDWJ/qlWXCgMB4NJJ/zkFWUug/6JY+F+Vj/Sq7uXqsDbOHg0OIcGJ+fW/4FbA0bFjFJNaTNb7NCcYdEi7ESy4WGkBIgfdWyCtUGTkRm8BaGJ7s2vs/K7ROlZ1ji5MBZaGDEV/1Z0jBQxmhi7ACUeOkZumxL3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787093; c=relaxed/simple;
	bh=0AnBNIWW8jXnUIcje7j+Qh4ECNzr+vJNiqJnp2bLlt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paoYNhHsATyFjg7Y8xLQk0PF2yppiSmDg/F0i9vxwBQCg6FX6Lkr6rQrhCOkR1pQ8TyiMQ2ur86NlqzopaeSV3vCmoI13BvNSUKI/XdSlojaU8CfnJiWv6lo5NVzLlZ3dMCqa+5V3/sZ8yLXSZ+VGY4fF64F/+YxDNWhh3Elh6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9gr50wY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9gr50wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0AF1F00893;
	Wed, 30 Sep 2026 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787092;
	bh=lq3E9c1jpd42Gx3rUMsJ8XgVR6UdkkJaeVdvGGXB62c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9gr50wY8sgG83tqDxxHRRf+ewSjJSY3Z3Tm5MNbmxRDosiRc/TAqzVUAeYgH+0In
	 vbe916okUeaxqYpYZvTVaiqiuLw3L4zyvgV0i3spX5gnbfEMlC0YXBciYp2VAjGmht
	 pNUQAyTwAqnYuE8ZHfYFFCyMq0CflhJHSSddOlY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 065/457] fs: avoid repeated scans in evict_inodes()
Date: Wed, 30 Sep 2026 17:22:50 +0200
Message-ID: <20260930152347.446320629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 95e981b4e19c9..c6b08e8c5f627 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -883,7 +883,6 @@ void evict_inodes(struct super_block *sb)
 	struct inode *inode;
 	LIST_HEAD(dispose);
 
-again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (icount_read_once(inode))
@@ -902,19 +901,19 @@ void evict_inodes(struct super_block *sb)
 		inode_state_set(inode, I_FREEING);
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



