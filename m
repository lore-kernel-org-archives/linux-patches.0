Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831872;
	b=m/uv03ybNJQP1BGsapEHoxoZXCPGSqZRer3RXmNSIuLJCUIyC9E/qK6jtZF9+zame7aZ
	 iR+ANOsEWWzIOyRt7OvztBMpZID4y45neCZo2rkSIUKnzPRsT0UQZunhPyVacDSU8RznW
	 82pGUZ1amqNCksFoox10+kis4HYGpFIAVfpouIhZOBNYdeKZBgBG9XFOCa2xTSSeGqcGN
	 bJcoJiZzdJwzlNVKyr/sm7qNQRF1L7LHQ0Zqp4Egoc+PmMzBarmGplbNlh7jFrYPZSSOv
	 IV8WFF+pkKzx7meiEQZqSotfCvogkwssWc3rt18rBsWxJi08mfjJdf4sYhKOm3aIw3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8l/tk0AoIcUX0tLXrzoZbnHGkeFvUvqtTrzewZJCqc=;
	b=4iznqJjbVwtRtX74eWX61qIJkS4/8f39tEDsviwtt0CvcMvCPeWcq9rKoNsuOUea6wnu
	 2iEglnnRYiIn8QDOnDmaqj0OZxOfNndo8ySXHe3MOxiQPOljsoSYv6Pc4FCs7P/hPrktv
	 pYLeR6DVp1TBgbytzrD4oxftohgcmt42C1Pm7vR3i6SUlrCzFI40Q5ithoDtQ3iIBf73O
	 nPkSjJQdZbP+1zabFlxWNsSTx8mBSXSmGPpQWjjBF76EMlM0SlvnRIvbV7W/mIzSEMzIk
	 VVA+P+98ilMJgsmu37DCbzaBm5IIANb+3AzUPv5aG0dBidqKYqH0oepHWFouWaL1C0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=katlSyNX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809B606A326;
	Wed,  4 Nov 2026 22:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=katlSyNX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6B41F000C1;
	Wed,  4 Nov 2026 22:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831872;
	bh=x8l/tk0AoIcUX0tLXrzoZbnHGkeFvUvqtTrzewZJCqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=katlSyNXPxzlHGYv3Cm/Sc2Lw8t5fetLltGAw6jzofzoY5Vvz3P8vvg9g1N3yVt6Z
	 2CUA9HX4YbCeyE7tPQlKpUjg5SuwCoK0QnGJ9SDgkdi5X0luw9rkCUyIpbkk0ni9Vq
	 KcqZKGkuDIVkRF5m2japMfKoz7uUo4v02Rb8X9I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0967/1005] ovl: hold a reference on the parent in readdir
Date: Wed,  4 Nov 2026 16:11:40 -0500
Message-ID: <20261104211110.156215042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 16d319e12328acafeafd3eecdf09c46d7fb43452 upstream.

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
[backport: no ovl_need_adjust_d_ino(), take the parent with dget_parent()
 in ovl_iterate() and test a local flag]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/readdir.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -572,8 +572,8 @@ static int ovl_cache_update(const struct
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
@@ -802,6 +802,7 @@ static int ovl_iterate_real(struct file
 	struct dentry *dir = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.ctx.count = ctx->count,
@@ -813,18 +814,26 @@ static int ovl_iterate_real(struct file
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
@@ -853,6 +862,10 @@ static int ovl_iterate(struct file *file
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+		bool parent_merge = OVL_TYPE_MERGE(ovl_path_type(parent));
+
+		dput(parent);
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
@@ -860,8 +873,7 @@ static int ovl_iterate(struct file *file
 		 */
 		if (ovl_xino_bits(ofs) ||
 		    (ovl_same_fs(ofs) &&
-		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (ovl_is_impure_dir(file) || parent_merge))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);


