Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AE919CCF2;
	Thu,  6 Jun 2024 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683425; cv=none; b=CwQnt8clC8RBXVx+gDG2KdJiJYlAy450Frr2y84h8He1weqiyJJNu5EKrY81N2kGp95NEI+4VSOndmvnXexGanD91euHJBLdXo49rtQ0c4NU+Mgl0lGch60OjEXdZHJqFvAFcZEiQ27UvS/hBFWrc6nQJZBrpdmDXhOLrcfSdhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683425; c=relaxed/simple;
	bh=TcSofByB0za/L8/iAJ2NTKcMpqnYD/HKORscHZa9grQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQrXrGVoClnbLM6+yP4IY1D6fEbWAoYHc4bfVbsbRl65C5wKOKtAfspBcBh/yHDdlFTzGI1TD3S5bz1xAlf/UWvKTxESzOSRqMtgfzh+Fm6uAZAGvdQhvWsSekvNOONjTUmcdfnw9V2pT94Vny6C5gSsH8Qezg7NxnCxyKJ25sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3y/SgSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3y/SgSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82155C2BD10;
	Thu,  6 Jun 2024 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683424;
	bh=TcSofByB0za/L8/iAJ2NTKcMpqnYD/HKORscHZa9grQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3y/SgSDPKBgUsgQRV8Ee7jVWxdAPYmhBf4XoNh4nAFZhkz/ItyHPdb4A7cwgyu5O
	 WN49gNGscmFDrFqqC2J+eJeb3hTzBHoun+OGz8SKfzpUQsKrOHIV8ES9Z731XoD2lP
	 LoKo+Vga5+Mf9Pfg9MEcjjUx9tlR4YwGXvQyMPGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/473] f2fs: fix to relocate check condition in f2fs_fallocate()
Date: Thu,  6 Jun 2024 16:03:59 +0200
Message-ID: <20240606131710.193025214@linuxfoundation.org>
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
index 423b9150dc0a8..1a7ee769f9389 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1804,15 +1804,6 @@ static long f2fs_fallocate(struct file *file, int mode,
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
@@ -1820,6 +1811,17 @@ static long f2fs_fallocate(struct file *file, int mode,
 
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



