Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACA747125D;
	Tue, 21 Jul 2026 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658070; cv=none; b=L+hUT3UJ6ahq+UNXazgiP/f2m6dLj9GMp19BAeMeqW7Y/KhSybHhM18g6OUCZf10b1Ea+kYyaMDwo9SJ5SqzHfc13Rp3Ma5dCuT7Ly6x1lxzPu4kr+VM6VTbJ7GFkbXynjh0MPnGz0ywKLq7lfkOPZyt1nm38qFHAqrbfIYh8jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658070; c=relaxed/simple;
	bh=Ek3dIxyUbDAO+Xxo1/OccVgwZ9kbBFbp2H1vdjAvWnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUSKbPI+Vo+sST/PL32UfyCrVaeWW7RigUfDogxjes06ROE7Hq6Fc0SZF2dBqsTooSrMdNrZVyf0f5q1TqfmW6fYTLy3/KHFmdmllGF1RLHeDh5x7HPjTndk5XU/YjVW1ZlsjxoLsRyeTtAt9Nh50HZJOhx79pjBfceB5NKg+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1Tiz6BM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1Tiz6BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C461F00A3A;
	Tue, 21 Jul 2026 18:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658069;
	bh=8dzPTMJf64XptbFnzU/vToOKVqYPWXkCIegjJhv0ie4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1Tiz6BMeADaglNvtVXvY1uL6CVQKpZrXOsttNUwNJl/ebXfDfU6mmy1nUhc/mGTK
	 fQ3YwGLb9LPjQ2LOX4ToKNmsip66WY6xtC7dM8SEJcCT2acJqb3XKhnKP5mGoo9SGl
	 duMT+DV4j1b/Z9JBxufnuTkXi6PWhOdUjnfvbROQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1003/1611] afs: Fix bulk lookup malfunction due to change in dir_emit() API
Date: Tue, 21 Jul 2026 17:18:39 +0200
Message-ID: <20260721152537.955108323@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2f79d1b93c62470fe02dbdc24770f1ae5a9e1be6 ]

afs_do_lookup() and afs_do_lookup_one() use the same directory parsing code
as afs_readdir() and were supplying alternative dir_context actors to
retrieve dirents, but because lookup needs the vnode's uniquifier as part
of the reference, but not the DT flags, the uniquifier was being passed in
the dt flags argument to the lookup actors.

Unfortunately, commit c644bce62b9c, added to fix overlayfs with fuse, broke
this by masking off part of the uniquifier.  This doesn't matter enough to
be directly noticeable, instead causing bulk advance inode lookups to fail
(which are retried later) and may cause dir revalidation to malfunction if
the uniquifier is changed by masking.

Fix this by making the afs directory parsing code take special ->actor
values of AFS_LOOKUP or AFS_LOOKUP_ONE instead that tell it to call
afs_lookup_filldir() or afs_lookup_one_filldir() directly rather than going
through dir_emit().  dir_emit() is still used for readdir.

Fixes: c644bce62b9c ("readdir: require opt-in for d_type flags")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-11-dhowells@redhat.com
cc: Amir Goldstein <amir73il@gmail.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index fa84610e0b0d98..7c3cef0835a8bd 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -28,9 +28,11 @@ static int afs_d_revalidate(struct inode *dir, const struct qstr *name,
 static int afs_d_delete(const struct dentry *dentry);
 static void afs_d_iput(struct dentry *dentry, struct inode *inode);
 static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name, int nlen,
-				  loff_t fpos, u64 ino, unsigned dtype);
+				   u64 ino, u32 uniquifier);
+#define AFS_LOOKUP_ONE ((filldir_t)0x123UL)
 static bool afs_lookup_filldir(struct dir_context *ctx, const char *name, int nlen,
-			      loff_t fpos, u64 ino, unsigned dtype);
+			       u64 ino, u32 uniquifier);
+#define AFS_LOOKUP ((filldir_t)0x137UL)
 static int afs_create(struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, bool excl);
 static struct dentry *afs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
@@ -434,11 +436,18 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 		}
 
 		/* found the next entry */
