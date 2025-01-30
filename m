Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F81C13D;
	Thu, 30 Jan 2025 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245674; cv=none; b=PyA6ZtvifKD2Ius3LuaWI767r9ksZ+5NCdeIffThXu4oOM09Z8RnornY0Md9xNpK48iAZqOZOlgX0n1hu46YsyouHM+bQzxWgGX3VrW71Gzr+yzUktMnI451I3r2nCdnld1hzJ0ZWJxU40oWcZd/2y5vbQFaA2odcw884Qkt2fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245674; c=relaxed/simple;
	bh=qPfx9kAU1/oyHdAGh+bC+tCwAngXMQSwXokJEtqfAYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvNg8W97esoCQuPVx95Ku/B4BCTsNWp2qh/j988ABWYirv1hGCXksQuJiPUeZ9UrWBGgkG1XbgjbQ5COulKYUaNzk/7Wxg2GkMH8R8JcdEg3s5oUmCiM2jf1unxJZi/QvaQA/Uy58aiUkwHNGAkU2d5v18umhMrz6L1dKR0iREw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgVRXd3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgVRXd3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCFBC4CED2;
	Thu, 30 Jan 2025 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245673;
	bh=qPfx9kAU1/oyHdAGh+bC+tCwAngXMQSwXokJEtqfAYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgVRXd3hk43pDHb1IGvcgzIPyh+TXTxa+2DxpkvZzUZF2DRgsGvYp54nkGNysMZ3u
	 E7GtVtEjkv8h8SYKI0/IkZE8hy+XkzBxkcaeE7BK86+hy5I7l2bSNWzAOaNAlKFiQg
	 r74QHl0+KrGDY9Vp08f9gGXa6k6ZtJ7cREc9rtXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 21/40] libfs: Replace simple_offset end-of-directory detection
Date: Thu, 30 Jan 2025 14:59:21 +0100
Message-ID: <20250130133500.561438053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 68a3a65003145644efcbb651e91db249ccd96281 upstream.

According to getdents(3), the d_off field in each returned directory
entry points to the next entry in the directory. The d_off field in
the last returned entry in the readdir buffer must contain a valid
offset value, but if it points to an actual directory entry, then
readdir/getdents can loop.

This patch introduces a specific fixed offset value that is placed
in the d_off field of the last entry in a directory. Some user space
applications assume that the EOD offset value is larger than the
offsets of real directory entries, so the largest valid offset value
is reserved for this purpose. This new value is never allocated by
simple_offset_add().

When ->iterate_dir() returns, getdents{64} inserts the ctx->pos
value into the d_off field of the last valid entry in the readdir
buffer. When it hits EOD, offset_readdir() sets ctx->pos to the EOD
offset value so the last entry is updated to point to the EOD marker.

When trying to read the entry at the EOD offset, offset_readdir()
terminates immediately.

It is worth noting that using a Maple tree for directory offset
value allocation does not guarantee a 63-bit range of values --
on platforms where "long" is a 32-bit type, the directory offset
value range is still 0..(2^31 - 1). For broad compatibility with
32-bit user space, the largest tmpfs directory cookie value is now
S32_MAX.

Fixes: 796432efab1e ("libfs: getdents() should return 0 after reaching EOD")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-5-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -241,9 +241,15 @@ const struct inode_operations simple_dir
 };
 EXPORT_SYMBOL(simple_dir_inode_operations);
 
-/* 0 is '.', 1 is '..', so always start with offset 2 or more */
+/* simple_offset_add() never assigns these to a dentry */
 enum {
-	DIR_OFFSET_MIN	= 2,
+	DIR_OFFSET_EOD		= S32_MAX,
+};
+
+/* simple_offset_add() allocation range */
+enum {
+	DIR_OFFSET_MIN		= 2,
+	DIR_OFFSET_MAX		= DIR_OFFSET_EOD - 1,
 };
 
 static void offset_set(struct dentry *dentry, long offset)
@@ -287,7 +293,8 @@ int simple_offset_add(struct offset_ctx
 		return -EBUSY;
 
 	ret = mtree_alloc_cyclic(&octx->mt, &offset, dentry, DIR_OFFSET_MIN,
-				 LONG_MAX, &octx->next_offset, GFP_KERNEL);
+				 DIR_OFFSET_MAX, &octx->next_offset,
+				 GFP_KERNEL);
 	if (unlikely(ret < 0))
 		return ret == -EBUSY ? -ENOSPC : ret;
 
@@ -443,8 +450,6 @@ static loff_t offset_dir_llseek(struct f
 		return -EINVAL;
 	}
 
-	/* In this case, ->private_data is protected by f_pos_lock */
-	file->private_data = NULL;
 	return vfs_setpos(file, offset, LONG_MAX);
 }
 
@@ -454,7 +459,7 @@ static struct dentry *offset_find_next(s
 	struct dentry *child, *found = NULL;
 
 	rcu_read_lock();
-	child = mas_find(&mas, LONG_MAX);
+	child = mas_find(&mas, DIR_OFFSET_MAX);
 	if (!child)
 		goto out;
 	spin_lock(&child->d_lock);
@@ -475,7 +480,7 @@ static bool offset_dir_emit(struct dir_c
 			  inode->i_ino, fs_umode_to_dtype(inode->i_mode));
 }
 
-static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
+static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 {
 	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *dentry;
@@ -483,7 +488,7 @@ static void *offset_iterate_dir(struct i
 	while (true) {
 		dentry = offset_find_next(octx, ctx->pos);
 		if (!dentry)
-			return ERR_PTR(-ENOENT);
+			goto out_eod;
 
 		if (!offset_dir_emit(ctx, dentry)) {
 			dput(dentry);
@@ -493,7 +498,10 @@ static void *offset_iterate_dir(struct i
 		ctx->pos = dentry2offset(dentry) + 1;
 		dput(dentry);
 	}
-	return NULL;
+	return;
+
+out_eod:
+	ctx->pos = DIR_OFFSET_EOD;
 }
 
 /**
@@ -513,6 +521,8 @@ static void *offset_iterate_dir(struct i
  *
  * On return, @ctx->pos contains an offset that will read the next entry
  * in this directory when offset_readdir() is called again with @ctx.
+ * Caller places this value in the d_off field of the last entry in the
+ * user's buffer.
  *
  * Return values:
  *   %0 - Complete
@@ -525,13 +535,8 @@ static int offset_readdir(struct file *f
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
-
-	/* In this case, ->private_data is protected by f_pos_lock */
-	if (ctx->pos == DIR_OFFSET_MIN)
-		file->private_data = NULL;
-	else if (file->private_data == ERR_PTR(-ENOENT))
-		return 0;
-	file->private_data = offset_iterate_dir(d_inode(dir), ctx);
+	if (ctx->pos != DIR_OFFSET_EOD)
+		offset_iterate_dir(d_inode(dir), ctx);
 	return 0;
 }
 


