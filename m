Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C243254B1;
	Mon, 27 Oct 2025 19:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592450; cv=none; b=SnOqmAgaWNXwFsNAgAzf7cxeUIMwnrfkb3zbHbdD3ADjdWme7S5LYrx8ZrCABrSh2izwkFQCV5TUnWuPlLU1OHN8LyaoydLkchheV5vGRCgsZk0qqb5ogLyQPSN+ey3I9A/L90fCyExKfpuLTNTU25IzY1vrwu1zT71xKLV/1Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592450; c=relaxed/simple;
	bh=e2uFfYMQaHrcq6Jkl9b3c8eZMqCsVBTKSjjFhqFMQvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMZjavEQgBKBmtYv4mWCkNIc0yHQv9xZL3SceQlfkUpm8B5cIxrUNk3/iS4fgVtL4QOawUD9ATCtEfdLD2w1dFEp9bc+qu9UsL3CQItuM4d6DRbB9dN582sVSAMroZsxf8jcAZssXKCZm6wyta49/H7Os93jqlbxZ2OoVh6STwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQinwap0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQinwap0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31FEC4CEF1;
	Mon, 27 Oct 2025 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592450;
	bh=e2uFfYMQaHrcq6Jkl9b3c8eZMqCsVBTKSjjFhqFMQvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQinwap00/6UCmAJDYUvta7ooZLMBuPjzlAog2A/+RRF0dT9lJI4rjw1wM59hTdwY
	 /e6Jgk94agab/oRlqG9JMByCaWeJwnxS4/WJYvHD/i50oxaIkWUR0SAB2TqT0dY+mV
	 boOaJcVONOMFKW8XyUKNDgBe3TpWAT6jzvQN4xCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/157] fuse: allocate ff->release_args only if release is needed
Date: Mon, 27 Oct 2025 19:36:27 +0100
Message-ID: <20251027183504.630545833@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit e26ee4efbc79610b20e7abe9d96c87f33dacc1ff ]

