Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623515;
	b=TBwo7C9jZIFqAsDjgN78K+4HlOQyNTpnPK9oxNc8P6QBkD1zLeU5RkI8z7qnJ7bFXxsJ
	 bEAcKWPQZb+XJ4U37Az4mCwBDl1AfuanS4MgnBxY8vPDzRZpyM+/PeigSu+fnUu396HYw
	 pzxTLaS7mYlKlJvgDz4c5dJ34uyzlrro0YQdeDmc9TSaoHQxDguuaMQVjRKb3m8DEPmnl
	 uypyHZlLL888QrqXEvOMN6jxFYrPq70RKWbK9qSTw68J9Ya7UX9y9CAGTQq77MZmjzdSK
	 vyD2AndpsV672T0rOqQc2tcowPF2+uN2ofJM+5DCybWAO8LusbkxcJnGQOYMsLhA7Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sHq3jSfuWwSI/b/mKj4EEm+FRzc5EwdFwJbP7l8COPA=;
	b=W+CsIiOSrI4uwenFjt0HB6CLSZAJsndikC+lYQV0fORJMsSGLdWQrO/EsBadXBF94aNk
	 aXy0jQGQyKTEf29xSdjOmvk/TVIV8FFaa7/S4nSUTx6AEKpXZxPXQv9BkHNFYasLJ68mr
	 dMfyoosoljSULUdEV9SPi7GFR4to91oqk7Rx2xZqDSvf3YeVJbyAt1lIAGHKjX+2NASxl
	 kLfZ1MMXN0Typvw6NdSvYXUZsPGWx7X7QtxjgMOShibwRqfY+vSro8yAVcQoBEpds6nHJ
	 46hiLYuwhMMPwiGAjrTLrXJ/bk5a7GNGp+kE3kRIqtvIbm3wsl5ArC65bgwVB/WYNWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEPT3q8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DBD606A31E;
	Wed, 25 Nov 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEPT3q8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16431F000C6;
	Wed, 25 Nov 2026 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623515;
	bh=sHq3jSfuWwSI/b/mKj4EEm+FRzc5EwdFwJbP7l8COPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEPT3q8Q11B0fpoKcN1opGCi43kQjIxbaov0RAfVnTdyIb7teQVVJmPrz6nWHoskg
	 U47VB5NkxGUbWKFQtscrl/pTxXsIrr59JRDDWdwgRRO157cyYFSKJtMX7egjBby2Sd
	 I6mopxYrxIE/Yfi2X1VmGohrbkXpX1hF2ehRE9vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 840/990] smb: client: fix double conversion of DFS path in setup_dfs_ref()
Date: Wed, 25 Nov 2026 15:36:47 +0100
Message-ID: <20261125143841.707886096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit 92509ce64ffff02d05fe9f3c82b889e1cc500076 upstream.

setup_dfs_ref() converts the path from the mount charset to the DFS
cache charset (utf8) via dfs_get_path(), and then passes that already
converted string to dfs_get_referral().  dfs_cache_find() converts its
input again, assuming it is still in the mount charset.

When the mount charset is not utf8 (iocharset=iso8859-1, or a kernel
built with a non-utf8 CONFIG_NLS_DEFAULT) and the DFS path contains
non-ASCII characters, the utf8 bytes are interpreted as mount-charset
characters and encoded a second time.  For example, "é" is sent as
c3 83 c2 a9 instead of c3 a9.  The server then fails the second-level
referral with STATUS_OBJECT_PATH_NOT_FOUND and the mount fails with
-ENOENT, even though the path exists.

Pass the unconverted path to dfs_get_referral() so that it is converted
exactly once.

Such mounts now get past the second-level referral and reach
dfs_parse_target_referral(), which is why this change depends on
"smb: client: fix out-of-bounds read in dfs_parse_target_referral()".

Tested with a Samba DFS root containing a link named "café", mounted
with iocharset=iso8859-1 and the single Latin-1 byte 0xe9 in the path:
before, the mount failed with -ENOENT; with both patches applied, it
succeeds.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -103,6 +103,7 @@ static int setup_dfs_ref(struct dfs_info
 	struct cifs_sb_info *cifs_sb = rw->mnt_ctx->cifs_sb;
 	struct smb3_fs_context *ctx = rw->mnt_ctx->fs_ctx;
 	char *ref_path, *full_path;
+	const char *raw_path;
 	int rc;
 
 	set_root_smb_session(rw->mnt_ctx);
@@ -114,9 +115,10 @@ static int setup_dfs_ref(struct dfs_info
 
 	if (!tgt || (tgt->server_type == DFS_TYPE_LINK &&
 		     DFS_INTERLINK(tgt->flags)))
-		ref_path = dfs_get_path(cifs_sb, ctx->UNC);
+		raw_path = ctx->UNC;
 	else
-		ref_path = dfs_get_path(cifs_sb, full_path);
+		raw_path = full_path;
+	ref_path = dfs_get_path(cifs_sb, raw_path);
 	if (IS_ERR(ref_path)) {
 		rc = PTR_ERR(ref_path);
 		kfree(full_path);
@@ -125,9 +127,7 @@ static int setup_dfs_ref(struct dfs_info
 	ref_walk_path(rw) = ref_path;
 	ref_walk_fpath(rw) = full_path;
 
-	return dfs_get_referral(rw->mnt_ctx,
-				ref_walk_path(rw) + 1,
-				ref_walk_tl(rw));
+	return dfs_get_referral(rw->mnt_ctx, raw_path + 1, ref_walk_tl(rw));
 }
 
 static int __dfs_referral_walk(struct dfs_ref_walk *rw)


