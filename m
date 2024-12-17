Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA17F1F8924;
	Tue, 17 Dec 2024 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456397; cv=none; b=PU56so0/NCHKLWHmLq2IfRQ7UwEb12+mCOeTWVd08SDm5i0GSei0NOg9fG3uYiPfuXEbk72HquSgz9ohQ9JYXmLdTJeRp1evkUafvj6SddokEeXdo8VmKPGye1seqJLfyfCNY5wvTUBg+LAvBonL16oU7PofpUUI3ZZI/7QVeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456397; c=relaxed/simple;
	bh=IZ5Mm3P7hT7aHiEK6Ygf39qkxmpZy8OKsEW3/VCQUQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyqWZVkHLypzuk+ekw3NFp3Doui6kovAQjh/8l4CyzR+mkxpvcr16HG221lCQJ/4wC7hZb6sn4diO9DE+AHm+XG9JOmXT8j3dfTcejJSSy9I4Qv4EfWskXO+56dICnStp9ltaJOfPqaU65kXBLhx+4KvZAXmObTvDbQmn0RFGRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHFkmNIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHFkmNIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CB1C4CED3;
	Tue, 17 Dec 2024 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456397;
	bh=IZ5Mm3P7hT7aHiEK6Ygf39qkxmpZy8OKsEW3/VCQUQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHFkmNImbOSCusUQ1IoJ+nnzgxsBWRREM5VuHFDgZrI6ym8KtblCy4kGXvvB/Lvz1
	 C+vunxYAn+FJeAz4B/gieephXK8a8iG3AHfOp5eE0G4B4kuYNbfixsC7J5bCfeTWtY
	 y0x9p3pxkkc9ISuRbWMb6X7a/0dvUC0rI6By2kXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 017/172] block: Switch to using refcount_t for zone write plugs
Date: Tue, 17 Dec 2024 18:06:13 +0100
Message-ID: <20241217170546.967797482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 4122fef16b172f7c1838fcf74340268c86ed96db upstream.

Replace the raw atomic_t reference counting of zone write plugs with a
refcount_t.  No functional changes.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411050650.ilIZa8S7-lkp@intel.com/
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241107065438.236348-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -18,7 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 #include <linux/spinlock.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/mempool.h>
 
 #include "blk.h"
@@ -64,7 +64,7 @@ static const char *const zone_cond_name[
 struct blk_zone_wplug {
 	struct hlist_node	node;
 	struct list_head	link;
-	atomic_t		ref;
+	refcount_t		ref;
 	spinlock_t		lock;
 	unsigned int		flags;
 	unsigned int		zone_no;
@@ -417,7 +417,7 @@ static struct blk_zone_wplug *disk_get_z
 
 	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
 		if (zwplug->zone_no == zno &&
-		    atomic_inc_not_zero(&zwplug->ref)) {
+		    refcount_inc_not_zero(&zwplug->ref)) {
 			rcu_read_unlock();
 			return zwplug;
 		}
@@ -438,7 +438,7 @@ static void disk_free_zone_wplug_rcu(str
 
 static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
 {
-	if (atomic_dec_and_test(&zwplug->ref)) {
+	if (refcount_dec_and_test(&zwplug->ref)) {
 		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
 		WARN_ON_ONCE(!list_empty(&zwplug->link));
 		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_UNHASHED));
@@ -469,7 +469,7 @@ static inline bool disk_should_remove_zo
 	 * taken when the plug was allocated and another reference taken by the
 	 * caller context).
 	 */
-	if (atomic_read(&zwplug->ref) > 2)
+	if (refcount_read(&zwplug->ref) > 2)
 		return false;
 
 	/* We can remove zone write plugs for zones that are empty or full. */
@@ -539,7 +539,7 @@ again:
 
 	INIT_HLIST_NODE(&zwplug->node);
 	INIT_LIST_HEAD(&zwplug->link);
-	atomic_set(&zwplug->ref, 2);
+	refcount_set(&zwplug->ref, 2);
 	spin_lock_init(&zwplug->lock);
 	zwplug->flags = 0;
 	zwplug->zone_no = zno;
@@ -630,7 +630,7 @@ static inline void disk_zone_wplug_set_e
 	 * finished.
 	 */
 	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
-	atomic_inc(&zwplug->ref);
+	refcount_inc(&zwplug->ref);
 
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
 	list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
@@ -1105,7 +1105,7 @@ static void disk_zone_wplug_schedule_bio
 	 * reference we take here.
 	 */
 	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
-	atomic_inc(&zwplug->ref);
+	refcount_inc(&zwplug->ref);
 	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 }
 
@@ -1450,7 +1450,7 @@ static void disk_destroy_zone_wplugs_has
 		while (!hlist_empty(&disk->zone_wplugs_hash[i])) {
 			zwplug = hlist_entry(disk->zone_wplugs_hash[i].first,
 					     struct blk_zone_wplug, node);
-			atomic_inc(&zwplug->ref);
+			refcount_inc(&zwplug->ref);
 			disk_remove_zone_wplug(disk, zwplug);
 			disk_put_zone_wplug(zwplug);
 		}
@@ -1876,7 +1876,7 @@ int queue_zone_wplugs_show(void *data, s
 			spin_lock_irqsave(&zwplug->lock, flags);
 			zwp_zone_no = zwplug->zone_no;
 			zwp_flags = zwplug->flags;
-			zwp_ref = atomic_read(&zwplug->ref);
+			zwp_ref = refcount_read(&zwplug->ref);
 			zwp_wp_offset = zwplug->wp_offset;
 			zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
 			spin_unlock_irqrestore(&zwplug->lock, flags);


