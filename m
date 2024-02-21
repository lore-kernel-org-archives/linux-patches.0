Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589AB7C6E9;
	Wed, 21 Feb 2024 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524976; cv=none; b=SMDBQpYY6bOuoRZU2QDVGfgrFy37nXNoMjI8ATDtKi56ljIPFrlIsBH8RrFU417hEvCbbu5u70NaeLiFzBi8J/pjBhizxl6s0VWdiHTpgtrJT1SN+nrfzwUf1xQyW5rc7RDyAuzQc1FR9uhcOSf5eShUm1/VygyRGYGQWoXQiq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524976; c=relaxed/simple;
	bh=s448CnaVin2US6C1HATS7J88G6sbK4MZhMItcTef4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhMlZGc+U9FvVhP+kjVmYY11mlczvK6rPNCvQC+MsGa3l6k306a2URHD6F4qQlghS5e7/h9bbrr9Ix/Yuoi20LChzWi0RNAghtQ4HFIXs4nuQoLSNzTvLIyCXQqfgPeLY5ADofzYo14c6qrNgMONvVXcmo21weVilSGx4bGQ9i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4fQfG7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4fQfG7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A8CC43390;
	Wed, 21 Feb 2024 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524975;
	bh=s448CnaVin2US6C1HATS7J88G6sbK4MZhMItcTef4Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4fQfG7lx9r8Es8+1g/N+tCYZ5GpUvo0YbHpXpnF6PiEMP9ZGQuyJ+tCmwwzOHHt7
	 ytAA8sElwksLJwecE5mXlcWSIXT/IO3jipn387S/+lSe65t/vQaunbFUxtSSbVgjTV
	 TE61+5aXvKQndrjZ6JxpkIozzX3Agse1t2nWlGQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Mahmoud Adam <mngyadam@amazon.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.4 022/267] fs: add mode_strip_sgid() helper
Date: Wed, 21 Feb 2024 14:06:03 +0100
Message-ID: <20240221125940.747449739@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 2b3416ceff5e6bd4922f6d1c61fb68113dd82302 upstream.

[remove userns argument of helper for 5.4.y backport]

Add a dedicated helper to handle the setgid bit when creating a new file
in a setgid directory. This is a preparatory patch for moving setgid
stripping into the vfs. The patch contains no functional changes.

Currently the setgid stripping logic is open-coded directly in
inode_init_owner() and the individual filesystems are responsible for
handling setgid inheritance. Since this has proven to be brittle as
evidenced by old issues we uncovered over the last months (see [1] to
[3] below) we will try to move this logic into the vfs.

Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [1]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [2]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [3]
Link: https://lore.kernel.org/r/1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[commit 347750e1b69cef62966fbc5bd7dc579b4c00688a upstream
	backported from 5.10.y, resolved context conflicts]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c         |   34 ++++++++++++++++++++++++++++++----
 include/linux/fs.h |    1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2100,10 +2100,8 @@ void inode_init_owner(struct inode *inod
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(inode->i_gid) &&
-			 !capable_wrt_inode_uidgid(dir, CAP_FSETID))
-			mode &= ~S_ISGID;
+		else
+			mode = mode_strip_sgid(dir, mode);
 	} else
 		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
@@ -2359,3 +2357,31 @@ int vfs_ioc_fssetxattr_check(struct inod
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_p(dir->i_gid))
+		return mode;
+	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
+		return mode;
+
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1743,6 +1743,7 @@ extern long compat_ptr_ioctl(struct file
 extern void inode_init_owner(struct inode *inode, const struct inode *dir,
 			umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode);
 /*
  * VFS FS_IOC_FIEMAP helper definitions.
  */


