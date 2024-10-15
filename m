Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576AE1D0492;
	Tue, 15 Oct 2024 11:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993421; cv=none; b=ZvTbN9IPC2Sml9jNLyR0xZgtqmOMZRKMHs/Q5CYWIrAAto2f3lhNizrHDwu+EI8/TufawRKF7IBhMBHRkCo2ZH56FWLsAiPYgxXZrb5fOL1UHDssfcO9CO0UXJ9hGHU6NmiKrW/xBsbzH2nIJ1FITs06ZW31bF6CD9x2pcCTRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993421; c=relaxed/simple;
	bh=ALR4QYvOnlQklucaD0DX8Q1kIYiJYq0ZayK1mL0dOmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUy3qsfrEuDTcC3JQ0DozWXa8qwwfkhsbc5EJ+8Td6V13q0GbwKtyOrf0T55aEpt4aV67NoQ7O/jYbjhswyjSUQMNvnJuW5+36M14WUL4ygW6lmClsQI6N/Er1uPAcsgmTDeN3JHPy7GiQ8I5Y7Q6z6Z9zFP9VVQSUOzMzFMjfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ7hH12t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ7hH12t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA08BC4CECE;
	Tue, 15 Oct 2024 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993421;
	bh=ALR4QYvOnlQklucaD0DX8Q1kIYiJYq0ZayK1mL0dOmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ7hH12tNxPSMUBRtZXq1lO82LfqOyOZ1dBHStbQzJ6stdEmbcHOhW4gb/silj0k1
	 i77h58/+PPKMRih3dhI3B5Ldeh9p9ai80C+WtnU4vl6tmiooseKncB5Z1du/2U3y8D
	 /IfKc+9+NzyM2UFCr+3ik6metX5qW+O6dlmamdrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/691] f2fs: Require FMODE_WRITE for atomic write ioctls
Date: Tue, 15 Oct 2024 13:25:54 +0200
Message-ID: <20241015112456.458989147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index ee20d79bd93e4..b38ce5a7a2ef2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2010,6 +2010,9 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(&init_user_ns, inode))
 		return -EACCES;
 
@@ -2080,6 +2083,9 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(&init_user_ns, inode))
 		return -EACCES;
 
@@ -2122,6 +2128,9 @@ static int f2fs_ioc_start_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(&init_user_ns, inode))
 		return -EACCES;
 
@@ -2157,6 +2166,9 @@ static int f2fs_ioc_release_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(&init_user_ns, inode))
 		return -EACCES;
 
@@ -2186,6 +2198,9 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(&init_user_ns, inode))
 		return -EACCES;
 
-- 
2.43.0



