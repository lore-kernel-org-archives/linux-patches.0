Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DED52222CB;
	Mon, 29 Dec 2025 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025378; cv=none; b=gZTeTWTW0JTnlkDMYzC5UsNJ1ax2s+pG/FzcDg0BrYmMqwPFjd3y3V9toXakyeRZ6YAzylGG8LqAE72qwJi6RoXZVKtV/dVG0rZBrRg9BsUkSU4xy4TI88aq7WU/6axjhyiGjydaieetnC+54vx2YeiGQSB9+5tZTrpXNHJ57SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025378; c=relaxed/simple;
	bh=WylmChFSpOvUUD8PSQ6RYwN9XZ5+o0tKfZJFHRl8MZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlXXuhaboGNz7NqPZsUr7AMm4YoOeenFf5QYiH2w5KcQpSc97n73tdPbqoQx0RmihUR4k3ZiuF3R9rr8Oz90ucDoAbn5nMWEPagey/JBqM75jcTsesDe3P6DUe5bzPnO/QNjAcMI/s0okayiR/xLDD9pYIrdpZfe98BMxvjqG7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+2QxE0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+2QxE0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FEFC4CEF7;
	Mon, 29 Dec 2025 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025378;
	bh=WylmChFSpOvUUD8PSQ6RYwN9XZ5+o0tKfZJFHRl8MZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+2QxE0SyVRjCE0d7vDjE7adq4FZAswD29jETrtg0E4y0bKzcRTRmJ4tyJb+lm5GV
	 wEkgRlsEWT1tOMWVDm9q5GsswgJ931DicJodIJTn0/6OxfSZhigFy+WAfrQo9C+Xwk
	 vmSvZKc8Xm3J4Ag4azLKYnQ7eQh6yNuEOw/m4rnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/430] functionfs: fix the open/removal races
Date: Mon, 29 Dec 2025 17:09:54 +0100
Message-ID: <20251229160731.421681554@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e5bf5ee266633cb18fff6f98f0b7d59a62819eee ]

ffs_epfile_open() can race with removal, ending up with file->private_data
pointing to freed object.

There is a total count of opened files on functionfs (both ep0 and
dynamic ones) and when it hits zero, dynamic files get removed.
Unfortunately, that removal can happen while another thread is
in ffs_epfile_open(), but has not incremented the count yet.
In that case open will succeed, leaving us with UAF on any subsequent
read() or write().

The root cause is that ffs->opened is misused; atomic_dec_and_test() vs.
atomic_add_return() is not a good idea, when object remains visible all
along.

To untangle that
	* serialize openers on ffs->mutex (both for ep0 and for dynamic files)
	* have dynamic ones use atomic_inc_not_zero() and fail if we had
zero ->opened; in that case the file we are opening is doomed.
	* have the inodes of dynamic files marked on removal (from the
callback of simple_recursive_removal()) - clear ->i_private there.
	* have open of dynamic ones verify they hadn't been already removed,
along with checking that state is FFS_ACTIVE.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 53 ++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff..69f6e3c0f7e0 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -640,13 +640,22 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	int ret;
 
-	if (ffs->state == FFS_CLOSING)
-		return -EBUSY;
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
 
-	file->private_data = ffs;
 	ffs_data_opened(ffs);
+	if (ffs->state == FFS_CLOSING) {
+		ffs_data_closed(ffs);
+		mutex_unlock(&ffs->mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&ffs->mutex);
+	file->private_data = ffs;
 
 	return stream_open(inode, file);
 }
@@ -1193,14 +1202,33 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 static int
 ffs_epfile_open(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	struct ffs_epfile *epfile;
+	int ret;
 
-	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
+
+	if (!atomic_inc_not_zero(&ffs->opened)) {
+		mutex_unlock(&ffs->mutex);
+		return -ENODEV;
+	}
+	/*
+	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
+	 * not enough, though - we might have been through FFS_CLOSING
+	 * and back to FFS_ACTIVE, with our file already removed.
+	 */
+	epfile = smp_load_acquire(&inode->i_private);
+	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
+		mutex_unlock(&ffs->mutex);
+		ffs_data_closed(ffs);
 		return -ENODEV;
+	}
+	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
-	ffs_data_opened(epfile->ffs);
-
 	return stream_open(inode, file);
 }
 
@@ -1332,7 +1360,7 @@ static void ffs_dmabuf_put(struct dma_buf_attachment *attach)
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2352,6 +2380,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
+static void clear_one(struct dentry *dentry)
+{
+	smp_store_release(&dentry->d_inode->i_private, NULL);
+}
+
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -2359,7 +2392,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}
-- 
2.51.0



