Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17282110E;
	Tue, 27 May 2025 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365596; cv=none; b=Q04wRPD28GJB4V4qvpnSS6UMocuUhq7OcOhzwSobrZVmbiANIu8o8L6KhL7KJbPI+D4QVK1zSqBk4OuaPcCWkLLTVM6HF9RIOvdygcKh2ryI7J0genKv0ouRR9JobMxYc31ha1vsZ8TDAFUGOnN3l/KhmZLC63LpZ8npQBS2QUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365596; c=relaxed/simple;
	bh=CYSidLXWYWbH3EYrPdS5O3Li+fDK5327Nc0/G3vsTjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhEJlyVoV4CbS6AymtOT22C1V9ruBYR+euC7MQKVrfYXOefgJedNniqtou6JyPCAqeT6QdGZV6zVr4B7K4O8th303+N1bvKaNeAZLQXCZKKzYiqPQKLmzVgVP8jeDKCRn06zSOSWJ+DV+QL+CbSw0YlfiEXvrxKMimGA8z/t0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYpp7was; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYpp7was"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81949C4CEE9;
	Tue, 27 May 2025 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365595;
	bh=CYSidLXWYWbH3EYrPdS5O3Li+fDK5327Nc0/G3vsTjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYpp7wasW6UcEOFWh3VA64G5eGcpO+CcUlykL8MKSv6nS5fUX0w004pEVZc9cdnj+
	 stDlP6w74AhlVMAeii8nkBugvD+wBZDO4s4d4M+cFmp6ddHHXgsNK6c5qqR91110Dn
	 tAs32PkKvRtxwJN6pgI7yxy0HmlVWkRGQleiViUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/626] ext4: dont write back data before punch hole in nojournal mode
Date: Tue, 27 May 2025 18:25:21 +0200
Message-ID: <20250527162502.402018534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 43d0105e2c7523cc6b14cad65e2044e829c0a07a ]

There is no need to write back all data before punching a hole in
non-journaled mode since it will be dropped soon after removing space.
Therefore, the call to filemap_write_and_wait_range() can be eliminated.
Besides, similar to ext4_zero_range(), we must address the case of
partially punched folios when block size < page size. It is essential to
remove writable userspace mappings to ensure that the folio can be
faulted again during subsequent mmap write access.

In journaled mode, we need to write dirty pages out before discarding
page cache in case of crash before committing the freeing data
transaction, which could expose old, stale data, even if synchronization
has been performed.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 487d9aec56c9d..819be57bb4ecf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3933,17 +3933,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + length - 1);
-		if (ret)
-			return ret;
-	}
-
 	inode_lock(inode);
 
 	/* No need to punch hole beyond i_size */
@@ -4005,8 +3994,11 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		ret = ext4_update_disksize_before_punch(inode, offset, length);
 		if (ret)
 			goto out_dio;
-		truncate_pagecache_range(inode, first_block_offset,
-					 last_block_offset);
+
+		ret = ext4_truncate_page_cache_block_range(inode,
+				first_block_offset, last_block_offset + 1);
+		if (ret)
+			goto out_dio;
 	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-- 
2.39.5



