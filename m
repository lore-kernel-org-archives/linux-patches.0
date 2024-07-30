Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F31A6192;
	Tue, 30 Jul 2024 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359094; cv=none; b=R1ZtPGzPJQimN6JahAK7v+GXt0u3ePRdKEJvqCo8yYYNk3RvYBxu1DbUt55B+yhjMeuLWp5LfOql6mVmhNqDMe2Mx/XBQw2AOA5glkQKm0sv95Jjt634ZTC3U8oJ4hCoFxANbgufnN9FfPKt6ati95noKbS2wvtuj/aN0Qh0Yho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359094; c=relaxed/simple;
	bh=y2DUodAh+igN1VWMw14FzT8bJX1xxd16RoxL/S1QpYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzSPqPrsVz8zXbPs2SVeX4fu9MWeu9LGYWlKVzgHwip04q7fnC6C0fW/vek14kv/HHBqYsEbJLsKYITlYMCWb0A861bUl101K7Xxq0sBpyukMvi8osd/LefTyQRzc2TH6vtM8LMI3DCNf0nSNUjEM9AIkNsg/N0gOBx5n1zLQHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3i0iXNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3i0iXNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE332C32782;
	Tue, 30 Jul 2024 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359094;
	bh=y2DUodAh+igN1VWMw14FzT8bJX1xxd16RoxL/S1QpYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3i0iXNfw3LQfcLfW49KWFrqF1As0C+rGhRtHd97DAmJVrR+3G6HSYmuIV3zNmiXe
	 wgvQMrD7hyj2cxcIUR/zDRfqqSDlkKZGfNWzwvOw9ZmhGxzxRJXNLiebm0uZWqYdiA
	 ukhjkwxPwlfgugDhbqER8aYA4McTa8FWzvaUE1Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 431/568] hostfs: fix dev_t handling
Date: Tue, 30 Jul 2024 17:48:58 +0200
Message-ID: <20240730151656.715999639@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 267ed02c2121b75e0eaaa338240453b576039e4a upstream.

dev_t is a kernel type and may have different definitions
in kernel and userspace. On 32-bit x86 this currently makes
the stat structure being 4 bytes longer in the user code,
causing stack corruption.

However, this is (potentially) not the only problem, since
dev_t is a different type on user/kernel side, so we don't
know that the major/minor encoding isn't also different.
Decode/encode it instead to address both problems.

Cc: stable@vger.kernel.org
Fixes: 74ce793bcbde ("hostfs: Fix ephemeral inodes")
Link: https://patch.msgid.link/20240702092440.acc960585dd5.Id0767e12f562a69c6cd3c3262dc3d765db350cf6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hostfs/hostfs.h      |    7 ++++---
 fs/hostfs/hostfs_kern.c |   10 ++++++----
 fs/hostfs/hostfs_user.c |    7 ++++---
 3 files changed, 14 insertions(+), 10 deletions(-)

--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -63,9 +63,10 @@ struct hostfs_stat {
 	struct hostfs_timespec atime, mtime, ctime;
 	unsigned int blksize;
 	unsigned long long blocks;
-	unsigned int maj;
-	unsigned int min;
-	dev_t dev;
+	struct {
+		unsigned int maj;
+		unsigned int min;
+	} rdev, dev;
 };
 
 extern int stat_file(const char *path, struct hostfs_stat *p, int fd);
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -526,10 +526,11 @@ static int hostfs_inode_update(struct in
 static int hostfs_inode_set(struct inode *ino, void *data)
 {
 	struct hostfs_stat *st = data;
-	dev_t rdev;
+	dev_t dev, rdev;
 
 	/* Reencode maj and min with the kernel encoding.*/
-	rdev = MKDEV(st->maj, st->min);
+	rdev = MKDEV(st->rdev.maj, st->rdev.min);
+	dev = MKDEV(st->dev.maj, st->dev.min);
 
 	switch (st->mode & S_IFMT) {
 	case S_IFLNK:
@@ -555,7 +556,7 @@ static int hostfs_inode_set(struct inode
 		return -EIO;
 	}
 
-	HOSTFS_I(ino)->dev = st->dev;
+	HOSTFS_I(ino)->dev = dev;
 	ino->i_ino = st->ino;
 	ino->i_mode = st->mode;
 	return hostfs_inode_update(ino, st);
@@ -564,8 +565,9 @@ static int hostfs_inode_set(struct inode
 static int hostfs_inode_test(struct inode *inode, void *data)
 {
 	const struct hostfs_stat *st = data;
+	dev_t dev = MKDEV(st->dev.maj, st->dev.min);
 
-	return inode->i_ino == st->ino && HOSTFS_I(inode)->dev == st->dev;
+	return inode->i_ino == st->ino && HOSTFS_I(inode)->dev == dev;
 }
 
 static struct inode *hostfs_iget(struct super_block *sb, char *name)
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -34,9 +34,10 @@ static void stat64_to_hostfs(const struc
 	p->mtime.tv_nsec = 0;
 	p->blksize = buf->st_blksize;
 	p->blocks = buf->st_blocks;
-	p->maj = os_major(buf->st_rdev);
-	p->min = os_minor(buf->st_rdev);
-	p->dev = buf->st_dev;
+	p->rdev.maj = os_major(buf->st_rdev);
+	p->rdev.min = os_minor(buf->st_rdev);
+	p->dev.maj = os_major(buf->st_dev);
+	p->dev.min = os_minor(buf->st_dev);
 }
 
 int stat_file(const char *path, struct hostfs_stat *p, int fd)


