Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B751DFE27;
	Wed,  6 Nov 2024 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896537; cv=none; b=m5W5cLJzxLuqLYlKVAu138j36uvEpkJzI8TJ9/SP8Nj/C0td0Bhs4enjq7IHjgVHdLuxdgNJjLNXa3vsqkS8tsEkKYuWK02srlxMqwITMmcKX/WbwE2uiSzuVmSRiK2v7XKQ7mZusOEKVX1AHy4tzyQf59QIKnfHjxvnJaDbIkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896537; c=relaxed/simple;
	bh=VUqj7FqhSFCJshF03GbNyvrsEdQOhkq6VB2dcBIF6KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPsLLnC2y41z4CGDPQi1FHubDyBIs6RIBkHE2xmTv/YqN/ENnJf8D8uNjj5sbWuLMrxW79YXqv4ul26xHEHxHGyV5fpUthbZzm+n+qUfyed9hqrGBU+bhc7LvE22mafkdHJOFkcI74m6ssKvzKs4WJhpcdCZv6VcxHI6r3HWRnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgeXJ4zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgeXJ4zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8394C4CED6;
	Wed,  6 Nov 2024 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896537;
	bh=VUqj7FqhSFCJshF03GbNyvrsEdQOhkq6VB2dcBIF6KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgeXJ4zkAsdtoqlL/HwXCBNBmsG7wiBTpB11vFneIuMNEpiZ2UR35kkHa4QJMmGVx
	 FiJa7F6zT88moa0HVHtFwLzhISxH+OMM9t0It+eAD9khUHnuf6k/DYh9atUiYKkFvD
	 zl/YiUFZyOxjMBLNNodDZFq0XlaKUIih1QJuMonI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 199/245] btrfs: fix defrag not merging contiguous extents due to merged extent maps
Date: Wed,  6 Nov 2024 13:04:12 +0100
Message-ID: <20241106120324.142570495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 77b0d113eec49a7390ff1a08ca1923e89f5f86c6 ]

When running defrag (manual defrag) against a file that has extents that
are contiguous and we already have the respective extent maps loaded and
merged, we end up not defragging the range covered by those contiguous
extents. This happens when we have an extent map that was the result of
merging multiple extent maps for contiguous extents and the length of the
merged extent map is greater than or equals to the defrag threshold
length.

The script below reproduces this scenario:

   $ cat test.sh
   #!/bin/bash

   DEV=/dev/sdi
   MNT=/mnt/sdi

   mkfs.btrfs -f $DEV
   mount $DEV $MNT

   # Create a 256K file with 4 extents of 64K each.
   xfs_io -f -c "falloc 0 64K" \
             -c "pwrite 0 64K" \
             -c "falloc 64K 64K" \
             -c "pwrite 64K 64K" \
             -c "falloc 128K 64K" \
             -c "pwrite 128K 64K" \
             -c "falloc 192K 64K" \
             -c "pwrite 192K 64K" \
             $MNT/foo

   umount $MNT
   echo -n "Initial number of file extent items: "
   btrfs inspect-internal dump-tree -t 5 $DEV | grep EXTENT_DATA | wc -l

   mount $DEV $MNT
   # Read the whole file in order to load and merge extent maps.
   cat $MNT/foo > /dev/null

   btrfs filesystem defragment -t 128K $MNT/foo
   umount $MNT
   echo -n "Number of file extent items after defrag with 128K threshold: "
   btrfs inspect-internal dump-tree -t 5 $DEV | grep EXTENT_DATA | wc -l

   mount $DEV $MNT
   # Read the whole file in order to load and merge extent maps.
   cat $MNT/foo > /dev/null

   btrfs filesystem defragment -t 256K $MNT/foo
   umount $MNT
   echo -n "Number of file extent items after defrag with 256K threshold: "
   btrfs inspect-internal dump-tree -t 5 $DEV | grep EXTENT_DATA | wc -l

Running it:

   $ ./test.sh
   Initial number of file extent items: 4
   Number of file extent items after defrag with 128K threshold: 4
   Number of file extent items after defrag with 256K threshold: 4

The 4 extents don't get merged because we have an extent map with a size
of 256K that is the result of merging the individual extent maps for each
of the four 64K extents and at defrag_lookup_extent() we have a value of
zero for the generation threshold ('newer_than' argument) since this is a
manual defrag. As a consequence we don't call defrag_get_extent() to get
an extent map representing a single file extent item in the inode's
subvolume tree, so we end up using the merged extent map at
defrag_collect_targets() and decide not to defrag.

Fix this by updating defrag_lookup_extent() to always discard extent maps
that were merged and call defrag_get_extent() regardless of the minimum
generation threshold ('newer_than' argument).

A test case for fstests will be sent along soon.

CC: stable@vger.kernel.org # 6.1+
Fixes: 199257a78bb0 ("btrfs: defrag: don't use merged extent map for their generation check")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/defrag.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index f6dbda37a3615..990ef97accec4 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -772,12 +772,12 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
 	 * We can get a merged extent, in that case, we need to re-search
 	 * tree to get the original em for defrag.
 	 *
-	 * If @newer_than is 0 or em::generation < newer_than, we can trust
-	 * this em, as either we don't care about the generation, or the
-	 * merged extent map will be rejected anyway.
+	 * This is because even if we have adjacent extents that are contiguous
+	 * and compatible (same type and flags), we still want to defrag them
+	 * so that we use less metadata (extent items in the extent tree and
+	 * file extent items in the inode's subvolume tree).
 	 */
-	if (em && (em->flags & EXTENT_FLAG_MERGED) &&
-	    newer_than && em->generation >= newer_than) {
+	if (em && (em->flags & EXTENT_FLAG_MERGED)) {
 		free_extent_map(em);
 		em = NULL;
 	}
-- 
2.43.0



