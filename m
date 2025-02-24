Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C784D165F16;
	Mon, 24 Feb 2025 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407857; cv=none; b=lmFMnkp/XXK1RfbWQgOPadwB3MgjCFGShKv8NqP/p7aulyaVXtalNuJ1jChsLb/wK9nA4OPkj+lk/HyCfAzH0a0zQlm5PDa+NWVlI+hyDJFqP3SBRZMLZLRoCyRhqSpWxpnuRhq0N0mVeVuJHNgbsGKgPs9H+X7/+ekJsa/LFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407857; c=relaxed/simple;
	bh=ZQz07TkbcnmvuXeV8QH3uOd7xKvMTQ2s9PRhbn/xnME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geh6QaFzcmwGhcoEjIIxNW0etiEPXWS6OilklBxwDE3ipPjUJY3w4INUQTYAAtSED6yDA7C0Vo3OD86Cwm/EVx7ir/CS7Pstk74PDhnc01Fj5laNgiWUh8X+vt9wNRIAEb6ekzim8Bd1b67B2Dk1jQ58rEgetl4glTSkph8pz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUg/4iED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUg/4iED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E68CC4CED6;
	Mon, 24 Feb 2025 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407857;
	bh=ZQz07TkbcnmvuXeV8QH3uOd7xKvMTQ2s9PRhbn/xnME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUg/4iED7nxWR0ovrxNCRcXqX+sNVDw2EirV2zHoW0CN5ZbgYhZnmAioLDXfHUy73
	 HEcH7L2ebSFuqkbw9zWsuzdMn5W1f3IT7HtTkf3UyiAp8HgCn9Znd8rLEvkHnZ3btD
	 rKfwHyeQjnTFrQB3J3iPNxSuOZB9Hd60bIVgspqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Darrick Wong <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 006/140] xfs: skip background cowblock trims on inodes open for write
Date: Mon, 24 Feb 2025 15:33:25 +0100
Message-ID: <20250224142603.256386231@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Brian Foster <bfoster@redhat.com>

commit 90a71daaf73f5d39bb0cbb3c7ab6af942fe6233e upstream.

The background blockgc scanner runs on a 5m interval by default and
trims preallocation (post-eof and cow fork) from inodes that are
otherwise idle. Idle effectively means that iolock can be acquired
without blocking and that the inode has no dirty pagecache or I/O in
flight.

This simple mechanism and heuristic has worked fairly well for
post-eof speculative preallocations. Support for reflink and COW
fork preallocations came sometime later and plugged into the same
mechanism, with similar heuristics. Some recent testing has shown
that COW fork preallocation may be notably more sensitive to blockgc
processing than post-eof preallocation, however.

For example, consider an 8GB reflinked file with a COW extent size
hint of 1MB. A worst case fully randomized overwrite of this file
results in ~8k extents of an average size of ~1MB. If the same
workload is interrupted a couple times for blockgc processing
(assuming the file goes idle), the resulting extent count explodes
to over 100k extents with an average size <100kB. This is
significantly worse than ideal and essentially defeats the COW
extent size hint mechanism.

While this particular test is instrumented, it reflects a fairly
reasonable pattern in practice where random I/Os might spread out
over a large period of time with varying periods of (in)activity.
For example, consider a cloned disk image file for a VM or container
with long uptime and variable and bursty usage. A background blockgc
scan that races and processes the image file when it happens to be
clean and idle can have a significant effect on the future
fragmentation level of the file, even when still in use.

To help combat this, update the heuristic to skip cowblocks inodes
that are currently opened for write access during non-sync blockgc
scans. This allows COW fork preallocations to persist for as long as
possible unless otherwise needed for functional purposes (i.e. a
sync scan), the file is idle and closed, or the inode is being
evicted from cache. While here, update the comments to help
distinguish performance oriented heuristics from the logic that
exists to maintain functional correctness.

Suggested-by: Darrick Wong <djwong@kernel.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1234,14 +1234,17 @@ xfs_inode_clear_eofblocks_tag(
 }
 
 /*
- * Set ourselves up to free CoW blocks from this file.  If it's already clean
- * then we can bail out quickly, but otherwise we must back off if the file
- * is undergoing some kind of write.
+ * Prepare to free COW fork blocks from an inode.
  */
 static bool
 xfs_prep_free_cowblocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_icwalk	*icw)
 {
+	bool			sync;
+
+	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
+
 	/*
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
@@ -1253,9 +1256,21 @@ xfs_prep_free_cowblocks(
 	}
 
 	/*
-	 * If the mapping is dirty or under writeback we cannot touch the
-	 * CoW fork.  Leave it alone if we're in the midst of a directio.
+	 * A cowblocks trim of an inode can have a significant effect on
+	 * fragmentation even when a reasonable COW extent size hint is set.
+	 * Therefore, we prefer to not process cowblocks unless they are clean
+	 * and idle. We can never process a cowblocks inode that is dirty or has
+	 * in-flight I/O under any circumstances, because outstanding writeback
+	 * or dio expects targeted COW fork blocks exist through write
+	 * completion where they can be remapped into the data fork.
+	 *
+	 * Therefore, the heuristic used here is to never process inodes
+	 * currently opened for write from background (i.e. non-sync) scans. For
+	 * sync scans, use the pagecache/dio state of the inode to ensure we
+	 * never free COW fork blocks out from under pending I/O.
 	 */
+	if (!sync && inode_is_open_for_write(VFS_I(ip)))
+		return false;
 	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
@@ -1291,7 +1306,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
 
-	if (!xfs_prep_free_cowblocks(ip))
+	if (!xfs_prep_free_cowblocks(ip, icw))
 		return 0;
 
 	if (!xfs_icwalk_match(ip, icw))
@@ -1320,7 +1335,7 @@ xfs_inode_free_cowblocks(
 	 * Check again, nobody else should be able to dirty blocks or change
 	 * the reflink iflag now that we have the first two locks held.
 	 */
-	if (xfs_prep_free_cowblocks(ip))
+	if (xfs_prep_free_cowblocks(ip, icw))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 	return ret;
 }


