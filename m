Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061061;
	b=2N4ZGUhQ/MtnuVklQ3DlLYf/wtnViORUiz/PiyWCehsVFizb7ACOYHLf46t61rJINuaj
	 2Qbkmx9gbofAYwA7GC6KDg0ceSSN281jDLxYs34kqtIg8mg41Xx4zZuS1rhKRCGrsCL6O
	 Rob1rTmNumfsHr5ZPc6zBAbXGl4apGy0XmaNBUoZE6SEh9bwgOCLJ8OQJQigGk2s2E2/v
	 uXdfsKSpPsaypYgYXy1qH5FQiNnZrFK84HL/KQTZitFoZQDFFVHK6g3pxiJ9IllsJGKhb
	 EI4rGdR1mrpDt9xBbe8GrvdopEqAvD5ZdW7t25qADS6UcOxtqEmTPems5lm5X7nX4bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/e67uwbM/6H0deOuNOw5b6kFwWbUOR6FrW9SN3t2d8=;
	b=YJrhh2hsWIONt74x44gofIxgdAk16/hvmAMye2Yt6ssiw3aHXBParoFH8uGtQEoaGcCF
	 A8VaHkwMZNF+3+P3Dv9jBpries6yEdM6MMySkdEsfVVMxOeUVM7E/NDKL1AlR1inTA+5d
	 +m44w/gxgBonWFo3YNC5XfY5ZZggO3FREC2LliVkQlsL/rJAFr+8cE3yq5evpXnDaX0rx
	 +QKrIL707iQcegPBwjHZktmuaAqZw5kZsD6hL7/SxSyDEP9WCWTXe/57GihI7/A9nh/VD
	 4wPh7z5fB1+h2vmsOb8Ybe+ruhKMimANR6nJYf/jYrF9lc+dmgYX23tZBkvf3XYHCzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xv4J29bP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36486082BC8;
	Sat,  7 Nov 2026 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xv4J29bP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7201F0089F;
	Sat,  7 Nov 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061060;
	bh=Y/e67uwbM/6H0deOuNOw5b6kFwWbUOR6FrW9SN3t2d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xv4J29bPU62Kn/ZhvhescpWfqvGDxIcZFh4KDez/MtV0mzCzsYm+XUd9JwrJGHLkt
	 X4bHYGGR7WCqvH6P2T03Mn3gerIvBu6mkJsRu/FSW0KeVqRJ24W7Y6XHRntjfis8tG
	 LwZYfXwDG7lobw8bwCEcj88G53bwZz2mkcUuPgzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Zuber <jamz@amazon.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0390/1536] fuse: zero the partial EOF page when extending a file
Date: Sat,  7 Nov 2026 08:40:06 -0500
Message-ID: <20261107135008.560177028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Zuber <jamz@amazon.com>

[ Upstream commit 34b5c4a6e4fb9dbb3f9d87f3b0fb0372105c8302 ]

Extending a fuse file past a non-page-aligned EOF does not zero the tail of
the old last page.  When that page is cached and has been mmap-dirtied beyond
the old EOF, the now in-bounds tail is served to later reads as stale data
rather than zeros, which violates POSIX file-extension semantics.

Some file systems get this zeroing automatically at writeback time
(block_write_full_folio() / iomap_writeback_handle_eof() zero the tail of the
folio straddling i_size).  A non-writeback caching fuse file system uses neither
path, so it has to zero the tail itself from the size-extending paths, like
XFS (xfs_file_write_zero_eof()) and ext4 (ext4_block_zero_eof()) do.

Call truncate_pagecache_range() over the newly-exposed range up front from the
three paths that extend a file, before the new size is published:

  - a buffered write whose position is past the old EOF (fuse_perform_write());
  - a size-extending setattr/truncate (fuse_do_setattr());
  - a size-extending fallocate (fuse_file_fallocate()).

This unmaps the stale mappings and zeroes the partial tail of the old EOF
folio, so a later read returns zeros.  Truncating [old EOF, write start) before
a buffered write keeps the dropped range disjoint from the written data, so a
write that lands inside the old EOF folio is preserved.

writeback_cache connections are unaffected, as their writes go through
iomap_file_buffered_write(), which zeroes post-EOF folios.  The bug is
observable on a non-writeback_cache server that returns FOPEN_KEEP_CACHE on
writable files (without FOPEN_DIRECT_IO), and is caught by the new
write_extend_eof fuse selftest.

Signed-off-by: Jimmy Zuber <jamz@amazon.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c  | 3 +++
 fs/fuse/file.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 45cbe0cb22a0c..54fcf91272a04 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2060,6 +2060,9 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	 */
 	if ((is_truncate || !is_wb) &&
 	    S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
+		if (outarg.attr.size > oldsize)
+			truncate_pagecache_range(inode, oldsize,
+						 outarg.attr.size - 1);
 		truncate_pagecache(inode, outarg.attr.size);
 		invalidate_inode_pages2(mapping);
 	}
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 33ba8ae3b8c22..d242613a1c8a0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1298,9 +1298,13 @@ static ssize_t fuse_perform_write(struct kiocb *iocb, struct iov_iter *ii)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t pos = iocb->ki_pos;
+	loff_t old_size = i_size_read(inode);
 	int err = 0;
 	ssize_t res = 0;
 
+	if (pos > old_size)
+		truncate_pagecache_range(inode, old_size, pos - 1);
+
 	if (inode->i_size < pos + iov_iter_count(ii))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
@@ -3222,6 +3226,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 
 	/* we could have extended the file */
 	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		loff_t oldsize = i_size_read(inode);
+
+		if (offset + length > oldsize)
+			truncate_pagecache_range(inode, oldsize,
+						 offset + length - 1);
 		if (fuse_write_update_attr(inode, offset + length, length))
 			file_update_time(file);
 	}
-- 
2.53.0



