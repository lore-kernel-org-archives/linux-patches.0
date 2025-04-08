Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86860269B11;
	Tue,  8 Apr 2025 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116629; cv=none; b=jdZCoPX+afmqnqv9uLLpFHB0P7SViAMhXcm++/Ivx/KKtmdMtkgEFUU69TP6szwlwwLrjMzON9c7n6n4u5zhGBpP+53bxsffx6vnTDzBRK5NGCkJ/wBxQtw7dr2dm7eAY1R13hqrop3MKrfn/B+LFRtm2qh9n/SRz+VlGq4aIGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116629; c=relaxed/simple;
	bh=XFi6+/yU/oLupjqVXl4DliClC1fGhzntWfqk1pK2CnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oroKTfD807SVyteGw+puiyZM9mw4HdxyJ5mDWbWbsw4y96/W+sztnUNwDUVM2/b+osm2yTMQk4JEIFVClU55HCBakjBtklHZBvANP6rqDi2lpDmZg2d2ji0onxaMIgUGENb84ST7/7cocyOm1lHpC4Ld/xwWjbXRGlVVgGZAjho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXOuxeGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXOuxeGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B130EC4CEE5;
	Tue,  8 Apr 2025 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116629;
	bh=XFi6+/yU/oLupjqVXl4DliClC1fGhzntWfqk1pK2CnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXOuxeGsmeJDH1p0q/nFXSUswllmhGDI7ZLybH071YV+yjY3XgZUad0zXKAc3prU+
	 OA7Tu81ECh2Awbvw2p/Sd/RiqCQd10gj9AEz+C4EFBCI/EfxFICvwRySMfDnPMTw+y
	 emFMOKgVYMc6IP1GWwTQDDiU9b+YNFqekEXhJ09U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/423] um: hostfs: avoid issues on inode number reuse by host
Date: Tue,  8 Apr 2025 12:48:55 +0200
Message-ID: <20250408104850.603467797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 94f3cc42c7403..a16a7df0766cd 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -33,6 +33,7 @@ struct hostfs_inode_info {
 	struct inode vfs_inode;
 	struct mutex open_mutex;
 	dev_t dev;
+	struct hostfs_timespec btime;
 };
 
 static inline struct hostfs_inode_info *HOSTFS_I(struct inode *inode)
@@ -550,6 +551,7 @@ static int hostfs_inode_set(struct inode *ino, void *data)
 	}
 
 	HOSTFS_I(ino)->dev = dev;
+	HOSTFS_I(ino)->btime = st->btime;
 	ino->i_ino = st->ino;
 	ino->i_mode = st->mode;
 	return hostfs_inode_update(ino, st);
@@ -560,7 +562,10 @@ static int hostfs_inode_test(struct inode *inode, void *data)
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



