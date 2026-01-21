Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65753A6414;
	Wed, 21 Jan 2026 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020571; cv=none; b=jGiJU05rYeMsX73McayavXa5GmQa5/6V60U8GQW5ZdG7lkaNcUe7hASiaXUXNjSa4/QBMobpna/A8wuW+dH6CgP5gwri6fJXZsHOVPhJZfk2TUBg2KyJQXiNRq7DoZI1BsCKIpiSYMRHhKoTuTGV2bdvjxyANMdlZYm8r5uYIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020571; c=relaxed/simple;
	bh=QlXLj/psdQHrWsxuK4diY88GruKdvJvTg/6y1HmkskA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5D47/KXBNRzmGgrZh8B/yXrRnGA4iQ/odv0Wg3G3Y/wP/FU5nhfP1TbEQ5k4WzhlcIZAmYSqPoC+Om259juPUHJhdmGHp9Qzpxjfcfo1gdWh11jGFUWOW94Ndni+pk9ubOk2v4FP7jepksYjZIj4fSCteYC/5PCahK9FzMAp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDkXt6jZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDkXt6jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307E3C4CEF1;
	Wed, 21 Jan 2026 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020570;
	bh=QlXLj/psdQHrWsxuK4diY88GruKdvJvTg/6y1HmkskA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDkXt6jZvQvmfyS7/yg3CAvZbCn7v0J7rvYGBexbZ1ZoFFNjX6aJ5MyRctsH0X9p2
	 hFNGx/16D9+/5fqQr7LSRmK3bKe3sevb6z1APiBDFgEHz1C9a/E+Dr1CfGmpB0+5oW
	 CvYPspPbYnHTLGKkErKjnpYO39+mlnLGdX4aadoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/198] Revert "functionfs: fix the open/removal races"
Date: Wed, 21 Jan 2026 19:17:05 +0100
Message-ID: <20260121181425.648793094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b49c766856fb5901490de577e046149ebf15e39d which is
commit e5bf5ee266633cb18fff6f98f0b7d59a62819eee upstream.

It has been reported to cause test problems in Android devices.  As the
other functionfs changes were not also backported at the same time,
something is out of sync.  So just revert this one for now and it can
come back in the future as a patch series if it is tested.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   53 ++++++-------------------------------
 1 file changed, 10 insertions(+), 43 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -640,22 +640,13 @@ done_mutex:
 
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_sb->s_fs_info;
-	int ret;
-
-	/* Acquire mutex */
-	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
-	if (ret < 0)
-		return ret;
+	struct ffs_data *ffs = inode->i_private;
 
-	ffs_data_opened(ffs);
-	if (ffs->state == FFS_CLOSING) {
-		ffs_data_closed(ffs);
-		mutex_unlock(&ffs->mutex);
+	if (ffs->state == FFS_CLOSING)
 		return -EBUSY;
-	}
-	mutex_unlock(&ffs->mutex);
+
 	file->private_data = ffs;
+	ffs_data_opened(ffs);
 
 	return stream_open(inode, file);
 }
@@ -1202,33 +1193,14 @@ error:
 static int
 ffs_epfile_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_sb->s_fs_info;
-	struct ffs_epfile *epfile;
-	int ret;
-
-	/* Acquire mutex */
-	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
-	if (ret < 0)
-		return ret;
+	struct ffs_epfile *epfile = inode->i_private;
 
-	if (!atomic_inc_not_zero(&ffs->opened)) {
-		mutex_unlock(&ffs->mutex);
-		return -ENODEV;
-	}
-	/*
-	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
-	 * not enough, though - we might have been through FFS_CLOSING
-	 * and back to FFS_ACTIVE, with our file already removed.
-	 */
-	epfile = smp_load_acquire(&inode->i_private);
-	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
-		mutex_unlock(&ffs->mutex);
-		ffs_data_closed(ffs);
+	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
 		return -ENODEV;
-	}
-	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
+	ffs_data_opened(epfile->ffs);
+
 	return stream_open(inode, file);
 }
 
@@ -1360,7 +1332,7 @@ static void ffs_dmabuf_put(struct dma_bu
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = file->private_data;
+	struct ffs_epfile *epfile = inode->i_private;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2380,11 +2352,6 @@ static int ffs_epfiles_create(struct ffs
 	return 0;
 }
 
-static void clear_one(struct dentry *dentry)
-{
-	smp_store_release(&dentry->d_inode->i_private, NULL);
-}
-
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -2392,7 +2359,7 @@ static void ffs_epfiles_destroy(struct f
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, clear_one);
+			simple_recursive_removal(epfile->dentry, NULL);
 			epfile->dentry = NULL;
 		}
 	}


