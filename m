Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC486C13D;
	Thu, 30 Jan 2025 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245614; cv=none; b=n+sbOlpOAHZ4mEdKcxnq+zoX6gACVsdKQt290Nl/T737qUqt/LSfQX47jaA8M2gtlS+ZmikzmjQOprsJJH6LzN1yXIsS5WSVMkP1BXBbkgSRy2PJaoqGw7tAdCihmGNuABlEK8paxIk/T1oG3FyW4DCrWv8bXkjNzNa3bpfcYfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245614; c=relaxed/simple;
	bh=t6vAwATcBbTyQ4gXrn2A5QS7S3SnF2NsKDtplk8SvWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsdGwYKtd35f0hM6bJ/qXpHdTAYRQIZ2VBUQIxpH6p5n2BJjAml16cFedmP/ygmak3m52QZjFgkldVu/GiSM5jKEqTDK9ILPa0mIVejGGxppuiTVIz6AwTsPGbLzQtAJBK1btQZ5lCHlUqY5pQdOYMcbCLGLxgrdP1BFrbXQRsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd9oKJuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd9oKJuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E0FC4CED2;
	Thu, 30 Jan 2025 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245614;
	bh=t6vAwATcBbTyQ4gXrn2A5QS7S3SnF2NsKDtplk8SvWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd9oKJuOatWs5TyFHeei+ZzHyJCMpo/+P85uSHy1VwA5IqmJWewnl+m/KVP6GPg6I
	 jyEwFm9oSSrSmbS/h+xje02JlFZan4yT7OSbEZqDRdHBbOdjunKCbEMknqqcsmb2sJ
	 CrhyWCnXJQTw2iIMIbSauoLcwWztijR9vgDVUKAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 06/25] libfs: Use d_children list to iterate simple_offset directories
Date: Thu, 30 Jan 2025 14:58:52 +0100
Message-ID: <20250130133457.183993628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit b9b588f22a0c049a14885399e27625635ae6ef91 upstream.

The mtree mechanism has been effective at creating directory offsets
that are stable over multiple opendir instances. However, it has not
been able to handle the subtleties of renames that are concurrent
with readdir.

Instead of using the mtree to emit entries in the order of their
offset values, use it only to map incoming ctx->pos to a starting
entry. Then use the directory's d_children list, which is already
maintained properly by the dcache, to find the next child to emit.

One of the sneaky things about this is that when the mtree-allocated
offset value wraps (which is very rare), looking up ctx->pos++ is
not going to find the next entry; it will return NULL. Instead, by
following the d_children list, the offset values can appear in any
order but all of the entries in the directory will be visited
eventually.

Note also that the readdir() is guaranteed to reach the tail of this
list. Entries are added only at the head of d_children, and readdir
walks from its current position in that list towards its tail.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-6-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   84 ++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 26 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -247,12 +247,13 @@ EXPORT_SYMBOL(simple_dir_inode_operation
 
 /* simple_offset_add() never assigns these to a dentry */
 enum {
+	DIR_OFFSET_FIRST	= 2,		/* Find first real entry */
 	DIR_OFFSET_EOD		= S32_MAX,
 };
 
 /* simple_offset_add() allocation range */
 enum {
-	DIR_OFFSET_MIN		= 2,
+	DIR_OFFSET_MIN		= DIR_OFFSET_FIRST + 1,
 	DIR_OFFSET_MAX		= DIR_OFFSET_EOD - 1,
 };
 
@@ -457,51 +458,82 @@ static loff_t offset_dir_llseek(struct f
 	return vfs_setpos(file, offset, LONG_MAX);
 }
 
-static struct dentry *offset_find_next(struct offset_ctx *octx, loff_t offset)
+static struct dentry *find_positive_dentry(struct dentry *parent,
+					   struct dentry *dentry,
+					   bool next)
+{
+	struct dentry *found = NULL;
+
+	spin_lock(&parent->d_lock);
+	if (next)
+		dentry = d_next_sibling(dentry);
+	else if (!dentry)
+		dentry = d_first_child(parent);
+	hlist_for_each_entry_from(dentry, d_sib) {
+		if (!simple_positive(dentry))
+			continue;
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		if (simple_positive(dentry))
+			found = dget_dlock(dentry);
+		spin_unlock(&dentry->d_lock);
+		if (likely(found))
+			break;
+	}
+	spin_unlock(&parent->d_lock);
+	return found;
+}
+
+static noinline_for_stack struct dentry *
+offset_dir_lookup(struct dentry *parent, loff_t offset)
 {
-	MA_STATE(mas, &octx->mt, offset, offset);
+	struct inode *inode = d_inode(parent);
+	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *child, *found = NULL;
 
-	rcu_read_lock();
-	child = mas_find(&mas, DIR_OFFSET_MAX);
-	if (!child)
-		goto out;
-	spin_lock(&child->d_lock);
-	if (simple_positive(child))
-		found = dget_dlock(child);
-	spin_unlock(&child->d_lock);
-out:
-	rcu_read_unlock();
+	MA_STATE(mas, &octx->mt, offset, offset);
+
+	if (offset == DIR_OFFSET_FIRST)
+		found = find_positive_dentry(parent, NULL, false);
+	else {
+		rcu_read_lock();
+		child = mas_find(&mas, DIR_OFFSET_MAX);
+		found = find_positive_dentry(parent, child, false);
+		rcu_read_unlock();
+	}
 	return found;
 }
 
 static bool offset_dir_emit(struct dir_context *ctx, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
-	long offset = dentry2offset(dentry);
 
-	return ctx->actor(ctx, dentry->d_name.name, dentry->d_name.len, offset,
-			  inode->i_ino, fs_umode_to_dtype(inode->i_mode));
+	return dir_emit(ctx, dentry->d_name.name, dentry->d_name.len,
+			inode->i_ino, fs_umode_to_dtype(inode->i_mode));
 }
 
-static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
+static void offset_iterate_dir(struct file *file, struct dir_context *ctx)
 {
-	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
+	struct dentry *dir = file->f_path.dentry;
 	struct dentry *dentry;
 
+	dentry = offset_dir_lookup(dir, ctx->pos);
+	if (!dentry)
+		goto out_eod;
 	while (true) {
-		dentry = offset_find_next(octx, ctx->pos);
-		if (!dentry)
-			goto out_eod;
+		struct dentry *next;
 
-		if (!offset_dir_emit(ctx, dentry)) {
-			dput(dentry);
+		ctx->pos = dentry2offset(dentry);
+		if (!offset_dir_emit(ctx, dentry))
 			break;
-		}
 
-		ctx->pos = dentry2offset(dentry) + 1;
+		next = find_positive_dentry(dir, dentry, true);
 		dput(dentry);
+
+		if (!next)
+			goto out_eod;
+		dentry = next;
 	}
+	dput(dentry);
 	return;
 
 out_eod:
@@ -540,7 +572,7 @@ static int offset_readdir(struct file *f
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 	if (ctx->pos != DIR_OFFSET_EOD)
-		offset_iterate_dir(d_inode(dir), ctx);
+		offset_iterate_dir(file, ctx);
 	return 0;
 }
 


