Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035549;
	b=i7A1vB8CCIPmBMzb90egzXgB1YcYjn86zOfK/vVsc67QMyANPYxJlX3+WtcNDzOE4bZA
	 YOpC+cmNbBHUHOT0eqRlOyabnHWp3A0d9g+8UG4V/x6jt53vB6bpu7iUDeVeC/1B8aFmL
	 5YpGz22NpQAoDwLNaygIaFaaMqtdiQxfx4JL251iyRSzYGtCE6FnqTJvEspcLaguda3/r
	 cjB1CByFzEczyvLGZFIBUF0kYVunydhCMJCtyo0kRueQPtUaAjC1mERZrhCCdVNErkXAM
	 vAjOhLmMLRzZa1uR+xvmH7rPFUff4s+TE+PCZaFeyoYqlX96cbMA71YVwKALjFLH9VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C3dWmTfNZpZcuyAm0vPEz1FAZD/QqT3LNPIBxkyD8ok=;
	b=lI6Ica6u3jF1sK5JtF8ZhOHtCXPQMrLo/UuH2thlPAEsiAyskgV8KFQCPBZbVFxpNDuu
	 uyoufKwz4hg2DaqBob+1m/raA/L0+jzJt7j6YvQ7HQdT7cOxxLFngbu82x7FB6soWOpxL
	 fH1ODhW2F3ZjnNhOpIh2vBMwS45Wf1luMmc5WzT+mAkoTPAVVeo2V9jsUf2OooW9xhIvJ
	 kzAQKeTwSB54rHQuwW0qBmPJOeIHiWfCqmZvGBB2gQzkPBEN1u+hkkicrYEz0cOyoXHVy
	 xbnhYt/3odEs9vl/SPapKUnpVGgLA0pck53GqdEfpQm0ZQdvAUijjmsmgKzKqO0gyVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKUGg338;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E92606A320;
	Wed, 18 Nov 2026 20:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKUGg338
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065A81F000C4;
	Wed, 18 Nov 2026 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035549;
	bh=C3dWmTfNZpZcuyAm0vPEz1FAZD/QqT3LNPIBxkyD8ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKUGg338rHePnL2S10HapvdIZLwvuCJsSxrUDO49drt87a4xF31DDf2cSN1m7QKOF
	 AR876fD+jUEQOkn3PgMaEfGoxNeGPL9eqHA+2LwqjCfClovRufFSwwmXWVq3146Niu
	 hHdGRu3AEcAH5Ry6bLtxsmAcZxY+TuMSl6ojW0Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0742/3318] ovl: take a snapshot of the name for copy up
Date: Wed, 18 Nov 2026 15:22:44 +0100
Message-ID: <20261118150340.862260249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb upstream.

The copy up of a directory reads a freed dentry name when a lookup
moves the directory at the same time.

A pointer to the name of a dentry is only valid while something stops
a move of the dentry. ovl_do_copy_up() keeps a plain copy of
c->dentry->d_name in c->destname, and ovl_copy_up_start() only keeps
ovl_rename() away. When a lookup finds the same directory under another
name after a change to the lower layer, d_splice_alias() moves the
dentry and frees its external name.

With a delay in ovl_do_copy_up(), a chmod of a lower-only directory with
a 60 byte name raced with a rename of that directory in the lower layer
and a stat of the new name, and KASAN reported a use-after-free in
lookup_noperm_common().

Fix this by using take_dentry_name_snapshot() for c->destname.

Fixes: 829c28be9bb9 ("ovl: use d_splice_alias() in place of d_add() in lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: destname is set in ovl_copy_up_one(), take the snapshot in
 the non-index branch of ovl_do_copy_up() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -867,6 +867,7 @@ static int ovl_do_copy_up(struct ovl_cop
 {
 	int err;
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -896,12 +897,22 @@ static int ovl_do_copy_up(struct ovl_cop
 		return -EIO;
 	} else {
 		/*
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
+		 */
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
+		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
 		err = ovl_set_impure(c->parent, c->destdir);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -933,6 +944,8 @@ static int ovl_do_copy_up(struct ovl_cop
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 	return err;
 }
 
@@ -1083,7 +1096,6 @@ static int ovl_copy_up_one(struct dentry
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,


