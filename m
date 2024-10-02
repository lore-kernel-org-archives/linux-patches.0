Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFAA29CE7;
	Wed,  2 Oct 2024 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876416; cv=none; b=YgwlJvxqj4fVlBkjTlrxnp+5iKc1GlTdGpleaMzxqwE1Q3nc7Pw5m9xzuuorqt2QRXiDkfWyL3jpHuQzocEY1EKf2aSlAYnpAFdQwk3s1wx2HKGadTLCM0NBqmH6NEUFls4g5eGNjpaxD4Q/eA3hqw0Ays7ak1lz8/dM0RoR+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876416; c=relaxed/simple;
	bh=K2B1EBya6GHxNaLkjQN5gO6DZB6AoVjGnDX9uVIpn1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5PyPd+BtEqM+wlaweauh0Y8baZsPsjjq0YkJnGoQMv+qculnVoYZjaEYcer1mjveJVWhuhlggglezH/nhrsAb6sIS3JUWVPO3+FLU5mOno1eUWyuOndAJfB+0Og+CRTw9nZTqgHkuTNvB101bJbS4z3bXSlSy2cs8/hhm+qw6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbtjRPXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbtjRPXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCCAC4CEC5;
	Wed,  2 Oct 2024 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876415;
	bh=K2B1EBya6GHxNaLkjQN5gO6DZB6AoVjGnDX9uVIpn1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbtjRPXluGKeQ5wbeL808iRqxzuwzELSmeAzU1twlYAWpOyzu4ancCbOG2TE5/c8d
	 jGw9ztXP0TBMQicZ46d0JJvbV3v+88UWX/cp/JNYFnGm0EGnN6Q8gVcbcex3bO34jy
	 s6W0Gu39OFN6Aa1uVZR3GIFo55MyZvOct8IDlA+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 437/695] f2fs: Create COW inode from parent dentry for atomic write
Date: Wed,  2 Oct 2024 14:57:15 +0200
Message-ID: <20241002125839.905186207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeongjin Gil <youngjin.gil@samsung.com>

[ Upstream commit 8c1b787938fd86bab27a1492fa887408c75fec2b ]

The i_pino in f2fs_inode_info has the previous parent's i_ino when inode
was renamed, which may cause f2fs_ioc_start_atomic_write to fail.
If file_wrong_pino is true and i_nlink is 1, then to find a valid pino,
we should refer to the dentry from inode.

To resolve this issue, let's get parent inode using parent dentry
directly.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Sunmin Jeong <s_min.jeong@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index afa43d1aa030a..bf448dbe2c551 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2119,7 +2119,6 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct inode *pinode;
 	loff_t isize;
 	int ret;
 
@@ -2169,15 +2168,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	/* Check if the inode already has a COW inode */
 	if (fi->cow_inode == NULL) {
 		/* Create a COW inode for atomic write */
-		pinode = f2fs_iget(inode->i_sb, fi->i_pino);
-		if (IS_ERR(pinode)) {
-			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-			ret = PTR_ERR(pinode);
-			goto out;
-		}
+		struct dentry *dentry = file_dentry(filp);
+		struct inode *dir = d_inode(dentry->d_parent);
 
-		ret = f2fs_get_tmpfile(idmap, pinode, &fi->cow_inode);
-		iput(pinode);
+		ret = f2fs_get_tmpfile(idmap, dir, &fi->cow_inode);
 		if (ret) {
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 			goto out;
-- 
2.43.0