This removed the need to pass isdir argument to fuse_put_file().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 26e5c67deb2e ("fuse: fix livelock in synchronous file put from fuseblk workers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c    |    2 -
 fs/fuse/file.c   |   69 +++++++++++++++++++++++++++++++------------------------
 fs/fuse/fuse_i.h |    2 -
 3 files changed, 41 insertions(+), 32 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -584,7 +584,7 @@ static int fuse_create_open(struct inode
 		goto out_err;
 
 	err = -ENOMEM;
-	ff = fuse_file_alloc(fm);
+	ff = fuse_file_alloc(fm, true);
 	if (!ff)
 		goto out_put_forget_req;
 
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -54,7 +54,7 @@ struct fuse_release_args {
 	struct inode *inode;
 };
 
-struct fuse_file *fuse_file_alloc(struct fuse_mount *fm)
+struct fuse_file *fuse_file_alloc(struct fuse_mount *fm, bool release)
 {
 	struct fuse_file *ff;
 
@@ -63,11 +63,13 @@ struct fuse_file *fuse_file_alloc(struct
 		return NULL;
 
 	ff->fm = fm;
-	ff->release_args = kzalloc(sizeof(*ff->release_args),
-				   GFP_KERNEL_ACCOUNT);
-	if (!ff->release_args) {
-		kfree(ff);
-		return NULL;
+	if (release) {
+		ff->release_args = kzalloc(sizeof(*ff->release_args),
+					   GFP_KERNEL_ACCOUNT);
+		if (!ff->release_args) {
+			kfree(ff);
+			return NULL;
+		}
 	}
 
 	INIT_LIST_HEAD(&ff->write_entry);
@@ -103,14 +105,14 @@ static void fuse_release_end(struct fuse
 	kfree(ra);
 }
 
-static void fuse_file_put(struct fuse_file *ff, bool sync, bool isdir)
+static void fuse_file_put(struct fuse_file *ff, bool sync)
 {
 	if (refcount_dec_and_test(&ff->count)) {
-		struct fuse_args *args = &ff->release_args->args;
+		struct fuse_release_args *ra = ff->release_args;
+		struct fuse_args *args = (ra ? &ra->args : NULL);
 
-		if (isdir ? ff->fm->fc->no_opendir : ff->fm->fc->no_open) {
-			/* Do nothing when client does not implement 'open' */
-			fuse_release_end(ff->fm, args, 0);
+		if (!args) {
+			/* Do nothing when server does not implement 'open' */
 		} else if (sync) {
 			fuse_simple_request(ff->fm, args);
 			fuse_release_end(ff->fm, args, 0);
@@ -130,15 +132,16 @@ struct fuse_file *fuse_file_open(struct
 	struct fuse_conn *fc = fm->fc;
 	struct fuse_file *ff;
 	int opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
+	bool open = isdir ? !fc->no_opendir : !fc->no_open;
 
-	ff = fuse_file_alloc(fm);
+	ff = fuse_file_alloc(fm, open);
 	if (!ff)
 		return ERR_PTR(-ENOMEM);
 
 	ff->fh = 0;
 	/* Default for no-open */
 	ff->open_flags = FOPEN_KEEP_CACHE | (isdir ? FOPEN_CACHE_DIR : 0);
-	if (isdir ? !fc->no_opendir : !fc->no_open) {
+	if (open) {
 		struct fuse_open_out outarg;
 		int err;
 
@@ -146,11 +149,13 @@ struct fuse_file *fuse_file_open(struct
 		if (!err) {
 			ff->fh = outarg.fh;
 			ff->open_flags = outarg.open_flags;
-
 		} else if (err != -ENOSYS) {
 			fuse_file_free(ff);
 			return ERR_PTR(err);
 		} else {
+			/* No release needed */
+			kfree(ff->release_args);
+			ff->release_args = NULL;
 			if (isdir)
 				fc->no_opendir = 1;
 			else
@@ -272,7 +277,7 @@ out_inode_unlock:
 }
 
 static void fuse_prepare_release(struct fuse_inode *fi, struct fuse_file *ff,
-				 unsigned int flags, int opcode)
+				 unsigned int flags, int opcode, bool sync)
 {
 	struct fuse_conn *fc = ff->fm->fc;
 	struct fuse_release_args *ra = ff->release_args;
@@ -290,6 +295,9 @@ static void fuse_prepare_release(struct
 
 	wake_up_interruptible_all(&ff->poll_wait);
 
+	if (!ra)
+		return;
+
 	ra->inarg.fh = ff->fh;
 	ra->inarg.flags = flags;
 	ra->args.in_numargs = 1;
@@ -299,6 +307,13 @@ static void fuse_prepare_release(struct
 	ra->args.nodeid = ff->nodeid;
 	ra->args.force = true;
 	ra->args.nocreds = true;
+
+	/*
+	 * Hold inode until release is finished.
+	 * From fuse_sync_release() the refcount is 1 and everything's
+	 * synchronous, so we are fine with not doing igrab() here.
+	 */
+	ra->inode = sync ? NULL : igrab(&fi->inode);
 }
 
 void fuse_file_release(struct inode *inode, struct fuse_file *ff,
@@ -308,14 +323,12 @@ void fuse_file_release(struct inode *ino
 	struct fuse_release_args *ra = ff->release_args;
 	int opcode = isdir ? FUSE_RELEASEDIR : FUSE_RELEASE;
 
-	fuse_prepare_release(fi, ff, open_flags, opcode);
+	fuse_prepare_release(fi, ff, open_flags, opcode, false);
 
-	if (ff->flock) {
+	if (ra && ff->flock) {
 		ra->inarg.release_flags |= FUSE_RELEASE_FLOCK_UNLOCK;
 		ra->inarg.lock_owner = fuse_lock_owner_id(ff->fm->fc, id);
 	}
-	/* Hold inode until release is finished */
-	ra->inode = igrab(inode);
 
 	/*
 	 * Normally this will send the RELEASE request, however if
@@ -326,7 +339,7 @@ void fuse_file_release(struct inode *ino
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff, ff->fm->fc->destroy, isdir);
+	fuse_file_put(ff, ff->fm->fc->destroy);
 }
 
 void fuse_release_common(struct file *file, bool isdir)
@@ -361,12 +374,8 @@ void fuse_sync_release(struct fuse_inode
 		       unsigned int flags)
 {
 	WARN_ON(refcount_read(&ff->count) > 1);
-	fuse_prepare_release(fi, ff, flags, FUSE_RELEASE);
-	/*
-	 * iput(NULL) is a no-op and since the refcount is 1 and everything's
-	 * synchronous, we are fine with not doing igrab() here"
-	 */
-	fuse_file_put(ff, true, false);
+	fuse_prepare_release(fi, ff, flags, FUSE_RELEASE, true);
+	fuse_file_put(ff, true);
 }
 EXPORT_SYMBOL_GPL(fuse_sync_release);
 
@@ -923,7 +932,7 @@ static void fuse_readpages_end(struct fu
 		put_page(page);
 	}
 	if (ia->ff)
-		fuse_file_put(ia->ff, false, false);
+		fuse_file_put(ia->ff, false);
 
 	fuse_io_free(ia);
 }
@@ -1670,7 +1679,7 @@ static void fuse_writepage_free(struct f
 		__free_page(ap->pages[i]);
 
 	if (wpa->ia.ff)
-		fuse_file_put(wpa->ia.ff, false, false);
+		fuse_file_put(wpa->ia.ff, false);
 
 	kfree(ap->pages);
 	kfree(wpa);
@@ -1918,7 +1927,7 @@ int fuse_write_inode(struct inode *inode
 	ff = __fuse_write_file_get(fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
-		fuse_file_put(ff, false, false);
+		fuse_file_put(ff, false);
 
 	return err;
 }
@@ -2316,7 +2325,7 @@ static int fuse_writepages(struct addres
 		fuse_writepages_send(&data);
 	}
 	if (data.ff)
-		fuse_file_put(data.ff, false, false);
+		fuse_file_put(data.ff, false);
 
 	kfree(data.orig_pages);
 out:
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1022,7 +1022,7 @@ void fuse_read_args_fill(struct fuse_io_
  */
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir);
 
-struct fuse_file *fuse_file_alloc(struct fuse_mount *fm);
+struct fuse_file *fuse_file_alloc(struct fuse_mount *fm, bool release);
 void fuse_file_free(struct fuse_file *ff);
 void fuse_finish_open(struct inode *inode, struct file *file);
 


