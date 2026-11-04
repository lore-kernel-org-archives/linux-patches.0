Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831598;
	b=jq5emxpCApGEYISYU2JIk1jz8z0EaB3Klk2bAhdStxdHqvVnOTDl4E6+du5dIZLqdcrL
	 sTKwjXZDgx/G5QotRcmSfl7E836LZZWbrklLhYCkYPyLLVFOJ6+s1F5GHlJ/smdGtAGJT
	 09daGHNwyQSnBxo1RY1/fv0S085ZBrmF7w5254dbuf6Vt5SMYMN92vr/qrTdhtkP6qD1l
	 zxDIq50r//9QVx0+dwv0/0hCyc6oLy6bFACMUaRGjSnEfzj7y+Cx+UUe+/U5bvn0feMsQ
	 wzXOs3FC7XsGUQcnertUv6X2rkPaqG73mCmMVBREd3lC+e/CTEolpKtxhlYk3/Krvzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xhvu35COQSHvGOTd9wtuD9yUFNm0nnDbn1TQJP4zNCQ=;
	b=t38XoIvDZigPRPTsMAc3sxNCXOHsWb62EIduFR6wr/Z++Ce/Nt5l3Q42M1F6F2m8sFeW
	 GUZvGlGupvdDyeS1kAoC3dfVIJEeygkJ4J1IORkvspERC/ZzGch2cpWVkfZR4ABo2x7yq
	 kwtyqKP52L6sfWq38dgYU8XvkjrKrU66nc5vbyi5v2Wwse1d43f6qfAnfB0Won6noM0xb
	 HrdFQ5X9a5vTIUn90VwwRZjKhMVKTibs//QPoSX/rqQwtFv5DZ1WSsL685e2WHG81N7i7
	 +4nG1YPHIBHVzBulD9rYabEL+/nSOCwK3q12rvCOhjwtPnzrnc/K5xgAfmGexwZDkwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfzXcaDv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3652606A844;
	Wed,  4 Nov 2026 22:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfzXcaDv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF141F00A02;
	Wed,  4 Nov 2026 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831597;
	bh=Xhvu35COQSHvGOTd9wtuD9yUFNm0nnDbn1TQJP4zNCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfzXcaDvlsSC/w0QRtvqUTbE91Tp680zkpx0Iv+zwUirEvR/y3Ie4RJfNB48vGTXl
	 MZF9NlMm3gU2jew8KBMpMSUnXQ2oHt9+2kgEmyh/0E9LdCBEc6xgUgfiBiV2Ar6Lvd
	 vzSIPX+Ip2PyDFOuYR02yUyc5kMH/93OXBTfWmY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0762/1005] ovl: take a snapshot of the name for copy up
Date: Wed,  4 Nov 2026 16:08:15 -0500
Message-ID: <20261104211104.766349833@linuxfoundation.org>
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
@@ -948,6 +948,7 @@ static int ovl_do_copy_up(struct ovl_cop
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct dentry *origin = c->lowerpath.dentry;
 	struct ovl_fh *fh = NULL;
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -985,12 +986,15 @@ static int ovl_do_copy_up(struct ovl_cop
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
@@ -999,7 +1003,7 @@ static int ovl_do_copy_up(struct ovl_cop
 		err = ovl_set_impure(c->parent, c->destdir);
 		ovl_end_write(c->dentry);
 		if (err)
-			goto out_free_fh;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -1033,6 +1037,8 @@ static int ovl_do_copy_up(struct ovl_cop
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 out_free_fh:
 	kfree(fh);
 	return err;


