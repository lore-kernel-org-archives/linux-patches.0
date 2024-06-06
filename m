Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB34F1BB69D;
	Thu,  6 Jun 2024 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683491; cv=none; b=SiKHEpBA+DKmwbQnr8Mbz1v1UIaVSO/QFJNiCtDwEVX/NTP8B4ddY+KOdQvbkz1tu3jTVkvGAxqGoSOGcIJkTfYNvbTcusahv4yn5Ta9IHXfX+4aef7JgFHMOe1enk7TRByWrjqIQGfBqdVFzQEDizqpb9xbonI6vJ3d9Sn8Sko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683491; c=relaxed/simple;
	bh=aJ0t4koR/Xl6ceWtvqTdfNjIob6D7NjitTE1zLhr+fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3vXJTP2O6TTtbSlbryzuL8IZ/iRnUHVEdv9WXyQVOD+KsTRNA3IZ2YuwRA3qPadh84j7vF0KVhoAPOOr63J1KGxEhqxQOF0I1kX67iR+7fcpAhPQ576sSu6SZ3e2Z2cjQzWqE0g/r8Wjz5qf/KO1R+jn3ZAfdeQjaZvgYyyQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJYpI4TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJYpI4TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3686AC32782;
	Thu,  6 Jun 2024 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683491;
	bh=aJ0t4koR/Xl6ceWtvqTdfNjIob6D7NjitTE1zLhr+fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJYpI4TDj3H+wHk6APf2fLpD8rgDyEidup66BX8XKqqv3frh38WzzuOZPz+BOrUFq
	 RwTaYeGXGzGB76wYDyQxPfyLfX7y69uncAeKq5LOls4liv205spdrpXWvSsACGsUME
	 2kJ2lM3S2NhqKRKq7NT/vUdUxeoaDqu7Gy149uqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 434/744] f2fs: fix to relocate check condition in f2fs_fallocate()
Date: Thu,  6 Jun 2024 16:01:46 +0200
Message-ID: <20240606131746.393997959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 278a6253a673611dbc8ab72a3b34b151a8e75822 ]

compress and pinfile flag should be checked after inode lock held to
avoid race condition, fix it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 420939ca36422..d908ef72fef6e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1797,15 +1797,6 @@ static long f2fs_fallocate(struct file *file, int mode,
 		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Pinned file should not support partial truncation since the block
-	 * can be used by applications.
-	 */
-	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
-		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
-			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE)))
-		return -EOPNOTSUPP;
-
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 			FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
 			FALLOC_FL_INSERT_RANGE))
@@ -1813,6 +1804,17 @@ static long f2fs_fallocate(struct file *file, int mode,
 
 	inode_lock(inode);
 
+	/*
+	 * Pinned file should not support partial truncation since the block
+	 * can be used by applications.
+	 */
+	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
+		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE))) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	ret = file_modified(file);
 	if (ret)
 		goto out;
-- 
2.43.0



