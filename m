Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1B02236F4;
	Mon,  2 Jun 2025 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873829; cv=none; b=rgcVVQksNyrPT3OZnXjX+bAe99fYniZlHaNneMRwcThpkJItgatvLDRPnU3kuiSIFbHShDrUyQhWrCPipHeX4LZYtJbKp4VufWVww83cul75Q6EP7d1T2+MaNJFxaqGOXPccJgSXGow6aLjQNkJZjG9jImRiWE6FXmyep9mhPOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873829; c=relaxed/simple;
	bh=3l2K+z8oPLChHIvuBLEnDjbSOmqcKznrVzFH/+R+Yto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy9RxgyGWtDbn5tI/JjESNFCM6gJ4wcjQJSyvw6zE9EECrkE+ICU3EvqevJV1aHsyeFo77U1aZXtcTsavYTSUr5fYoGX/o9Ps0E+7e8Q9X2YvIrZvKaFHAZJ844oeBz4vO16rHRSzF/J5+0yxeTsnic9690V632QoZDUNY3PS7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfyhkIcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfyhkIcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E799C4CEEB;
	Mon,  2 Jun 2025 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873828;
	bh=3l2K+z8oPLChHIvuBLEnDjbSOmqcKznrVzFH/+R+Yto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfyhkIcuhbjGnYIAwYTZf9qK5IIx92lmL5nxx39rFagq3q8Z0SFq/U1JhnCpzgOrh
	 a6FH+66sUVDLTQCoHvwR9U4bwi4x0LAqZmeXj8WAy9ADi3zEYXAu5eZm3doLFRZHVs
	 C+88gK5jdjA/cUBAIXCU2DoYUHFyMm43gpC1BkTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/444] ext4: dont write back data before punch hole in nojournal mode
Date: Mon,  2 Jun 2025 15:45:30 +0200
Message-ID: <20250602134351.753071893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index d3d28e6587202..456f686136fc5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3946,17 +3946,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
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
@@ -4018,8 +4007,11 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
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



