Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828854;
	b=KS5zJaP0824f0MumlHmoqREghSgiR5FwribID02zCZL+PEN/r2dAqdgC8uAXH2WuOiVj
	 8XoYhRa3TvIVpd7PcLjOOVZj+xYn6qdoGDlLxjkzY8cSRsL3FbqcfWNG23nYX0qtheFQX
	 eJ2ARkm9OarZr6WbefS5vH3qAdrDTMIrtZkE1MIIzJtc5IqJ84yULv8tB7GvGV+BmyTjp
	 3qgSZeFFWdrSCG8H23g/2vRWP2faFpZ3aqqWyjZGoo3v+xy90tvtfTZIjQkDmZ5biXVn6
	 zroUe0yEKFfrLLPYaoWk0oS6OiT58YbI9wmwITFz+mKG2RqQSI3e6CDqbOgtQlm5yMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/5qEwRkaLIolO+UUoVcUt6hpvnsABYBvULgBbuqDLK0=;
	b=N9QcGuNyj5g4SnFxhg1bZ9XVaDRs/uVccrPkjEWrwgrFR9QIKAh35pfQMVJ/l/9j1WkY
	 M6zcNnRCgfbv+1x01L23LXXSNGsbDuKNlLt9ZCKstYl0vTh9x9U2CXsQXAiC1o0eAmDT4
	 5eA5JfD65+cUxnKoyFfGvtKOQbIvO2NPaJqIpMiaJnM+24hQllgtnue9snAVxE1ImaDNC
	 uF0t9HS7ptLLvDHRow+8I7iA8DxonJReFI1oNSzvL97xUSnHuoqzSgUz8OwI/qEg16Oli
	 aV4DgKQldUDQwurTC8FZDh8aegnyEaTJNv6hNV+LFP+JSqM6XTtPcxyJcvZybCYg7WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Spo+s+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1B0606A32D;
	Wed,  4 Nov 2026 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Spo+s+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDE51F000C1;
	Wed,  4 Nov 2026 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828854;
	bh=/5qEwRkaLIolO+UUoVcUt6hpvnsABYBvULgBbuqDLK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Spo+s+OJJQTIQJsMuGkx+RhVw8uLaUjPZio18lqcLyQHtNUP4fTqarhOXvXE4IvS
	 MPg9FQ6NJgdFKFMunAHEOcTrTHne4z6TGmtxBHin4VNtxFjLrxVmGVao387Sv7kHo9
	 12UgPEV+7+aJXSLFInpuIg93wBelHQj9MF74yV/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 282/547] ovl: hold a reference on the parent in readdir
Date: Wed,  4 Nov 2026 16:07:46 -0500
Message-ID: <20261104211046.210808182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/readdir.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -568,8 +568,8 @@ static int ovl_cache_update(const struct
 			goto get;
 		}
 		if (p->len == 2) {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			/* d_splice_alias() can move even a locked dir */
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
@@ -797,6 +797,7 @@ static int ovl_iterate_real(struct file
 	struct dentry *dir = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.ctx.count = ctx->count,
@@ -808,18 +809,26 @@ static int ovl_iterate_real(struct file
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
@@ -875,8 +884,10 @@ static bool ovl_need_adjust_d_ino(struct
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	struct dentry *parent;
+	enum ovl_path_type type;
 
-	/* If parent is merge, then need to adjust d_ino for '..' */
+	/* With xino, need to map real d_ino to the unified overlay ino space */
 	if (ovl_xino_bits(ofs))
 		return true;
 
@@ -885,8 +896,14 @@ static bool ovl_need_adjust_d_ino(struct
 		return false;
 
 	/* If dir is impure then need to adjust d_ino for copied up entries */
-	if (ovl_is_impure_dir(file) ||
-	    OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))
+	if (ovl_is_impure_dir(file))
+		return true;
+
+	/* If parent is merge, then need to adjust d_ino for '..' */
+	parent = dget_parent(dentry);
+	type = ovl_path_type(parent);
+	dput(parent);
+	if (OVL_TYPE_MERGE(type))
 		return true;
 
 	/* Pure: no need to adjust d_ino */


