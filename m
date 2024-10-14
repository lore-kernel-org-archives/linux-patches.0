Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67D1AB534;
	Mon, 14 Oct 2024 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918762; cv=none; b=ntZzKUth3hXadRqjsC4jKnPXaCPvKx/F+6OcfCoEZ2zjwP8UInAf5spQ6q/nEZeTBArV5M8bp8Tw1N/VXf8xJMjbR2BjWpXfJh1rsPxi7uy9gmQBwqXA5iKpVtI0hWF14i/SQ3wRkLGJKmsLua9t0oYEkx1O0Fmfo9/1gPKoHy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918762; c=relaxed/simple;
	bh=l7EWOjVjjhv4jsZOLsXCqiYuuOAgwz8LT1gGWZ1Egv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH/XcL1Iet0rakb3bwFegviUK7F2JrrULO3ERD/mbtIF0LPdc2to3bsRV7qL0HLlJEBusOJqbBjzyycu2IiY8m5dGC7Mg4E0qMsfpGBBYdu5TmRVmE+UJNzzAxanY5lETmymztIXwCdCQu2WxctFNwsGvhlKucds/iSDzSLv2tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNVzlkr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNVzlkr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC0EC4CEC3;
	Mon, 14 Oct 2024 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918762;
	bh=l7EWOjVjjhv4jsZOLsXCqiYuuOAgwz8LT1gGWZ1Egv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNVzlkr3Om3FJPArLxzG2abJjCw/2DK5AK0+jvlAJWJADcYPRrhFG+o26A0N7gOVK
	 9B5mdeGNC/CcI8KTz9eLSuHtOldrD2/dnXIFSchsQe3VwZVhMrUt0sFU+bDuibkv8g
	 UMIT1QRfq87t/x2rQp5LUrv14hSadWaVCvI7a7D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/798] f2fs: Require FMODE_WRITE for atomic write ioctls
Date: Mon, 14 Oct 2024 16:16:10 +0200
Message-ID: <20241014141234.290289358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
 fs/f2fs/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1e1f640bf1c5c..6a2b5fcbe6799 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2108,6 +2108,9 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	loff_t isize;
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(mnt_userns, inode))
 		return -EACCES;
 
@@ -2209,6 +2212,9 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(mnt_userns, inode))
 		return -EACCES;
 
@@ -2241,6 +2247,9 @@ static int f2fs_ioc_abort_atomic_write(struct file *filp)
 	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(mnt_userns, inode))
 		return -EACCES;
 
-- 
2.43.0



