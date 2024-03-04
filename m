Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15621EB5A;
	Mon,  4 Mar 2024 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588983; cv=none; b=LHR+8EVG0q5PVaTirm7pB/xoUDNFhJkPw3QzSvUo8zJkaALmgtQPXXZ70UQ4+jCEHVQUOqF5DHhhQ4nLQoIPEWPE7VvxumOJn1F+R1zEzN2iUeaEJr2YMwkWEvk7dBQt6A9USB/vlnmz8rTEhehrE/tcSNRol6ndLX1E76ml5gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588983; c=relaxed/simple;
	bh=fT86dAU3p0ZfnzBP96XBtn9hSvzUsW9sjQEzlmolLsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2+ngd6a1P9xGx0octKWyGf8sdCRWkctVMK/8/sGx0bQGVAxv06p/cinT5MAcVWO/1P/RjC6tMqVZHqDAj9bfHkfy2swCgVOnhxgt0ajiPzQrRvQH1wDar8nbV/6bsch3td6FER3pt/73766eoI+52BBHL0BZrmXuRdM3uo/2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnqdY/OP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnqdY/OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC52C433F1;
	Mon,  4 Mar 2024 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588983;
	bh=fT86dAU3p0ZfnzBP96XBtn9hSvzUsW9sjQEzlmolLsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnqdY/OPGes1XgMgPmwe12o9YZkh9o3XzvWvSVz8PVvvbyJeyTN0SRzTOGg6uY4QY
	 PsIyI5h5qUPiGETyt7VSfHXDOWwgwa0kP5BUrwrQBWQSpqF5dT1NgrRORPl9QbPMFJ
	 XcAAmBl93W4AjE15Tcb9rBqkEygwjOMyxQtu9Z7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 6.1 157/215] NFSD: Clean up find_or_add_file()
Date: Mon,  4 Mar 2024 21:23:40 +0000
Message-ID: <20240304211601.982728377@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9270fc514ba7d415636b23bcb937573a1ce54f6a ]

Remove the call to find_file_locked() in insert_nfs4_file(). Tracing
shows that over 99% of these calls return NULL. Thus it is not worth
the expense of the extra bucket list traversal. insert_file() already
deals correctly with the case where the item is already in the hash
bucket.

Since nfsd4_file_hash_insert() is now just a wrapper around
insert_file(), move the meat of insert_file() into
nfsd4_file_hash_insert() and get rid of it.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   64 ++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4699,24 +4699,42 @@ find_file_locked(const struct svc_fh *fh
 	return NULL;
 }
 
-static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
-				     unsigned int hashval)
+static struct nfs4_file * find_file(struct svc_fh *fh)
 {
 	struct nfs4_file *fp;
+	unsigned int hashval = file_hashval(fh);
+
+	rcu_read_lock();
+	fp = find_file_locked(fh, hashval);
+	rcu_read_unlock();
+	return fp;
+}
+
+/*
+ * On hash insertion, identify entries with the same inode but
+ * distinct filehandles. They will all be in the same hash bucket
+ * because nfs4_file's are hashed by the address in the fi_inode
+ * field.
+ */
+static noinline_for_stack struct nfs4_file *
+nfsd4_file_hash_insert(struct nfs4_file *new, const struct svc_fh *fhp)
+{
+	unsigned int hashval = file_hashval(fhp);
 	struct nfs4_file *ret = NULL;
 	bool alias_found = false;
+	struct nfs4_file *fi;
 
 	spin_lock(&state_lock);
-	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
+	hlist_for_each_entry_rcu(fi, &file_hashtbl[hashval], fi_hash,
 				 lockdep_is_held(&state_lock)) {
-		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
-			if (refcount_inc_not_zero(&fp->fi_ref))
-				ret = fp;
-		} else if (d_inode(fh->fh_dentry) == fp->fi_inode)
-			fp->fi_aliased = alias_found = true;
+		if (fh_match(&fi->fi_fhandle, &fhp->fh_handle)) {
+			if (refcount_inc_not_zero(&fi->fi_ref))
+				ret = fi;
+		} else if (d_inode(fhp->fh_dentry) == fi->fi_inode)
+			fi->fi_aliased = alias_found = true;
 	}
 	if (likely(ret == NULL)) {
-		nfsd4_file_init(fh, new);
+		nfsd4_file_init(fhp, new);
 		hlist_add_head_rcu(&new->fi_hash, &file_hashtbl[hashval]);
 		new->fi_aliased = alias_found;
 		ret = new;
@@ -4725,32 +4743,6 @@ static struct nfs4_file *insert_file(str
 	return ret;
 }
 
-static struct nfs4_file * find_file(struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
-	rcu_read_unlock();
-	return fp;
-}
-
-static struct nfs4_file *
-find_or_add_file(struct nfs4_file *new, struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
-	rcu_read_unlock();
-	if (fp)
-		return fp;
-
-	return insert_file(new, fh, hashval);
-}
-
 static noinline_for_stack void nfsd4_file_hash_remove(struct nfs4_file *fi)
 {
 	hlist_del_rcu(&fi->fi_hash);
@@ -5661,7 +5653,7 @@ nfsd4_process_open2(struct svc_rqst *rqs
 	 * and check for delegations in the process of being recalled.
 	 * If not found, create the nfs4_file struct
 	 */
-	fp = find_or_add_file(open->op_file, current_fh);
+	fp = nfsd4_file_hash_insert(open->op_file, current_fh);
 	if (fp != open->op_file) {
 		status = nfs4_check_deleg(cl, open, &dp);
 		if (status)


