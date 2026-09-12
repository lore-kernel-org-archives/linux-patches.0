Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568D3542F8;
	Sat, 12 Sep 2026 09:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204902; cv=none; b=qgSIL1Ixp1HxGDuW+mIaUWSgn6S4EhQKjkW6MJHry17buGILuUZpmFSK7YIuvScGV/T+oKZJi9WSh5+e3Z1/csyEV/JGo6urqLOb4lbpS7ShEfnvmolGtE2XYfW2FomjJuzz6v6DGCSdi1Ln/am8FCVGJx3pU2J6X7rPfsYYHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204902; c=relaxed/simple;
	bh=VmDI5enPnl8dpbe/Vr0wp+xs26lHEpvRWkQjA71Mnc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifT7fiCGTbGi5gXJNpdULSPhkNHuAcNU73KsAkfJ2QwK/jplonWirAzojQbcGSW7nC1ohzx6/75WlHypUu+PQ5GIrC92QJQzLtcgN0Cg8V1JAumXEqtF+unc1RWjXsvR4mO8obkKltGgavOQbT7FEHkicuuUtTXEcGMTthmQ4RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK/6uGi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK/6uGi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66E11F000FF;
	Sat, 12 Sep 2026 09:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204900;
	bh=DU74uBN8XQ4OOgpH4dPPrUM9dg0CtMbHNE7yhfKGubE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK/6uGi/ee+boGDSsjo2VTMiq9UOhwbYDIyk26Lq0Yt9uRAbncWOAu5KpG5nnxwSw
	 Zw83z7z38y0ewyOyxlHdSo30TcPsJN95AeyV3O114ninhO3/Pup1n/xPi3sRbAWZuf
	 7ZwiDC8gXbjr2upsmaqkl/D/NNPja7ArdpTTwAfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1709/1815] fuse: invalidate the correct range after O_APPEND direct write
Date: Sat, 12 Sep 2026 08:57:39 +0200
Message-ID: <20260912065729.098519383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 26d7e1f5c407b5859122b5cd47d7ebbf4b4c1cd2 ]

fuse_direct_write_iter() captures pos before generic_write_checks(),
which moves ki_pos to EOF for O_APPEND writes:

  fuse_direct_write_iter()
  {
      pos = iocb->ki_pos;           /* 0 (user-supplied)       */
      generic_write_checks();       /* ki_pos -> EOF           */
      fuse_direct_io();             /* writes at EOF, correct  */
      invalidate(pos, pos + res);   /* [0, res) -- wrong       */
  }

The post-write invalidation targets a stale range instead of the
actual written range at EOF.

This can cause data inconsistency when the file size is not
page-aligned.  The tail page straddling EOF has a valid portion
before EOF that concurrent readers can fault back in during the
DIO write window:

  Tail page (file size X not page-aligned):

    page_start         X (EOF)   page_end
    |--- valid data ----|-- stale --|

  CPU0 (O_APPEND DIO writer)    CPU1 (buffered reader)
  --------------------------    ----------------------
  invalidate [X, X+len)
    tail page evicted
  FUSE_WRITE in flight ...
                                read [page_start, X)
                                  tail page re-faulted
                                  [X, page_end) = stale
  FUSE_WRITE completes
  i_size = X + len
  invalidate [0, len)  <- WRONG
    tail page still cached
                                read [X, X+len)
                                  hits stale tail page
                                  returns old data

Fix by reading pos back from iocb->ki_pos after generic_write_checks(),
as generic_file_direct_write() does.

Also fix a typo in the comment ("may have" -> "may have competed").

Fixes: 2b0408d0284f ("fuse: invalidate page cache after DIO and async DIO writes")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e7b2a839f0814..5820def81d9f5 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1801,13 +1801,14 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct address_space *mapping = inode->i_mapping;
-	loff_t pos = iocb->ki_pos;
 	ssize_t res;
 	bool exclusive;
 
 	fuse_dio_lock(iocb, from, &exclusive);
 	res = generic_write_checks(iocb, from);
 	if (res > 0) {
+		loff_t pos = iocb->ki_pos;
+
 		task_io_account_write(res);
 		if (!is_sync_kiocb(iocb)) {
 			res = fuse_direct_IO(iocb, from);
@@ -1822,7 +1823,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			/*
 			 * As in generic_file_direct_write(), invalidate after
 			 * write, to invalidate read-ahead cache that may have
-			 * with the write.
+			 * competed with the write.
 			 */
 			invalidate_inode_pages2_range(mapping,
 				pos >> PAGE_SHIFT,
-- 
2.53.0



