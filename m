Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590723;
	b=1Jv3EqcUabTfKWps5QHPrKUxF9tOdLrZnkd3ZFsCRSfhXtpVdQcZp/Zqg0FT8/YpdrHU
	 wgUu68g/zIPHhG+ttnfgyzj+IBEyYtwcDwN3DLo1AJ/s1s92OBcOm/M4AOqY4asVIxeyi
	 bdTBJnli33VHOVV+B/j6qvpbRg+3q8HczSwsRrkHc5pZsxhneqm/G5jKAL+pKaPe4AHcf
	 3BXD7qGQQ9qp7XGgEO8kUIIkG7Cea1JTNX/V8QrNGA1rVVEDjvhcJVHOQ5uyNJ7rll3wa
	 +FXyx3Z4BIk5lgu+mVWA4OpNKOlN/fc08ZQWQJXh5WfRqGJWQDr2Poi5ziVQ5A2KLnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fw9k7WBt7cohfyTybSBLTFeSa2XoZ25bBZkVdMsyU2g=;
	b=zfMVjLbpfc3Wgv2EhGKkPtkRL57EJ5BCbV8cFVtH93tAHX8ICYScHLTbJaia2rfcKMS+
	 ruuuAbJkAZIgnumSnh3uNg+44Gou+rAVtzfPDclE5CTHyJUq96J3o2sNy6vkX6GyjebFA
	 a6Q5hqi55FdpRAv+vvsfU/K7sM/GLowP5dnRfUFEGxR5ihcmFOa3b3borfxktJElT/PU0
	 8529U3WalaiHryWmulJemnvLjucPtfJDzFgDHiUo3ziilCW8wsE0oIKsI2Mdw8rNJ0pMp
	 v6XKftnPbvyr4sLcAsWT8Biv0bDJ9ZS8rVj7ssLksNu/TqqMBytKHfGo4q/pAJoz4HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zil5ZOI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E179607A5E8;
	Fri, 13 Nov 2026 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zil5ZOI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC7F1F000C4;
	Fri, 13 Nov 2026 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590723;
	bh=Fw9k7WBt7cohfyTybSBLTFeSa2XoZ25bBZkVdMsyU2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zil5ZOI5aSD2O6R0V0zmBGycWsT0xIhHsoLhhyrpS/ViBcgZj99snMjKmaxiu3EMs
	 mYTQSpdTaksBJBCrYgk32fNqy3gDj7gzqLAILhl6GTNLzDu+9uZbcepTMVx4K9g/VI
	 g29blkSrySxzBezGyNa2ZhCEQ17fCwLmXEHrpMGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 629/686] fs: Ignore inode metadata buffers in inode_lru_isolate()
Date: Fri, 13 Nov 2026 10:52:42 -0500
Message-ID: <20261113153843.154965210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 972b9dd4e4180fbb2352bf2f0e015b7b63f5cca0 ]

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such the logic to reclaim tracked metadata
buffer heads in inode_lru_isolate() doesn't bring a benefit big enough
to justify intertwining of inode reclaim and metadata buffer head
tracking. Just treat tracked metadata buffer heads as any other metadata
filesystem has to properly clean up on inode eviction and stop handling
it in inode_lru_isolate(). As a result filesystems using generic
tracking of metadata buffer heads may now see dirty metadata buffers in
their .evict methods more often which can slow down inode reclaim but
given these filesystems aren't used in performance demanding setups we
should be fine.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260326095354.16340-64-jack@suse.cz
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c                 | 29 -----------------------------
 fs/inode.c                  | 21 +++++++++------------
 include/linux/buffer_head.h |  3 ---
 3 files changed, 9 insertions(+), 44 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 261f521dbc583..b5a1ff2d559fb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -880,35 +880,6 @@ void invalidate_inode_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL(invalidate_inode_buffers);
 
-/*
- * Remove any clean buffers from the inode's buffer list.  This is called
- * when we're trying to free the inode itself.  Those buffers can pin it.
- *
- * Returns true if all buffers were removed.
- */
-int remove_inode_buffers(struct inode *inode)
-{
-	int ret = 1;
-
-	if (inode_has_buffers(inode)) {
-		struct address_space *mapping = &inode->i_data;
-		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
-
-		spin_lock(&buffer_mapping->i_private_lock);
-		while (!list_empty(list)) {
-			struct buffer_head *bh = BH_ENTRY(list->next);
-			if (buffer_dirty(bh)) {
-				ret = 0;
-				break;
-			}
-			__remove_assoc_queue(bh);
-		}
-		spin_unlock(&buffer_mapping->i_private_lock);
-	}
-	return ret;
-}
-
 /*
  * Create the appropriate buffers when given a folio for data area and
  * the size of each buffer.. Use the bh->b_this_page linked list to
diff --git a/fs/inode.c b/fs/inode.c
index 7adfc787e934a..ec58d248a7ed9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -16,7 +16,6 @@
 #include <linux/fsnotify.h>
 #include <linux/mount.h>
 #include <linux/posix_acl.h>
-#include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
 #include <linux/iversion.h>
@@ -366,7 +365,6 @@ struct inode *alloc_inode(struct super_block *sb)
 
 void __destroy_inode(struct inode *inode)
 {
-	BUG_ON(inode_has_buffers(inode));
 	inode_detach_wb(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
@@ -954,19 +952,18 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * page cache in order to free up struct inodes: lowmem might
 	 * be under pressure before the cache inside the highmem zone.
 	 */
-	if (inode_has_buffers(inode) || !mapping_empty(&inode->i_data)) {
+	if (!mapping_empty(&inode->i_data)) {
+		unsigned long reap;
+
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&lru->lock);
-		if (remove_inode_buffers(inode)) {
-			unsigned long reap;
-			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
-			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
-			else
-				__count_vm_events(PGINODESTEAL, reap);
-			mm_account_reclaimed_pages(reap);
-		}
+		reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
+		if (current_is_kswapd())
+			__count_vm_events(KSWAPD_INODESTEAL, reap);
+		else
+			__count_vm_events(PGINODESTEAL, reap);
+		mm_account_reclaimed_pages(reap);
 		inode_unpin_lru_isolating(inode);
 		return LRU_RETRY;
 	}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e7..631bf971efc04 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -517,7 +517,6 @@ void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
 int inode_has_buffers(struct inode *inode);
 void invalidate_inode_buffers(struct inode *inode);
-int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
@@ -528,9 +527,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
-static inline int inode_has_buffers(struct inode *inode) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
-- 
2.53.0



