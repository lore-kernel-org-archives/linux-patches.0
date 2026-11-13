Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585725;
	b=syb7rocCmahm7f8pBt/Ae0gEXPYAaCkyqdoc91zS7xRJpfoNM4TvYxZ1vmA5lUKmTf+R
	 s4ZtbnFD6pTKB4UHOPLitlmntlO17+yp0cwpgd2KbJRm67A/3SXCJZjayk9HGet+v3HY+
	 HZ1HzUaJ5fEwiU0bbLIKq7uUh2a6G828ns2c44xeGofYmnjONN/QZMst8HyYcBGVFqsct
	 RUxo8VzTSl+RAnf/BEMWI1d58dEBIhdXqN6JZcbedCQYnqdPYA/e9l+gBcL73qTlcJeE4
	 YFg+nexOIZSgBcQMnP1BawGED7vwy0AD9b/TQBI2Xn1nwsnFYomZ0wvqY8jitmXB3gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5vtOR8AV/QPT2uhnRXx1Dz8pUvgQZmcEpWyQxo+mIU=;
	b=lPgOYlAjDOnhUQNDdlGliTry6pJfh+9V+wXrEkBtSMhISaiC6EMmaVE353ML+bkZ4hV5
	 FoVL61PesDtIv6Qb/MBe++A7RVaDFnshrV6Eoe95BDhpH+hLMIEEjEfRBTyJ2T7mKZiQh
	 UiMMoC5PMnlpzX+zxKT74Nkc+qg6snFVVcRX4YhrBgtmmBHDSHXT95R21iZFaFWR/9/AP
	 1ljlQ8eC+bDffPaiFIDarnbCI6qZkPG8aRmWwvpvEZPUYcDtm6gTrpFGNZABsURJfXu/Y
	 TqWWsWfVBW6mXNXboaC22UY4+0mkIGZQA+0ZNzhCjw+kU5lOkpPoJqIVqXDlNr3JdNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08t34stJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4565F606A8A9;
	Fri, 13 Nov 2026 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08t34stJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E2E1F000C4;
	Fri, 13 Nov 2026 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585725;
	bh=s5vtOR8AV/QPT2uhnRXx1Dz8pUvgQZmcEpWyQxo+mIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08t34stJCB8l9SxbbCvpVLlfJfkSCgZEKjV8tmiWd/KVsUIaDDXpZbEviKfueY38I
	 gX0rG0BTRETx2CkEgJaYQeRGBWzBd2zk7lRL+wbnVpM6Nmchgbr8ccqCjwzB1h1Eji
	 WaycEjDLRzoKb9dis10cGNTTBv5ZMIa6lI0HVQSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 283/507] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
Date: Fri, 13 Nov 2026 10:49:47 -0500
Message-ID: <20261113153804.757841718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit bcf0b7f18ad11e1d410e82ffef678705eff0a317 ]

A client can commit a hole in a LAYOUTCOMMIT, because nfsd does not
check the extents against its layouts. xfs_iomap_write_unwritten() then
allocates written blocks there. A large hole overruns the block
reservation and shuts XFS down. A small one exposes stale data.

Refuse such a range with -EIO, using XFS_BMAPI_CONVERT_ONLY.

Link: https://lore.kernel.org/r/20261014130834.GB15773@lst.de
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c  |  2 +-
 fs/xfs/xfs_ioend.c |  2 +-
 fs/xfs/xfs_iomap.c | 20 +++++++++++++++++---
 fs/xfs/xfs_iomap.h |  3 ++-
 fs/xfs/xfs_pnfs.c  |  9 ++++++++-
 5 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca9..59bd9a24b3eff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -668,7 +668,7 @@ xfs_dio_write_end_io(
 	 * they are converted.
 	 */
 	if (flags & IOMAP_DIO_UNWRITTEN) {
-		error = xfs_iomap_write_unwritten(ip, offset, size, true);
+		error = xfs_iomap_write_unwritten(ip, offset, size, true, 0);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 40695d18dac08..aced9a023db1d 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -102,7 +102,7 @@ xfs_end_ioend_write(
 	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
-		error = xfs_iomap_write_unwritten(ip, offset, size, false);
+		error = xfs_iomap_write_unwritten(ip, offset, size, false, 0);
 
 	if (!error &&
 	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed61e4..93826ca74b6be 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -614,7 +614,8 @@ xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	xfs_off_t	count,
-	bool		update_isize)
+	bool		update_isize,
+	uint32_t	bmapi_flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -676,8 +677,21 @@ xfs_iomap_write_unwritten(
 		 */
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
+					XFS_BMAPI_CONVERT | bmapi_flags,
+					resblks, &imap, &nimaps);
+		if (error == -ENOSR && (bmapi_flags & XFS_BMAPI_CONVERT_ONLY)) {
+			/*
+			 * Nothing was mapped: the rest of the range starts
+			 * with a hole or a delalloc extent. Nothing was
+			 * changed either, but xfs_iext_count_extend() may
+			 * have logged the inode, and cancelling a dirty
+			 * transaction shuts the filesystem down. Commit it,
+			 * as xfs_alloc_file_space() does on -ENOSR.
+			 */
+			error = xfs_trans_commit(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error ? error : -EIO;
+		}
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f2520a9b3a13e..8fc0c6fc8bea5 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -15,7 +15,8 @@ struct xfs_zone_alloc_ctx;
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+int xfs_iomap_write_unwritten(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count, bool update_isize, uint32_t bmapi_flags);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a9f0b472f3076..7ff83274a5135 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -344,7 +344,14 @@ xfs_fs_commit_blocks(
 					(end - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(error);
 
-		error = xfs_iomap_write_unwritten(ip, start, length, false);
+		/*
+		 * A client may only write to blocks that a layout handed out,
+		 * and xfs_fs_map_blocks() allocates blocks for any hole in a
+		 * write layout, so refuse to allocate blocks for a hole or a
+		 * delalloc extent in the committed range.
+		 */
+		error = xfs_iomap_write_unwritten(ip, start, length, false,
+				XFS_BMAPI_CONVERT_ONLY);
 		if (error)
 			goto out_drop_iolock;
 	}
-- 
2.53.0



