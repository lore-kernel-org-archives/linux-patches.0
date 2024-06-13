Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAA1DFD9;
	Thu, 13 Jun 2024 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282194; cv=none; b=Mjx3aKzk+CgUCERbL9Py8yQlK+UMeu8ziBwtoqg72Az/lAiOlPA3y2uEO33DlHB5m2cP0hOKinJ5eEos9XSr9YYn+PejdFRqrA7brajT3Mc1EgbrPD1mULsTMjqxNErWAJNvEdcDi97dXhc5nB6x/fO4rUXVjPqZ3hcXJpDqlJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282194; c=relaxed/simple;
	bh=7a4PyVyRacVL/Zq4IwNUAUT/J2PbeZ/MCYX7LMYo2wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpB5pf2dqdqrjRr9BFDpIXqfpSaQZb7AkD0rCcv7p7wAWA8VTdE6KF7jNClmplEveNpJ0z4zsCTJoX3x5zTu0s9IiES6UgofD5E2dxB9wlm82lI2kVCLzodbXzbVMXjvBaecwDsXcu16tNlLNiGeh/l+unX0ecDHtGqWbMRFsH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6aY9gnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6aY9gnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEFAC2BBFC;
	Thu, 13 Jun 2024 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282194;
	bh=7a4PyVyRacVL/Zq4IwNUAUT/J2PbeZ/MCYX7LMYo2wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6aY9gnS8dcFjhDHtx9lXTvci8PxkxCJXBQX3zrtGBR+OPYjHn7lWeYyCT837/J00
	 b9ct602fgWey9Zx96uQe0qGPEe46ZBVMffh7LsjXSa6wU13B+aXPQN9jQrljMb+hGd
	 J5TMfD5bJzpKmEG1lrNecjB6KyDOiOZvETVWh5e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/402] f2fs: convert to use sbi directly
Date: Thu, 13 Jun 2024 13:32:32 +0200
Message-ID: <20240613113309.748695557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit c3355ea9d82fe6b1a4226c9a7d311f9c5715b456 ]

F2FS_I_SB(inode) is redundant.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: bd9ae4ae9e58 ("f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1a03d0f33549c..5c0c7b95259f3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3436,7 +3436,7 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	int ret;
 	int writecount;
 
-	if (!f2fs_sb_has_compression(F2FS_I_SB(inode)))
+	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
 	if (f2fs_readonly(sbi->sb))
@@ -3446,7 +3446,7 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	if (ret)
 		return ret;
 
-	f2fs_balance_fs(F2FS_I_SB(inode), true);
+	f2fs_balance_fs(sbi, true);
 
 	inode_lock(inode);
 
@@ -3613,7 +3613,7 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	unsigned int reserved_blocks = 0;
 	int ret;
 
-	if (!f2fs_sb_has_compression(F2FS_I_SB(inode)))
+	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
 	if (f2fs_readonly(sbi->sb))
@@ -3626,7 +3626,7 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	if (atomic_read(&F2FS_I(inode)->i_compr_blocks))
 		goto out;
 
-	f2fs_balance_fs(F2FS_I_SB(inode), true);
+	f2fs_balance_fs(sbi, true);
 
 	inode_lock(inode);
 
@@ -4019,7 +4019,7 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 	if (!f2fs_compressed_file(inode))
 		return -EINVAL;
 
-	f2fs_balance_fs(F2FS_I_SB(inode), true);
+	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
 	inode_lock(inode);
@@ -4091,7 +4091,7 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 	if (!f2fs_compressed_file(inode))
 		return -EINVAL;
 
-	f2fs_balance_fs(F2FS_I_SB(inode), true);
+	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
 	inode_lock(inode);
-- 
2.43.0



