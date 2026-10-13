Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B13AE18C;
	Tue, 13 Oct 2026 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894416; cv=none; b=aI7RrIqV9ZtutDI5n9QVFYPdSqykGupnFI0uatSO9o/ZRGtOjo6hDAcHpKjSE/8ZxqUA/IU+Wz8FKiiaym3rKTQQrt4u4hBAFyj58SsWrSY9N4TcZRjhJ2ak8yyKJ1TMSC7P1UWPT2pFD0TyFmRNPpgbGDxyW8UyIG/YDgluzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894416; c=relaxed/simple;
	bh=EsNSTOCpRnoNpT2u+p/yYrtaktdc6MoZtugWxYeJgCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1Az3QKc/8iF7UgibfTlycI18K2k5JHltRGEmea4Jhf53+NyVlFMlZVF5oLvzsALqOSHzdNWXuUelJS5EHxg1ZkKkiVFfKDYch6Cz2IzO9k5Jn1JFBG2VEhSz24OEneW74J48mK0YIXUtQXlLY1HUmGgSgAKa4NJIph8i2D/lqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGkMurUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGkMurUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216841F000FF;
	Tue, 13 Oct 2026 12:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894415;
	bh=girrrYaZA1HezP+L+qTMUZ/obYcK6Zkr3sd0rJP96qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGkMurUGTGB2MmKe4CleIPcGy12o1s8u9pkNHP27fLs4E09tfDc+fQVpFCNtsry+H
	 26wHuHZ6mVsQiY/AV1nPzPOe2UE1OPsuVo/rAxCmhD7v6cX0SwwBrCTf95ke5B3AJF
	 xWzR5O3iFI7nYrvPqizYuOsNYqBUsobB+WX2m/8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Qu Wenruo <wqu@suse.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 553/621] btrfs: unlock inode and extent in caller when io_uring read extent fails
Date: Tue, 13 Oct 2026 13:39:08 +0200
Message-ID: <20261013112933.936567047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit b6e8add5d79d1f6f819a054c833bab452bd7365d ]

btrfs_uring_read_extent() runs only after btrfs_encoded_read() has taken
the inode shared lock and the extent lock.  On failure it used to unlock
in out_fail, and a pages-array allocation failure returned -ENOMEM
without unlocking at all.

Unlock in the caller instead on all failure returns, matching the
copy_to_user() error path.  The deferred -EIOCBQUEUED path still unlocks
in btrfs_uring_read_finished().

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd663f8c0c52b..9a8902012ae6d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4659,7 +4659,7 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 	size_t page_offset;
 	ssize_t ret;
 
-	/* The inode lock has already been acquired in btrfs_uring_read_extent.  */
+	/* The inode lock has already been acquired in btrfs_encoded_read(). */
 	btrfs_lockdep_inode_acquire(inode, i_rwsem);
 
 	if (priv->err) {
@@ -4725,7 +4725,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 				   struct iovec *iov, struct io_uring_cmd *cmd)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
-	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct page **pages = NULL;
 	struct btrfs_uring_priv *priv = NULL;
 	unsigned long nr_pages;
@@ -4781,8 +4780,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	return -EIOCBQUEUED;
 
 out_fail:
-	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
 	for (int i = 0; i < nr_pages; i++) {
 		if (pages[i])
@@ -4930,6 +4927,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      data->iov, cmd);
 		if (ret == -EIOCBQUEUED)
 			goto out_acct;
+		btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	}
 
 out_free:
-- 
2.53.0



