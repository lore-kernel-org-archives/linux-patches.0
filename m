Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180E9269830;
	Tue,  8 Apr 2025 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113362; cv=none; b=bqHBWUcxHv+KeUm85mlZnnzt7/P+FdSf26wIF3kiVmQCZvIPZXjN5mQXzB8zCCdD9JIoIN8SuSPDhIAaStQb2w9aDO9uvAudzoJC+YPj0OcgvuLWWnTzidkBYMr7GtqclPir4eSz6+UZPJijfOjLocuH5dgzzxi+W80fILkj6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113362; c=relaxed/simple;
	bh=ppssbzudWCMxTWKSS4DGzL4x3g/Iex0sOQ6DvYjj/pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJDJ5zBQ/oPqqv20bgn2ALv2AQYBRsgD0P6MQZFtzEoaU7rSmHl79ZrEaa+7sO2LAWWX+dEz6vJsoDCV6kOxBFmprbqOjPstAmsl+V9b3/I5iySPphtbbRkUwqpfbJI1a2wAIGj1P9kSO3+CzITeOSBk2JhJcF+HnXhrUEIQnIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJ1h9ygW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJ1h9ygW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A8AC4CEE5;
	Tue,  8 Apr 2025 11:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113361;
	bh=ppssbzudWCMxTWKSS4DGzL4x3g/Iex0sOQ6DvYjj/pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJ1h9ygWd2Xdb7FQmRya48dZ40xbeMk3ARI9BvLf/B1bG62PqvczinA99G8VjZG5a
	 Nz5Pb5ENnHBqP4iNH2voaKXmnb8v+NfRLZfRx1W47cEnWz7uLAuX4CN/UMZCoG19kZ
	 CYIdAI8htLR6D2G1ioE2VIxVF/UkDYZTVuhcg9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/268] um: hostfs: avoid issues on inode number reuse by host
Date: Tue,  8 Apr 2025 12:49:02 +0200
Message-ID: <20250408104832.041606298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 0bc754d1e31f40f4a343b692096d9e092ccc0370 ]

Some file systems (e.g. ext4) may reuse inode numbers once the inode is
not in use anymore. Usually hostfs will keep an FD open for each inode,
but this is not always the case. In the case of sockets, this cannot
even be done properly.

As such, the following sequence of events was possible:
 * application creates and deletes a socket
 * hostfs creates/deletes the socket on the host
 * inode is still in the hostfs cache
 * hostfs creates a new file
 * ext4 on the outside reuses the inode number
 * hostfs finds the socket inode for the newly created file
 * application receives -ENXIO when opening the file

As mentioned, this can only happen if the deleted file is a special file
that is never opened on the host (i.e. no .open fop).

As such, to prevent issues, it is sufficient to check that the inode
has the expected type. That said, also add a check for the inode birth
time, just to be on the safe side.

Fixes: 74ce793bcbde ("hostfs: Fix ephemeral inodes")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Mickaël Salaün <mic@digikod.net>
Tested-by: Mickaël Salaün <mic@digikod.net>
Link: https://patch.msgid.link/20250214092822.1241575-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs.h      |  2 +-
 fs/hostfs/hostfs_kern.c |  7 ++++-
 fs/hostfs/hostfs_user.c | 59 ++++++++++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 8b39c15c408cc..15b2f094d36ef 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -60,7 +60,7 @@ struct hostfs_stat {
 	unsigned int uid;
 	unsigned int gid;
 	unsigned long long size;
-	struct hostfs_timespec atime, mtime, ctime;
+	struct hostfs_timespec atime, mtime, ctime, btime;
 	unsigned int blksize;
 	unsigned long long blocks;
 	struct {
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index ff201753fd181..44fe76174e122 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -27,6 +27,7 @@ struct hostfs_inode_info {
 	struct inode vfs_inode;
 	struct mutex open_mutex;
 	dev_t dev;
+	struct hostfs_timespec btime;
 };
 
 static inline struct hostfs_inode_info *HOSTFS_I(struct inode *inode)
@@ -557,6 +558,7 @@ static int hostfs_inode_set(struct inode *ino, void *data)
 	}
 
 	HOSTFS_I(ino)->dev = dev;
+	HOSTFS_I(ino)->btime = st->btime;
 	ino->i_ino = st->ino;
 	ino->i_mode = st->mode;
 	return hostfs_inode_update(ino, st);
@@ -567,7 +569,10 @@ static int hostfs_inode_test(struct inode *inode, void *data)
 	const struct hostfs_stat *st = data;
 	dev_t dev = MKDEV(st->dev.maj, st->dev.min);
 
-	return inode->i_ino == st->ino && HOSTFS_I(inode)->dev == dev;
+	return inode->i_ino == st->ino && HOSTFS_I(inode)->dev == dev &&
+	       (inode->i_mode & S_IFMT) == (st->mode & S_IFMT) &&
+	       HOSTFS_I(inode)->btime.tv_sec == st->btime.tv_sec &&
+	       HOSTFS_I(inode)->btime.tv_nsec == st->btime.tv_nsec;
 }
 
 static struct inode *hostfs_iget(struct super_block *sb, char *name)
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 97e9c40a94488..3bcd9f35e70b2 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -18,39 +18,48 @@
 #include "hostfs.h"
 #include <utime.h>
 
