Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CD21B4C59;
	Thu,  6 Jun 2024 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683452; cv=none; b=ZrpEQNGSqqKa2vbgdXdE3HiNQqfVO2aYXf1QIW2lwY4o03ozBHQqEzG1S3kjFUXa/aCAwVn302QIbrnOtLPVjkcNxAvM5XhxI2FyD0Uf4oIJzKi9sdwLDoAWLseiKXvNiorWKt95IzphyjsqOYPvsmFL6ilHG0ZvRuVwUXaxhGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683452; c=relaxed/simple;
	bh=w4HRekpgUkmOaoNoqffBl1QGSJ82ILc3NFH4SM71DRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F72+BOY83H1eNZEjfzJ4nyl+CN3o6Dq4jDWpzbKT3AFS7JRbZMsrQz0H7eyoouWsQK/khf9ooX01J2WKhiKUXhjXj9qtWytyCaCfzJFBaIecJHCFtTzTlKZcBepeNO8l6JTxyjHw2WZa/C2nv5E/yfTPWV+Uc9sGNC5a2B6Wghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6Azz/hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6Azz/hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A46EC32781;
	Thu,  6 Jun 2024 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683452;
	bh=w4HRekpgUkmOaoNoqffBl1QGSJ82ILc3NFH4SM71DRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6Azz/hnr6+YZHg1tzI9XiYZD+5ijbkTrbeC97Yfxllfk7UBcKWbvbj8oyVKXORBO
	 IbdaxJaHiBSU9gTxFtd0/mRCIuRCZYEKZsX2vtS/m1+Y6KAGHX30wky7Z7vej4dn+o
	 fEJ1UkJHEv1zJq+BGjfOKf2TeqcHsyiuP0Lr4E2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/473] f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()
Date: Thu,  6 Jun 2024 16:03:56 +0200
Message-ID: <20240606131710.088401320@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b325290d6a54..b321f0da1bd70 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3468,9 +3468,6 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3489,7 +3486,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3650,9 +3648,6 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3664,7 +3659,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 	inode_lock(inode);
 
-	if (!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto unlock_inode;
 	}
-- 
2.43.0



