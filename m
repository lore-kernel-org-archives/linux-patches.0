Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12615FA91;
	Mon, 27 May 2024 19:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837788; cv=none; b=rf0AM5X4PoRjwIEJSLts6S2GXnvSGXUn1wyNEsRcZ/7XtL0NLqVeGLXUTGDKhnpWKJP76sJJYPn20XzUDayRFySEABa2KjcUn/fM7xYcrG6RpDX9no1uaNW5yTm05Rb/9m5+NzU3838rYSkHRWlrg2aUllQhHLleDiSnjh/GZOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837788; c=relaxed/simple;
	bh=F2azrsx0tc02+V8hyBNtYRiUTZDvGHHxSlbaYhBL14Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byoeXKwDv+7fp92DoDH/RH7NXzMwEKx7+cHw9sjZPXHfCZoL13B60AYcaRBeoZC4oUjA/x3gk8pKYoIOVWeCZNnbYTkcaPkGVhhIaY7k2X/1pH5TRki5NzE8UI/7k7m/uYQ23xHRkySW97LCVpfdCkbMkpuTgOWU4OpTdG4F+fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n41i7pX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n41i7pX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484BDC2BBFC;
	Mon, 27 May 2024 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837788;
	bh=F2azrsx0tc02+V8hyBNtYRiUTZDvGHHxSlbaYhBL14Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n41i7pX3RsIS9X2tUSOmlIg7yyYhqj0qSFos4n1dMDvWAsJPwxjtjmhBrBrng4bDB
	 +jqMDxOLoLTdXzoTJT/UJgZInxitoTghyXoHmy7JUSDDE0lDoRMVlp72hgoHnT6kZP
	 mYg98bt48KQIPKRaytilkYjhfAaWxWrkNP72AKyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 128/493] libfs: Re-arrange locking in offset_iterate_dir()
Date: Mon, 27 May 2024 20:52:10 +0200
Message-ID: <20240527185634.678787875@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3f6d810665dfde0d33785420618ceb03fba0619d ]

Liam and Matthew say that once the RCU read lock is released,
xa_state is not safe to re-use for the next xas_find() call. But the
RCU read lock must be released on each loop iteration so that
dput(), which might_sleep(), can be called safely.

Thus we are forced to walk the offset tree with fresh state for each
directory entry. xa_find() can do this for us, though it might be a
little less efficient than maintaining xa_state locally.

We believe that in the current code base, inode->i_rwsem provides
protection for the xa_state maintained in
offset_iterate_dir(). However, there is no guarantee that will
continue to be the case in the future.

Since offset_iterate_dir() doesn't build xa_state locally any more,
there's no longer a strong need for offset_find_next(). Clean up by
rolling these two helpers together.

Suggested-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Message-ID: <170785993027.11135.8830043889278631735.stgit@91.116.238.104.host.secureserver.net>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170820142021.6328.15047865406275957018.stgit@91.116.238.104.host.secureserver.net
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 23cdd0eed3f1 ("libfs: Fix simple_offset_rename_exchange()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index eec6031b01554..752e24c669d97 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -402,12 +402,13 @@ static loff_t offset_dir_llseek(struct file *file, loff_t offset, int whence)
 	return vfs_setpos(file, offset, U32_MAX);
 }
 
-static struct dentry *offset_find_next(struct xa_state *xas)
+static struct dentry *offset_find_next(struct offset_ctx *octx, loff_t offset)
 {
 	struct dentry *child, *found = NULL;
+	XA_STATE(xas, &octx->xa, offset);
 
 	rcu_read_lock();
-	child = xas_next_entry(xas, U32_MAX);
+	child = xas_next_entry(&xas, U32_MAX);
 	if (!child)
 		goto out;
 	spin_lock(&child->d_lock);
@@ -430,12 +431,11 @@ static bool offset_dir_emit(struct dir_context *ctx, struct dentry *dentry)
 
 static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 {
-	struct offset_ctx *so_ctx = inode->i_op->get_offset_ctx(inode);
-	XA_STATE(xas, &so_ctx->xa, ctx->pos);
+	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *dentry;
 
 	while (true) {
-		dentry = offset_find_next(&xas);
+		dentry = offset_find_next(octx, ctx->pos);
 		if (!dentry)
 			return ERR_PTR(-ENOENT);
 
@@ -444,8 +444,8 @@ static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 			break;
 		}
 
+		ctx->pos = dentry2offset(dentry) + 1;
 		dput(dentry);
-		ctx->pos = xas.xa_index + 1;
 	}
 	return NULL;
 }
-- 
2.43.0



