Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95E114A4E6;
	Tue, 20 Feb 2024 21:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464455; cv=none; b=WGTamHASR19u48+QU0JfaUoHoH5vH6mn6AiYyF0cZtvZR3q2O4YaVCId7RPGE8kLIVPPPuoRCdg43jFn9Np0jC2b+JNV8YowGSpCGcvaNlGIKSZt9mmSAmOmFtGUGZs53oD4BIuYdBBEy59aBYT3kezttaqBnbtkLZksWg7zJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464455; c=relaxed/simple;
	bh=SlVUg3tRu4R8AniT3ivfLxRQKOF0qGMBvwnz7kSbbrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f38ATuSNqWDLEUn1sF8ibMhfYwXNw8z+uSyfkQEgv9GB9PaCQlPnxOP8to/duH5jbx9uO684O1W1otKNNN2O1TV3dLBFZNjAOFh/WDbpDS+bLW5orPqC+fy9pxrKxcgMN35gkJ6PHB+2sKwH/Mu3cCzxSHq7ebwVVVdbkCZtc5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AReNLZ+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AReNLZ+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A88C433F1;
	Tue, 20 Feb 2024 21:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464454;
	bh=SlVUg3tRu4R8AniT3ivfLxRQKOF0qGMBvwnz7kSbbrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AReNLZ+nm7LGWYcwF6Cm6Uj3uhdeNQWbeujm+XTy+xIBAfYHecNkUkcnfgV0nwE85
	 5noQVLxkFxmz8XSuDh+ivncnsMGrtyQiBfn/eUzgfwol7VW88DrsmOPpgCCOi4BYZj
	 taJCSk49rH4zTyQZy1rFaYA6IqZWWutUBLmwWJ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Heddxh <g311571057@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 008/309] btrfs: dont refill whole delayed refs block reserve when starting transaction
Date: Tue, 20 Feb 2024 21:52:47 +0100
Message-ID: <20240220205633.395727292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2f6397e448e689adf57e6788c90f913abd7e1af8 upstream.

Since commit 28270e25c69a ("btrfs: always reserve space for delayed refs
when starting transaction") we started not only to reserve metadata space
for the delayed refs a caller of btrfs_start_transaction() might generate
but also to try to fully refill the delayed refs block reserve, because
there are several case where we generate delayed refs and haven't reserved
space for them, relying on the global block reserve. Relying too much on
the global block reserve is not always safe, and can result in hitting
-ENOSPC during transaction commits or worst, in rare cases, being unable
to mount a filesystem that needs to do orphan cleanup or anything that
requires modifying the filesystem during mount, and has no more
unallocated space and the metadata space is nearly full. This was
explained in detail in that commit's change log.

However the gap between the reserved amount and the size of the delayed
refs block reserve can be huge, so attempting to reserve space for such
a gap can result in allocating many metadata block groups that end up
not being used. After a recent patch, with the subject:

  "btrfs: add new unused block groups to the list of unused block groups"

We started to add new block groups that are unused to the list of unused
block groups, to avoid having them around for a very long time in case
they are never used, because a block group is only added to the list of
unused block groups when we deallocate the last extent or when mounting
the filesystem and the block group has 0 bytes used. This is not a problem
introduced by the commit mentioned earlier, it always existed as our
metadata space reservations are, most of the time, pessimistic and end up
not using all the space they reserved, so we can occasionally end up with
one or two unused metadata block groups for a long period. However after
that commit mentioned earlier, we are just more pessimistic in the
metadata space reservations when starting a transaction and therefore the
issue is more likely to happen.

This however is not always enough because we might create unused metadata
block groups when reserving metadata space at a high rate if there's
always a gap in the delayed refs block reserve and the cleaner kthread
isn't triggered often enough or is busy with other work (running delayed
iputs, cleaning deleted roots, etc), not to mention the block group's
allocated space is only usable for a new block group after the transaction
used to remove it is committed.

A user reported that he's getting a lot of allocated metadata block groups
but the usage percentage of metadata space was very low compared to the
total allocated space, specially after running a series of block group
relocations.

So for now stop trying to refill the gap in the delayed refs block reserve
and reserve space only for the delayed refs we are expected to generate
when starting a transaction.

CC: stable@vger.kernel.org # 6.7+
Reported-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/9cdbf0ca9cdda1b4c84e15e548af7d7f9f926382.camel@intelfx.name/
Link: https://lore.kernel.org/linux-btrfs/CAL3q7H6802ayLHUJFztzZAVzBLJAGdFx=6FHNNy87+obZXXZpQ@mail.gmail.com/
Tested-by: Ivan Shapovalov <intelfx@intelfx.name>
Reported-by: Heddxh <g311571057@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAE93xANEby6RezOD=zcofENYZOT-wpYygJyauyUAZkLv6XVFOA@mail.gmail.com/
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |   38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -564,56 +564,22 @@ static int btrfs_reserve_trans_metadata(
 					u64 num_bytes,
 					u64 *delayed_refs_bytes)
 {
-	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
 	struct btrfs_space_info *si = fs_info->trans_block_rsv.space_info;
-	u64 extra_delayed_refs_bytes = 0;
-	u64 bytes;
+	u64 bytes = num_bytes + *delayed_refs_bytes;
 	int ret;
 
 	/*
-	 * If there's a gap between the size of the delayed refs reserve and
-	 * its reserved space, than some tasks have added delayed refs or bumped
-	 * its size otherwise (due to block group creation or removal, or block
-	 * group item update). Also try to allocate that gap in order to prevent
-	 * using (and possibly abusing) the global reserve when committing the
-	 * transaction.
-	 */
-	if (flush == BTRFS_RESERVE_FLUSH_ALL &&
-	    !btrfs_block_rsv_full(delayed_refs_rsv)) {
-		spin_lock(&delayed_refs_rsv->lock);
-		if (delayed_refs_rsv->size > delayed_refs_rsv->reserved)
-			extra_delayed_refs_bytes = delayed_refs_rsv->size -
-				delayed_refs_rsv->reserved;
-		spin_unlock(&delayed_refs_rsv->lock);
-	}
-
-	bytes = num_bytes + *delayed_refs_bytes + extra_delayed_refs_bytes;
-
-	/*
 	 * We want to reserve all the bytes we may need all at once, so we only
 	 * do 1 enospc flushing cycle per transaction start.
 	 */
 	ret = btrfs_reserve_metadata_bytes(fs_info, si, bytes, flush);
-	if (ret == 0) {
-		if (extra_delayed_refs_bytes > 0)
-			btrfs_migrate_to_delayed_refs_rsv(fs_info,
-							  extra_delayed_refs_bytes);
-		return 0;
-	}
-
-	if (extra_delayed_refs_bytes > 0) {
-		bytes -= extra_delayed_refs_bytes;
-		ret = btrfs_reserve_metadata_bytes(fs_info, si, bytes, flush);
-		if (ret == 0)
-			return 0;
-	}
 
 	/*
 	 * If we are an emergency flush, which can steal from the global block
 	 * reserve, then attempt to not reserve space for the delayed refs, as
 	 * we will consume space for them from the global block reserve.
 	 */
-	if (flush == BTRFS_RESERVE_FLUSH_ALL_STEAL) {
+	if (ret && flush == BTRFS_RESERVE_FLUSH_ALL_STEAL) {
 		bytes -= *delayed_refs_bytes;
 		*delayed_refs_bytes = 0;
 		ret = btrfs_reserve_metadata_bytes(fs_info, si, bytes, flush);


