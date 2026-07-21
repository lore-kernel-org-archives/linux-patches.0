Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B0E47143A;
	Tue, 21 Jul 2026 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659698; cv=none; b=NWwAYXE628LpQBk5nEtHNw2hrk+2HU/JqBK4x9XqsxRuaVRvscFuf4I5OojD1xfNPQz2EGav7Tzqkbw1xHu7h4vDa9zTwze5p1dm7Wh5zBlTFQywek3q+r1RCqzLD3N+DaJi21M8wIStvfiHXVA47ldDK9J/ijvttgT3laBhGCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659698; c=relaxed/simple;
	bh=OvOHasm8/PFcJMtj8l8Ekvp0FtPl070peNIZ9uXNlyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKA3m24dn8eiDhQTfItcCN90TGNB16JrFmJLyF5RRLGzJ8VuCJLqJPbIdABZLkFSO2N0SDdyXFyi0hoZQM8oN4kNsjpZ8hjGdEo4NzFJCksvZVXAIllUgojpAwxa2ACCeyoUobFgahe47sfi1OP2JQ9IWF2z4lAZAUmO68LzBvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGvkcn9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGvkcn9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BCD1F00A3A;
	Tue, 21 Jul 2026 18:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659690;
	bh=fa2PcGhI2vS8Zo5gqzTFW03qLqFKCxvwQ70v+Bmi4No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGvkcn9AnY0wFAdB53jey7oEAcTyCdDPiJotw0MT4pz/yWAmKSQIId0lQm+gGwHxg
	 9lnzZiJsxcf3g/jlb5llTTK+hYIXNhcatOVttGTWnLbjjALqZzfxonvvMupor2KThn
	 UbLQIDTrjBlXA1kzxuWPwdN6odkaApRNQrAJvHMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1581/1611] functionfs: switch to simple_remove_by_name()
Date: Tue, 21 Jul 2026 17:28:17 +0200
Message-ID: <20260721152551.033534669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c7747fafaba0dcdad3d7da240e961927b4865f98 ]

No need to return dentry from ffs_sb_create_file() or keep it around
afterwards.

To avoid subtle issues with getting to ffs from epfiles in
ffs_epfiles_destroy(), pass the superblock as explicit argument.
Callers have it anyway.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 3137b243c939 ("usb: gadget: f_fs: initialize reset_work at allocation time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   51 +++++++++++++++----------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -162,8 +162,6 @@ struct ffs_epfile {
 	struct ffs_data			*ffs;
 	struct ffs_ep			*ep;	/* P: ffs->eps_lock */
 
-	struct dentry			*dentry;
-
 	/*
 	 * Buffer for holding data from partial reads which may happen since
 	 * we’re rounding user read requests to a multiple of a max packet size.
@@ -273,11 +271,11 @@ struct ffs_desc_helper {
 };
 
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count);
 
-static struct dentry *
-ffs_sb_create_file(struct super_block *sb, const char *name, void *data,
-		   const struct file_operations *fops);
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops);
 
 /* Devices management *******************************************************/
 
@@ -1881,9 +1879,8 @@ ffs_sb_make_inode(struct super_block *sb
 }
 
 /* Create "regular" file */
-static struct dentry *ffs_sb_create_file(struct super_block *sb,
-					const char *name, void *data,
-					const struct file_operations *fops)
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops)
 {
 	struct ffs_data	*ffs = sb->s_fs_info;
 	struct dentry	*dentry;
@@ -1891,16 +1888,16 @@ static struct dentry *ffs_sb_create_file
 
 	dentry = d_alloc_name(sb->s_root, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	d_add(dentry, inode);
-	return dentry;
+	return 0;
 }
 
 /* Super block */
@@ -1943,10 +1940,7 @@ static int ffs_sb_fill(struct super_bloc
 		return -ENOMEM;
 
 	/* EP0 file */
-	if (!ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations))
-		return -ENOMEM;
-
-	return 0;
+	return ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations);
 }
 
 enum {
@@ -2180,7 +2174,7 @@ static void ffs_data_closed(struct ffs_d
 							flags);
 
 			if (epfiles)
-				ffs_epfiles_destroy(epfiles,
+				ffs_epfiles_destroy(ffs->sb, epfiles,
 						 ffs->eps_count);
 
 			if (ffs->setup_state == FFS_SETUP_PENDING)
@@ -2239,7 +2233,7 @@ static void ffs_data_clear(struct ffs_da
 	 * copy of epfile will save us from use-after-free.
 	 */
 	if (epfiles) {
-		ffs_epfiles_destroy(epfiles, ffs->eps_count);
+		ffs_epfiles_destroy(ffs->sb, epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -2336,6 +2330,7 @@ static int ffs_epfiles_create(struct ffs
 {
 	struct ffs_epfile *epfile, *epfiles;
 	unsigned i, count;
+	int err;
 
 	count = ffs->eps_count;
 	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
@@ -2353,12 +2348,11 @@ static int ffs_epfiles_create(struct ffs
 		else
 			sprintf(epfile->name, "ep%u", i);
 		epfile->in = (ffs->eps_addrmap[i] & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
-		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
-						 epfile,
-						 &ffs_epfile_operations);
-		if (!epfile->dentry) {
-			ffs_epfiles_destroy(epfiles, i - 1);
-			return -ENOMEM;
+		err = ffs_sb_create_file(ffs->sb, epfile->name,
+					 epfile, &ffs_epfile_operations);
+		if (err) {
+			ffs_epfiles_destroy(ffs->sb, epfiles, i - 1);
+			return err;
 		}
 	}
 
@@ -2366,16 +2360,15 @@ static int ffs_epfiles_create(struct ffs
 	return 0;
 }
 
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
+	struct dentry *root = sb->s_root;
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
-		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
-			epfile->dentry = NULL;
-		}
+		simple_remove_by_name(root, epfile->name, NULL);
 	}
 
 	kfree(epfiles);


