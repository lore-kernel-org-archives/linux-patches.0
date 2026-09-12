Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88A3F23BE;
	Sat, 12 Sep 2026 10:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208007; cv=none; b=opjy5m02RxmQB4JyXK7gJktWNOG2YSdfmn5DuAJI0QJF9pTFAcRdGX+GQk4nDc34abE/9U4YkuQfEm/R+B/QMBbS7fbQYM9iU9lef0RSfeIa56DJwzAbGlMTQqAwPuMKUrOYgyngW8gYIeg0zNcY8ysN76QhaeZCP2dzu3lIFxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208007; c=relaxed/simple;
	bh=QH4y2ZZ+YkNs7qrun2lvdQo/84mQp+pIjEHI3saag9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbGjcOWt8k5GfO/VspXGSzCkYCcohpCOskgvgisV25shaV5FXQuLndTp4FsE8+t0CSIZoCNMjKrdi7HjiW7JF/wIXUJf0Ipc+g+6oA7Q6ix/WUDYdxoktmJEMyppU+p7G5JDjBZol8180033ElDj8EqxqfARQN2Vgcixxc/tO4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqUPRuj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqUPRuj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5371F000FF;
	Sat, 12 Sep 2026 10:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208004;
	bh=TLZ7/VS2Pv1iBw2M9v6UNIeyWU12FuhgKeBXVGc2oEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqUPRuj0YR0fbUgIICrm26zvH9bhPjJMEnZHAqtTfVvKja9YpJQIBF18aR6YWp7Ex
	 Dw5RChIej6mdw5HXmqeTH74R/+A70TtsQZwKFx6NBK078QfPS+bDAyRPmH7tY1/Aln
	 CnspQBeoh3Wl5Lg07fHSPPg/jENmo5UoBC62FTgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0529/1518] ext4: drain in-flight DIO before buffered write fallback
Date: Sat, 12 Sep 2026 08:44:58 +0200
Message-ID: <20260912065635.412020236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ]

generic/746 started failing intermittently on ext3 (no-extent inodes).
The test triggers 'Page cache invalidation failure on direct I/O'
warnings and subsequent fsync returns -EIO. Adding a 50ms delay
between ext4_buffered_write_iter() and filemap_write_and_wait_range()
in ext4_dio_write_iter() makes the race almost always reproducible.

On no-extent inodes, DIO writes to holes cannot use unwritten extents,
so ext4_iomap_alloc() leaves m_flags=0 and ext4_map_blocks() returns 0.
The iomap layer then returns -ENOTBLK, causing fallback to buffered I/O.

The fallback path in ext4_dio_write_iter() calls
ext4_buffered_write_iter() which dirties pages, then does flush and
invalidate. However, there's an unprotected window between
ext4_buffered_write_iter() returning (with inode lock released) and
the subsequent flush+invalidate.

Concurrent async DIO completions from other threads can run
kiocb_invalidate_post_direct_write() during this window. If pages have
been re-dirtied, post-invalidation finds dirty pages and triggers the
warning, setting -EIO in the error sequence.

Consider a file with two 4k extents: [hole][written]. Thread A does
DIO to the written extent, while thread B does DIO spanning both:

  kworker A (4k DIO, allocated block)    kworker B (8k DIO, fallback)
  -----------------------------------    ----------------------------
  inode_lock_shared()                    inode_lock_shared()
  iomap_dio_rw():                        iomap_dio_rw():
    kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
    submit_bio (async)                     dio->size = 0
  inode_unlock_shared()                  inode_unlock_shared()

  [bio pending in block layer]           /* fallback: lock released */
                                         ext4_buffered_write_iter()
                                           inode_lock(exclusive)
                                           generic_perform_write()
                                             -> dirty pages [0, 8k]
                                           inode_unlock(exclusive)

                                         /* pages dirty, no lock */
  [bio completes]                        filemap_write_and_wait_range()
  iomap_dio_complete()                     -> flush dirty pages
    kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
      invalidate_inode_pages2_range()
      -> finds dirty page!
      -> dio_warn_stale_pagecache()
      -> errseq_set(-EIO)

This issue can be triggered through normal I/O paths, not just
intentionally overlapping DIO writes from userspace. For example,
generic/746 uses a loop device where multiple kworkers issue concurrent
I/O to the backing file. Additionally, when block_size < folio_size,
non-overlapping DIO writes that share a large folio can also trigger
the race.

Add inode_dio_wait() in ext4_buffered_write_iter() before
ext4_write_checks() to drain all in-flight DIO. This ensures that
all DIO clears existing pages before submitting IO (via
kiocb_invalidate_pages()), all BIO waits for all DIO to complete
(via inode_dio_wait()), and ext4_write_checks() observes the inode
size after all completed DIO so that ext4_block_zero_eof() does not
race with in-flight DIO, thus eliminating the race.

Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7a8b309321892..149a7fe5a0962 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -292,6 +292,13 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 		return -EOPNOTSUPP;
 
 	inode_lock(inode);
+
+	/*
+	 * Prevent concurrent direct I/O and buffered I/O to the same file
+	 * range. Wait for in-flight DIO to finish before dirtying pages.
+	 */
+	inode_dio_wait(inode);
+
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
-- 
2.53.0



