Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D001A76A1;
	Tue, 30 Jul 2024 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360261; cv=none; b=pgSAfkGkRirDzAGcpy84EOFePz5hQWj6rN+R/6lnLbMHo1agYsKwtnGSvgDlYo1sVKP0y7Xnh3YeGOCGCXQ2pvGjR5TNbvMrDkGoyOqtrEPhdNj9aI7rQl751cv89V6xo8xUptFXR8GS4oNMuDE58zAFN3pBBqRoc7Qq05+ZAuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360261; c=relaxed/simple;
	bh=6atmmIvTP/EcoxBleyBbs0BkrNgHLlc/GWvfRim/q0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt/TbIqv7KeL/5jrtcdRGNxb5bvuw1+HX5ShJrT6fV2HeP4V5/4/eiAKs2Zdi4R0ZQWQyoFHW80OFFBEws15R8XkcTWPIiuAIHLqv6zR04/0R3sMZZ5WQ3ZNeLrrOzpKXqrSdlU4kDCFSxrN/6XJrigbkLCl6Sy4bG3fzKKYZGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkLILYQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkLILYQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57390C4AF0C;
	Tue, 30 Jul 2024 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360260;
	bh=6atmmIvTP/EcoxBleyBbs0BkrNgHLlc/GWvfRim/q0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkLILYQIZb05CUceRrYphzpH+RVtk/dsJd293zEC70a5ElgaSPygC4OKwPiK7hfe/
	 V8TDuNHPrxmLWj9TTwQ9Zkzeu3Grk7fLrGS9OnxcBK06F2pn+FQvKeL/qKG8/kr8pR
	 C+hoXUj6ptSJUYbrcVF6Ij1Bl4GStqeQzDurNM18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.10 645/809] hostfs: fix dev_t handling
Date: Tue, 30 Jul 2024 17:48:41 +0200
Message-ID: <20240730151750.345086760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -530,10 +530,11 @@ static int hostfs_inode_update(struct in
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
@@ -559,7 +560,7 @@ static int hostfs_inode_set(struct inode
 		return -EIO;
 	}
 
-	HOSTFS_I(ino)->dev = st->dev;
+	HOSTFS_I(ino)->dev = dev;
 	ino->i_ino = st->ino;
 	ino->i_mode = st->mode;
 	return hostfs_inode_update(ino, st);
@@ -568,8 +569,9 @@ static int hostfs_inode_set(struct inode
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