-static void stat64_to_hostfs(const struct stat64 *buf, struct hostfs_stat *p)
+static void statx_to_hostfs(const struct statx *buf, struct hostfs_stat *p)
 {
-	p->ino = buf->st_ino;
-	p->mode = buf->st_mode;
-	p->nlink = buf->st_nlink;
-	p->uid = buf->st_uid;
-	p->gid = buf->st_gid;
-	p->size = buf->st_size;
-	p->atime.tv_sec = buf->st_atime;
-	p->atime.tv_nsec = 0;
-	p->ctime.tv_sec = buf->st_ctime;
-	p->ctime.tv_nsec = 0;
-	p->mtime.tv_sec = buf->st_mtime;
-	p->mtime.tv_nsec = 0;
-	p->blksize = buf->st_blksize;
-	p->blocks = buf->st_blocks;
-	p->rdev.maj = os_major(buf->st_rdev);
-	p->rdev.min = os_minor(buf->st_rdev);
-	p->dev.maj = os_major(buf->st_dev);
-	p->dev.min = os_minor(buf->st_dev);
+	p->ino = buf->stx_ino;
+	p->mode = buf->stx_mode;
+	p->nlink = buf->stx_nlink;
+	p->uid = buf->stx_uid;
+	p->gid = buf->stx_gid;
+	p->size = buf->stx_size;
+	p->atime.tv_sec = buf->stx_atime.tv_sec;
+	p->atime.tv_nsec = buf->stx_atime.tv_nsec;
+	p->ctime.tv_sec = buf->stx_ctime.tv_sec;
+	p->ctime.tv_nsec = buf->stx_ctime.tv_nsec;
+	p->mtime.tv_sec = buf->stx_mtime.tv_sec;
+	p->mtime.tv_nsec = buf->stx_mtime.tv_nsec;
+	if (buf->stx_mask & STATX_BTIME) {
+		p->btime.tv_sec = buf->stx_btime.tv_sec;
+		p->btime.tv_nsec = buf->stx_btime.tv_nsec;
+	} else {
+		memset(&p->btime, 0, sizeof(p->btime));
+	}
+	p->blksize = buf->stx_blksize;
+	p->blocks = buf->stx_blocks;
+	p->rdev.maj = buf->stx_rdev_major;
+	p->rdev.min = buf->stx_rdev_minor;
+	p->dev.maj = buf->stx_dev_major;
+	p->dev.min = buf->stx_dev_minor;
 }
 
 int stat_file(const char *path, struct hostfs_stat *p, int fd)
 {
-	struct stat64 buf;
+	struct statx buf;
+	int flags = AT_SYMLINK_NOFOLLOW;
 
 	if (fd >= 0) {
-		if (fstat64(fd, &buf) < 0)
-			return -errno;
-	} else if (lstat64(path, &buf) < 0) {
-		return -errno;
+		flags |= AT_EMPTY_PATH;
+		path = "";
 	}
-	stat64_to_hostfs(&buf, p);
+
+	if ((statx(fd, path, flags, STATX_BASIC_STATS | STATX_BTIME, &buf)) < 0)
+		return -errno;
+
+	statx_to_hostfs(&buf, p);
 	return 0;
 }
 
-- 
2.39.5



