Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831024;
	b=ECSN4WJ4GsWaRxVG2AWJY/IWWiBmUKBzNvwPWD8Qowr6vCtsF9MtNjSFaG5Wm2nXWkLH
	 MCegVHekk6w9GFF4iBb9Z+SO/WWcs4hINR3PpBwZPDzgH4fOoQEQnPxCmWnkOTpyiWAwW
	 hQD4CgmvSnO7YVBbsubz2OqG84T+AadiTbB8RL3Jg0WcLysQcMOV7qidDHZ6jCnAknyy6
	 aKoJxT8UCWiv482vPpLYHMfgrkbPlAmtMlVvQMPf8b/sTdKVmRGghonAhtCmrELy0hsqh
	 gHv/hC4EtTDUTIr5O2VjtoO8Y4ySqFRrkZPBwU3dPBovpCfPGK3mUZ4dpFelPBpL43g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJEuelLgwthbnbRmGMa9kJitOXnMR7Q6p1aKDSUVpdM=;
	b=IVQd/Z+kMembbOGbeNpx9mj3LDPymPIGrThDo9lLXco9mZNMcRxe/DXXwY8o+khe3ykf
	 2V/+IBIQ04L13OK2f4omKwRH7AC7zWj+sPxxejXKUED8meOvxt8EGgnbEPZuz/aoN9Jri
	 4tY9eTXxcGZBPkZKrzrPbA6zgB7+NxVPXV0wzPGOtdDRdvapVYGWcISPiTYBFA2faP7i1
	 sSXq3BhsW8wVxpt7qKoDsHjR3kBVxcxohjYAQrv9VTQ7ejNn/qmJNE+JN3W6EvbHiIXS0
	 EiA5YF1UMhTGMVuw6ydSZyv0944IRQdkbYnfzkjKaWohb4939gCiCtnOvB/r+rY9RpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IcFvL1dw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7D606A843;
	Wed,  4 Nov 2026 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IcFvL1dw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594371F000C1;
	Wed,  4 Nov 2026 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831023;
	bh=dJEuelLgwthbnbRmGMa9kJitOXnMR7Q6p1aKDSUVpdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcFvL1dwBRtWikuzSCHwIy0QlXFHx8PD1frLBwy48A2+cjSXUB2phOiMi+/uhQPkQ
	 HoP+nhRBV72bKhmkI8yVeVsK/+PGnFwLP+C2CUBmO0laEnesLl5ptQvEauSdTswLao
	 eadoH0eb05QtO0W5pD0z8Wdpya6IeEhlV/cr8rzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Zuber <jamz@amazon.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0461/1005] fuse: zero the partial EOF page when extending a file
Date: Wed,  4 Nov 2026 16:03:14 -0500
Message-ID: <20261104211056.944455128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a013fad843b2c..9e20bc9dbdac4 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2095,6 +2095,9 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
index 0812eee881519..a7a3ac5b34f42 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1290,9 +1290,13 @@ static ssize_t fuse_perform_write(struct kiocb *iocb, struct iov_iter *ii)
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
 
@@ -2952,6 +2956,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 
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



