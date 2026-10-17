Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EA43C1983;
	Sat, 17 Oct 2026 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255520; cv=none; b=FxLzogEhZd2fUf9HguYj+V6TfGOzgdcY06xbNvB9ilnZ+gipftyXtHJpl8cJOHLxdsrVCghhIVNwZymb9+Xg7Cc7MxckcKeEbQydeZDjfLe2BNPImV/BWKmKeBsaTYAHP+4tmTvo8Ac2hjHcgiyj4xlT32+4gakXHkEksw4/pzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255520; c=relaxed/simple;
	bh=yW6T6CFeRjfjUgCkKnPtpEA2UnDIH+Ra/ERm+zX6RHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5UtQx1j0dRW1xzSuOLF7+QqqaHHr615fVZVJu/aJwrtzlGB1J55dmsMevZeITOZV+paNwTN2HNSihIIs9Fz/l7gBmIOCbogdrhJ0SO8A/vJUoBDnEEBZKQh3XnNV/JXimsE1GDleGMyZ/oqa8FTG0AClWT7EEEE/ljHJWnY1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6VT5YIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6VT5YIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212531F000C4;
	Sat, 17 Oct 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255518;
	bh=0jm1Bysqwl6erPdzHvexOXqebYdEJiifyndtaCZyD+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6VT5YIuu0E3IuMM4xFQVij312OmyxzjBJeq9yUTdlQSWbm/cO5XFBI/XF8XIwna6
	 XX2Fonehoo27zbHZ7JjpFM7TJrlLftqV1Zg0PI27Mm8VI/kcLXhtmpvmyJH7g4z+Lf
	 HnstRcOiqPm2ZOPm9Ch7TOMTfhylvTXPeX0iAqR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 804/869] functionfs: fix the open/removal races
Date: Sat, 17 Oct 2026 18:00:45 +0200
Message-ID: <20261017160057.513351237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/gadget/function/f_fs.c | 55 ++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 489054d369537..8bad59b4242c6 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -649,13 +649,22 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
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
@@ -1212,14 +1221,34 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
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
 		return -ENODEV;
+	}
+	ffs_data_get(ffs);
+	/*
+	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
+	 * not enough, though - we might have been through FFS_CLOSING
+	 * and back to FFS_ACTIVE, with our file already removed.
+	 */
+	epfile = smp_load_acquire(&inode->i_private);
+	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
+		mutex_unlock(&ffs->mutex);
+		ffs_data_closed(ffs);
+		return -ENODEV;
+	}
+	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
-	ffs_data_opened(epfile->ffs);
-
 	return stream_open(inode, file);
 }
 
@@ -1368,7 +1397,7 @@ static void ffs_dmabuf_put(struct dma_buf_attachment *attach)
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2413,6 +2442,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
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
@@ -2421,8 +2455,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
-			d_delete(epfile->dentry);
-			dput(epfile->dentry);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}
-- 
2.53.0



