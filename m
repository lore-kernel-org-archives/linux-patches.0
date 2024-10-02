Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8C1EB21;
	Wed,  2 Oct 2024 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880457; cv=none; b=iGQ1sOcP86Vg0yf3JxorgW1UCU4iUzG85YQPhnsPSQongZntqHJM1EK6hbMEIlq/ofJFy7m3Kp/IYbtumrJYVw6GCktaSAaQzSmumaxdPC88Vfp9WXNU5hL+qe3uWQK0XBVSAUk6uoiQ5GnQnj90dPRqRRTLspbIUMk0ct0FCZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880457; c=relaxed/simple;
	bh=F6ffWZKOUdvtJANy1bB/awFo+GyXuu8xOwpxv4vGang=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEsBQ6oHq4g1jS5tsFHdUbMLhmsu99lpnD7T8MGlu7eEzvVZ3pwBAH+xBEYHmo55T83UYFRPcFkGcH09hEDC6UKmpPNv/txeVnXOk05qOoLjY1e8UpopPCpizDgr9PHrIWP7SRrvFNLJYkR6e1+FIplhl7ONqbV/1RvodHY4oG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OKXU3mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OKXU3mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F65C4CEC2;
	Wed,  2 Oct 2024 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880457;
	bh=F6ffWZKOUdvtJANy1bB/awFo+GyXuu8xOwpxv4vGang=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OKXU3mNcF1Yox762KPQd+lEol63alRpKXDf/tfN57aE4k9W1eimIrMc7cqDc/yzN
	 oTeSEpLmIyN5n9QnkXLr74E+r5oG+a/8Mu100eMiACQtKTV3/VUfXPrEO3Ur0b4dot
	 BS8+Ne4XL1YEZzj1ECwux7ntJJzrLUg+zWUzlxsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 464/538] f2fs: Require FMODE_WRITE for atomic write ioctls
Date: Wed,  2 Oct 2024 15:01:43 +0200
Message-ID: <20241002125810.759687604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2100,6 +2100,9 @@ static int f2fs_ioc_start_atomic_write(s
 	loff_t isize;
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EACCES;
 
@@ -2206,6 +2209,9 @@ static int f2fs_ioc_commit_atomic_write(
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EACCES;
 
@@ -2238,6 +2244,9 @@ static int f2fs_ioc_abort_atomic_write(s
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 	int ret;
 
+	if (!(filp->f_mode & FMODE_WRITE))
+		return -EBADF;
+
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EACCES;
 


