Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620172;
	b=KrDjFLRKRKy715ffF4Ily7tFhPvxFX7dz5Zqb9A1jyiWFQKuM5UMntNabvm10bIxvI+P
	 7s4KmNwB8v0UTtGiTzji2RA+5y3Z7ouf/0GnV8lmQPdYfgTGkQ1ovotKGTFJj832mLAAJ
	 mddgVU0Wfi48MH2F8jvzFuehG0HGImMsXYbTqDpB0E01HFEUtCm3Qd0rlW/igSF/o1weN
	 t7Mf4QRuuYT8FMsAhJ4LjBP4uFIfvH2V17W0sQ3fMN9X8QEsvq3oD7FzSP4o7wvo3yq7S
	 Ib7xka99CfVj7CzWFKY5gPAdzz5UoNhfNrgjhOhiXgDclpIC9NhN67gj9OxbImGFsLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGYlfY/LqtadTOOptKdVxcclYdgEU6Uri+mH6W3pBFc=;
	b=jCV4SlUQEOvU7Fx5Rhz2mGew8CxwEYx4YM4TXV0KLlXluSbJLXr91ikHwBnxj8TfG5A9
	 PVIqGWVHJFslAQK6krODYlZ4LjnayPIb3mntuB2msw0nJz0dZnb5X9qxyA9q8AxzHkM7O
	 4nuN1tq/2kmlTHzsuM/hON+bdATjUwXzyOiyJ/cy7I05TVye75UqsYuUMndAa7hWdx1Kq
	 UaCsxjyxGxVutIVitW+6AeeltpMBsg88Aid5QFcfTh0+NfJCxLR9yht/bQCIcXwtNpFHY
	 CmwmHAA0SWrkdhkHbt7uGuhsIuylLUQthSeU82OpaQfBSYLuyjt8w+jdo+PLvYsTvGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4RbkORb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD9D606A334;
	Wed, 25 Nov 2026 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4RbkORb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B881F000D4;
	Wed, 25 Nov 2026 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620171;
	bh=gGYlfY/LqtadTOOptKdVxcclYdgEU6Uri+mH6W3pBFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4RbkORbF2C88qfigT3ua9KASM1tFOsnqIReG1s1ibTew1Qq2rtHVI+AH5u6kBVuH
	 DcAuD1hrrkuz0uMsC3Ak8psTsX8H/4Tm9J9vmTt9YuSeeuPcUpoZZhUy2IFyMqcO4m
	 U71PJ4zhzxQs4ntf7PTZvcq0PvMbdOOGgyGFDer0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0830/1005] ovl: do not check the deferred lowerdata redirect on index lookup
Date: Wed, 25 Nov 2026 15:36:08 +0100
Message-ID: <20261125143841.164218429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 011f67b2b5c366679af023261ee02e284d534a96 upstream.

When a lower metacopy has an absolute redirect into a data-only layer,
ovl_lookup_layers() defers the data lookup and skips
ovl_check_follow_redirect(), but leaves the redirect in d->redirect.
If there is no upper dentry and a sibling hardlink was already copied
up to the index dir, the index branch calls ovl_check_follow_redirect()
again and, with redirect_dir=nofollow (e.g. forced by userxattr), fails
the lookup with -EPERM because of the lower data redirect.

Take the lowerdata redirect out of d->redirect at the point where the
data lookup is deferred, so that the index check only validates the
redirect and metacopy state of the index entry.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Closes: https://sashiko.dev/#/bug/linux-29bea9ea-5376-4e54-88f6-04dabce4db70
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -27,6 +27,7 @@ struct ovl_lookup_data {
 	bool last;
 	char *redirect;
 	char *upperredirect;
+	char *lowerdata_redirect;
 	int metacopy;
 	/* Referring to last redirect xattr */
 	bool absolute_redirect;
@@ -1258,6 +1259,8 @@ static int ovl_lookup_layers(struct ovl_
 	if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolute_redirect) {
 		d->metacopy = 0;
 		ctx->ctr++;
+		d->lowerdata_redirect = d->redirect;
+		d->redirect = NULL;
 	} else if (!ovl_check_follow_redirect(d)) {
 		err = -EPERM;
 		return err;
@@ -1374,15 +1377,14 @@ static int ovl_lookup_layers(struct ovl_
 		};
 
 		/* Store lowerdata redirect for lazy lookup */
-		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry)
-			oip.lowerdata_redirect = d->redirect;
+		if (d->lowerdata_redirect)
+			oip.lowerdata_redirect = d->lowerdata_redirect;
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
-		if (oip.lowerdata_redirect)
-			d->redirect = NULL;
+		d->lowerdata_redirect = NULL;
 
 		ctx->inode = inode;
 		if (ctx->upperdentry && !uppermetacopy)
@@ -1435,6 +1437,7 @@ struct dentry *ovl_lookup(struct inode *
 	dput(ctx.index);
 	ovl_stack_free(ctx.stack, ctx.ctr);
 	kfree(d.redirect);
+	kfree(d.lowerdata_redirect);
 
 	if (err) {
 		ovl_free_entry(ctx.oe);


