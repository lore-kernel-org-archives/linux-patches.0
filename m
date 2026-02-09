Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14C2690EC;
	Mon,  9 Feb 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648569; cv=none; b=DtAyfmDI4j3CSpanZEJwByP+1BN3EO1JkGW/XYzsdFgNhRkLYjNZUg5DDZEniHz6+sEroh4k62heEoMcbVXII525+Z3waNzqDYbkMlVlFYdwO69/GBANni9RDz71srIs6aT5lKYvvrIyoAzcGEQ7hJVV1tey2ialxX9IfWoZ7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648569; c=relaxed/simple;
	bh=qSRBoLs1BbY8FeSXzyyhlZIgA4w4nrRnkoyZJOgRsiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csZlS7Gw3qMWAQPrrgMXEukKCrbRAFw6DllperuiNqvl6CcCyu+2hykyzL/VNENsyFC9Hdm7T3ZZkNHUP3Ubkjo8cGp4wGFCz2vTrc70uCF7C/Uu0eTXy4KoTEBOhcFxe22/+xq9D0eXVuixUZbXMgyJT640tjzVzvxun95T+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOleinnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOleinnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC10C116C6;
	Mon,  9 Feb 2026 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648569;
	bh=qSRBoLs1BbY8FeSXzyyhlZIgA4w4nrRnkoyZJOgRsiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOleinnQE1dWCElgoWdxJwRCpPrLisyN4MdMArYBS8LFBWfgjpHXwlfxxu7YhZQYQ
	 Hcr6x14OfCJwu+lTKPlTAkc792OIKURiF57i9xHS9xylmWxyYRz50EM/d6X4V6paQo
	 Z7RjX/myIFHvWWtMr7/jELHoKw8bhvexnTfkOjzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 77/86] btrfs: fix racy bitfield write in btrfs_clear_space_info_full()
Date: Mon,  9 Feb 2026 15:24:40 +0100
Message-ID: <20260209142307.546541076@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 38e818718c5e04961eea0fa8feff3f100ce40408 upstream.

>From the memory-barriers.txt document regarding memory barrier ordering
guarantees:

 (*) These guarantees do not apply to bitfields, because compilers often
     generate code to modify these using non-atomic read-modify-write
     sequences.  Do not attempt to use bitfields to synchronize parallel
     algorithms.

 (*) Even in cases where bitfields are protected by locks, all fields
     in a given bitfield must be protected by one lock.  If two fields
     in a given bitfield are protected by different locks, the compiler's
     non-atomic read-modify-write sequences can cause an update to one
     field to corrupt the value of an adjacent field.

btrfs_space_info has a bitfield sharing an underlying word consisting of
the fields full, chunk_alloc, and flush:

struct btrfs_space_info {
        struct btrfs_fs_info *     fs_info;              /*     0     8 */
        struct btrfs_space_info *  parent;               /*     8     8 */
        ...
        int                        clamp;                /*   172     4 */
        unsigned int               full:1;               /*   176: 0  4 */
        unsigned int               chunk_alloc:1;        /*   176: 1  4 */
        unsigned int               flush:1;              /*   176: 2  4 */
        ...

Therefore, to be safe from parallel read-modify-writes losing a write to
one of the bitfield members protected by a lock, all writes to all the
bitfields must use the lock. They almost universally do, except for
btrfs_clear_space_info_full() which iterates over the space_infos and
writes out found->full = 0 without a lock.

Imagine that we have one thread completing a transaction in which we
finished deleting a block_group and are thus calling
btrfs_clear_space_info_full() while simultaneously the data reclaim
ticket infrastructure is running do_async_reclaim_data_space():

