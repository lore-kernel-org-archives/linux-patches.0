Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8B1B4C5D;
	Thu,  6 Jun 2024 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683453; cv=none; b=HsuZNyCJ1iMCyqdVuaMNa/E/mvZus7xm/jHflUtd8EwJTo3iFtKxESV9S2Rtf0m9BEJ17tmtx+lqj2/8GWJUq2sxoHU3bMqP6Gh6Aw7zkYGg6mCXiWMHwn13A2kOCkXQQXKHOF5Tmd4sNcxYQc2V3q40cj/PY5rVKHmberi3Aeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683453; c=relaxed/simple;
	bh=26D5pLrACl/MiE0gTGWdLn5FytF4P0hRsVvElwaQc/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz+schyz60dEEk92pwQhtdoLIq+A7dcFt4MgW95s+UwbYW/C6LBUx3hLId3bPSDol9+VV9wPZ8oWU8F7hKabRlvqk9fB6KvqNNQNSqmpi10h/zeo20eFjQzUvAh/0WQ11vsjvrdVTCwU78Vmuok57Wutfi0Y3TknyQQuQrIP3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+VYAMzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+VYAMzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A98C32781;
	Thu,  6 Jun 2024 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683453;
	bh=26D5pLrACl/MiE0gTGWdLn5FytF4P0hRsVvElwaQc/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+VYAMzOFRK7ehSvOCgiFUs9zUQ3PaT5jCvDua/sGtTL1tC5CH3s5rckj8cQtifmR
	 5Up3qarkoybh6bAujEKGPQNXGgDq6mwEQ0HOlIksE1fSvOq/Vpri5uNf4NZFxYibbA
	 sHnsPmD6FkuFBPkxs83NiOKURVRwbZRFHmPIdN8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 308/473] f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()
Date: Thu,  6 Jun 2024 16:03:57 +0200
Message-ID: <20240606131710.123618911@linuxfoundation.org>
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

[ Upstream commit bd9ae4ae9e585061acfd4a169f2321706f900246 ]

Compress flag should be checked after inode lock held to avoid
racing w/ f2fs_setflags_common() , fix it.

Fixes: 5fdb322ff2c2 ("f2fs: add F2FS_IOC_DECOMPRESS_FILE and F2FS_IOC_COMPRESS_FILE")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/CAHJ8P3LdZXLc2rqeYjvymgYHr2+YLuJ0sLG9DdsJZmwO7deuhw@mail.gmail.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b321f0da1bd70..46b6f06a4a76a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4064,9 +4064,6 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4077,7 +4074,8 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4136,9 +4134,6 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4149,7 +4144,8 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.43.0



