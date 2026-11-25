Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619773;
	b=5fmQI/z4isneIIyF8MFW31pynzLKH/sohPLQA6ph1+VuzZvZt3YsjKyVnSdtHNMPJd5f
	 ZFOxJ3JtFNjrgvtqmgBekDo0/DDYN4fMlwQB2NuJfCKAZ40YL8pIM0QV5Fy4FGXZ9hnYS
	 jivNjKHnr7Tfcd+nt9Uz5+QdHJTa4eHpcoXl3t/Sa84VuBNNbOaqMpvTw8uXulwS4phk/
	 3GgMkBKXE4PMQyzwo35dk9CaByBcofuXutBt18aCWIQ1oy4aj1O3bIVZ8PrO0PPIHSC50
	 i9q+KbpmwDc1STmYsUA6r+6iVpwAzJP80XWh1E1cJMnhd6xX15MWX/HrTW1AvUCU52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UP2WusgjufOtwplKHHGb69WTwZJ4D+2o7fHDFg6jK+Y=;
	b=0FkBxe/4Zkq0GT3ItmV1nKwBSJSq+d1jPhECjmA/Nb3b6yal5G/E6ljSvdlj5+MTCsPr
	 y8OhSL+begX6/rxkced9CAsM+HQo5RIQwkRX9h0JPhcLh2+mujr6XTTyKapAkXn0GJCym
	 gGpXwprFVz/vAPalrcbcRyn9N7kDBTw0pN5Zv/QTtNbJvcX81kiSGSleWDgcXEgxiqksI
	 2uum/Jcakg27YgvphnByRO9c5zv+6ocjsAxEHHvs59M5/KfqzJRvrT2Mz0eFtKTiYht2C
	 nrW2b64/lbuC0gCXrJmkmi90YFjBbqAEzh+VhC4Rw7Yy2mu+eO6n62LAPzHxCdUUaqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKEG523x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18737606A32C;
	Wed, 25 Nov 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKEG523x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17A01F000C4;
	Wed, 25 Nov 2026 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619772;
	bh=UP2WusgjufOtwplKHHGb69WTwZJ4D+2o7fHDFg6jK+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKEG523x0R0TI95vZYcwky25IEySBp4Bt5vlqobHUXdLjx/9BuNA2krs4ALbbcwlc
	 7jkKCDWCyGXrHACZBQmHAW6msOiyDe8IPcl1QBBO2/s0I9nKStDwD/0f2pfaCpqekb
	 Uy50cccEHCr0VIsCokn8PgA/uz5MKNZZWLYGLW10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0704/1005] fs: dont strand I_METADATA_WRITEBACK inodes outside the LRU
Date: Wed, 25 Nov 2026 15:34:02 +0100
Message-ID: <20261125143838.250306515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 9b4b26d110f32008134750f82c98e621f2e4758f upstream.

Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
metadata writeback") ext2, ext4 without a journal, fat, udf and minix
set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
buffer that might not have reached the disk yet. Only data integrity
writeback, i.e. fsync() and friends, clears it again. The flusher and
sync(2) leave it alone.

inode_lru_isolate() treats every state bit other than I_REFERENCED as a
reason not to reclaim the inode right now. It takes the inode off the
LRU and relies on iput(), writeback completion or the removal of the
last page from the page cache to put it back once the reason is gone.

But I_METADATA_WRITEBACK doesn't go away on its own. iput() puts the
inode back on the LRU with the bit still set and the next scan takes it
off again. So neither memory pressure nor drop_caches can free these
inodes. Only fsync() and friends or unmounting the filesystem get rid
of them.

On ext4 without a journal ext4_mark_iloc_dirty() sets the bit on every
ext4_mark_inode_dirty(), so even an atime update is enough. An
unprivileged user creating or touching lots of files grows the inode
cache without bound until the OOM killer comes along.

The inode can't just be thrown away though. An fsync() after the inode
was read back in wouldn't know that its metadata still has to be
written out. So let the shrinker reclaim inodes with
I_METADATA_WRITEBACK like any other clean inode and make evict() write
out what the bit tracks unless the inode is being deleted. Since the
previous patch the bit covers the tracked metadata buffers as well, and
since the lookup patches ->sync_inode_metadata() doesn't read anything
from disk for that. It writes and waits for whatever is still dirty or
under writeback. The mmb_sync() calls in ->evict_inode() are redundant
with that and the following patches drop them.

Handing these inodes to a work item that syncs them and puts them back
on the LRU would work too. But that's a second inode reclaim offload
mechanism next to the deferred inode reclaim that is being worked on,
and it needs a reference on the inode which leaks into remount, freeze
and umount.

For stable this needs the previous patches as well. Without the lookup
changes evict() ends up reading inode blocks from disk with
__GFP_NOFAIL allocations from reclaim. v7.3 also still has bfs which
sets I_METADATA_WRITEBACK too and reads the inode block in
bfs_sync_inode_metadata(), so the backport needs the cache-only lookup
for bfs as well.

Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata writeback")
Cc: stable@vger.kernel.org # v7.3; see patch description
Reported-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9cbcb0de7dfc..de207f2f95a9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -817,6 +817,14 @@ static void evict(struct inode *inode)
 	inode_wait_for_writeback(inode);
 	spin_unlock(&inode->i_lock);
 
+	/*
+	 * fsync() can't find what I_METADATA_WRITEBACK tracks anymore once the
+	 * inode is gone, so write it out unless the inode is being deleted.
+	 */
+	if (inode->i_nlink &&
+	    (inode_state_read_once(inode) & I_METADATA_WRITEBACK))
+		sync_inode_metadata(inode, 1);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
@@ -952,9 +960,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * they're already on the LRU, and this can make them
 	 * unreclaimable for a while. Remove them lazily here; iput,
 	 * sync, or the last page cache deletion will requeue them.
+	 * Nothing requeues them for I_METADATA_WRITEBACK, evict() writes
+	 * that out instead.
 	 */
 	if (icount_read(inode) ||
-	    (inode_state_read(inode) & ~I_REFERENCED) ||
+	    (inode_state_read(inode) &
+	     ~(I_REFERENCED | I_METADATA_WRITEBACK)) ||
 	    !mapping_shrinkable(&inode->i_data)) {
 		list_lru_isolate(lru, &inode->i_lru);
 		spin_unlock(&inode->i_lock);
-- 
2.56.1



