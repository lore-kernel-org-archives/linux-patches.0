Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3423859E2;
	Tue, 10 Mar 2026 11:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141072; cv=none; b=ICPtIHMOJxxK1uaparKAWboWSkwUKTFhUJkUqT/mu0nEwEIBoCd9sE30UeYTd7Ljs5kkRQUGxeZ4B1q+PORmntBwdd3lwSrgwFuLlxrk73AL+4vBgNjkG62M03/7RutI4KrzLTKIJqv/omVEvH7ZaoPDntf749PtnWfsttgMCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141072; c=relaxed/simple;
	bh=i7py5FjNGT799cHpVJPuiuqDm/fx6GTQM9YePFTRBug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtxREzZdxVm6Ojc4CzXUrM9W6NJ4wc2uc7ezrdyJHOrxuKRQCU4Hs5frTYq13nyYrUGVW/qZnm5MvKtedS3J1p2MxXtge+rSXIEdVLIShwWjm/wuPDJcSayOo6PH2mC1Zqc91KDjMoqlAPEq+izUhfvCcR5tOjiBDJcyjCatnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3FJylyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3FJylyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08465C19423;
	Tue, 10 Mar 2026 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141072;
	bh=i7py5FjNGT799cHpVJPuiuqDm/fx6GTQM9YePFTRBug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3FJylyDcFwp7pcrHz+u1o4kgWSYu2Y6Tf+W1hTHHlHYiR/OB7sLxNIkSF685yXq6
	 EiDrJmhZBRVq74KICxf9qFmBqZIwQWM9LEqTxuj50Y5gYgDNoPP6sqiWT0KDYp7R7Z
	 qSaFSrK7U1vUb5tLj7c93beWffi4qBFp04uHFpKKRDZcP8NTalSw7uneTLcuVfyZbL
	 33jPlLp9w9rnYmgVOUZZdt+bNhk8LFEkZIa7lPR+uv5abmkpzKzamKX3rL+P1VCfEP
	 3VKRWJB7zQZYZzx8YIv/9n3QVRrxXfU8ld6s60192BythwASfXGcv+N95AjuDy63Bn
	 OM0H0b4JSGPag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 072/311] btrfs: free pages on error in btrfs_uring_read_extent()
Date: Tue, 10 Mar 2026 07:01:59 -0400
Message-ID: <5959735b64690d6142b4a5b2ac7a09206bf36dd1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miquel Sabaté Solà <mssola@mssola.com>

[ Upstream commit 3f501412f2079ca14bf68a18d80a2b7a823f1f64 ]

In this function the 'pages' object is never freed in the hopes that it is
picked up by btrfs_uring_read_finished() whenever that executes in the
future. But that's just the happy path. Along the way previous
allocations might have gone wrong, or we might not get -EIOCBQUEUED from
btrfs_encoded_read_regular_fill_pages(). In all these cases, we go to a
cleanup section that frees all memory allocated by this function without
assuming any deferred execution, and this also needs to happen for the
'pages' allocation.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index acb484546b1da..c9284ce6c6e78 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4661,7 +4661,7 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree = &inode->io_tree;
-	struct page **pages;
+	struct page **pages = NULL;
 	struct btrfs_uring_priv *priv = NULL;
 	unsigned long nr_pages;
 	int ret;
@@ -4719,6 +4719,11 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
+	for (int i = 0; i < nr_pages; i++) {
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	kfree(pages);
 	return ret;
 }
 
-- 
2.51.0