          T1                                             T2
btrfs_commit_transaction
  btrfs_clear_space_info_full
  data_sinfo->full = 0
  READ: full:0, chunk_alloc:0, flush:1
                                              do_async_reclaim_data_space(data_sinfo)
                                              spin_lock(&space_info->lock);
                                              if(list_empty(tickets))
                                                space_info->flush = 0;
                                                READ: full: 0, chunk_alloc:0, flush:1
                                                MOD/WRITE: full: 0, chunk_alloc:0, flush:0
                                                spin_unlock(&space_info->lock);
                                                return;
  MOD/WRITE: full:0, chunk_alloc:0, flush:1

and now data_sinfo->flush is 1 but the reclaim worker has exited. This
breaks the invariant that flush is 0 iff there is no work queued or
running. Once this invariant is violated, future allocations that go
into __reserve_bytes() will add tickets to space_info->tickets but will
see space_info->flush is set to 1 and not queue the work. After this,
they will block forever on the resulting ticket, as it is now impossible
to kick the worker again.

I also confirmed by looking at the assembly of the affected kernel that
it is doing RMW operations. For example, to set the flush (3rd) bit to 0,
the assembly is:
  andb    $0xfb,0x60(%rbx)
and similarly for setting the full (1st) bit to 0:
  andb    $0xfe,-0x20(%rax)

So I think this is really a bug on practical systems.  I have observed
a number of systems in this exact state, but am currently unable to
reproduce it.

Rather than leaving this footgun lying around for the future, take
advantage of the fact that there is room in the struct anyway, and that
it is already quite large and simply change the three bitfield members to
bools. This avoids writes to space_info->full having any effect on
writes to space_info->flush, regardless of locking.

Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ The context change is due to the commit cc0517fe779f
  ("btrfs: tweak extent/chunk allocation for space_info sub-space")
  in v6.16 which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    6 +++---
 fs/btrfs/space-info.c  |   22 +++++++++++-----------
 fs/btrfs/space-info.h  |    6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4156,7 +4156,7 @@ int btrfs_chunk_alloc(struct btrfs_trans
 			mutex_unlock(&fs_info->chunk_mutex);
 		} else {
 			/* Proceed with allocation */
-			space_info->chunk_alloc = 1;
+			space_info->chunk_alloc = true;
 			wait_for_alloc = false;
 			spin_unlock(&space_info->lock);
 		}
@@ -4205,7 +4205,7 @@ int btrfs_chunk_alloc(struct btrfs_trans
 	spin_lock(&space_info->lock);
 	if (ret < 0) {
 		if (ret == -ENOSPC)
-			space_info->full = 1;
+			space_info->full = true;
 		else
 			goto out;
 	} else {
@@ -4215,7 +4215,7 @@ int btrfs_chunk_alloc(struct btrfs_trans
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
 out:
-	space_info->chunk_alloc = 0;
+	space_info->chunk_alloc = false;
 	spin_unlock(&space_info->lock);
 	mutex_unlock(&fs_info->chunk_mutex);
 
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -182,7 +182,7 @@ void btrfs_clear_space_info_full(struct
 	struct btrfs_space_info *found;
 
 	list_for_each_entry(found, head, list)
-		found->full = 0;
+		found->full = false;
 }
 
 /*
@@ -361,7 +361,7 @@ void btrfs_add_bg_to_space_info(struct b
 	found->bytes_readonly += block_group->bytes_super;
 	btrfs_space_info_update_bytes_zone_unusable(info, found, block_group->zone_unusable);
 	if (block_group->length > 0)
-		found->full = 0;
+		found->full = false;
 	btrfs_try_granting_tickets(info, found);
 	spin_unlock(&found->lock);
 
@@ -1103,7 +1103,7 @@ static void btrfs_async_reclaim_metadata
 	spin_lock(&space_info->lock);
 	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info);
 	if (!to_reclaim) {
-		space_info->flush = 0;
+		space_info->flush = false;
 		spin_unlock(&space_info->lock);
 		return;
 	}
@@ -1115,7 +1115,7 @@ static void btrfs_async_reclaim_metadata
 		flush_space(fs_info, space_info, to_reclaim, flush_state, false);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
-			space_info->flush = 0;
+			space_info->flush = false;
 			spin_unlock(&space_info->lock);
 			return;
 		}
@@ -1158,7 +1158,7 @@ static void btrfs_async_reclaim_metadata
 					flush_state = FLUSH_DELAYED_ITEMS_NR;
 					commit_cycles--;
 				} else {
-					space_info->flush = 0;
+					space_info->flush = false;
 				}
 			} else {
 				flush_state = FLUSH_DELAYED_ITEMS_NR;
@@ -1320,7 +1320,7 @@ static void btrfs_async_reclaim_data_spa
 
 	spin_lock(&space_info->lock);
 	if (list_empty(&space_info->tickets)) {
-		space_info->flush = 0;
+		space_info->flush = false;
 		spin_unlock(&space_info->lock);
 		return;
 	}
@@ -1331,7 +1331,7 @@ static void btrfs_async_reclaim_data_spa
 		flush_space(fs_info, space_info, U64_MAX, ALLOC_CHUNK_FORCE, false);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
-			space_info->flush = 0;
+			space_info->flush = false;
 			spin_unlock(&space_info->lock);
 			return;
 		}
@@ -1348,7 +1348,7 @@ static void btrfs_async_reclaim_data_spa
 			    data_flush_states[flush_state], false);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
-			space_info->flush = 0;
+			space_info->flush = false;
 			spin_unlock(&space_info->lock);
 			return;
 		}
@@ -1365,7 +1365,7 @@ static void btrfs_async_reclaim_data_spa
 				if (maybe_fail_all_tickets(fs_info, space_info))
 					flush_state = 0;
 				else
-					space_info->flush = 0;
+					space_info->flush = false;
 			} else {
 				flush_state = 0;
 			}
@@ -1381,7 +1381,7 @@ static void btrfs_async_reclaim_data_spa
 
 aborted_fs:
 	maybe_fail_all_tickets(fs_info, space_info);
-	space_info->flush = 0;
+	space_info->flush = false;
 	spin_unlock(&space_info->lock);
 }
 
@@ -1750,7 +1750,7 @@ static int __reserve_bytes(struct btrfs_
 				 */
 				maybe_clamp_preempt(fs_info, space_info);
 
-				space_info->flush = 1;
+				space_info->flush = true;
 				trace_btrfs_trigger_flush(fs_info,
 							  space_info->flags,
 							  orig_bytes, flush,
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -126,11 +126,11 @@ struct btrfs_space_info {
 				   flushing. The value is >> clamp, so turns
 				   out to be a 2^clamp divisor. */
 
-	unsigned int full:1;	/* indicates that we cannot allocate any more
+	bool full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
-	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
+	bool chunk_alloc;	/* set if we are allocating a chunk */
 
-	unsigned int flush:1;		/* set if we are trying to make space */
+	bool flush;		/* set if we are trying to make space */
 
 	unsigned int force_alloc;	/* set if we need to force a chunk
 					   alloc for this space */


