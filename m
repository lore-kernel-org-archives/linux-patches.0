Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33057EC4;
	Thu, 13 Jun 2024 12:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282191; cv=none; b=CI2Xo9Ke/Zjp2NEMD2O86w/BsUWPORId6BZ7dAD1cYbbceEhZW1sVQiVTVyI+Kzwurp4xIIIlOPcgJ76AUmZqtW6bwFCA7cS0Oby7NZNLJNUcr0w36pypaVPrEFXgDeShf+xd9ky2gQ70QIVakcs7tGGHfRuiqdk0L/UP/HN82w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282191; c=relaxed/simple;
	bh=pyt6jCgRsMMst5daAwneRu/5eqxAgjOyX/zeJnG2T/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdiOscLW+9iFIZnHIFzScff8saeoKj7gdcyy21MHa/5nbUxj6xEcXehPF5PMozgEiJRM/DDRw3iTt7Ln0frpsXtUmFgRSPWQKYh++J28f0u5hX6wiSlD2ypKJbYwiFX4YW9JYdniB2Ozl1xLOAqkomn20lisMJ5CW9qs0aqJz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9br29HP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9br29HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0002C2BBFC;
	Thu, 13 Jun 2024 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282191;
	bh=pyt6jCgRsMMst5daAwneRu/5eqxAgjOyX/zeJnG2T/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9br29HPdFgJV4hKPZkilDqJvsxN+BdTFbN3Ix0s52oTnKdjrULGhJBm20kq6aMy4
	 Pf/8ixoYjqnf8ZAYBavpNI0ZOB8ap9RwM6UHwbb2jR/p/34ZwJgKp7uDzcHO3NCqbF
	 byZzxOVoAe06CjM3oYPTLPNRxh7j9stPYuABKw04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/402] f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()
Date: Thu, 13 Jun 2024 13:32:31 +0200
Message-ID: <20240613113309.710396166@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7c5dffb3d90c5921b91981cc663e02757d90526e ]

Compress flag should be checked after inode lock held to avoid
racing w/ f2fs_setflags_common(), fix it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/CAHJ8P3LdZXLc2rqeYjvymgYHr2+YLuJ0sLG9DdsJZmwO7deuhw@mail.gmail.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3d811594d0d5c..1a03d0f33549c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3439,9 +3439,6 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(F2FS_I_SB(inode)))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3460,7 +3457,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3618,9 +3616,6 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(F2FS_I_SB(inode)))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3635,7 +3630,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 	inode_lock(inode);
 
-	if (!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto unlock_inode;
 	}
-- 
2.43.0



