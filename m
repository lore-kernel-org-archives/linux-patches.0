Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053016;
	b=aXtaeRk4fuNa/AIawYQF2tWvnTe1/I+URlrSqa7DSys/O+N3mFA+cWN4S0xUJeXaOA2L
	 V+Sld+ue0DOGswvOiP7M4XIAHNeeQt5U+ko6+OnwNNipgIKUA6PMkBC/t0cwmu+Qi8D02
	 xMthdIO5vzIA5XDGv4qiIDHHujQR4jc68eDcbCPaqmRfH94MA+xnb1iqbc/mcukw7oT/5
	 79Ah3bgt/73UpqShKvou+e+chJP9e86id6PocSqeSEjEi/+hKyRW4xsu9dZG+KWmltnzs
	 RC941jo2DLRVdPScHxFh+gKPZ/ZM5mIHOkBGss475pBOD9hikvvtViq5Uuk/ZYzhUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKpGJiN3BccZ4TxbVYQ95P5SsCtuGQTFwL3DTGMFA3o=;
	b=IU1/HesVs+rTFUFgVfweHNL8oMtCfBagEdrzhTSpDLclTV9y2yO7ZYrv2g71Hg3+YAtt
	 EfNJjU6YQJtI9Pl67cT2yT1tC4jSC2KxVsRVwvanYmhwhiiimQn678sS9YBpAEHVy5KOc
	 t3rUhempCil+gusmW57KYryEjuaMjUT9ClcEHvg8tNunZvGPgkUnru56+5qqeLNd0gluQ
	 JMSWBoYSeJi5wjT4Y9bmgJW4bkYmlSb/950KGPc2QPd5ZUwhcwFXsfWYalk8upuzVF69a
	 Sb9D4O00Ma4acqkSFUH32BkiwkI+oNc2ZqfwOtAFBxX/bLtcH9C1qln/zAbQZwN0FIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpbEj8xx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1349E606A32A;
	Thu, 19 Nov 2026 01:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpbEj8xx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CA01F000C5;
	Thu, 19 Nov 2026 01:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053015;
	bh=GKpGJiN3BccZ4TxbVYQ95P5SsCtuGQTFwL3DTGMFA3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpbEj8xxqm16/M74mYdbtLF3lNFbUWx5TNs9lgd9TTgrghl7iYECZxJyhK6qSZnU4
	 7HS3jBQjX1KeXXaLVrrcHGbBvlogeWY2OJ18cDyAvFUAIg2h4Lw78Rj7PfMK4NxhRC
	 pUsB50sb30BaNPqXtQH5CVqNJGtEDMzPo3uJk1P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0768/2214] ovl: hold a reference on the parent in readdir
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150042.411232403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 16d319e12328acafeafd3eecdf09c46d7fb43452 ]

Listing a directory on an overlay uses a freed dentry and crashes the
kernel when a lookup moves the directory at the same time.

Code that can sleep may only use d_parent without a reference while
something stops a move of the dentry. ovl_iterate_real(),
ovl_need_adjust_d_ino() and ovl_cache_update() use the d_parent of the
listed directory and hold only the lock of that directory. When a
lookup finds the directory under another parent after a change to a
layer, d_splice_alias() moves it without that lock and drops its
reference on the old parent.

With a delay in ovl_iterate_real(), getdents64 on an overlay directory
raced a rename in the lower layer and a lookup that moved its dentry,
and after an rmdir of the old parent KASAN reported a use-after-free in
security_inode_getattr().

Fix this by using dget_parent() in the three functions.

Fixes: b5efccbe0a12 ("ovl: constant d_ino across copy up")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: fix comments in ovl_need_adjust_d_ino()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: adapted ovl_need_adjust_d_ino() changes to the inline logic in ovl_iterate() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ed4c34366c5c0..896bc521bcdc3 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -474,8 +474,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 			goto get;
 		}
 		if (p->len == 2 && p->name[1] == '.') {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			/* d_splice_alias() can move even a locked dir */
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
@@ -693,6 +693,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -703,18 +704,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	if (rdt.xinobits && lower_layer)
 		rdt.fsid = lower_layer->fsid;
 
-	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
+	/*
+	 * The lock on dir does not stop d_splice_alias() from moving it to
+	 * another parent, which drops the reference dir holds on this one.
+	 */
+	parent = dget_parent(dir);
+	if (OVL_TYPE_MERGE(ovl_path_type(parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
 
-		statpath.dentry = dir->d_parent;
+		statpath.dentry = parent;
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
-		if (err)
+		if (err) {
+			dput(parent);
 			return err;
+		}
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		rdt.parent_ino = stat.ino;
 	}
+	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
@@ -742,6 +751,8 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
@@ -750,11 +761,12 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		if (ovl_xino_bits(dentry->d_sb) ||
 		    (ovl_same_fs(dentry->d_sb) &&
 		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		      OVL_TYPE_MERGE(ovl_path_type(parent))))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
 		}
+		dput(parent);
 		goto out;
 	}
 
-- 
2.53.0