-		if (!dir_emit(ctx, dire->u.name, nlen,
-			      ntohl(dire->u.vnode),
-			      (ctx->actor == afs_lookup_filldir ||
-			       ctx->actor == afs_lookup_one_filldir)?
-			      ntohl(dire->u.unique) : DT_UNKNOWN)) {
+		if (ctx->actor == AFS_LOOKUP) {
+			if (!afs_lookup_filldir(ctx, dire->u.name, nlen,
+						ntohl(dire->u.vnode),
+						ntohl(dire->u.unique)))
+				return 0;
+		} else if (ctx->actor == AFS_LOOKUP_ONE) {
+			if (!afs_lookup_one_filldir(ctx, dire->u.name, nlen,
+						    ntohl(dire->u.vnode),
+						    ntohl(dire->u.unique)))
+				return 0;
+		} else if (!dir_emit(ctx, dire->u.name, nlen,
+				     ntohl(dire->u.vnode), DT_UNKNOWN)) {
 			_leave(" = 0 [full]");
 			return 0;
 		}
@@ -558,6 +567,7 @@ static int afs_readdir(struct file *file, struct dir_context *ctx)
 {
 	afs_dataversion_t dir_version;
 
+	ctx->dt_flags_mask = UINT_MAX;
 	return afs_dir_iterate(file_inode(file), ctx, file, &dir_version);
 }
 
@@ -567,14 +577,14 @@ static int afs_readdir(struct file *file, struct dir_context *ctx)
  *   uniquifier through dtype
  */
 static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
-				  int nlen, loff_t fpos, u64 ino, unsigned dtype)
+				  int nlen, u64 ino, u32 uniquifier)
 {
 	struct afs_lookup_one_cookie *cookie =
 		container_of(ctx, struct afs_lookup_one_cookie, ctx);
 
 	_enter("{%s,%u},%s,%u,,%llu,%u",
 	       cookie->name.name, cookie->name.len, name, nlen,
-	       (unsigned long long) ino, dtype);
+	       (unsigned long long) ino, uniquifier);
 
 	/* insanity checks first */
 	BUILD_BUG_ON(sizeof(union afs_xdr_dir_block) != 2048);
@@ -587,7 +597,7 @@ static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
 	}
 
 	cookie->fid.vnode = ino;
-	cookie->fid.unique = dtype;
+	cookie->fid.unique = uniquifier;
 	cookie->found = 1;
 
 	_leave(" = false [found]");
@@ -604,7 +614,7 @@ static int afs_do_lookup_one(struct inode *dir, const struct qstr *name,
 {
 	struct afs_super_info *as = dir->i_sb->s_fs_info;
 	struct afs_lookup_one_cookie cookie = {
-		.ctx.actor = afs_lookup_one_filldir,
+		.ctx.actor = AFS_LOOKUP_ONE,
 		.name = *name,
 		.fid.vid = as->volume->vid
 	};
@@ -635,14 +645,14 @@ static int afs_do_lookup_one(struct inode *dir, const struct qstr *name,
  *   uniquifier through dtype
  */
 static bool afs_lookup_filldir(struct dir_context *ctx, const char *name,
-			      int nlen, loff_t fpos, u64 ino, unsigned dtype)
+			      int nlen, u64 ino, u32 uniquifier)
 {
 	struct afs_lookup_cookie *cookie =
 		container_of(ctx, struct afs_lookup_cookie, ctx);
 
 	_enter("{%s,%u},%s,%u,,%llu,%u",
 	       cookie->name.name, cookie->name.len, name, nlen,
-	       (unsigned long long) ino, dtype);
+	       (unsigned long long) ino, uniquifier);
 
 	/* insanity checks first */
 	BUILD_BUG_ON(sizeof(union afs_xdr_dir_block) != 2048);
@@ -650,7 +660,7 @@ static bool afs_lookup_filldir(struct dir_context *ctx, const char *name,
 
 	if (cookie->nr_fids < 50) {
 		cookie->fids[cookie->nr_fids].vnode	= ino;
-		cookie->fids[cookie->nr_fids].unique	= dtype;
+		cookie->fids[cookie->nr_fids].unique	= uniquifier;
 		cookie->nr_fids++;
 	}
 
@@ -791,7 +801,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 
 	for (i = 0; i < ARRAY_SIZE(cookie->fids); i++)
 		cookie->fids[i].vid = dvnode->fid.vid;
-	cookie->ctx.actor = afs_lookup_filldir;
+	cookie->ctx.actor = AFS_LOOKUP;
 	cookie->name = dentry->d_name;
 	cookie->nr_fids = 2; /* slot 1 is saved for the fid we actually want
 			      * and slot 0 for the directory */
-- 
2.53.0



