Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED2A94D
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2663DC433C8;
	Mon, 19 Jun 2023 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172300;
	bh=MJ9SqAkxj+Uz/O9NmUpcMuzKZlxZQhNVDtS3Pv/kHuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z03BmcI8r3A8DsIvxz1RQaI6L9y/603PAGYc/S97ySL7eEKVXTXtj4IBk8O5kWwjT
	 1ILPM9maUntRMa48S6GIyXIcvmVl7cPEs04VzpHC7MMb6I7qOsEnUNxh6sm3JrvDE+
	 Eg6FTd5jh88vlOhWIzHsi8S9o1THtNVm6c4tBM1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/107] btrfs: scrub: try harder to mark RAID56 block groups read-only
Date: Mon, 19 Jun 2023 12:30:03 +0200
Message-ID: <20230619102142.445479856@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 7561551e7ba870b9659083b95feb520fb2dacce3 ]

Currently we allow a block group not to be marked read-only for scrub.

But for RAID56 block groups if we require the block group to be
read-only, then we're allowed to use cached content from scrub stripe to
reduce unnecessary RAID56 reads.

So this patch would:

- Make btrfs_inc_block_group_ro() try harder
  During my tests, for cases like btrfs/061 and btrfs/064, we can hit
  ENOSPC from btrfs_inc_block_group_ro() calls during scrub.

  The reason is if we only have one single data chunk, and trying to
  scrub it, we won't have any space left for any newer data writes.

  But this check should be done by the caller, especially for scrub
  cases we only temporarily mark the chunk read-only.
  And newer data writes would always try to allocate a new data chunk
  when needed.

- Return error for scrub if we failed to mark a RAID56 chunk read-only

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 14 ++++++++++++--
 fs/btrfs/scrub.c       |  9 ++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 19f71c305b988..a76796f153d5f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2576,10 +2576,20 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	}
 
 	ret = inc_block_group_ro(cache, 0);
-	if (!do_chunk_alloc || ret == -ETXTBSY)
-		goto unlock_out;
 	if (!ret)
 		goto out;
+	if (ret == -ETXTBSY)
+		goto unlock_out;
+
+	/*
+	 * Skip chunk alloction if the bg is SYSTEM, this is to avoid system
+	 * chunk allocation storm to exhaust the system chunk array.  Otherwise
+	 * we still want to try our best to mark the block group read-only.
+	 */
+	if (!do_chunk_alloc && ret == -ENOSPC &&
+	    (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM))
+		goto unlock_out;
+
 	alloc_flags = btrfs_get_alloc_profile(fs_info, cache->space_info->flags);
 	ret = btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 	if (ret < 0)
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ca8d6979c7887..0d1715ebdef9c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3812,13 +3812,20 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		if (ret == 0) {
 			ro_set = 1;
-		} else if (ret == -ENOSPC && !sctx->is_dev_replace) {
+		} else if (ret == -ENOSPC && !sctx->is_dev_replace &&
+			   !(cache->flags & BTRFS_BLOCK_GROUP_RAID56_MASK)) {
 			/*
 			 * btrfs_inc_block_group_ro return -ENOSPC when it
 			 * failed in creating new chunk for metadata.
 			 * It is not a problem for scrub, because
 			 * metadata are always cowed, and our scrub paused
 			 * commit_transactions.
+			 *
+			 * For RAID56 chunks, we have to mark them read-only
+			 * for scrub, as later we would use our own cache
+			 * out of RAID56 realm.
+			 * Thus we want the RAID56 bg to be marked RO to
+			 * prevent RMW from screwing up out cache.
 			 */
 			ro_set = 0;
 		} else if (ret == -ETXTBSY) {
-- 
2.39.2



