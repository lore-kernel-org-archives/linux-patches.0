Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A4F4E4302;
	Tue, 13 Oct 2026 11:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892565; cv=none; b=hnictvd0dXD0H0eDtuNHHp9OowP+3y1OQetxjTgc2vi38THkZIWasnqw1bkx0HF9or+yHM4oYohjHtiZ21mYHN5O8TCYn8LEMh6mKF1aUBhXSwt7YameUALWSoezDq05FENgG9l1BTOBC3tRtFOZdeZS8T3D8lREZjldhjpRlPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892565; c=relaxed/simple;
	bh=lITi+6kCEcFwGc/LxgwiVhcTHSokd3Og847Kf7bvrUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy3ksrJKVzIa8FBUb/rzEpFHwXCFwhnRzYxmAcW1qCJb1qAZQcIAtsPBR9ze3mVD8NgMULP36dlQAWzdRttLt0CEWvJ2lmyvu3hgtTbVWqIDd5/8qZYEzN9XKvqXrW01xaMBPQZ4JlL4ylFMR727wcx+mnZO1XzWFaLDm0cOR2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6aYNjPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6aYNjPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D994C1F000FF;
	Tue, 13 Oct 2026 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892563;
	bh=8N5sc5FQqp+zlAb3726RcphhnmPaNKYk8UxbjZ/c/jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6aYNjPcerPAqWqJ0sxzd3JUu0lJDH155eWyKFNLO1e6lyNMVWvGFkXeno0J2/AHQ
	 JQ2lUY0H9H4duYr4Ch2SBwji3p67P94YTd401C4nSOslvEdf4Lwa4vCOc4NnypTrs/
	 suBPl0Sc57l+kKoO1VjXLXrL1vIJjUP6gVs4peQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Qu Wenruo <wqu@suse.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 213/281] btrfs: unlock inode and extent in caller when io_uring read extent fails
Date: Tue, 13 Oct 2026 13:38:49 +0200
Message-ID: <20261013112900.331019394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
index 0ac2f449134a0..1c2e17bade5e5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4559,7 +4559,7 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 	size_t page_offset;
 	ssize_t ret;
 
-	/* The inode lock has already been acquired in btrfs_uring_read_extent.  */
+	/* The inode lock has already been acquired in btrfs_encoded_read(). */
 	btrfs_lockdep_inode_acquire(inode, i_rwsem);
 
 	if (priv->err) {
@@ -4625,7 +4625,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 				   struct iovec *iov, struct io_uring_cmd *cmd)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
-	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct page **pages = NULL;
 	struct btrfs_uring_priv *priv = NULL;
 	unsigned long nr_pages;
@@ -4681,8 +4680,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	return -EIOCBQUEUED;
 
 out_fail:
-	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
 	for (int i = 0; i < nr_pages; i++) {
 		if (pages[i])
@@ -4825,6 +4822,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      data->iov, cmd);
 		if (ret == -EIOCBQUEUED)
 			goto out_acct;
+		btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	}
 
 out_free:
-- 
2.53.0



