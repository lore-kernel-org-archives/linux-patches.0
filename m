Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828857;
	b=y7vAXTy0o01VNIKb9/U3n01kaUXRit6fYRRUO6eXQwDDNX7jOoCpRS4fnKLv6leaQlPs
	 8/AmFNGibA+qyamgCBbnnSAM+yiuMwUtUXyCLzuel1WdXsomol/LSJuLVKieQ6FMWgOhl
	 gDwxTg4oIgqCNLx7mWodtQ3mM6eZ/nOr6+X067PbsHS9tlt7LhzfLoQg0v3AcrECDCIWf
	 0IDjXHJgSd0y5D7izZ5wmcTa0yX013phwh704vp5CmXWLCw+OYsHGfppIE+WTv/J3SVxu
	 HJjNsCULCs1G/+4BMcU5/DrnnobeIYc48FXcwbuMyNucTmSRrQFOu96zrgfAQ4PuA+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5gjPLkF2lQHIZ8k28YCUl7So8YDAflWIyf70Mf8LuvQ=;
	b=fx+27dBlAGboESP75EO2at1I3Fe872TjOdVyiJKpAjqF+8Yl7ht+42/mqp9OYkX4Z8PS
	 U+yER111Hzas6sujk3zJiXFDsK/naGmqEZEp7HY+oYu2/2b7PKG16ohtTaTqbKq8/qZiW
	 jIXKf6BRlqEMv7EHUOLsZnUvcrG8TXJeL2eecCEx7+RhrnfIBwo/4WCLjcTr0qlrt+aPU
	 5pNkBy1rd2MkYtkLpDbEuUiEAtVQqS9CwDZyFZjtFftsVEZCwiKTV3QAyLLiPzvyI4670
	 jH76YfUyJd4NjKGtVdq3TITJHYjSHo2sQrNct89TtwDe9dJRzDQ5h5+3w6SJwiURzvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7yJwJpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D86070F18;
	Wed,  4 Nov 2026 21:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7yJwJpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DDC1F000C1;
	Wed,  4 Nov 2026 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828857;
	bh=5gjPLkF2lQHIZ8k28YCUl7So8YDAflWIyf70Mf8LuvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7yJwJplGV8UYvlYBTu7RXOY9NITkkE1oBMxjWHj+1dtAxRJy/5qbjpynlnSrURu3
	 8zPIcJaihMDm56XN81fpYZgOXrfOFtmxwt3+LlYD+fzblLPvU5v6tAZVaTlTX5+hFv
	 5MYCaJ5GVg4xPpLPZN41wwPoCOCPsce0YqCYgEo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 284/547] ovl: take a snapshot of the name for copy up
Date: Wed,  4 Nov 2026 16:07:48 -0500
Message-ID: <20261104211046.268123174@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -935,6 +935,7 @@ static int ovl_do_copy_up(struct ovl_cop
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct dentry *origin = c->lowerpath.dentry;
 	struct ovl_fh *fh = NULL;
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -972,12 +973,15 @@ static int ovl_do_copy_up(struct ovl_cop
 		goto out_free_fh;
 	} else {
 		/*
-		 * c->dentry->d_name is stabilzed by ovl_copy_up_start(),
-		 * because if we got here, it means that c->dentry has no upper
-		 * alias and changing ->d_name means going through ovl_rename()
-		 * that will call ovl_copy_up() on source and target dentry.
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
 		 */
-		c->destname = c->dentry->d_name;
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
@@ -986,7 +990,7 @@ static int ovl_do_copy_up(struct ovl_cop
 		err = ovl_set_impure(c->parent, c->destdir);
 		ovl_end_write(c->dentry);
 		if (err)
-			goto out_free_fh;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -1020,6 +1024,8 @@ static int ovl_do_copy_up(struct ovl_cop
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 out_free_fh:
 	kfree(fh);
 	return err;


