Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFC81C07ED;
	Tue, 15 Oct 2024 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997810; cv=none; b=h5stD67/++Uzzgsmsny/7r36Zwx7/NiUWIyY+NQkpY9YCKQ8frG+SUYi+E3niZCc+dLEYzpHau/+uTQ1/kVAMcLFp340mR0dLY9KV96Tj5FMteOEqvo/ymoWT9yHdlngH7ORSjJ7PQBR5LE68aKmUd2VEXVN7vHFuA8h8PIdd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997810; c=relaxed/simple;
	bh=qHy66VAQahBgRbnCLfA+fK/fy2r8cOTkVnM9PivXteE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmlaL7izEAdLa7D3ydEGDLqW0Ob5p6fXvCSEAGWx3onZXnMWPri0GJMmezW0Z0qC6aHtein2nZvGqylss1o3W/i5flt4KL0Qbz5F+YGa0VebsG9o1LFD8UexSYSIaOCEYgMCjMHuEuokCftw8JucIMX01A/5cu8HI4EatB3+TLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTt8J3UK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTt8J3UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E109C4CEC6;
	Tue, 15 Oct 2024 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997809;
	bh=qHy66VAQahBgRbnCLfA+fK/fy2r8cOTkVnM9PivXteE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTt8J3UK0bxUoofVjJretJuzF6g1EXoVfUhqk6HA4TCQ+9jDhB9fh8Bu6M5eCekoB
	 90cA904ZPyvyCz7tKBZpwdSX+clOrY9fJ/H3LvUbbAsAaqRfEv/dBUGySypL12j9Ii
	 /NtkPeIy7tfWanc49ZSjB9Q3o65amDhQOt8Rr5IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/518] f2fs: Require FMODE_WRITE for atomic write ioctls
Date: Tue, 15 Oct 2024 14:43:17 +0200
Message-ID: <20241015123928.294802984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 4f5a100f87f32cb65d4bb1ad282a08c92f6f591e upstream.

The F2FS ioctls for starting and committing atomic writes check for
inode_owner_or_capable(), but this does not give LSMs like SELinux or
Landlock an opportunity to deny the write access - if the caller's FSUID
matches the inode's UID, inode_owner_or_capable() immediately returns true.

There are scenarios where LSMs want to deny a process the ability to write
particular files, even files that the FSUID of the process owns; but this
can currently partially be bypassed using atomic write ioctls in two ways:

 - F2FS_IOC_START_ATOMIC_REPLACE + F2FS_IOC_COMMIT_ATOMIC_WRITE can
   truncate an inode to size 0
 - F2FS_IOC_START_ATOMIC_WRITE + F2FS_IOC_ABORT_ATOMIC_WRITE can revert
   changes another process concurrently made to a file

Fix it by requiring FMODE_WRITE for these operations, just like for
F2FS_IOC_MOVE_RANGE. Since any legitimate caller should only be using these
ioctls when intending to write into the file, that seems unlikely to break
anything.

Fixes: 88b88a667971 ("f2fs: support atomic writes")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 060bd64502c68..7ce22137afbe9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2054,6 +2054,9 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
@@ -2124,6 +2127,9 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
@@ -2166,6 +2172,9 @@ static int f2fs_ioc_start_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
@@ -2201,6 +2210,9 @@ static int f2fs_ioc_release_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
@@ -2230,6 +2242,9 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
-- 
2.43.0



